classdef API
   
   properties
       configFile = Configuration;
   
   end
    
    
    methods
        
        
        
        function [d] = distance(~, x1_cor, y1_cor, x2_cor, y2_cor)
            
            d = sqrt( (x1_cor -x2_cor)^2  + (y1_cor -y2_cor)^2 );
            
            %end of function
        end
        
            % return the slope of vector from wind direction.
            % The wind direction, omega, is accepted from the user, the
            % angle in degrees.
            % Let alpha be the angle between the vector of the wind direction and
            % the positive direction of X axis
            % alphe  = 270(in degrees)  - omega
            % m =  tan(alpha)
            function [m]  = getCurveByWindDirection(~, windDirection)
                
                omega = windDirection;
                alpha = 270 - omega ;
                %convert to radians
                alpha  = deg2rad(alpha);
                m =  tan(alpha);
                
                
            end
            
            %return the equation of a line by the slope and known point
            %the line is represented by m(the slope) and n (cut-off point with Y axis)
            %the line equation is : y-y1 = m*(x-x1) =>
            % y = m*(x-x1) + y1 =>
            % n = -x1*m + y1
            function [m,n] = getLineEquation(~, x1_cor, y1_cor,m)
               
                
                n =  y1_cor -m*x1_cor;              
            end
             
            %get distance between line and point. the line represented by m
            %and n, the point is x and y
            %the equation is: d = (abs (-mx0 + y0 - n))/(sqrt(m^2 +1))
            function [d] = getDistanceFromPointToLine(~, m, n, x0, y0)        
                d= (abs(-m*x0 + y0 - n))/(sqrt(m^2 +1));
            end
             
            %calculate source concentration Gaussian model
            function [Q]  = calculateSourceCon(obj,x_sen, y_sen, x_source, y_source,sensorCon)
                
                C = sensorCon;
                U = obj.configFile.WIND_SPEED;%sourceSpeed;
                wind_direction = obj.configFile.WIND_DIRECTION;
                %effective stack height, aribtrrary 
                He = obj.configFile.EFFECTIVE_HEIGHT;
                grid_scale = obj.configFile.GRID_SCALE;
                % first: calculate the distance between the source and
                % sensor
                
                %we only deal with west winds, so
                %in case the source is in front of the sensor, i.e. only
                %east wind can reach it,so this is irrelevant case and the
                %function should exit.                
                if(x_sen <= x_source)
                    Q = 0;
                    return
                end
                
                if(C == 0)
                    Q = 0;
                    return
                end
                
                %X distance: In meters
               % x_distance_kilometers  = (x_sen-x_source);
                
                x_distance_meters  = obj.distance(x_sen, y_sen, x_source, y_source)*grid_scale;
                
                x_distance_kilometers  = x_distance_meters/1000;
                
                %the slope of the wind direction refere to X axis
                mWD = obj.getCurveByWindDirection(wind_direction);%hCon.WIND_DIRECTION);
                
                %get the line equation of the wind, based on two point (the
                %source) and the slope
                [mWD,nWD] =  obj.getLineEquation(x_source, y_source, mWD);
                
                %calculate the distance between the sensor and the line
                %equation of the wind direction
                y_distance = obj.getDistanceFromPointToLine(mWD,nWD,x_sen, y_sen);
                
                %in meters
                y_distance =  y_distance*grid_scale;
                
                
                %## calculate sigma y and sigma z ##%
                
                  %sigma_y = a*x^0.894; a depend on wheather conditions
                  % for now I choose stability category C (see presentation)
                  a = 104;
                  c = 61;
                  d = 0.911 ;
                  f = 0;
                  
                  
                   sigma_y =  a*x_distance_kilometers^0.894; 
                   %sigma_z = c*x^d + f; c,d,f depends on wheather conditions                 
                   sigma_z = c*x_distance_kilometers^d + f; 
                
                
               
 
%                 expy = exp(-(y_distance^2)/(2*sigma_y^2));

%                 expH = exp(-(He^2)/(2*sigma_z^2));
%                 windParam = (U*sigma_y*sigma_z*pi);
                
                %Q = (C*windParam)/(expy* expH);
                Q = C*(U*sigma_y*sigma_z*pi)/(exp(-(y_distance^2)/(2*sigma_y^2))*exp(-(He^2)/(2*sigma_z^2)));
                
            % end of function    
            end
            
            
            % calculate the sensor concentration level based on given
            % emission from source
            
            function [C]  = calculateSensorCon(obj,x_sen, y_sen, x_source, y_source,sourceCon)
                
                Q = sourceCon;
                U = obj.configFile.WIND_SPEED;%sourceSpeed;
                wind_direction = obj.configFile.WIND_DIRECTION;
                %effective stack height, aribtrrary 
                He = obj.configFile.EFFECTIVE_HEIGHT;
                grid_scale = obj.configFile.GRID_SCALE; 
                
                % first: calculate the distance between the source and
                % sensor
                
                %we only deal with west winds, so
                %in case the source is in front of the sensor, i.e. only
                %east wind can reach it,so this is irrelevant case and the
                %function should exit.                
                if(x_sen <= x_source)
                    C = 0;
                    return
                end
                
                %X distance: In meters
                x_distance_meters  = obj.distance(x_sen, y_sen, x_source, y_source)*grid_scale;
                x_distance_kilometers = (x_distance_meters/1000);
                
                %the slope of the wind direction refere to X axis
                mWD = obj.getCurveByWindDirection(wind_direction);
                
                %get the line equation of the wind, based on two points (the
                %source) and the slope
                [mWD,nWD] =  obj.getLineEquation(x_source, y_source, mWD);
                
                %calculate the distance between the sensor and the line
                %equation of the wind direction
                y_distance = (obj.getDistanceFromPointToLine(mWD,nWD,x_sen, y_sen));
                
                %in meters
                y_distance =  y_distance*grid_scale;
                
                
                %## calculate sigma y and sigma z ##%
                
                  %sigma_y = a*x^0.894; a depend on wheather conditions
                  % for now I choose stability category C (see presentation)
                   a = obj.configFile.STABILITY_PARAMETER_a;
                   c = obj.configFile.STABILITY_PARAMETER_c;
                   d = obj.configFile.STABILITY_PARAMETER_d ;
                   f = obj.configFile.STABILITY_PARAMETER_f;
                  
                  
                   sigma_y =  a*x_distance_kilometers^0.894; 
                   %sigma_z = c*x^d + f; c,d,f depends on wheather conditions                 
                   sigma_z = c*x_distance_kilometers^d + f; 
                
                
                  C = (Q/(U*sigma_y*sigma_z*pi))*(exp(-(y_distance^2)/(2*sigma_y^2))* exp(-(He^2)/(2*sigma_z^2)));
                
                 
                
            % end of function    
            end
            
            
            function newSignal = addGausienNoise(obj, oldSignal)
            
                %noise level
                noiseRange = obj.configFile.NOISE_RANGE;
                noiseLevelA = -(noiseRange);
                noiseLevelB = noiseRange;
                
                noise  = noiseLevelA + (noiseLevelB - noiseLevelA)*rand;
                
                newSignal = oldSignal + noise*oldSignal;
                 
            end
                   
        
        
        %end of methods
    end
    
    %end of class
end