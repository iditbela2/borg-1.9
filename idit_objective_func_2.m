function [ objs, constrs ] = idit_objective_func_2( x )
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
% objective 2 - maximize mean PED, given locations of active sensors
objs(2) = -PED_mean(Q_source, sensorArray(x>thr,1:2)); % source locations are defined in idit_CD1

% % objs(1) = -PED_mean(x(1:5), reshape(x(6:end),[5 2]));% maximize the mean PED. not sure about the minus sign
% % % objs(2) = sum(abs(VarMeans-x(1:5))./VarMeans); %sum of percentage of error
% % % objs(2) = norm(VarMeans-x(1:5)); %minimize the difference between stated values and predicted
% % % seperate to two errors
% % objs(2)=0;objs(3)=0;
% % for i=1:size(VarMeans,2)    
% %     %objs(1)=objs(1)+((abs(sensorArray(i,3)-trueSensorReadings(i,3)))/(sensorArray(i,3)+trueSensorReadings(i,3)));
% %     if x(i)-VarMeans(1,i)<0        
% %         objs(2)=objs(2)+(abs(x(i)-VarMeans(i)))/(x(i)+VarMeans(i));
% %     elseif x(i)-VarMeans(1,i)>0        
% %         objs(3)=objs(3)+(abs(x(i)-VarMeans(i)))/(x(i)+VarMeans(i));
% %     end
% % end
% % 
% % % maybe interesting to minimize this norm seperately for each source in
% % % order to enable one source to be far from mean values and the other to be
% % % close. 
% % 
% % % %maximize distance between sensors / minimize variance(equaly distributed) 
% % % objs(3) = -mean(pdist(sensorArray(:,1:2),'euclidean')); 
% % % objs(4) = var(pdist(sensorArray(:,1:2),'euclidean'));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

