function directed_count = get_directed_weight(is_complex_detector,pos, dir, weight, n_in, n_out, center, max_radius, max_refracted_angle)
    if numel(pos)>0
    if is_complex_detector
       dist_x = abs(pos(:,1)-center(1));
       dist_y = abs(pos(:,2)-center(2));
       suspect = find((dist_x<=max_radius(1))&(dist_y<=max_radius(2)));
    else 
       %dist_from_center = sqrt(sum(bsxfun(@minus, pos, center).^2,2));
       dist_from_center = sqrt((pos(:,1)-center(1)).^2+(pos(:,2)-center(2)).^2);
       suspect = find(dist_from_center<=max_radius);
    end
    else
        suspect = [];
    end
    dir_suspect = dir(suspect, :);
    angle_incidence = angles_of_incidence(dir_suspect);
    angle_refraction = angles_of_refraction(angle_incidence, n_in, n_out);
    
    suspect = suspect(abs(angle_refraction) <= max_refracted_angle);
    
    directed_count = sum(weight(suspect));
end