function res = normr(data)
%% function res = normr(data)
% ������� ��� ������������ ������� data �� �������
    norm = sqrt(sum(data.^2, 2));
    res = bsxfun(@rdivide, data, norm); 
    