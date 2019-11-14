function [pix_corr, radius] = convertRawPCSToWCSFcn(pixel, probErr)

range1 = 195;
range2 = 206;
range3 = 223;
range4 = 253;
range5 = 324;
range6 = 512;

if pixel(2)<range1
    err = [-.345569,-1.9];
    sigma = [3.6243, 4.60386];
elseif pixel(2)>=range1 && pixel(2) < range2
    err = [-.345569,-0.820233];
    sigma = [3.6243, 5.67147];
elseif pixel(2)>=range2 && pixel(2) < range3
    err = [-1.31711,0.316178];
    sigma = [4.05014, 8.89495];
elseif pixel(2)>=range3 && pixel(2) < range4
    err = [-.187478,0.316178];
    sigma = [4.51462, 8.89495];
elseif pixel(2)>=range4 && pixel(2) < range5
    err = [-.187478,0.316178];
    sigma = [5.90608, 8.89495];
elseif pixel(2)>=range5 && pixel(2) < range6
    err = [-1.769,10.2578];
    sigma = [5.90608, 17.5366];
end

if probErr == 0.5
    std_dev = 0.6745;
elseif probErr == 0.95
    std_dev = 1.96;
end

radius = sigma*std_dev

pix_corr = pixel-err;
% px_min = pix_corr(1)-std_dev*sigma(1);
% px_max = pix_corr(1)+std_dev*sigma(1);
% py_min = pix_corr(2)-std_dev*sigma(2);
% py_max = pix_corr(2)+std_dev*sigma(2);
% 
%     
% camParameters = open('C:\Users\benmi\Documents\Thesis\Matlab\Calibration Parameters\cameraParametersJune7Calib.mat');
% focalLength = camParameters.cameraParamsJune7Calibration.FocalLength; % [fx, fy] in pixel units
% principalPoint = camParameters.cameraParamsJune7Calibration.PrincipalPoint; % [cx, cy] optical center in pixel coordinates
% RadialDistortion = camParameters.cameraParamsJune7Calibration.RadialDistortion; %[0 0]
% imageSize = [512, 640]; % [nrows, mcols]
% camIntrinsics = cameraIntrinsics(focalLength, principalPoint, imageSize, 'RadialDistortion', RadialDistortion);
% 
% % Camera tilt angle in degrees
% tiltDeg = 8.584;
% tilt = tiltDeg * pi/180;
% 
% height = 1.67; % mounting height in meters from the ground
% pitch  = tiltDeg; % pitch of the camera in degrees
% yaw = 0;
% roll = 0;
% sensorLocation = [-2.235 0.152];
% sensor2 = monoCamera(camIntrinsics,height,'Pitch',pitch, 'sensorLocation', sensorLocation);
% % since all detections were made on an image of size [700,875] and
% % calibration was done for an image of size [512,640], the images need to
% % be downsampled back to [512, 640].
% scale = 0.73142857;
% 
% xy_base = imageToVehicle(sensor2, pix_corr)
% x_max = imageToVehicle(sensor2, [pix_corr(1), py_min])
% x_min = imageToVehicle(sensor2, [pix_corr(1), py_max])
% y_min = imageToVehicle(sensor2, [px_max, pix_corr(2)])
% y_max = imageToVehicle(sensor2, [px_min, pix_corr(2)])
end