function C = concentration(C00, a,  pos, z_grid)%, x_grid, y_grid)%,b, irradiance, time)
    
%     ix = discretize(pos(:,1), x_grid);
%     iy = discretize(pos(:,2), y_grid);
    iz = discretize(pos(:,3), z_grid);
    C0_f = @(z,C00,a) C00*exp(-a*z);
    C = C0_f(z_grid(iz),C00,a);

%     C_f = @(I,C0,t,b) C0.*exp(-I*t/b);
%     for i = 1: numel(ix)
%         irr(i) = irradiance(ix(i),iy(i),iz(i));
%     end
%     C = C_f(irr', C0, time,b);
end