     %% scattering 
    N = 1e6;
    use_gpu=false;
    is_in_het = false(N,1);
    g_het = 0.9;
    
    if use_gpu
        dir_0 = gpuArray.rand(N,3);
    else
        dir_0 = rand(N,3);
    end
    dir_0 = normr(dir_0);
    is_need_recalculation_test = true(N,1);
    layer_test = ones(N,1); 
    for g=0:0.1:1,
        dir_calc = photon_scattering(dir_0, g, layer_test, is_need_recalculation_test, false,is_in_het,g_het);
        cos_T = dot(dir_calc, dir_0, 2);
        mean_cos_T = mean(cos_T);
        std_cos_T = std(cos_T)/sqrt(N);

        %Standard deviation = sd
        %в качестве оценки в assert можно выбирать среднеквадратичное
        %отклонение
        %sd = sqrt((sum((cos_T - expect_cos_T).^2))/N);
        assert(abs(mean_cos_T - g)< 3*std_cos_T, sprintf('Error with g=%2.1f', g)); 
    end