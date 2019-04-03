clc; close all; clear all;
 
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
% % Q_source = [1000 1500 600 1900 300];
% % [sensorArray, ~, ~] = idit_CD1(Q_source, sensorArray); 

tic
NumOfVars=NumOfSens; % Number of sensors
NumOfObj=2; % Number of Objectives (least squares/bias/)
NumOfCons=1; 
NFE=5e3; %the number of objective function evaluations, defines how many times
%  the Borg MOEA can invoke objectiveFcn.  Once the NFE limit is reached, the
%  algorithm terminates and returns the result. 
eps=[1 0.5e-8];
 
VarMeans=[1000 1500 600 1900 300]; % annual mean values of the stacks
% VarLB=[0*VarMeans 160 160 160 160 160 zeros(1,5).*20]; % the lower bounds of the decision variables
% VarUB=[3*VarMeans ones(1,10).*580]; % the upper bounds of the decision variables
VarLB=zeros(1,NumOfSens); % the lower bounds of the decision variables
VarUB=ones(1,NumOfSens); % the upper bounds of the decision variables

% @idit_objective_func_1 @idit_objective_func_2
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @idit_objective_func_2, NFE, eps, VarLB, VarUB);
toc

% look at results

% option 1 - 

% scatter
scatter(objs(:,1),objs(:,2))

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
    plot(sensorLocations(:,2),sensorLocations(:,1),'bx') % is there a X Y problem here?
    title(['PED = ' num2str(-objs(i,1))]);
    pause
end

% option 2 - 
% If I increase epsilon, I get less solutions, but with lower number of
% sensors. if I lower the epsilon value, I get more solutions but higher
% number of sensors. Increasing the threshold decreases the number of
% sensors and give solutions with variability in the number of sensors. I
% can't seem to find variability in the PED values. ok results - eps 0.5e-6/0.5e-8, thr 0.65/0.7, median 
% I should understand if the fact that it wants to maximize PED, won't lead
% to unrealistic placement - like no sensor at all in front of one of the
% stacks. 
thr = 0.7;
str_mean = strtrim(cellstr(num2str(VarMeans'))');
[objsSorted,ind] = sortrows(objs);
varsSorted = vars(ind,:);
for i=1:size(varsSorted,1)
    close all
    figure 
    plot(sourceLocations(:,1),sourceLocations(:,2),'ro')
    text(sourceLocations(:,1)+5,sourceLocations(:,2),str_mean)
    xlim([0 600])
    ylim([0 600])

    hold on
    sensorLocations = sensorArray(varsSorted(i,:)>thr,1:2);
    plot(sensorLocations(:,1),sensorLocations(:,2),'bx')% is there a X Y problem here?
    title(['PED = ' num2str(-objsSorted(i,2)) ', No of sensors: '  num2str(objsSorted(i,1))]);    
    pause
end

% SAVE PLOTS OF RESULTS
% (1) scatter of results 
scatter(objs(:,1),-objs(:,2),'filled')
title('Pareto front','fontsize',14)
xl = xlabel('Number of sensors','fontsize',14);
yl = ylabel('Minimal PED in each group of scenarios','fontsize',14);
% xl.Position(2) = -0.015;  % Shift x label down
% yl.Position(1) = 0.20;  % Shift y label left
saveas(gcf,['results_pareto_front.png'])

% (2) display also PED matrices for each solution up to 10 sensors
% call PED_mean without it's last line (mean)
Q_source = [1000 1500 600 1900 300];

thr = 0.7;
str_mean = strtrim(cellstr(num2str(VarMeans'))');
[objsSorted,ind] = sortrows(objs);
varsSorted = vars(ind,:);
for i=1:sum(objsSorted(:,1)<=10)
    close all
    subplot(1,2,1)
    plot(sourceLocations(:,1),sourceLocations(:,2),'ro')
    text(sourceLocations(:,1)+5,sourceLocations(:,2),str_mean)
    xlim([0 600])
    ylim([0 600])

    hold on
    sensorLocations = sensorArray(varsSorted(i,:)>thr,1:2);
    plot(sensorLocations(:,1),sensorLocations(:,2),'bx')
    title(['PED = ' num2str(-objsSorted(i,2)) ', No of sensors: '  num2str(objsSorted(i,1))]);  
    subplot(1,2,2)
    min_PED = PED_mean(Q_source, [sensorLocations(:,1),sensorLocations(:,2)]); %CHANGE PED_mean to return min
    out_min = accumarray([min_PED(:,1),min_PED(:,2)],min_PED(:,3),[5 5]);
    imagesc(out_min)
    colorbar
    title('min PED');
    set(gca,'YTick',1:5) 
    print -r500 % set resolution
    set(gcf, 'PaperUnits', 'centimeters','PaperPosition', [0 0 20 10]);%x_width=20cm y_width=10cm
    saveas(gcf,['results_' num2str(i) '.png'])
%     pause
end

% (3) run borg (idit_objective_func_1) to find emissions. calculate error rates for the different
% number of sensors placed. 

clear all
tic
NumOfVars=5; % Number of sources (stacks)
NumOfObj=2; % Number of Objectives (least squares/bias/)
NumOfCons=0; 
NFE=5e3; %the number of objective function evaluations, defines how many times
%  the Borg MOEA can invoke objectiveFcn.  Once the NFE limit is reached, the
%  algorithm terminates and returns the result. 
eps=[0.5e-8 0.5e-8];
 
VarMeans=[1000 1500 600 1900 300]; % annual mean values of the stacks
% VarLB=[0*VarMeans 160 160 160 160 160 zeros(1,5).*20]; % the lower bounds of the decision variables
% VarUB=[3*VarMeans ones(1,10).*580]; % the upper bounds of the decision variables
VarLB=zeros(1,NumOfVars); % the lower bounds of the decision variables
VarUB=3.*VarMeans.*ones(1,NumOfVars); % the upper bounds of the decision variables

% @idit_objective_func_1 @idit_objective_func_2
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @idit_objective_func_1, NFE, eps, VarLB, VarUB);
toc

% n=1
vars_1 = [929.870494858328,2224.42716461704,599.999999173690,2692.57463751177,0.192447796857081];
objs_1 = [6.89806218849787e-10,1.87454282971682e-10];
numOfSolutions = 1;

% n=2
vars_2 = [834.251314339622,1560.01287596723,600.000005961904,3773.23756140510,271.173477655653;834.244330921653,1560.04630516546,599.999987834647,3773.31630948354,271.157425085382;834.243180753766,1560.05112838857,600.000030856695,3773.32946037020,271.155126546797];
objs_2 = [7.59192653924548e-09,8.56257665306859e-09;1.84564292664652e-08,0;0,3.20948653011976e-08];
numOfSolutions = 3;

% n=3
vars_3 = [999.999953767749,1499.99996435140,599.999969324166,1899.99990610270,509.910652899966;1000.00008364713,1499.99998487657,600.000040589301,1899.99988156562,501.434165372808;999.999939381613,1500.00001658236,599.999983760870,1899.99987898636,494.198620571172;999.999993449772,1499.99998561139,600.000027940475,1900.00028020864,817.170687671559];
objs_3 = [8.16000536658181e-08,0;2.89122726860682e-08,7.46938224771253e-08;7.56269076419732e-08,8.86638464208562e-09;2.26835590664419e-09,9.70750015639264e-08];
numOfSolutions = 4;

% n=4
vars_4 = [999.964403279552,1500.00404718822,599.993747688784,1899.71370272024,299.961517502425;1000.00878388315,1500.13945794901,600.009088231240,1899.97218854341,299.924286499984;1000.00165487307,1500.10074071995,600.000633286155,1899.93587627358,299.922611034661;999.962536355011,1499.99726185959,599.991370820920,1899.69489245163,299.961744361094;1000.00179259165,1500.10080617210,600.000675920333,1899.93593952895,299.922733742651;999.963825684887,1500.00421374573,599.993938380615,1899.71257706618,299.962499063164;1000.00086500293,1500.17415536488,600.010431140549,1899.98272238830,299.910533550899;999.991981178608,1500.16444002405,599.998405403090,1899.99837581627,299.905104717076;999.986067892136,1499.98695865967,600.002921634676,1899.81636059563,299.948445635506;999.998733149394,1500.17235935576,600.011262169237,1900.00634243254,299.923476272430;999.974579315154,1500.03282434652,600.002957696280,1899.79535523470,299.961761789501;1000.00256853118,1500.17619976661,600.010592518267,1899.98100093570,299.911558205081;999.968221258819,1500.02832725118,599.999404002997,1899.79651062579,299.954868528493;1000.00189623909,1500.09908891048,599.999082680495,1899.93305054874,299.923103682828;1000.00799598208,1500.10727036761,600.007199413852,1899.97201654044,299.927248418601;999.963987973638,1500.00148144592,599.993315217924,1899.70857155291,299.962497914934;1000.00222895719,1500.10075304938,600.000559451264,1899.93960878150,299.923036126693;1000.00611463469,1500.08849567236,599.995102648129,1899.94593174516,299.923649997341;999.992429720059,1500.16628204565,599.999449140847,1899.99906801860,299.903422260657;1000.00325824698,1500.07888608291,599.988542489650,1899.94134286729,299.929267234567;1000.00679499556,1500.12717888281,600.008322924756,1899.97104400626,299.924826428559;1000.00097019165,1500.14349113143,600.009338656424,1899.98194865471,299.915403844030;1000.00780241830,1500.10704055082,600.009251047649,1899.96971694174,299.932041699646;1000.01805340516,1500.13200864367,600.010167628328,1899.97930954577,299.928319345418;999.996542259555,1500.04404677581,599.995932681066,1899.86719852834,299.963432980029;999.984517391519,1499.96324793587,600.001803997658,1899.79902791878,299.952242345577;1000.00246353957,1500.10075304938,600.002951688681,1899.93960878150,299.946846133050;999.990404482885,1500.16890316410,600.000026926391,1899.99689769266,299.908130734208;1000.00944203124,1500.08094617883,599.991946770327,1899.95111767953,299.918515592550;999.999211615858,1500.18434969571,600.008752424602,1900.00079667019,299.904892401693;1000.00065791836,1500.19183744465,600.005628237789,1900.00238516504,299.903840220588;1000.00574853309,1500.19698753516,600.008934147653,1900.00622683114,299.906049085720];
objs_4 = [0.000113988926527523,1.34903973254871e-06;1.09794952444310e-05,5.82960814231744e-05;3.01538954537965e-05,3.47028426834633e-05;0.000124094085262426,0;3.00589803873261e-05,3.48283637529094e-05;0.000113894664222903,1.40455839767510e-06;7.13332130951286e-06,6.71083081091430e-05;1.37012795414496e-05,5.48102718085798e-05;8.63397191857757e-05,2.43468963464839e-06;6.03325873393451e-07,7.14536008156249e-05;7.59546811975661e-05,1.34060438444448e-05;6.53465956815906e-06,6.87588813592337e-05;8.38995937395061e-05,9.44229989271909e-06;3.17639556243411e-05,3.37339232533585e-05;1.71670816538993e-05,4.56043986727438e-05;0.000115985900522916,4.93794595254611e-07;2.89969466028003e-05,3.49415529779647e-05;3.39834598261036e-05,3.23290012573615e-05;1.28142263649991e-05,5.54242108737456e-05;4.01789078976683e-05,2.77006813559250e-05;1.39423755291912e-05,5.25803062716714e-05;1.21539390446169e-05,5.60268468079359e-05;1.54511225597111e-05,4.71340432409717e-05;8.73780679768096e-06,6.13113056620320e-05;4.63072868807568e-05,1.46820246761893e-05;0.000103151213177538,1.50332912122417e-06;1.73248467954899e-05,3.70508365556280e-05;1.10325270417308e-05,5.63202561246202e-05;3.95254244303029e-05,3.14724276619999e-05;3.59902574956645e-06,6.89176334024336e-05;1.96605040080464e-06,6.95766873542434e-05;0,7.79930475964704e-05];
numOfSolutions = 4;


