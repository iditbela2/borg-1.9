%% Main Code

%{
This code optimizes three objectives positive deviation, negative deviation, and simplicity. Actual
optimization is performed in:
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @OptFlow_Free, NFE, eps, VarLB, VarUB);
Borg computes optimal vars and objective values and also sends runtime report. It accepts a function handle which is the objective function @OptFlow_Free. 
%} 
clc; close all; clear all;
 
tic
NumOfVars=9; % This is the number of sources that we are looking into the optimal flow
NumOfObj=3; % This is the number of Objectives (originily was written sensors here...) we need to minimize deviation from real case
NumOfCons=0; 
NFE=5e5;
NumActive=1; %Not sure what this is
eps=[0.5e-11 0.5e-11 0.1 ];
 
 
VarLB=zeros(1,NumOfVars); %the lower bounds of the decision variables
VarUB=2000*ones(1,NumOfVars); %the upper bounds of the decision variables
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @OptFlow_Free, NFE, eps, VarLB, VarUB);
toc



dimsource=3;
VarsAndSourceAccu=[objs vars];
VarsAndSourceAccuSort=sortrows(VarsAndSourceAccu,dimsource); 
% This array contains the acccuracy defined as the sum of the absulute
% negative deviation from ideal readings, sum of the positive deviation
% from ideal readings, number of sources and calculated flows. the array is
% sortted according to the number of active sources
load('RealSource.txt');
 
formatOut='dd_mm_yy_HH_MM';
currentFolder = pwd;
% DataString = ['C:\Users\ikend\Dropbox\Results\Improving source location\', datestr(now,formatOut) ' Results'];
DataString = [currentFolder, '\Results\Improving source location\' datestr(now,formatOut)  'Results'];
fig1string=[currentFolder, '\Results\Improving source location\' datestr(now,formatOut) ' fig1'];
fig2string=[currentFolder, '\Results\Improving source location\' datestr(now,formatOut) ' fig2'];
fig3string=[currentFolder, '\Results\Improving source location\' datestr(now,formatOut) ' fig3'];
fig4string=[currentFolder, '\Results\Improving source location\' datestr(now,formatOut) ' fig4'];
fig5string=[currentFolder, '\Results\Improving source location\' datestr(now,formatOut) ' fig5'];
 
Makeplots (VarsAndSourceAccuSort, dimsource,RealSource,NumActive,fig2string,fig3string,fig4string)
CorrectNumSource=find(VarsAndSourceAccuSort(:,dimsource)==NumOfVars);
if numel(CorrectNumSource)==0
    CorrectNumSource=find(VarsAndSourceAccuSort(:,dimsource)==max(VarsAndSourceAccuSort(:,dimsource)));
end
[BestFlows]=findbest(VarsAndSourceAccuSort, dimsource,CorrectNumSource);
GloAccu=sqrt((VarsAndSourceAccuSort(:,1).^2+VarsAndSourceAccuSort(:,2).^2));
figure;
scatter(RealSource, BestFlows);
title( 'BestMatch'); hold on;
         ylabel({'Calculated source flow, Kg/second'},'FontSize',12);xlabel({'Actual source flow, Kg/second'},'FontSize',12);
        savefig(fig5string);
figure;scatter (objs(:,1),objs(:,3));
h=gca;
set(h,'FontSize',14);
ylabel({'Number of sources'},'FontSize',12);xlabel({'Accuracy 1e6ppm'},'FontSize',12);
savefig(fig1string)
figure;scatter (objs(:,2),objs(:,3));
clipboard('copy',DataString);
r2=corr2(BestFlows,RealSource);
 
save(DataString);

