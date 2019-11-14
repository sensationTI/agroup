% remainder of code can be found after 25:00 of video found at:
% https://www.mathworks.com/videos/introduction-to-automated-driving-system-toolbox-1501177087798.html?elqsid=1533134550499&potential_use=Student
clear;

% Does data have groundTruth and detection data? y/n = 1/0
groundTruth = 0;
groundTruthWithDetected = 0;
detected = 1;

if groundTruth
% load detections
    load("C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\All_Combined\Test\testLabels.mat");
    IoUtruth = testLabelData; % was detections
    
end
if detected
    load("C:\Users\benmi\Documents\Thesis\Thesis Instructions\Raw Data\IoUdetectedWithConfidence.mat")
    IoUdetected = IoUdetectedWithConfidence;
end
    

% location of images
imgPath = 'C:\Users\benmi\Documents\Thesis\Thesis Instructions\Raw Data\All_Combined\Validation';

% Classes to include? y/n = 1/0
CRO = 1;
BIK = 1;
PDU = 1;
PDC = 1;
PDS = 1;
CAR = 0;
BUS = 0;
DGS = 1;
DGL = 1;
SUV = 0;

j=1;
% remove unwanted classes
if CRO == 0
    IoUtruth.CRO = [];
    IoUdetected.CRO = [];
else
    colour{j} = 'green';
    j=j+1;
end
if BUS == 0
    IoUtruth.BUS = [];
    IoUdetected.BUS = [];
else    
    colour{j} = 'blue';
    j=j+1;
end
if CAR == 0
    IoUtruth.CAR = [];
    IoUdetected.CAR = [];
else    
    colour{j} = 'blue';
    j=j+1;
end
if DGS == 0    
    IoUtruth.DGS = [];
    IoUdetected.DGS = [];
else    
    colour{j} =[0 0.4470 0.7410];
    j=j+1;
end
if DGL == 0      
    IoUtruth.DGL = [];
    IoUdetected.DGL = [];
else    
    colour{j} = [0.9290 0.6940 0.1250];
    j=j+1;
end
if BIK == 0
    IoUtruth.BIK = [];
    IoUdetected.BIK = [];
else
    colour{j} = 'black';
    j=j+1;    
end
if PDS == 0
    IoUtruth.PDS = [];
    IoUdetected.PDS = [];
else    
    colour{j} = 'cyan';
    j=j+1;
end
if PDC == 0
    IoUtruth.PDC = [];
    IoUdetected.PDC = [];
else
    colour{j} = 'magenta';
    j=j+1;
end
if PDU == 0
    IoUtruth.PDU = [];
    IoUdetected.PDU = [];
else    
    colour{j} = 'red';
    j=j+1;
end
if SUV == 0
    IoUtruth.SUV = [];
    IoUdetected.SUV = [];    
end

detections = IoUdetected; % for testing

ax1 = axes('Position', [0.02 0 0.55 1]);

% get camera parameters
camParameters = open('C:\Users\benmi\Documents\Thesis\Matlab\Calibration Parameters\cameraParametersJune7Calib.mat');
focalLength = camParameters.cameraParamsJune7Calibration.FocalLength; % [fx, fy] in pixel units
principalPoint = camParameters.cameraParamsJune7Calibration.PrincipalPoint; % [cx, cy] optical center in pixel coordinates
imageSize = [512, 640]; % [nrows, mcols]

camIntrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize);

% Camera tilt angle in degrees
tiltDeg = 8.584;
tilt = tiltDeg * pi/180;

height = 1.67; % mounting height in meters from the ground
pitch  = tiltDeg; % pitch of the camera in degrees
yaw = 0;
roll = 0;
sensorLocation = [-2.235 0.152];

sensor = visionDetectionGenerator('SensorLocation',...
    sensorLocation, 'Height', height,...
    'Pitch', pitch, 'Intrinsics', cameraIntrinsics(...
    focalLength,... %Focal length
    principalPoint,... %principal point
    imageSize,...%image size
    'RadialDistortion',[0 0],...
    'TangentialDistortion',[0 0]),...
    'UpdateInterval',0.1, ... % updated every 0.1s
    'BoundingBoxAccuracy', 5, ...
    'MaxRange', 150); %,...'ActorProfiles', actorProfiles(s)

% used to get the world coordinates from image frame
sensor2 = monoCamera(camIntrinsics,height,'Pitch',pitch);


% since all detections were made on an image of size [700,875] and
% calibration was done for an image of size [512,640], the images need to
% be downsampled back to [512, 640].
scale = 0.73142857;


% initialize the required plots:

% % Use the imageToVehicle() function!!!
% % Create extrinsic matrix for predicting object locations 
% rotMatWorld = rotation(pitch, yaw, roll);
% transMatWorld = [sensorLocation(1) sensorLocation(2) height]';
% rotMatCam = rotMatWorld.';
% transMatCam = -rotMatCam*transMatWorld;
% extrinsicMat = [rotMatCam transMatCam; 0 0 0 1];
% camMatrix = cameraMatrix(camParameters.cameraParamsJune7Calibration, rotMatCam, transMatCam)
% camMat2 = [camParameters.cameraParamsJune7Calibration.IntrinsicMatrix zeros(3,1)]*extrinsicMat

%Add sensor to birds eye plot
ax2 = axes('Position', [0.6 0.12 0.4 0.85]);
bep = birdsEyePlot('Parent', ax2,...
    'Xlimits', [0 100],...
    'Ylimits', [-30 30]);
legend(ax2, 'on');
% legend(ax2, 'off');

%create plotters
covPlot = coverageAreaPlotter(bep,...
    'FaceColor','blue',...
    'EdgeColor','blue');

% Update coverage area plotter
plotCoverageArea(covPlot,...
    sensor.SensorLocation,sensor.MaxRange,...
    sensor.Yaw,sensor.FieldOfView(1))

%create lane marking plotter
LanePlotter = laneBoundaryPlotter(bep, 'Color', 'red');
% constant lanes for understanding of object locations
% driving lane, assuming a lane width of 3m
lb = parabolicLaneBoundary([-0.00,0.0, 1.5]); 
rb = parabolicLaneBoundary([-0.0,0.0,-1.5]);
% adjacent lanes
lb2 = parabolicLaneBoundary([-0.00,0.0, 4.5]);
rb2 = parabolicLaneBoundary([-0.0,0.0,-4.5]);

% Update lanes
plotLaneBoundary(LanePlotter,...
    [lb lb2, rb rb2])
    
% Create detection plotter for each class
classes = {detections.Properties.VariableNames{2:end}};

for m = 1:length(classes)
    detPlot{m} = detectionPlotter(bep,...
        'MarkerFaceColor',colour{m},...
        'DisplayName', classes{m},...
        'Marker','o');

end

truthPlot = outlinePlotter(bep);

% parse through all images and plot their detections with bounding boxes
% and world coordinates on the plot.

for k = 1:20:size(detections, 1)
%     img = imread([imgPath,'\',detections.imageFilename{k}])*scale;
%     imgResize = img*scale;
%     imshow(img,'Parent',ax1)

    boundingBox = cell(1,length(classes));
    for m = 1:length(classes)
        if size(detections{k,:}{m+1},1)>0
        boundingBox{m} = [boundingBox{m} ; detections{k,:}{m+1}(:,1:4)*scale];
        % minimum bounding box value can be is 1
        boundingBox{m}(boundingBox{m}<1)=1;
        end
    end
%     % minimum bounding box value can be is 1
%     boundingBox(boundingBox<1)=1;    
    objLocation = cell(1,length(classes));
    for m = 1:length(classes)
    for n = 1:size(boundingBox{m},1)
        objLocation{m}(n, :) = [boundingBox{m}(n, 1)+boundingBox{m}(n, 3)/2 , boundingBox{m}(n, 2)+boundingBox{m}(n, 4)];
    end    
    end
    for m = 1:length(classes)
        if length(objLocation{m})>0
            objLocationCol{m} = objLocation{m}(:,2);
            objLocationCol{m}(objLocationCol{m}>512)=512;
            objLocation{m}(:,2) = objLocationCol{m};
            objLocationRow{m} = objLocation{m}(:,2);
            objLocationRow{m}(objLocationRow{m}>640)=640;
            objLocation{m}(:,2) = objLocationRow{m};
        end
    end
    % objLocation = [350, 365] %This was done to test if this pixel value lead
    % to a WCS prediction of ~[5.8 0] and it did.
    for m = 1:length(classes)
    if size(objLocation{m}, 1)>0
        detectionsWorld{m} = imageToVehicle(sensor2, objLocation{m});
    else
        detectionsWorld{m} = [];
    end
    end

    % Plot the video frame and bounding boxes for the objects as well as the
    % BEP
    img = imread([imgPath,'\',detections.imageFilename{k}]);
    frameAnnotated = imresize(img,scale);

    i=0;
    
    for m=1:length(classes)  
        clearData(detPlot{m})
    end
    for m = 1:length(classes)    
    if size(objLocation{m},1) > 0
        for i = 1:size(objLocation,1)
            frameAnnotated = insertShape(frameAnnotated, 'Rectangle', boundingBox{m}(i,:), 'Color', colour{m});%[leftmost x,top y,width, height]
%               frameAnnotated = insertMarker(frameAnnotated, objLocation(i,:));
%               This is no longer needed
            frameAnnotated = insertText(frameAnnotated, objLocation{m}(i,:), num2str(detectionsWorld{m}(i,:)));
        end
        im = imshow(frameAnnotated, 'Parent', ax1);
    else
        im = imshow(frameAnnotated,'Parent',ax1);
    end
    % plots detection on bird's eye plot
    if length(detectionsWorld{m})>0
        plotDetection(detPlot{m}, detectionsWorld{m})
        hold on
    end
    end

    % Also possible to plot tracks using trackPlotter(bep). See:
    % https://www.mathworks.com/help/driving/examples/visualize-sensor-coverage-detections-and-tracks.html
    pause(0.25)
    
end

