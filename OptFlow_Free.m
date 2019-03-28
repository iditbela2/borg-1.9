%% Objective function

function [ objs , constrs] = OptFlow_Free( x )
%{ This is the objective function that is activated by the Borg. It accepts a vector, x, that contains the decision variables.
%it returns the objective values.
%}
AccepLeakRate=0;
NumOfVars=9; % This is the number of sources that we are looking into the optimal flow
NumOfObj=3; % Summing all sensors %I think what "Summing all sensors" mean is that the objective is calculated by summing the objectives from all sensors. 


% True_sensorarray contains the real sensor readings. We compute it only in
% the first cycle. This is accomplished using the "persistent" keyword. In
% the first cycle we also choose leak rate for every source.
persistent True_sensorarray
if isempty(True_sensorarray) % Initialization
    counter=1;
    
    Q_source(1:9)=0;
    % 9 active sources
    %Q_source(2)=500;Q_source(3)=1000;Q_source(8)=150;Q_source(7)=500;Q_source(4)=200;Q_source(5)=100;Q_source(6)=900;Q_source(9)=25;Q_source(1)=700;
    % % 8 active sources
    % Q_source(2)=500;Q_source(3)=1000;Q_source(8)=150;Q_source(7)=500;Q_source(4)=200;Q_source(5)=0;Q_source(6)=900;Q_source(9)=25;Q_source(1)=700;
    
    % 3 active sources
    % Q_source(2)=0;Q_source(3)=0;Q_source(8)=0;Q_source(7)=0;Q_source(4)=200;Q_source(5)=100;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 5 active sources
    %Q_source(2)=0;Q_source(3)=150;Q_source(8)=0;Q_source(7)=300;Q_source(4)=200;Q_source(5)=100;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 6 active sources
    Q_source(2)=250;Q_source(3)=150;Q_source(8)=0;Q_source(7)=300;Q_source(4)=200;Q_source(5)=750;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 7 active sources
    %Q_source(2)=250;Q_source(3)=150;Q_source(8)=150;Q_source(7)=300;Q_source(4)=200;Q_source(5)=750;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 4 active sources
    %Q_source(2)=0;Q_source(3)=150;Q_source(8)=0;Q_source(7)=0;Q_source(4)=200;Q_source(5)=100;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 2 active sources
    % Q_source(2)=0;Q_source(3)=0;Q_source(8)=0;Q_source(7)=0;Q_source(4)=0;Q_source(5)=100;Q_source(6)=900;Q_source(9)=0;Q_source(1)=0;
    % 1 active sources
    %Q_source(2)=0;Q_source(3)=0;Q_source(8)=0;Q_source(7)=0;Q_source(4)=0;Q_source(5)=100;Q_source(6)=0;Q_source(9)=0;Q_source(1)=0;
    % %1' active sources
%     Q_source(2)=0;
%     Q_source(3)=0;
%     Q_source(8)=0;
%     Q_source(7)=0;
%     Q_source(4)=0;
%     Q_source(5)=0;
%     Q_source(6)=0;
%     Q_source(9)=25;
%     Q_source(1)=0;
    NumOfSens=6; 
    ShiftX=150; 
    ShiftY=100;
    counter=0;
    
    sensorArray(1,:)=[450, 175];sensorArray(2,:)=[450, 225];sensorArray(3,:)=[450, 275];sensorArray(4,:)=[450, 325];sensorArray(5,:)=[450, 375];sensorArray(6,:)=[450, 425];
    
    % sensorArray(1,:)=[375, 175];sensorArray(2,:)=[450, 225];sensorArray(3,:)=[450, 275];sensorArray(4,:)=[450, 325];sensorArray(5,:)=[450, 375];sensorArray(6,:)=[375, 425];
%     sensorArray(1,:)=[100, 65];
%     sensorArray(2,:)=[100, 148];
%     sensorArray(3,:)=[100, 232];
%     sensorArray(4,:)=[100, 315];
%     sensorArray(5,:)=[100, 398];
%     sensorArray(6,:)=[100, 482];
    
    
    [ sensorArray, sourceArray, sizeOfStudyArea ] = CD1( Q_source, sensorArray );
    True_sensorarray = sensorArray;
    [m]=PlotMap(sensorArray, sourceArray,sizeOfStudyArea);
    
    save('RealSensors.txt', 'True_sensorarray','-ascii');
    
    save('RealSource.txt', 'Q_source', '-ascii')
    
    
end
% end of Initialization, performed only once
% bias=1e-32;
bias=0;
% Computes sensors reading using Asaf's function CD1. It needs
% True_sensorarray for the sensors locations

[ sensorArray, sourceArray, sizeOfStudyArea ] = CD1( x, True_sensorarray );% in the true sensorarray we have the location of the sources, so this is the reason we send it to CD1
objs(1)=0;objs(3)=0;objs(2)=0;
for i=1:size(sensorArray,1)
    
    %objs(1)=objs(1)+((abs(sensorArray(i,3)-True_sensorarray(i,3)))/(sensorArray(i,3)+True_sensorarray(i,3)));
    if sensorArray(i,3)-True_sensorarray(i,3)<0
        
        objs(1)=objs(1)+(abs(sensorArray(i,3)-True_sensorarray(i,3)))/(sensorArray(i,3)+True_sensorarray(i,3)+bias);
        %   objs(1)=objs(1)+(abs(sensorArray(i,3)-True_sensorarray(i,3)));
    elseif sensorArray(i,3)-True_sensorarray(i,3)>0
        objs(2)=objs(2)+(abs(sensorArray(i,3)-True_sensorarray(i,3)))/(sensorArray(i,3)+True_sensorarray(i,3)+bias);
        %objs(2)=objs(2)+(abs(sensorArray(i,3)-True_sensorarray(i,3)));
    end
end

objs(3)=size(find(x>AccepLeakRate),2);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

