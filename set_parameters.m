function params = set_parameters(varargin)
%% params = set_parameters(varargin)

    params = set_default_parameters();
    if mod(nargin, 2) == 1
        error('myApp:argChk', 'Wrong number of input arguments');
    end
    
    for i=1:2:nargin,
        params.(varargin{i}) = varargin{i+1};
    end
    
    params.n = [params.n_out(1), params.n_in, params.n_out(2)];

    
    check_parameters(params);
end

function params = set_default_parameters()
    params.use_gpu = false;
    params.is_circle = true;
    params.is_calculate_irradiance = true;     
    params.is_show_irradiance = true;          
    params.is_calculate_directed_escape = false; 
    params.is_calculate_histograms = false;        
    params.is_calculate_TR = false;
    params.result_filename = 'MC.mat';
    params.is_complex_detector = false;
    params.is_calculate_absorption_map = false;
    params.is_show_absorption_map = false; 
    params.is_show_absorption_map = false;
    params.with_PS = false;
    params.wavelenght = 405;
    params.with_air = false;
  
    %detectors parameters
    params.detectors_on = false;
    params.ODR_on = false;
    params.detector_angl = pi; 
    params.custom_ring_grid = false;
    params.ring_grid = [0 1 2];
    params.detector_is_ring = true;
    params.detector_d = 1; 
    params.dx_detector = 1;
    params.dy_detector = 2;
    params.center_detector = 5;
    params.angl_detector = 30*pi/180; 
    
    %heterogeneity 
    params.x0 = 5;
    params.a  = 1;
    params.y0 = 5;
    params.b = 1;
    params.z0 = 1;
    params.c = 1;
    params.d = 1;
    params.is_het = false;
    params.het_cylinder = false;
    params.ma_het = 0.2;
    params.ms_het = 1;
    params.g_het = 0.9;
    params.map_filename = 'map.mat';
 

    %PS parameters
    params.C00 = 4; %ml
    params.alpha = 0.6; %mm^-1
    params.PSconc_total = 1; %ml
    params.z_pentr = 4; %mm
    params.var_conc = 1;
    params.total_photons = 1e6;                
    params.x = 10; %mm
    params.y = 10; %mm
    params.z = [0 5];  %mm     

    
    %fluorescence 
    params.is_fluor = false;
    
    params.ma = [0.1];  %mm^-1   
    params.ms = [2]; %mm^-1     
    params.g = [0.7];           
    params.n_in = 1.33;        
    params.n_out = [1 1];        

    
    params.dx = 0.05;           
    params.dy = 0.05;           
    params.dz = 0.05;           
    params.d_hist = 0.05;
    params.d_r_hist = 0.05;

    params.directed_escape_radius = 2;       
    params.directed_escape_refracted_angle =pi/180;  
    params.T_radius = 0.5;   
    params.R_radius = 0.5;  
    
    params.adjacent_directed_count = 0;
    params.opposite_directed_count = 0;
    
    params.source_center = [5 5 0];
    params.source_width = 0;
    params.source_direction = [0 0 1];
    params.min_weight = 1e-5;
    
end

function check_parameters(params)
    assert(numel(params.ma) == numel(params.ms),'Lengths of ma and ms are different');
    assert(numel(params.ma) == numel(params.g),'Lengths of ma and g are different');
    assert(numel(params.ma) == numel(params.n_in),'Lengths of optical properties and n_in are different');
    assert(numel(params.z) == numel(params.n_in) + 1, 'Lengths of z is equal length(n_in)+1 ');
end