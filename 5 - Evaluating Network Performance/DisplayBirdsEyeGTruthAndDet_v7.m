% remainder of code can be found after 25:00 of video found at:
% https://www.mathworks.com/videos/introduction-to-automated-driving-system-toolbox-1501177087798.html?elqsid=1533134550499&potential_use=Student
clear;

% Does data have groundTruth and detection data? y/n = 1/0
groundTruth = 0;
groundTruthWithDetected = 1;
detected = 0;
pauseTime = 0;
saveResults = 0;
dispResults = 0;

imgSavePath = 'C:\Users\benmi\Documents\Thesis\Thesis Instructions\Results\Birds Eye with Covariance';
IoU = '0p4';
probErr = 0.95;

if groundTruth
% load detections
    load("C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_No_Stationary_Vehicle\Test\testLabels.mat");
    IoUtruth = testLabelData; % was detections
    
end
if detected
    load("C:\Users\benmi\Documents\Thesis\Algorithm Performance\YOLOv2\7 Classes Trained on All Data\epoch-step 29250\All Data\IoUdetectedWithConfidence.mat")
    IoUdetected = IoUdetectedWithConfidence;
end

% get these using IoU_calc_per_frame_v6.m (fixed the FP and FN removal
% problem from v5 by adding FNref and FPref variables
if groundTruthWithDetected;
    load("C:\Users\benmi\Documents\Thesis\Thesis Instructions\Results\rectFNTable.mat");
    load("C:\Users\benmi\Documents\Thesis\Thesis Instructions\Results\rectFPTable.mat");
    load("C:\Users\benmi\Documents\Thesis\Thesis Instructions\Results\rectTPTable.mat");
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
    colour{j} = 'blue';%[0 0.4470 0.7410];
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
detGround = rectTPTable;


% get camera parameters
camParameters = open('C:\Users\benmi\Documents\Thesis\Matlab\Calibration Parameters\cameraParametersJune7Calib.mat');
focalLength = camParameters.cameraParamsJune7Calibration.FocalLength; % [fx, fy] in pixel units
principalPoint = camParameters.cameraParamsJune7Calibration.PrincipalPoint; % [cx, cy] optical center in pixel coordinates
RadialDistortion = camParameters.cameraParamsJune7Calibration.RadialDistortion; %[0 0]
imageSize = [512, 640]; % [nrows, mcols]

camIntrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize, 'RadialDistortion', RadialDistortion);

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
    'RadialDistortion',RadialDistortion,...
    'TangentialDistortion',[0 0]),...
    'UpdateInterval',0.1, ... % updated every 0.1s
    'BoundingBoxAccuracy', 5, ...
    'MaxRange', 150); %,...'ActorProfiles', actorProfiles(s)

% used to get the world coordinates from image frame
sensor2 = monoCamera(camIntrinsics,height,'Pitch',pitch, 'sensorLocation', sensorLocation);


% since all detections were made on an image of size [700,875] and
% calibration was done for an image of size [512,640], the images need to
% be downsampled back to [512, 640].
scale = 0.73142857;

    
% Create detection plotter for each class
classes = {detGround.Properties.VariableNames{2:end}};


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

if dispResults
ax1 = axes('Position', [0.02 0 0.55 1]);

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


for m = 1:length(classes)
    detPlot{m} = detectionPlotter(bep,...
        'MarkerFaceColor',colour{m},...
        'DisplayName', classes{m},...
        'Marker','o');
    detPlotTruth{m} = detectionPlotter(bep,...
        'MarkerFaceColor',colour{m},...
        'DisplayName', classes{m},...
        'Marker','^');
    detPlotVar{m} = detectionPlotter(bep,...
        'MarkerFaceColor','non',...
        'DisplayName', classes{m},...
        'Marker','.');

end

truthPlot = outlinePlotter(bep);

% parse through all images and plot their detections with bounding boxes
% and world coordinates on the plot.

set(gcf, 'Position', [10 10 1200 600])
end

for k = 1:size(detGround, 1) %size(detGround, 1)-4% 370:390%
%     img = imread([imgPath,'\',detections.imageFilename{k}])*scale;
%     imgResize = img*scale;
%     imshow(img,'Parent',ax1)

    boundingBox = cell(1,length(classes));
    boundingBoxTruth = cell(1,length(classes));
    for m = 1:length(classes)
        for h = 1:size(detGround{k,:}{m+1},1)
        if size(detGround{k,:}{m+1}{h,3},1)>0 %detections{k,:}{m+1},1)>0
            boundingBox{m} = [boundingBox{m} ; detGround{k,:}{m+1}{h,3}{1}(:,1:4)*scale];%detections{k,:}{m+1}(:,1:4)
            % minimum bounding box value can be is 1
            boundingBox{m}(boundingBox{m}<1)=1;
        end
        end
        % get the bounding Box of the ground truth
        
        for g = 1:size(detGround{k,:}{m+1},1)
        if size(detGround{k,:}{m+1}{g,1},1)>0
            count = 1;
            for t = 1:size(detGround{k,:}{m+1}{g,1}{1},1)
                if max(detGround{k,:}{m+1}{g,1}{1}(t,1:4))==0
                    
                    boundingBoxTruth{m} = [boundingBoxTruth{m} ; detGround{k,:}{m+1}{g,1}{1}(t-count,1:4)*scale];%detections{k,:}{m+1}(:,1:4)
                    % minimum bounding box value can be is 1
                    boundingBoxTruth{m}(boundingBoxTruth{m}<1)=1;
                    count = count+1;
                else
                    boundingBoxTruth{m} = [boundingBoxTruth{m} ; detGround{k,:}{m+1}{g,1}{1}(t,1:4)*scale];
                    boundingBoxTruth{m}(boundingBoxTruth{m}<1)=1;
                end                    
            end
        end
        end

    end
%     % minimum bounding box value can be is 1
%     boundingBox(boundingBox<1)=1;    
    objLocation = cell(1,length(classes));
    objLocationTruth = cell(1,length(classes));    
    for m = 1:length(classes)
    for n = 1:size(boundingBox{m},1)
        objLocation{m}(n, :) = [boundingBox{m}(n, 1)+boundingBox{m}(n, 3)/2 , boundingBox{m}(n, 2)+boundingBox{m}(n, 4)];
        
    end
    for p = 1:size(boundingBoxTruth{m},1)
        objLocationTruth{m}(p, :) = [boundingBoxTruth{m}(p, 1)+boundingBoxTruth{m}(p, 3)/2 , boundingBoxTruth{m}(p, 2)+boundingBoxTruth{m}(p, 4)];
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
            
            objLocationColTruth{m} = objLocationTruth{m}(:,2);
            objLocationColTruth{m}(objLocationColTruth{m}>512)=512;
            objLocationTruth{m}(:,2) = objLocationColTruth{m};
            objLocationRowTruth{m} = objLocationTruth{m}(:,2);
            objLocationRowTruth{m}(objLocationRowTruth{m}>640)=640;
            objLocationTruth{m}(:,2) = objLocationRowTruth{m};
        end
    end
    % objLocation = [350, 365] %This was done to test if this pixel value lead
    % to a WCS prediction of ~[5.8 0] and it did.
    for m = 1:length(classes)
    if size(objLocation{m}, 1)>0
%         if size(objLocation{m},1)>1
%             k
%             size(objLocationTruth{m},1)
%         end
        detectionsWorld{m} = imageToVehicle(sensor2, objLocation{m});
        detectionsWorldTruth{m} = imageToVehicle(sensor2, objLocationTruth{m});
        % if any detections come back as > 500m, make their values 500m
        % if they come back negative, make their values 500m 
%         test(test>999)=999
        detComb{m} = {detectionsWorldTruth{m}, detectionsWorld{m}};
        detPixComb{m} = {objLocationTruth{m}, objLocation{m}};
        % for debugging negative detection problem
        if detectionsWorld{m}(:,1)<0
            stop = 1
        end
    else
        detectionsWorld{m} = [];
        detectionsWorldTruth{m} = [];
        detComb{m} = {[]};
        detPixComb{m} = {[]};
    end
    end
    
    % Add world coordinate location of ground truth and detected object for
    % each true positive (didn't want to figure out indexing so making
    % detected world-coordinate and ground truth world-coordinate pairs instead
%     for n = 1: length(classes)
%         if size(detectionsWorld{n},1)>0
%             detGround{k,n+1}{}

    if k==1 || exist('WCPairTable')==0
        WCPairTable = array2table(detComb,'VariableNames',classes);
        pixPairTable = array2table(detPixComb,'VariableNames',classes);
    else
        WCPairTableAdd = array2table(detComb,'VariableNames',classes);
        pixPairTableAdd = array2table(detPixComb,'VariableNames',classes);
        
        WCPairTable = [WCPairTable; WCPairTableAdd];
        pixPairTable = [pixPairTable; pixPairTableAdd];
    end
            
    
    
    if dispResults
    % Plot the video frame and bounding boxes for the objects as well as the
    % BEP
    img = imread([imgPath,'\',detGround.imageFilename{k}]);% detections.imageFilename{k}]);
    frameAnnotated = imresize(img,scale);

    i=0;
    % clear all detections shown on detPlot from previous frame
    for m=1:length(classes)  
        clearData(detPlot{m})
        clearData(detPlotTruth{m})
        clearData(detPlotVar{m})
    end
    
    for m = 1:length(classes)    
    if size(objLocation{m},1) > 0
%         for i = 1:size(objLocation,1)
        % for some reason insertShape does not perform properly when given
        % a colour vecotr and returns a black box for any colour specified
        % as a vector.
            frameAnnotated = insertShape(frameAnnotated, 'Rectangle', boundingBox{m}, 'Color', colour{m}); ;%[leftmost x,top y,width, height]

            frameAnnotated = insertText(frameAnnotated, objLocation{m}, cellstr(num2str(detectionsWorld{m})));
            
            frameAnnotated = insertShape(frameAnnotated, 'Rectangle', boundingBoxTruth{m}, 'Color', 'yellow') ;%colour{m});%[leftmost x,top y,width, height]
            % creat confidence oval for each detected object in obj
            % location
            for t = 1:size(objLocation{m},1)     
                [corr_loc, radius] = convertRawPCSToWCSFcn(objLocation{m}(t,:), probErr);
                x0 = corr_loc(1); y0 = corr_loc(2);
                t=-pi:0.2:pi;
                x=x0+radius(1)*cos(t);
                y=y0+radius(2)*sin(t);
                frameAnnotated = insertMarker(frameAnnotated, [x',y'], 'size', 1);
                frameAnnotated = insertMarker(frameAnnotated, [x0,y0], 'size', 1);
            end
            
    else
    end
    im = imshow(frameAnnotated, 'Parent', ax1);
    % plots detection on bird's eye plot
    if length(detectionsWorld{m})>0
        plotDetection(detPlot{m}, detectionsWorld{m})
        plotDetection(detPlotTruth{m}, detectionsWorldTruth{m})
        for t = 1:size(objLocation{m},1)     
            [corr_loc, radius] = convertRawPCSToWCSFcn(objLocation{m}(t,:), probErr);
            x0 = corr_loc(1); y0 = corr_loc(2);
            t=-pi:0.2:pi;
            x=x0+radius(1)*cos(t);
            y=y0+radius(2)*sin(t);
            y = y(x<640);
            x = x(x<640);
            x = x(y<512);
            y = y(y<512);
            y = y(x>1);
            x = x(x>1);
            x = x(y>1);
            y = y(y>1);
            varianceWorld = imageToVehicle(sensor2, [x',y']);
            plotDetection(detPlotVar{m}, varianceWorld)
        end
        hold on
    end
    end
    
    if saveResults == 1
        saveas(gcf, [imgSavePath, '\',detGround.imageFilename{k}, '_IoU_', IoU,'.jpg'])
    end

    % Also possible to plot tracks using trackPlotter(bep). See:
    % https://www.mathworks.com/help/driving/examples/visualize-sensor-coverage-detections-and-tracks.html
    pause(pauseTime)    
    end
    
end

