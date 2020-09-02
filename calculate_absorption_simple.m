function absorption = calculate_absorption_simple(photons_coords, weight, x_grid, y_grid, z_grid, absorption)
    N = numel(weight);
 

    ix = discretize(photons_coords(:,1), x_grid);
    iy = discretize(photons_coords(:,2), y_grid);
    iz = discretize(photons_coords(:,3), z_grid);
    
    for i = 1:N
     absorption(ix(i),iy(i),iz(i)) = absorption(ix(i),iy(i),iz(i)) + weight(i);
    end

end