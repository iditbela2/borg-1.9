function [ objs ] = idit_objective_func( x )
% This is the objective function that is activated by the Borg 
% It accepts a vector (x) that contains the decision variables and returns the objective values

AccepLeakRate=0;
NumOfVars=5; % Number of sources (stacks)
NumOfObj=3; % Number of Objectives (least squares/bias/)
NumOfSens=3;

% trueSensorReadings contains the real sensor readings. We compute it only in
% the first cycle. This is accomplished using the "persistent" keyword. In
% the first cycle we also choose leak rate for every source.
persistent trueSensorReadings
if isempty(trueSensorReadings) % Initialization
    % all sources are active
    factors = [1.2 0.9 1.05 0.79 1.17]; % true factors for leak rates
    Q_source(1:NumOfVars)=factors.*[1000 1500 600 1900 300]; % true leak rates 
    
    sensorArray = zeros(NumOfSens,3); % first column x location, second y location, third measured values (currently 0). 
    sensorArray(1:NumOfSens,1:2)=[300, 65; 300, 148; 300, 232];% 300, 315; 300, 398; 300, 482];   
    
    % calculate true sensor readings based on true sensor arrays
    [sensorArray, sourceArray, sizeOfStudyArea] = idit_CD1(Q_source, sensorArray); % the sensorArray is given to CD1 with locations only (NumOfSensx2) and is returned with values as well (NumOfSensx3)
    % try to understand what addGausienNoise gives me
    trueSensorReadings = sensorArray;
    PlotMap(sensorArray, sourceArray,sizeOfStudyArea);
    
    save('Results/RealSensors.txt', 'trueSensorReadings','-ascii'); % save true sensor readings   
    save('Results/RealSource.txt', 'Q_source', '-ascii') % save true chosen leak rates
        
end % try to understand what bias gives me

bias=0; % what is the meaning of bias?
% Computes sensors reading using Asaf's function CD1. It needs
% trueSensorReadings for the sensors locations

[sensorArray, ~, ~] = idit_CD1(x, trueSensorReadings);% in the trueSensorReadings we have the location of the sources, so this is the reason we send it to CD1
objs(1)=0;objs(2)=0;
for i=1:size(sensorArray,1)    
    %objs(1)=objs(1)+((abs(sensorArray(i,3)-trueSensorReadings(i,3)))/(sensorArray(i,3)+trueSensorReadings(i,3)));
    if sensorArray(i,3)-trueSensorReadings(i,3)<0        
        objs(1)=objs(1)+(abs(sensorArray(i,3)-trueSensorReadings(i,3)))/(sensorArray(i,3)+trueSensorReadings(i,3)+bias);
        %   objs(1)=objs(1)+(abs(sensorArray(i,3)-trueSensorReadings(i,3)));
    elseif sensorArray(i,3)-trueSensorReadings(i,3)>0
        objs(2)=objs(2)+(abs(sensorArray(i,3)-trueSensorReadings(i,3)))/(sensorArray(i,3)+trueSensorReadings(i,3)+bias);
        %objs(2)=objs(2)+(abs(sensorArray(i,3)-trueSensorReadings(i,3)));
    end
end
% ojective 3? don't exceed the factors? only relevant if I run a simulation of one year 
objs(3)=size(find(x>AccepLeakRate),2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

