function [BestFlows]=findbest(VarsAndSourceSort, dimsource,CorrectNumSource)
%counter=1;
% for i=CorrectNumSource(1):CorrectNumSource(end)
% Accuracy(counter)=sqrt((VarsAndSourceSort(i,1)^2+VarsAndSourceSort(i,2)^2));
% counter=counter+1;
% end
Accuracy=sqrt((VarsAndSourceSort(CorrectNumSource(1):CorrectNumSource(end),1).^2+VarsAndSourceSort(CorrectNumSource(1):CorrectNumSource(end),2).^2));
IndBest=find(Accuracy(:)==min(Accuracy(:)));
BestFlows=VarsAndSourceSort(IndBest+CorrectNumSource(1)-1,dimsource+1:end);
end