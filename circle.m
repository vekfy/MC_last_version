function [x, y] = circle(R, count, center)
      u = 2*pi*rand(count,1);
      r = R*sqrt(rand(count,1));
      x = center(1)+r.*cos(u);
      y = center(2)+r.*sin(u);
end