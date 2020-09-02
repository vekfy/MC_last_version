function [pos, dir, weight, max_deep, layer] = launch_photons_isotropic_point_source(count,source_center,z)

pos = repmat(source_center, count, 1);
dir = rand_dir(count);
weight = ones(count,1);
max_deep = ones(count,1)*source_center(3);
layer = find(source_center(3)>z,1,'last').*ones(count,1);
end
function res = random(c,N)
res = c(1)+(c(2)-c(1)).*rand(N,3);
end
function direction = rand_dir(count)
cosT =  2*random([0 1],count) - 1;
sinT = sqrt(1-cosT.^2);
u = 2*pi*random([0 1],count);
cosU = cos(u);
if u<pi
    sinU = sqrt(1-cosU.^2);
else
    sinU = - sqrt(1- cosU.^2);
end
direction = [sinT.*cosU sinT.*sinu cosT];

end