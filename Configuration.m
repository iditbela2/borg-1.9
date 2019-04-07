classdef Configuration
    
    properties (Access = public)
        
        GRID_SIZE = 600;
        WIND_SPEED = []; %m/sec
        WIND_DIRECTION = []; % degrees, west-wind
        EFFECTIVE_HEIGHT = 5; % meters
        GRID_SCALE = 1; % each grid cell is representing this scale, in meters
        NOISE_RANGE = 1e-16;
        STABILITY_PARAMETER_a = 104;
        STABILITY_PARAMETER_c = 61;
        STABILITY_PARAMETER_d = 0.911;
        STABILITY_PARAMETER_f = 0;
        
    end
%     methods
%         function obj = setWIND_DIRECTION(obj,direction)
%             obj.WIND_DIRECTION = direction;
%         end
%         function obj = setWIND_SPEED(obj,speed)
%             obj.WIND_SPEED = speed; %m/sec
%         end
%         function d = getWIND_DIRECTION(obj)
%             d = obj.WIND_DIRECTION;
%         end
%         function s = getWIND_SPEED(obj)
%             s = obj.WIND_SPEED;
%         end
%     end
    
end

% ORIGINAL
%         GRID_SIZE = 600;
%         WIND_SPEED = 5; %m/sec
%         WIND_DIRECTION = 270; % degrees, west-wind
%         EFFECTIVE_HEIGHT = 5; % meters
%         GRID_SCALE = 1; % each grid cell is representing this scale, in meters
%         NOISE_RANGE = 1e-16;
%         STABILITY_PARAMETER_a = 104;
%         STABILITY_PARAMETER_c = 61;
%         STABILITY_PARAMETER_d = 0.911;
%         STABILITY_PARAMETER_f = 0;