function m = PlotMap(sensorArray, sourceArray,sizeOfStudyArea);
%plot data in sensors and sources
figure;

for i=1:size(sourceArray)
    hold on
    plot(sourceArray(i,1), sourceArray(i,2), '*r')
    text(sourceArray(i,1)+ 3,sourceArray(i,2)+ 3,num2str(sourceArray(i,3)));
end

axis([0 sizeOfStudyArea+2 0 sizeOfStudyArea+2]);
for i=1:size(sensorArray)
    hold on
    plot(sensorArray(i,1), sensorArray(i,2), '-mo')
    text(sensorArray(i,1)+ 3,sensorArray(i,2)+ 3,num2str(sensorArray(i,3)));
end
title('Reality');
drawnow ;

figure;
for i=1:size(sourceArray)
    hold on
    plot(sourceArray(i,1), sourceArray(i,2), '*r')
    text(sourceArray(i,1)+ 3,sourceArray(i,2)+ 3,num2str(sourceArray(i,3)));
    text(sourceArray(i,1)- 3,sourceArray(i,2)- 3,num2str(i));
end
title('Source reality');
drawnow ;

figure;
for i=1:size(sensorArray)
    hold on
    plot(sensorArray(i,1), sensorArray(i,2), '-mo')
    text(sensorArray(i,1)+ 3,sensorArray(i,2)+ 3,num2str(sensorArray(i,3)));
    text(sensorArray(i,1)- 3,sensorArray(i,2)- 3,num2str(i));
end
title('Sensor reality');
drawnow ;

m=1;
end
