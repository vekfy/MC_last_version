function [x, y] = square(a, count,center)
x = rand(count,1)*a(1);
y = rand(count,1)*a(2);
x = x + center(1)-a(1)/2;
y = y + center(2)-a(2)/2;
end