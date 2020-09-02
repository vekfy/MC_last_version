%% test_1
%% Тест Ванга "Документы/MCML Wang Jaques.pdf" стр. 57
MonteCarlo_Rect('is_calculate_TR',true,'with_air', true,'use_gpu',false,'is_calculate_irradiance', false, 'is_show_irradiance',false,'is_calculate_histograms',false,'result_filename','MC_Wang_test1.mat','ma',1, 'ms',9, 'g',0.75, 'z',[0 0.2],'dx',0.05,'dy',0.05,'dz',0.05,'n_in',1,'T_radius', 10,'R_radius',10, 'min_weight', 1e-5,'total_photons',1e6)
load('MC_Wang_test1.mat');

R_Wang_mean = 0.09734;
R_Wang_std = 0.00035;

T_Wang_mean = 0.66096;
T_Wang_std = 0.0002;
 
assert(abs(R - R_Wang_mean)< R_Wang_std); 
assert(abs(T - T_Wang_mean)< T_Wang_std);

%%  test_2
%% Simple test
MonteCarlo_Rect('is_calculate_TR',true,'is_calculate_irradiance', false, 'is_show_irradiance',false,'is_calculate_histograms',false,'result_filename','MC_simple_test.mat','ma',0, 'ms',0, 'g',1, 'z',[0 1],'dx',0.05,'dy',0.05,'dz',0.05,'n_in',1,'T_radius', 5,'R_radius',5, 'min_weight', 1e-5,'total_photons',1e6)
load('MC_simple_test.mat');
assert(abs(R) < 0.00001); 
assert(abs(T) > 0.99999);

%% test_3
%% Тест Ванга "Документы/MCML Wang Jaques.pdf" стр. 57
MonteCarlo_Rect('is_calculate_TR',true,'with_air', false,'is_calculate_irradiance', false, 'is_show_irradiance',false,'is_calculate_histograms',false,'result_filename','MC_Wang_test2.mat','ma',1, 'ms',9, 'g',0, 'z',[0 10],'dx',0.05,'dy',0.05,'dz',0.05,'n_in',1.5,'T_radius', 5,'R_radius',5, 'min_weight', 1e-5,'total_photons',1e6)
load('MC_Wang_test2.mat');

R_Wang_mean = 0.25907;
R_Wang_std = 0.00170;

 
assert(abs(R - R_Wang_mean)< R_Wang_std); 

