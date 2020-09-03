function irradiance = calculate_irradiance_simpleMK(photons_coords_prev, photons_coords, weight, x_grid, y_grid, z_grid, irradiance)
    N = numel(weight);

%     ix_prev = discretize(photons_coords_prev(:,1), x_grid);
%     iy_prev = discretize(photons_coords_prev(:,2), y_grid);
%     iz_prev = discretize(photons_coords_prev(:,3), z_grid);
% 
%     ix = discretize(photons_coords(:,1), x_grid);
%     iy = discretize(photons_coords(:,2), y_grid);
%     iz = discretize(photons_coords(:,3), z_grid);
     
    irradiance_size = size(irradiance);
    
    mysub2ind_func=@(i,j,k) i+(j-1)*irradiance_size(1)+(k-1)*irradiance_size(1)*irradiance_size(2);
    
    t=tic;
    for i = 1:N
      %  ind_prev = [ix_prev(i) iy_prev(i) iz_prev(i)];
     %   ind = [ix(i) iy(i) iz(i)];

       
        c1=photons_coords_prev(i,:);
        c2=photons_coords(i,:);
        z_min = find(z_grid>=min(c1(3),c2(3)),1,'first');
        z_max = find(z_grid<=max(c1(3),c2(3)),1,'last');
        
        
        if z_min>z_max 
            isz=[];
        else
            isz=z_grid(z_min):abs(z_grid(2)-z_grid(1)):z_grid(z_max);
            indz=z_min:z_max;
        end
                % [c1(3) c2(3) ]
                % isz(:)
        
        if not (isempty(isz))
        %isz    
        isx=(c1(1)+(c2(1)-c1(1))*(isz-c1(3))/(c2(3)-c1(3)));
        isy=(c1(2)+(c2(2)-c1(2))*(isz-c1(3))/(c2(3)-c1(3)));
       
      
        
        exclude1=find((isx>=max(x_grid)) | (isy>=max(y_grid)) | (isx<min(x_grid)) | (isy<min(y_grid)) | (isz>=max(z_grid)));
        %exclude2=find(isy>max(y_grid));
        %exclude3=find(isx<min(x_grid));
        %exclude4=find(isy<min(y_grid));
        
        isx(exclude1)=[];
        isy(exclude1)=[];
        isz(exclude1)=[];
        indz(exclude1)=[];
        
        
        indx=floor (isx/abs(x_grid(2)-x_grid(1)))+1;
        indy=floor (isy/abs(y_grid(2)-y_grid(1)))+1;
        %indz=ceil (isz/abs(z_grid(2)-z_grid(1)))+1;
        end
        
        %[c1(3) c2(3) isz(:)] 

        
        
        
        if not (isempty(isz))
            
        %[c1(3) c2(3)]    
        %isx=uint16(isx)
        %isy=uint16(isy)
        %isz=uint16(isz)  
        
        
        %[isx,isy,isz] = bresenham_line3d_f(ind_prev, ind, x_grid, y_grid, z_grid,);
        line_indexes = mysub2ind_func(indx, indy, indz);
        try
            irradiance(line_indexes) = irradiance(line_indexes) + weight(i);
        catch
            indx
            indy
            indz
            disp('ERRRORORO!!');
        end
        end
    end
    toc(t)