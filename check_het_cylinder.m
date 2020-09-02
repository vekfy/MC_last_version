function is_in_het = check_het_cylinder(pos, y0, z0, d)
%% находится ли фотон после перемещения внутри неоднородности?
    N = size(pos);
    is_in_het = false(N(1),1);
    is_in_het((  ((pos(:,3)-z0)/(d/2)).^2+((pos(:,2)-y0)/(d/2)).^2)<=1) = true ;
end
