function dir = photon_scattering(dir, g, layer, is_need_recalculation, use_gpu,is_in_het,g_het)
%% ������� ��� ���������� ��������� ����� �� N �������
% dir = photon_scattering(dir, g, layers, is_need_recalculation, use_gpu)
% dir - ������� N*3, ������ ������� �������� - ��������� ������ �����������
% g - ����������� �����������
% layers - ���� �� ������� ��������� ������
% is_need_recalculation - ���������� ������ �� 0 � 1. 0 - �� ���� �������������
% �����������, 1 - ����.
% use_gpu - ������������ �� gpu ��� ����������� (0 - ���, ������ cpu)

    count = sum(is_need_recalculation);    
    if use_gpu
        phi = 2*pi*gpuArray.rand(count,1);
        eps = gpuArray.rand(count,1);
        cos_T = gpuArray.zeros(count,1);
    else
        phi = 2*pi*rand(count,1);
        eps = rand(count,1);
        cos_T = zeros(count,1);
    end
    
    g_all = ones(size(layer));
    g_all(is_need_recalculation) = g(layer(is_need_recalculation))';
    g_all(is_need_recalculation&is_in_het) = g_het;
    g_layer = g_all(is_need_recalculation);
    
    if size(g_layer, 2) >= size(g_layer, 1) && size(g_layer, 1) > 0   
        g_layer = g_layer';
    end
   
    g_positive = g_layer > 0;
    g_zero = ~g_positive; 
    
    cos_T(g_zero) = 2*eps(g_zero)-1;
    cos_T(g_positive) = (1+g_layer(g_positive).^2-(1-g_layer(g_positive).^2).^2./(1 - g_layer(g_positive) + 2*g_layer(g_positive).*eps(g_positive)).^2)./(2*g_layer(g_positive));
    
    T = acos(cos_T);
    sin_T = sin(T);

    cos_phi = cos(phi);
    sin_phi = sin(phi);
       
    mx = dir(is_need_recalculation,1);
    my = dir(is_need_recalculation,2);
    mz = dir(is_need_recalculation,3);

    temp_mz = sqrt(1-mz.*mz);
    
    ind_direct = find(abs(mz) == 1);

    ind_need_recalculation = find(is_need_recalculation);
   	dir(ind_need_recalculation,1) = mx.*cos_T+sin_T.*(mx.*mz.*cos_phi-my.*sin_phi)./temp_mz;
	dir(ind_need_recalculation,2) = my.*cos_T+sin_T.*(my.*mz.*cos_phi+mx.*sin_phi)./temp_mz;
	dir(ind_need_recalculation,3) = mz.*cos_T-temp_mz.*sin_T.*cos_phi;

    dir(ind_need_recalculation(ind_direct),1) = sin_T(ind_direct).*cos_phi(ind_direct);
    dir(ind_need_recalculation(ind_direct),2) = sin_T(ind_direct).*sin_phi(ind_direct);
    dir(ind_need_recalculation(ind_direct),3) = sign(mz(ind_direct)).*cos_T(ind_direct);
end