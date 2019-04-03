function [sensorLocations] = getSensorsLocations(n)
% Get the locations of the sensors according to the solution (minimal PED)
% n - input, the index number of the solution (sorted). for example n=1 is
% the first solution, i.e., 2 sensors.

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

a = load('results_min_PED_104_sensors_1.mat');
[~,ind] = sortrows(a.objs);
varsSorted = a.vars(ind,:);
sensorLocations = sensorArray(varsSorted(n,:)>a.thr,1:2);

end

