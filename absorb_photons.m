function [weight,absorb,dweight] = absorb_photons(weight, ma, mt,out,layer,on,use_gpu,with_PS,ma_PS,is_het,ma_het,mt_het, is_in_het)
delt = zeros(numel(weight),1);
if with_PS
    delt(~out&~on) = ((ma(layer(~out&~on))+ma_PS(~out&~on))./(mt(layer(~out&~on))+ma_PS(~out&~on)))';
else
    delt(~out&~on) = (ma(layer(~out&~on))./mt(layer(~out&~on)))';
end

if is_het
    if with_PS
        delt(is_in_het&(~out&~on)) = ((ma_het+ma_PS(is_in_het&(~out&~on)))./(mt_het+ma_PS(is_in_het&(~out&~on))))';
    else
        delt(is_in_het&(~out&~on)) = ((ma_het)./(mt_het))';
    end
end
delt(isnan(delt)) = 0;
absorb = sum(weight.*delt);

if use_gpu
    dweight =gpuArray( zeros(size(weight)));
    dweight = weight.*delt;
else
    dweight = zeros(size(weight));
    dweight = weight.*delt;
end

weight = weight.*(1 - delt);

end
