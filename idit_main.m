clc; close all; clear all;
 
tic
NumOfVars=5; % Number of sources (stacks)
NumOfObj=3; % Number of Objectives (least squares/bias/)
NumOfCons=0; 
NFE=5e5; %the number of objective function evaluations, defines how many times
%  the Borg MOEA can invoke objectiveFcn.  Once the NFE limit is reached, the
%  algorithm terminates and returns the result. 
eps=[0.5e-11 0.5e-11 0.1];
 
VarMeans=[1000 1500 600 1900 300]; % annual mean values of the stacks
VarLB=0.7*VarMeans; % the lower bounds of the decision variables
VarUB=1.3*VarMeans; % the upper bounds of the decision variables
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @idit_objective_func, NFE, eps, VarLB, VarUB);
toc

% NumActive = 5;
% dimsource=3; %the column you want to sort by. in Shai's problem it is number of active sources
% VarsAndSourceAccu=[objs vars];
% VarsAndSourceAccuSort=sortrows(VarsAndSourceAccu,dimsource); 
% % This array contains the acccuracy defined as the sum of the absulute
% % negative deviation from ideal readings, sum of the positive deviation
% % from ideal readings, number of sources and calculated flows. the array is
% % sortted according to the number of active sources
% load('RealSource.txt');
 
% formatOut='dd_mm_yy_HH_MM';
% currentFolder = pwd;
% % DataString = ['C:\Users\ikend\Dropbox\Results\Improving source location\', datestr(now,formatOut) ' Results'];
% DataString = [currentFolder, '/Results/' datestr(now,formatOut)  'Results'];
% fig1string=[currentFolder, '/Results/' datestr(now,formatOut) ' fig1'];
% fig2string=[currentFolder, '/Results/' datestr(now,formatOut) ' fig2'];
% fig3string=[currentFolder, '/Results/' datestr(now,formatOut) ' fig3'];
% fig4string=[currentFolder, '/Results/' datestr(now,formatOut) ' fig4'];
% fig5string=[currentFolder, '/Results/' datestr(now,formatOut) ' fig5'];
%  
% Makeplots(VarsAndSourceAccuSort, dimsource,RealSource,NumActive,fig2string,fig3string,fig4string)
% CorrectNumSource=find(VarsAndSourceAccuSort(:,dimsource)==NumOfVars);
% if numel(CorrectNumSource)==0
%     CorrectNumSource=find(VarsAndSourceAccuSort(:,dimsource)==max(VarsAndSourceAccuSort(:,dimsource)));
% end
% [BestFlows]=findbest(VarsAndSourceAccuSort, dimsource,CorrectNumSource);
% GloAccu=sqrt((VarsAndSourceAccuSort(:,1).^2+VarsAndSourceAccuSort(:,2).^2));
% figure;
% scatter(RealSource, BestFlows);
% title( 'BestMatch'); hold on;
%          ylabel({'Calculated source flow, Kg/second'},'FontSize',12);xlabel({'Actual source flow, Kg/second'},'FontSize',12);
%         savefig(fig5string);
% figure;scatter (objs(:,1),objs(:,3));
% h=gca;
% set(h,'FontSize',14);
% ylabel({'Number of sources'},'FontSize',12);xlabel({'Accuracy 1e6ppm'},'FontSize',12);
% savefig(fig1string)
% figure;scatter (objs(:,2),objs(:,3));
% clipboard('copy',DataString);
% r2=corr2(BestFlows,RealSource);
%  
% save(DataString);
% 
