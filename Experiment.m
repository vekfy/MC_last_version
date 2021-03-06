d_PS=[0.25 0.5 1 2 3];


for var=1:numel(d_PS)
    filename_blue=['MC_irr_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];

    
    ma_PS=0.12;
    ma_tis=0.89;
    ma_tot=ma_tis+ma_PS;
    
    MonteCarlo_Rect(...
       'is_fluor',false,'map_filename','map.mat',...
       'is_calculate_absorption_map',true,...
       'is_show_absorption_map',true,...
       'is_calculate_irradiance', false,...
       'is_show_irradiance',false,...
       'is_calculate_histograms',false,'d_hist',0.5,'d_r_hist',0.5, ...
       'with_air',false,...
       'detectors_on',false,...
       'detector_angl',30*pi/180,
       ...
       'result_filename',filename_blue,...
       ...
       'total_photons',1e6,...
       'ma',[ma_tot ma_tis], 'ms',[48.1650 48.1650], 'g',[0.8 0.8],'n_in',[1.37 1.37],'n_out',[1 1.37],'n_air', 1,...
       ...
       'z',[0 d_PS(var) 6],'x',20,'y',20,...
       ...
       'dx',0.25,'dy',0.25,'dz',0.25,...
       ...
       'is_circle',false,'source_center', [10 10 0],'source_width',[15 15],...
       'with_PS',false,'wavelenght',405,...
       ...
       'is_calculate_directed_escape',false,'is_complex_detector',true,...
       'directed_escape_radius',[1.7,5],'directed_escape_refracted_angle',pi/180,...
       'is_calculate_TR',false,'T_radius', 8,'R_radius',8,...
       ...
       'is_het',false,'het_cilind', false,'x0',5, 'a', 1,'y0', 5, 'b',1, 'z0',1,'c',1,'d',1,...
       'ma_het',0.2,'ms_het',1,'g_het',0.9,...
       ...
       'min_weight', 1e-5)

end

for var=1:numel(d_PS)
    filename_red=['MC_irr_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    
    ma_PS=0.04;
    ma_tis=0.15;
    ma_tot=ma_tis+ma_PS;
    
    MonteCarlo_Rect(...
       'is_fluor',false,'map_filename','map.mat',...
       'is_calculate_absorption_map',true,...
       'is_show_absorption_map',true,...
       'is_calculate_irradiance', false,...
       'is_show_irradiance',false,...
       'is_calculate_histograms',false,'d_hist',0.5,'d_r_hist',0.5, ...
       'with_air',false,...
       'detectors_on',false,...
       ...
       'result_filename',filename_red,...
       ...
       'total_photons',1e6,...
       'ma',[ma_tot ma_tis], 'ms',[18.3950 18.3950], 'g',[0.8 0.8],'n_in',[1.37 1.37],'n_out',[1 1.37],'n_air', 1,...
       ...
       'z',[0 d_PS(var) 6],'x',20,'y',20,...
       ...
       'dx',0.25,'dy',0.25,'dz',0.25,...
       ...
       'is_circle',false,'source_center', [10 10 0],'source_width',[15 15],...
       'with_PS',false,'wavelenght',405,...
       ...
       'is_calculate_directed_escape',false,'is_complex_detector',true,...
       'directed_escape_radius',[1.7,5],'directed_escape_refracted_angle',pi/180,...
       'is_calculate_TR',false,'T_radius', 8,'R_radius',8,...
       ...
       'is_het',false,'het_cilind', false,'x0',5, 'a', 1,'y0', 5, 'b',1, 'z0',1,'c',1,'d',1,...
       'ma_het',0.2,'ms_het',1,'g_het',0.9,...
       ...
       'min_weight', 1e-5)

end


for var=1:numel(d_PS)
    filename_blue=['MC_irr_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    filename_red=['MC_irr_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    map_blue=['map_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    map_red=['map_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    
    ma_PS=0.12;
    ma_tis=0.89;
    ma_tot=ma_tis+ma_PS;
    load(filename_blue);
    z_ps_top=find(z_grid==z(1));
    z_ps_bot=find(z_grid==z(2));
    absorption_map(:,:,z_ps_top:z_ps_bot-1)=absorption_map(:,:,z_ps_top:z_ps_bot-1)*(ma_tot-ma_tis)/ma_tot;
    absorption_map(:,:,z_ps_bot:end)=0;
    

    save(map_blue,'-v7.3');
        
    
    load(filename_red);
        
    ma_PS=0.04;
    ma_tis=0.15;
    ma_tot=ma_tis+ma_PS;
    z_ps_top=find(z_grid==z(1));
    z_ps_bot=find(z_grid==z(2));
    absorption_map(:,:,z_ps_top:z_ps_bot-1)=absorption_map(:,:,z_ps_top:z_ps_bot-1)*(ma_tot-ma_tis)/ma_tot;
    absorption_map(:,:,z_ps_bot:end)=0;

    save(map_red,'-v7.3');
end

for var=1:numel(d_PS)
    filename_blue=['MC_irr_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    filename_red=['MC_irr_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    map_blue=['map_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    map_red=['map_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    
    filename_fluor_blue=['MC_fluor_blue_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
    
    MonteCarlo_Rect(...
       'with_air',false,...
       'is_fluor',true,'map_filename',map_blue,...
       'is_calculate_absorption_map',false,...
       'is_show_absorption_map',false,...
       'is_calculate_irradiance', false,...
       'is_show_irradiance',false,...
       'is_calculate_histograms',false,'d_hist',0.5,'d_r_hist',0.5, ...
       'detectors_on',true,...
       ...
       'result_filename',filename_fluor_blue,...
       ...
       'total_photons',1e6,...
       'ma',[0.13], 'ms',[ 15.4700], 'g',[0.8],'n_in',[1.37],'n_out',[1 1.37],'n_air', 1,...
       ...
       'z',[0 6],'x',20,'y',20,...
       ...
       'dx',0.25,'dy',0.25,'dz',0.25,...
       ...
       'is_circle',false,'source_center', [10 10 0],'source_width',[15 15],...
       'with_PS',false,'wavelenght',405,...
       ...
       'is_calculate_directed_escape',false,'is_complex_detector',true,...
       'directed_escape_radius',[1.7,5],'directed_escape_refracted_angle',pi/180,...
       'is_calculate_TR',false,'T_radius', 8,'R_radius',8,...
       ...
       'is_het',false,'het_cilind', false,'x0',5, 'a', 1,'y0', 5, 'b',1, 'z0',1,'c',1,'d',1,...
       'ma_het',0.2,'ms_het',1,'g_het',0.9,...
       ...
       'min_weight', 1e-5)
   
    
     filename_fluor_red=['MC_fluor_red_msPlus30_' num2str(d_PS(var)) 'mm.mat'];
     
     MonteCarlo_Rect(...
       'with_air',false,...
       'is_fluor',true,'map_filename',map_red,...
       'is_calculate_absorption_map',false,...
       'is_show_absorption_map',false,...
       'is_calculate_irradiance', false,...
       'is_show_irradiance',false,...
       'is_calculate_histograms',false,'d_hist',0.5,'d_r_hist',0.5, ...
       'detectors_on',true,...
       ...
       'result_filename',filename_fluor_red,...
       ...
       'total_photons',1e6,...
       'ma',[0.13], 'ms',[ 15.4700], 'g',[0.8],'n_in',[1.37],'n_out',[1 1.37],'n_air', 1,...
       ...
       'z',[0 6],'x',20,'y',20,...
       ...
       'dx',0.25,'dy',0.25,'dz',0.25,...
       ...
       'is_circle',false,'source_center', [10 10 0],'source_width',[15 15],...
       'with_PS',false,'wavelenght',405,...
       ...
       'is_calculate_directed_escape',false,'is_complex_detector',true,...
       'directed_escape_radius',[1.7,5],'directed_escape_refracted_angle',pi/180,...
       'is_calculate_TR',false,'T_radius', 8,'R_radius',8,...
       ...
       'is_het',false,'het_cilind', false,'x0',5, 'a', 1,'y0', 5, 'b',1, 'z0',1,'c',1,'d',1,...
       'ma_het',0.2,'ms_het',1,'g_het',0.9,...
       ...
       'min_weight', 1e-5)

end