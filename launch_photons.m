function [pos, dir, weight, max_deep, layer,l] = launch_photons(is_circle,source_center,source_width,x_grid,y_grid,dx,dy,sourse_direction, count, use_gpu)
    if use_gpu  
        if is_circle
             [x, y] = circle(source_width, count,source_center);
         else
            [x,y] = square(source_width, count,source_center);
            % pos = [x_grid(randi([(source_center(1)-round(source_width(1)/2))/dx (source_center(1)+round(source_width(1)/2))/dx],count,1)+1)' y_grid(randi([(source_center(2)-round(source_width(2)/2))/dy (source_center(2)+round(source_width(2)/2))/dy],count,1)+1)' zeros(count,1)];
         end
        pos = gpuArray([x y zeros(count,1)]);
        dir = gpuArray(repmat(sourse_direction, count, 1));
        weight = gpuArray.ones(count,1);
        max_deep = gpuArray.zeros(count,1);
        layer = gpuArray.ones(count,1);
       
    else

         if is_circle
            [x, y] = circle(source_width, count,source_center);
         else
            [x,y] = square(source_width, count,source_center);
            % pos = [x_grid(randi([(source_center(1)-round(source_width(1)/2))/dx (source_center(1)+round(source_width(1)/2))/dx],count,1)+1)' y_grid(randi([(source_center(2)-round(source_width(2)/2))/dy (source_center(2)+round(source_width(2)/2))/dy],count,1)+1)' zeros(count,1)];
         end
        
        if use_gpu
        pos = gpuArray([x y zeros(count,1)]);
        dir = gpuArray(repmat(sourse_direction, count, 1));
        weight = gpuArray(ones(count,1));
        max_deep = gpuArray(zeros(count,1));
        layer = gpuArray(ones(count,1));
        else
        pos = [x y zeros(count,1)];
        dir = repmat(sourse_direction, count, 1);
        weight = ones(count,1);
        max_deep = zeros(count,1);
        layer = ones(count,1);
        l = zeros(count,1);
        end
    end

end

function res = random(c,N)
   res = c(1)+(c(2)-c(1)).*rand(N,1);
end