function is_in_het = check_het(pos, x0, y0, z0, a, b, c)
%% находится ли фотон после перемещения внутри неоднородности?
    N = size(pos);
    is_in_het = false(N(1),1);
    is_in_het = ((((pos(:,1)-x0)/a).^2+((pos(:,2)-y0)/b).^2+((pos(:,3)-z0)/c).^2)<=1);
end
