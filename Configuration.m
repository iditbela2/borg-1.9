classdef Configuration
    
    properties
        
        
        GRID_SIZE = 600;
        WIND_SPEED = 5; %m/sec
        WIND_DIRECTION = 270; % degrees, west-wind
        EFFECTIVE_HEIGHT = 5; % meters
        GRID_SCALE = 1; % each grid cell is representing this scale, in meters
        NOISE_RANGE = 1e-16;
        STABILITY_PARAMETER_a = 104;
        STABILITY_PARAMETER_c = 61;
        STABILITY_PARAMETER_d = 0.911;
        STABILITY_PARAMETER_f = 0;
        
        
    end
    
    
end