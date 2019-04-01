clc; close all; clear all;
 
tic
NumOfVars=15; % Number of sources (stacks)
NumOfObj=3; % Number of Objectives (least squares/bias/)
NumOfCons=0; 
NFE=5e3; %the number of objective function evaluations, defines how many times
%  the Borg MOEA can invoke objectiveFcn.  Once the NFE limit is reached, the
%  algorithm terminates and returns the result. 
eps=[0.5e-3 0.5e-3 0.5e-3];
 
VarMeans=[1000 1500 600 1900 300]; % annual mean values of the stacks
VarLB=[0*VarMeans 160 160 160 160 160 zeros(1,5).*20]; % the lower bounds of the decision variables
VarUB=[3*VarMeans ones(1,10).*580]; % the upper bounds of the decision variables
% @idit_objective_func_1 @idit_objective_func_2
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @idit_objective_func_2, NFE, eps, VarLB, VarUB);
toc

% look at results
% (two objectives are not conflicting as far as I understand). 

% scatter
scatter(objs(:,1),objs(:,2))

% sources locations
sourceLocations(1,:) = [20, 300]; %first column X location, second column Y location
sourceLocations(2,:) = [50,470];
sourceLocations(3,:) = [70,60];
sourceLocations(4,:) = [110,250];
sourceLocations(5,:) = [160,520];
str_mean = strtrim(cellstr(num2str(VarMeans'))');

% for each vars solution, display sensors+sources locations and values and mean_PED 
for i=1:size(vars,1)
    close all
    figure 
    plot(sourceLocations(:,1),sourceLocations(:,2),'ro')
    str_s = strtrim(cellstr(num2str(round(vars(i,1:5))'))');    
    text(sourceLocations(:,1)+5,sourceLocations(:,2),str_mean)
    text(sourceLocations(:,1)+40,sourceLocations(:,2),str_s,'Color','red')
    xlim([0 600])
    ylim([0 600])

    hold on
    sensorLocations = reshape(round(vars(i,6:end)),[5 2]);
    plot(sensorLocations(:,1),sensorLocations(:,2),'bx')
    title(['PED = ' num2str(-objs(i,1))]);
    pause
end

