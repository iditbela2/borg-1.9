function [mean_PED] = PED_mean(Q_source, sensorArray_recieved)

numOfSensors = size(sensorArray_recieved,1);
% Run all 31 options of working/not working stacks (for 5 sources)
% and calculate readings 
totalField = zeros(numOfSensors,31);
total_active = zeros(31,1);
for scenario=1:31
    active = zeros(1,5);
    for stack=1:5
        active(stack) = mod(round(scenario/2^stack),2);
    end
    [sensorArray, ~, ~] = idit_CD1(Q_source.*active, sensorArray_recieved); 
    total_active(scenario) = sum(active);
    totalField(:,scenario) = sensorArray(:,3);
end 

total_cr = totalField;
% calculate PED only for situation of different number of active sources
total_PED = [];
total_ind = [];
for i=1:5
    ind = find(total_active==i);
    ind_comp = find(total_active~=i);
    for j=1:size(ind,1)
        for k=1:size(ind_comp,1)          
            total_PED = [total_PED; norm(total_cr(:,ind(j))-total_cr(:,ind_comp(k)))];
            total_ind = [total_ind ; total_active(ind(j)) total_active(ind_comp(k)) ind(j) ind_comp(k)];
        end
    end
end

% mean_PED
[c,~,idx] = unique(sort(total_ind(:,[1 2]),2),'rows');
mean_PED = accumarray(idx,total_PED,[],@mean);
mean_PED = [c mean_PED];
mean_PED = mean(mean_PED(:,3));
end

