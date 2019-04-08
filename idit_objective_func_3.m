function [ objs, constrs ] = idit_objective_func_2( x )
global WF;

% This is the objective function that is activated by the Borg 
% It accepts a vector (x) that contains the decision variables and returns the objective values

% number of sensors will equal the number of grid points every 10 meters
% starting the x location of the source that is most on the right (east)
% plus the minimal distance between two sources. 

% sources locations
sourceLocations(1,:) = [20, 300]; %first column X location, second column Y location
sourceLocations(2,:) = [50,470];
sourceLocations(3,:) = [70,60];
sourceLocations(4,:) = [110,250];
sourceLocations(5,:) = [160,520];
configFile = Configuration;
boundery = configFile.GRID_SIZE;

stepSize = 50;
minDist = min(pdist(sourceLocations(:,2))); % minimal distance in Y coordinate 
NumOfSens = numel([max(sourceLocations(:,1)) + minDist:stepSize:boundery])*numel([0:stepSize:600]);
[X,Y] = meshgrid([max(sourceLocations(:,1)) + minDist:stepSize:boundery],[0:stepSize:600]);

% order of sensors (notice Y is zero on the top of matrix)
sensorArray = zeros(NumOfSens,3); % first column x location, second y location, third measured values (currently 0).
sensorArray(1:NumOfSens,1)=reshape(X,[size(X,1)*size(X,2),1]);
sensorArray(1:NumOfSens,2)=reshape(Y,[size(Y,1)*size(Y,2),1]);

% % % calculate sensor readings based on known Q_source 
Q_source = [1000 1500 600 1900 300];
% % [sensorArray, ~, ~] = idit_CD1(Q_source, sensorArray); 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

thr = 0.7; %above this threshold the sensor is active, below it is not

% objective 1 - minimize number of active sensors
objs(1)=sum(x>thr);

% minimum two sensors
cons1 = 2;
% cons2 = 15;
constrs(1) = 0; 
% constrs(2) = 0; 
if objs(1)<cons1
    constrs(1) = 1;       
end
% if objs(1)>cons2
%     constrs(2) = 1;       
% end

% objective 2 - maximize mean min PED, given locations of active sensors.
% calculate PED for each wind direction and speed, and multiply this matrix
% by frequencies of wind
tic
PED_max = zeros(size(WF));
[S,D] = meshgrid(1:16,190:10:360);
for i=1:size(S,2)  % WS 
    for j=1:size(S,1) %WD
        WS = S(1,i)-0.5;
        WD = D(j,1)-5;
        PED_max(j,i) = -PED_mean(Q_source, sensorArray(x>thr,1:2), WD, WS);
    end   
end
objs(2) = sum(PED_max.*WF,'all'); % source locations are defined in idit_CD1
toc

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tic
% PED_arr = windfrequencies180;
% PED_arr(:,3) = 0;
% ind = 1;
% for i=1:16  % WS 
%     for j=190:10:360 %WD
%         WS = PED_arr(ind,1)-0.5;
%         WD = PED_arr(ind,2)-5;
%         PED_arr(ind,3) = -PED_mean(Q_source, sensorArray(x>thr,1:2), WD, WS);
%         ind = ind + 1;
%     end   
% end
% sum(PED_arr(:,3).*PED_arr(:,4)); % source locations are defined in idit_CD1
% toc
