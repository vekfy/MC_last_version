function [det_weights, det_angls, det_depths] = check_detectors_rings(det_weights, det_angls, det_depths,pos,dir, weight,max_deep,numb_detectors,source_center, detector_ring_grid)
%MonteCarlo_Rect('is_calculate_irradiance',false, 'is_show_irradiance', false, 'is_calculate_absorption_map', false)
weights = zeros(1,numb_detectors);
depths = zeros(1,numb_detectors);
angls = zeros(1,numb_detectors);
    for i = 1 : (numb_detectors)
       r = sqrt((pos(:,1)-source_center(1)).^2 + (pos(:,2)-source_center(2)).^2);
       suspect = (r>=detector_ring_grid(i))&(r<detector_ring_grid(i+1));
       %save photons parameters
       if sum(suspect)>0
           if isempty(weights)
               weights(:,i) = weight(suspect)';
               depths(:,i) = max_deep(suspect)';
               angls(:,i) = (dir(suspect,3))';
           else
               weights(1:numel(weight(suspect)),i) = weight(suspect);
               depths(1:numel(weight(suspect)),i) = max_deep(suspect);
               angls(1:numel(weight(suspect)),i) = dir(suspect,3);
           end
       end

    end
    %outputs
    det_weights = [det_weights; weights];
    det_angls = [det_angls; angls];
    det_depths = [det_depths; depths];
end