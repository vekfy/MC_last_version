function [det_weights, det_angls, det_depths] = check_detectors_line(det_weights, det_angls, det_depths,pos,dir, weight,max_deep,numb_detectors, detector_grid,detector_d, center)
%MonteCarlo_Rect('is_calculate_irradiance',false, 'is_show_irradiance', false, 'is_calculate_absorption_map', false)
weights = zeros(1,numb_detectors);
depths = zeros(1,numb_detectors);
angls = zeros(1,numb_detectors);
    for i = 1 : numb_detectors
        suspect = (pos(:,1)>=detector_grid(i))&(pos(:,1)<detector_grid(i+1))&(pos(:,2)>= center - detector_d/2)&(pos(:,2)<= center + detector_d/2);
       %save photons parameters
       if sum(suspect)>0
           if isempty(weights)
               weights(:,i) = weight(suspect)';
               depths(:,i) = max_deep(suspect)';
               angls(:,i) = angles_of_incidence(dir(suspect,:))';
           else
               weights(1:numel(weight(suspect)),i) = weight(suspect);
               depths(1:numel(weight(suspect)),i) = max_deep(suspect);
               angls(1:numel(weight(suspect)),i) = angles_of_incidence(dir(suspect,:));
           end
       end

    end
    %outputs
    det_weights = [det_weights; weights];
    det_angls = [det_angls; angls];
    det_depths = [det_depths; depths];
end