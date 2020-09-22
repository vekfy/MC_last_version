function detector_matrix = detected(detector_matrix,pos,dir, weight,x_grid,y_grid)
%MonteCarlo_Rect('is_calculate_irradiance',false, 'is_show_irradiance', false, 'is_calculate_absorption_map', false)

ix = discretize(pos(:,1), x_grid);
iy = discretize(pos(:,2), y_grid);
save('data.mat')
for i = 1:numel(weight)
detector_matrix(ix(i),iy(i)) = detector_matrix(ix(i),iy(i)) + weight(i)*dir(i,3);
end


end