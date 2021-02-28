function photons_deep_hist = photons_histograms_r(photons_deep_hist,source_position, r_grid, hist_grid, pos, max_deep, weight)
	r = sqrt((pos(:,1)-source_position(1)).^2 + (pos(:,2)-source_position(2)).^2);
    ir = discretize(r, r_grid);
    ind_max_deep = discretize(max_deep, hist_grid);
    
    out = isnan(ir);
    ir(out) = [];
    ind_max_deep(out) = [];
    weight(out) = [];
    
    ind_deep = sub2ind(size(photons_deep_hist), ir, ind_max_deep);
    accum_deep = accumarray(ind_deep, weight);
    ind_deep = [1:max(ind_deep)]';
    photons_deep_hist(ind_deep) = photons_deep_hist(ind_deep) + accum_deep;
end