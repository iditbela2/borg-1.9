clc; close all; clear all;
 
tic
NumOfVars=15; % Number of sources (stacks)
NumOfObj=2; % Number of Objectives (least squares/bias/)
NumOfCons=0; 
NFE=5e3; %the number of objective function evaluations, defines how many times
%  the Borg MOEA can invoke objectiveFcn.  Once the NFE limit is reached, the
%  algorithm terminates and returns the result. 
eps=[0.5e-3 0.5e-3];
 
VarMeans=[1000 1500 600 1900 300]; % annual mean values of the stacks
VarLB=[0*VarMeans ones(1,10)*10]; % the lower bounds of the decision variables
VarUB=[3*VarMeans ones(1,10)*600]; % the upper bounds of the decision variables
% @idit_objective_func_1 @idit_objective_func_2
[vars, objs, runtime] = borg(NumOfVars, NumOfObj, NumOfCons, @idit_objective_func_2, NFE, eps, VarLB, VarUB);
toc

% look at results

