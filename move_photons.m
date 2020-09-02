function pos = move_photons(pos, dir, layer, mt, use_gpu,ma_PS,with_PS,is_het, is_in_het,mt_het)
count = size(dir, 1);
if use_gpu
    eps = gpuArray.rand(count,1);
else
    eps = rand(count,1);
end
if with_PS
    s = -log(eps)./(mt(1, layer)+ma_PS)';
else
    s = -log(eps)./(mt(1, layer))';
end
if is_het
    if with_PS
        s(is_in_het) = -log(eps(is_in_het))./(mt(1, layer(is_in_het))+mt_het+ma_PS(is_in_het))';
    else
        
        s(is_in_het) = -log(eps(is_in_het))./(mt_het)';
    end
end

s(s==Inf) = 100;
pos = pos + bsxfun(@times, dir, s);
end