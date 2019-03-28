tic
[vars, objs, runtime] = borg(11, 2, 0, @DTLZ2, 100000, 0.01*ones(1,2),zeros(1,11), ones(1,11));
toc


scatter(objs(:,1),objs(:,2));


%the number of decision variables
%number of objectives
%number of constraints
%handle for your objective function
%the number of function evaluations to run in the optimization
%the epsilon precision values for the objectives
%the lower bounds of the decision variables
%the upper bounds of the decision variables

