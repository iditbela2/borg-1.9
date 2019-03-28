%% Sensor readings computation

function [ sensorArray, sourceArray,sizeOfStudyArea ] = CD1( Q_source, sensorArray)

%{
Gets the true leak rates and sensor positions.
Calculate the true sensor readings according to the Gaussian dispersion model
It uses configuration data listed in Configuration
%}
now1 = {'Start run on:', datestr(now)};

% clearvars;
svAPI = API;
configFile = Configuration;

sizeOfStudyArea = configFile.GRID_SIZE;

% Source locations
x_source1 = 20;
y_source1 = 300;

x_source2 = 50;
y_source2 = 470;

x_source3 = 70;
y_source3 = 60;

x_source4 = 110;
y_source4 = 250;

x_source5 = 160;
y_source5 = 520;


windSpeed  = configFile.WIND_SPEED; % m/sec
windDirection  =  configFile.WIND_DIRECTION;

sourceArray = [x_source1, y_source1, Q_source(1); x_source2, y_source2, Q_source(2); ...
    x_source3, y_source3, Q_source(3); x_source4, y_source4, Q_source(4); ...
    x_source5, y_source5, Q_source(5)];

for i=1:size(sensorArray,1)
    totalAmbientDataOfSensor = 0;
    for j=1:size(sourceArray,1)
        ambientDataFromOneSource = svAPI.calculateSensorCon(sensorArray(i,1), sensorArray(i,2), sourceArray(j,1), sourceArray(j,2), sourceArray(j,3));
        ambientDataFromOneSource = svAPI.addGausienNoise(ambientDataFromOneSource);
        totalAmbientDataOfSensor  = totalAmbientDataOfSensor + ambientDataFromOneSource;
    end
    sensorArray(i,3) = totalAmbientDataOfSensor;
end
now1 = {'Ends On:', datestr(now)};
end

