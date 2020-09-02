function irradiance = calculate_irradiance_simple(photons_coords_prev, photons_coords, weight, x_grid, y_grid, z_grid, irradiance)
    N = numel(weight);

    ix_prev = discretize(photons_coords_prev(:,1), x_grid);
    iy_prev = discretize(photons_coords_prev(:,2), y_grid);
    iz_prev = discretize(photons_coords_prev(:,3), z_grid);

    ix = discretize(photons_coords(:,1), x_grid);
    iy = discretize(photons_coords(:,2), y_grid);
    iz = discretize(photons_coords(:,3), z_grid);
     
    irradiance_size = size(irradiance);
    
    mysub2ind_func=@(i,j,k) i+(j-1)*irradiance_size(1)+(k-1)*irradiance_size(1)*irradiance_size(2);
    
    t=tic;
    for i = 1:N
        ind_prev = [ix_prev(i) iy_prev(i) iz_prev(i)];
        ind = [ix(i) iy(i) iz(i)];

        [isx,isy,isz] = bresenham_line3d_f(ind_prev, ind);

        line_indexes = mysub2ind_func(isx, isy, isz);
        try
            irradiance(line_indexes) = irradiance(line_indexes) + weight(i);
        catch
            disp('ERRRORORO!!');
        end
    end
    toc(t)