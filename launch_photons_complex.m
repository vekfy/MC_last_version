function [pos, dir, weight, max_deep, layer] = ...
    launch_photons_complex(source_map,x_grid,y_grid,z_grid,dx,dy,dz)


ind = find(source_map~=0);
[i1, i2, i3] = ind2sub(size(source_map), ind);
for i = 1 :numel(i1)
    inc(i) = source_map(i1(i),i2(i),i3(i));
end
numb = floor(inc);
delt  = inc - numb;
% 
% numel(i1)

generPOS = @(x_grid, y_grid, z_grid, i1, i2, i3,numb,dx,dy,dz)...
    repmat([x_grid(i1)+dx/2,y_grid(i2)+dy/2,z_grid(i3)+dz/2],numb+1,1);
generWeight = @(numb,delt)[ones(numb,1); delt];
generDIR= @(numb) [normr(random([-1 1],numb+1));];
generLayer = @(numb) [ones(numb+1,1)];

WaitMessage = parfor_wait(numel(i1), 'Waitbar', true);
parfor i = 1 :numel(i1)
    
    pos{i} = feval(generPOS,x_grid, y_grid, z_grid, i1(i), i2(i), i3(i),numb(i),dx,dy,dz);
    weight{i} = feval(generWeight,numb(i),delt(i));
    dir{i} = feval(generDIR,numb(i));
    layer{i} = feval(generLayer,numb(i));
    WaitMessage.Send;
    pause(0.002);
end
WaitMessage.Destroy
pos = vertcat(pos{:});
weight = vertcat(weight{:});
dir = vertcat(dir{:});
max_deep = pos(:,3);
layer = vertcat(layer{:});

end

function res = random(c,N)
   res = c(1)+(c(2)-c(1)).*rand(N,3);
end