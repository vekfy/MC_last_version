function diffusive_count =get_diffuse_weight(pos, weight, center, max_radius)
    pos_xy = pos(:,1:2);
    dist_from_center = sqrt(sum(bsxfun(@minus, pos_xy, center(1:2)).^2,2));
    diffusive_count = sum(weight(dist_from_center<=max_radius));
end