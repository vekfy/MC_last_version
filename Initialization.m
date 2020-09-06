   %% Initialization.m contains a template for initialization of MC-function variables

   MonteCarlo_Rect(...
       'is_fluor',false,'map_filename','map.mat',...
       'is_calculate_absorption_map',false,...
       'is_show_absorption_map',false,...
       'is_calculate_irradiance', true,...
       'is_show_irradiance',true,...
       'is_calculate_histograms',false,'d_hist',0.5,'d_r_hist',0.5, ...
       'with_air',true,...
       ...
       'result_filename','MC.mat',...
       ...
       'total_photons',1e7,...
       'ma',[0.13], 'ms',[11.9], 'g',[0.8],'n_in',[1.38],'n_out',[1 1],...
       ...
       'z',[0 6],'x',20,'y',20,...
       ...
       'dx',0.25,'dy',0.25,'dz',0.25,...
       ...
       'is_circle',false,'source_center', [10 10 0],'source_width',[2 2],'source_direction',[0 0 1],...
       ...
       'with_PS',false,'wavelenght',405,'alpha',0.6,'PSconc_total',1,...
       'z_pentr',4,'var_conc',1,...
       ...
       'is_calculate_directed_escape',false,'is_complex_detector',true,...
       'directed_escape_radius',[5,5],'directed_escape_refracted_angle',pi/180,...
       'is_calculate_TR',false,'T_radius', 8,'R_radius',8,...
       ...
       'is_het',false,'het_cilind', false,'x0',5, 'a', 1,'y0', 5, 'b',1, 'z0',1,'c',1,'d',1,...
       'ma_het',0.2,'ms_het',1,'g_het',0.9,...
       ...
       'min_weight', 1e-5)