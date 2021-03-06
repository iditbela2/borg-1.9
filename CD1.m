%% Sensor readings computation

function [ sensorArray, sourceArray,sizeOfStudyArea ] = CD1( Q_source, sensorArray)

%{
Gets the leak rates and sensors positions.
Calculate the sensor readings according to the Gaussian dispersion model
It uses configuration data listed in Configuration
%}
now1 = {'Start run on:', datestr(now)};

% clearvars;
svAPI = API;
configFile = Configuration;

sizeOfStudyArea = configFile.GRID_SIZE;

studyArea = zeros(sizeOfStudyArea,sizeOfStudyArea);
scale =1;% sizeOfStudyArea/10;


x_source1 = 50;
y_source1 = 50;

x_source2 = 50;
y_source2 = 106;

x_source3 = 50;
y_source3 = 161;

x_source4 = 50;
y_source4 = 217;

x_source5 = 50;
y_source5 = 272;

x_source6 = 50;
y_source6 = 328;

x_source7 = 50;
y_source7 = 383;

x_source8 = 50;
y_source8 = 439;

x_source9 = 50;
y_source9 = 494;

windSpeed  = configFile.WIND_SPEED; % m/sec
windDirection  =  configFile.WIND_DIRECTION;

sourceArray = [x_source1, y_source1, Q_source(1); x_source2, y_source2, Q_source(2); x_source3, y_source3, Q_source(3); x_source4, y_source4, Q_source(4); x_source5, y_source5, Q_source(5); x_source6, y_source6, Q_source(6); x_source7, y_source7, Q_source(7); x_source8, y_source8, Q_source(8) ; x_source9, y_source9, Q_source(9)];


for i=1:size(sensorArray)
    totalAmbientDataOfSensor = 0;
    for j=1:size(sourceArray)
        ambientDataFromOneSource = svAPI.calculateSensorCon(sensorArray(i,1), sensorArray(i,2), sourceArray(j,1), sourceArray(j,2), sourceArray(j,3));
        ambientDataFromOneSource = svAPI.addGausienNoise(ambientDataFromOneSource);
        totalAmbientDataOfSensor  = totalAmbientDataOfSensor + ambientDataFromOneSource;
    end
    sensorArray(i,3) = totalAmbientDataOfSensor;
end

now1 = {'Ends On:', datestr(now)};
end

