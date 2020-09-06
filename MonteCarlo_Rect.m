function MonteCarlo_Rect(varargin)
%% MonteCarlo_RectGPU функци€ дл€ многослойного ћ 
    params = set_parameters(varargin{:});
    use_gpu = params.use_gpu;
    is_calculate_irradiance = params.is_calculate_irradiance;    
    is_show_irradiance = params.is_show_irradiance;           
    is_calculate_directed_escape = params.is_calculate_directed_escape; 
    is_calculate_histograms = params.is_calculate_histograms;      
    is_calculate_TR = params.is_calculate_TR;
    result_filename = params.result_filename;
    is_complex_detector = params.is_complex_detector;
    is_circle = params.is_circle;
    with_PS  = params.with_PS;
    with_air = params.with_air;
    is_calculate_absorption_map = params.is_calculate_absorption_map;
    is_show_absorption_map = params.is_show_absorption_map;
    min_weight = params.min_weight;
    total_photons = params.total_photons;                   
    x = params.x; %mm
    y = params.y; %mm
    
    %% Heterogeneity 
    is_het = params.is_het;
    het_cylinder = params.het_cylinder;
    ma_het = params.ma_het;
    ms_het = params.ms_het;
    g_het = params.g_het;
    d = params.d;
    z0 = params.z0;
    y0 = params.y0;
    x0 = params.x0;
    a = params.a;
    b = params.b;
    c = params.c;
  
    

   %% Tissue parameters

    z = params.z;
    min_z = min(z);
    ma =params.ma;    
    ms =params.ms;   
    g = params.g; 

    n = params.n;
    max_z = max(z);
    
    mt = ms + ma;
    
    mt_het = ma_het + ms_het;
   
   %% PS parameters C0 = C00*exp(-alpha*z) from  [1] doi:10.1016/j.jphotobiol.2016.04.014
     
    %C00 = params.C00; %initial concentration in the surface
    alpha = params.alpha; % in [1] for tumor 6 cm^-1 , for normal 20 cm^-1 (tissue model:dermis an  subcutaneous fat)
    load('Revixan_ma.mat');
    wavelenght = params.wavelenght;
    maPS = revixan(revixan(:,1) == wavelenght, 3);
    var_conc =  params.var_conc;
    surf_func = @(a,z,ma_tot) ma_tot*z*a/(25*(1-exp(-a*z)));
    z_pentr = params.z_pentr;
    ma_surf = surf_func(alpha,  z_pentr, maPS/var_conc);
    %% fluorescence
    is_fluor = params.is_fluor;
    map_filename = params.map_filename;
    if is_fluor
        load(map_filename,'absorption_map')   
    end

    %% Scale
    
    dx = params.dx;           %шаг сетки
    dy = params.dy;           %шаг сетки
    dz = params.dz;           %шаг сетки
    d_hist = params.d_hist;
    d_r_hist = params.d_r_hist; 

    
    %% Detector and source parameters
    
    directed_escape_radius = params.directed_escape_radius;       % радиус направленного вылета
    directed_escape_refracted_angle = params.directed_escape_refracted_angle;   % угол направленного вылета
    T_radius = params.T_radius;
    R_radius = params.R_radius;
    
    source_center = params.source_center;
    source_width = params.source_width;
    source_direction = params.source_direction;
   
    %% Initialization of result matrixes
    
    if use_gpu
        reset(gpuDevice);
        n = gpuArray(n);
    end

        x_grid = 0:dx:x; 
        y_grid = 0:dy:y; 
        z_grid = 0:dx:max_z;
        
        if use_gpu
            x_grid = gpuArray(x_grid);
            y_grid = gpuArray(y_grid);
            z_grid = gpuArray(z_grid);
        end
    
    if is_calculate_irradiance
        irradiance = zeros(numel(x_grid)-1, numel(y_grid)-1, numel(z_grid)-1);
        if use_gpu
            irradiance = gpuArray(irradiance);
        end
    end
    
    if is_calculate_absorption_map
        absorption_map = zeros(numel(x_grid)-1, numel(y_grid)-1, numel(z_grid)-1);
        if use_gpu
            absorption_map = gpuArray(absorption_map);
        end
    end
       
    if is_calculate_histograms
		r_grid = 0:d_r_hist:sqrt((x-source_center(1)).^2+(y-source_center(2)).^2); 
		
		hist_grid = min_z:d_hist:max_z;
        photons_deep_hist = zeros(numel(x_grid) - 1, numel(y_grid) - 1, numel(hist_grid) - 1);
		photons_deep_r_hist = zeros(numel(r_grid) - 1, numel(hist_grid) - 1);
        if use_gpu
            hist_grid = gpuArray(hist_grid);
            photons_deep_hist = gpuArray(photons_deep_hist);
			photons_deep_r_hist = gpuArray(photons_deep_r_hist);
        end
    end

    %% Monte-Carlo

    opposite_directed_count = 0;
    reflect_weight = 0;
    outside = 0;
    sum_ref = 0;
    outside_weight = 0;
    absorption_weight = 0;
    transmit_weight = 0;

    wb=waitbar(0,'Time');
    
    if ~is_fluor
        [pos, dir, weight, max_deep, layer] = launch_photons(is_circle,source_center,source_width,x_grid,y_grid,dx,dy, source_direction, total_photons, use_gpu);
    else
        tic
        [pos, dir, weight, max_deep, layer] = launch_photons_complex(absorption_map,x_grid,y_grid,z_grid,dx,dy,dz);
        total_photons = numel(weight);
        toc
    end
    calculated_photons = 0;

    is_in_het = false(numel(weight),1);

    tic;
    
    
    while (numel(pos)>0)
        
        
        ma_PS_conc = concentration(ma_surf, alpha,  pos, z_grid);
        pos_previous = pos;

        if is_het
            if het_cylinder
                is_in_het = check_het_cylinder(pos, y0, z0, d);
            else
                is_in_het = check_het(pos,x0, y0, z0, a,b,c);
            end
        else
            is_in_het = false(numel(weight),1);
        end
         
        pos = move_photons(pos, dir, layer, mt, use_gpu,ma_PS_conc,with_PS,is_het, is_in_het,mt_het);

        [pos, dir, layer, is_need_recalculation] = reflect_photons(pos, pos_previous, dir, layer, z, n, use_gpu);
        %is_need_recalculation - фотоны, которые не пересекли границу
        if is_calculate_irradiance
            
            in = pos(:,1) >= 0 & pos(:,2) >= 0 & pos(:,3) >=0 & pos(:,1) <= x & pos(:,2) <= y & pos(:,3) <= max_z;
            
            %count = in&(is_need_recalculation);
            count = in;
            if use_gpu
                irradiance = calculate_irradiance_simple_gpu(pos_previous(count,:), pos(count,:), weight(count), x_grid, y_grid, z_grid, irradiance);
            else
                irradiance = calculate_irradiance_simpleMK(pos_previous(count,:), pos(count,:), weight(count), x_grid, y_grid, z_grid, irradiance);
            end
            if is_show_irradiance 
                figure(1)
                imagesc( x_grid,z_grid,log10( squeeze(irradiance (:,round(numel(y_grid)/2),:)))');
                axis image;
                xlabel('Z, mm');
                ylabel('X, mm');
                colormap jet
            end
        end
        max_deep = max(max_deep, pos(:,3));
        if sum(is_need_recalculation)>0
        dir = photon_scattering(dir, g, layer, is_need_recalculation, use_gpu,is_in_het,g_het);
        end
       
        if is_calculate_histograms
            detected_photons = find(layer <=0);

            if numel(detected_photons) > 0 
                photons_deep_hist = photons_histograms(photons_deep_hist, x_grid, y_grid, hist_grid, pos(detected_photons,:), max_deep(detected_photons,:), weight(detected_photons));
				photons_deep_r_hist = photons_histograms_r(photons_deep_r_hist,source_center, r_grid, hist_grid, pos(detected_photons,:), max_deep(detected_photons,:), weight(detected_photons));
            end
        end
        
        if is_calculate_directed_escape
            opposite_escaped = layer == numel(z);
            opposite_directed_count = opposite_directed_count + get_directed_weight(is_complex_detector,pos(opposite_escaped,:), dir(opposite_escaped,:), weight(opposite_escaped), n(end-1), n(end), source_center, directed_escape_radius, directed_escape_refracted_angle);
        end
        
        if is_calculate_TR
            transmit_escaped = layer == numel(z);
            transmit_weight = transmit_weight + get_diffuse_weight(pos(transmit_escaped,:), weight(transmit_escaped),source_center,T_radius);
            if with_air
                reflect_escaped = layer == 1;
            else
                reflect_escaped = layer == 0;
            end

            sum_ref = sum_ref + sum(reflect_escaped);
            reflect_weight = reflect_weight + get_diffuse_weight(pos(reflect_escaped,:), weight(reflect_escaped),source_center,R_radius);
        end
        if with_air
            out_tissue = layer<=1 | layer>=numel(z); 
        else
            out_tissue = layer<=0 | layer>=numel(z); 
        end
        
        %смещение фотонов с границы
        pos(~is_need_recalculation,:) = pos(~is_need_recalculation,:) + bsxfun(@times, dir(~is_need_recalculation,:), 0.001);

        on = false(numel(weight),1);
        for i = 1:numel(z)
            on =on + (pos(:,3) == z(i));
        end

        out = pos(:,1) < 0 | pos(:,2) < 0 | pos(:,1) > x | pos(:,2) > y | layer <=0 | layer >= numel(z); 

        outside = outside+ sum(pos(:,1) < 0 | pos(:,2) < 0 | pos(:,1) > x | pos(:,2) > y );
        outside_weight = outside_weight + sum(weight(pos(:,1) < 0 | pos(:,2) < 0 | pos(:,1) > x | pos(:,2) > y ));

        
        [weight, absorb, dweight] = absorb_photons(weight, ma, mt,out,layer,on,use_gpu,with_PS,ma_PS_conc,is_het,ma_het,mt_het,is_in_het);

        if is_calculate_absorption_map
            
        if use_gpu
            absorption_map = calculate_absorption_simple_gpu(pos(~out&~on,:), dweight(~out&~on), x_grid, y_grid, z_grid, absorption_map);
        else
            absorption_map = calculate_absorption_simple(pos(~out&~on,:), dweight(~out&~on), x_grid, y_grid, z_grid, absorption_map);
        end
        if is_show_absorption_map
           figure(2)
           imagesc(x_grid,z_grid, log10(squeeze(absorption_map (:,round(numel(y_grid)/2),:)))');
           axis image;
           xlabel('X, mm');
           colormap jet
           ylabel('Z, mm');
        end
        end

        absorption_weight = absorption_weight + absorb;
        total_absorbed = weight <= min_weight;
        absorption_weight = absorption_weight + sum(weight(total_absorbed));
        new_photons = out | total_absorbed;
        calculated_photons = calculated_photons + sum(new_photons);

        
        [pos(new_photons,:), dir(new_photons,:), weight(new_photons,:), max_deep(new_photons,:), layer(new_photons,:)] = deal(0);
        [pos, dir, weight, max_deep, layer] = del(pos, dir, weight, max_deep, layer);
        is_in_het = is_in_het(~new_photons);
        ch = numel(weight) == numel(is_in_het);
        assert(ch, 'неправильно');
        if ~all(pos(:,3) <= max_z)
            disp('ERROR')
        end
       
        if use_gpu
            perc = gather(calculated_photons / total_photons);
        else
            perc = calculated_photons / total_photons;
        end

        if use_gpu == false
            assert(isreal(dir), '„то-то сломалось в расчете направлений');
            assert(all(~isnan(dir(:))), '„то-то сломалось в расчете направлений');
        end
        
        elapsed_time = toc;
        waitbar(perc,wb,sprintf('%g %', calculated_photons/total_photons*100));
 

    end
    
    %Ќормировка
    if is_calculate_histograms
        photons_deep_r_hist = photons_deep_r_hist./(repmat((2*[1:1:(length(r_grid)-1)]-1),numel(hist_grid) - 1,1))';
    end
    
    
    if is_calculate_TR
        T = transmit_weight/total_photons
        R = reflect_weight/total_photons
        A = absorption_weight/total_photons
        C = opposite_directed_count/total_photons
    end
    if use_gpu
        if is_calculate_irradiance
        irradiance = gather(irradiance);
        end
        if is_calculate_absorption_map
        absorption_map = gather(absorption_map);
        end
        if is_calculate_histograms
        photons_deep_r_hist = gather(photons_deep_r_hist)
        end
        C = gather(C);
        T = gather(T);
        R = gather(R);
        A = gather(A);
        z_grid = gather(z_grid);
        x_grid = gather(x_grid);
        y_grid = gather(y_grid);
    end
        
    close(wb);
    toc
   
    save(result_filename,'-v7.3');

end











