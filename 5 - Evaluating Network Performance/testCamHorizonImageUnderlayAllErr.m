% pixelLocations = [96.5 135; 66 139; 237 134; 362 149; ...
%     365 144; 377.78 140; 378 142.7]

% Camera tilt angle in degrees
tiltDeg = 8.584;
tilt = tiltDeg * pi/180;

height = 1.67; % mounting height in meters from the ground
pitch  = tiltDeg; % pitch of the camera in degrees
yaw = 0;
roll = 0;
sensorLocation = [-2.235 0.152];

% used to get the world coordinates from image frame
sensor2 = monoCamera(camIntrinsics,height,'Pitch',pitch, 'sensorLocation', sensorLocation);


img = imread("C:\Users\benmi\Documents\Thesis\Thesis Instructions\Raw Data\frame_2219.jpg");%032.jpg");%ones(512, 640,3);
scale = 0.73142857;
imag = imresize(img,scale);
pixelToDist = [];

% pixelLocations = [362, 145;362, 147;362, 148; 362, 149; 362 , 160]

for k= 1:2:size(imag,1)
    for m = 1:2:size(imag,2)
        distance = imageToVehicle(sensor2, [m,k]);
        if distance(1)<0 || 19.9<distance(1)
            imag(k,m, :) = [0 0 1]*255;
            if exist('pixelMax1')==0
                pixelMax1 = k;
            end
            if exist('pixelMax1')
            if k>pixelMax1
                pixelMax1 = k;
            end
            end            
        end
        if 19.9<distance(1) && distance(1)<=29.6
            imag(k,m,:) = [0,1,0]*255;
            if exist('pixelMax2')==0
                pixelMax2 = k;
            end
            if exist('pixelMax2')
            if k>pixelMax2
                pixelMax2 = k;
            end
            end    
        end
        if 14.9<distance(1)&& distance(1)<=19.9
            imag(k,m,:) = [1,0,0]*255;
            if exist('pixelMax3')==0
                pixelMax3 = k;
            end
            if exist('pixelMax3')
            if k>pixelMax3
                pixelMax3 = k;
            end
            end  
        end
        if 10.0<distance(1)&& distance(1)<=14.9
            imag(k,m,:) = [0,0,1]*255;
            if exist('pixelMax4')==0
                pixelMax4 = k;
            end
            if exist('pixelMax4')
            if k>pixelMax4
                pixelMax4 = k;
            end
            end  
        end
        if 5.0<distance(1)&& distance(1)<=10.0
            imag(k,m,:) = [1,0,1]*255;
            if exist('pixelMax5')==0
                pixelMax5 = k;
            end
            if exist('pixelMax5')
            if k>pixelMax5
                pixelMax5 = k;
            end
            end  
        end   
%         if 10<distance(1)&& distance(1)<=20
%             imag(k,m,:) = [0,1,1]*255;
%             if exist('pixelMax6')==0
%                 pixelMax6 = k;
%             end
%             if exist('pixelMax6')
%             if k>pixelMax6
%                 pixelMax6 = k;
%             end
%             end  
%         end
        if 0<distance(1)&& distance(1)<=5.0
            imag(k,m,:) = [1,1,0]*255;
            if exist('pixelMax7')==0
                pixelMax7 = k;
            end
            if exist('pixelMax7')
            if k>pixelMax7
                pixelMax7 = k;
            end
            end  
        end 
    end
    pixelToDist(k,:) = [k distance(1)];
end
% imag8 = uint8(imag*255);
figure
imshow(imag);
text(100, 100, ['distance range > 29.6m'], 'Color', 'w')
text(100, 195, ['distance range = 19.9m to 29.6m'], 'Color', 'w')
text(100, 213, ['distance range = 14.9.m to 19.9m'], 'Color', 'w')
text(100, 240, ['distance range = 10.0m to 14.9m'], 'Color', 'w')
text(100, 300, ['distance range = 5.0 to 10.0m'], 'Color', 'w')
text(100, 400, ['distance range = 1.1 to 5.0m'], 'Color', 'w')

saveas(gcf, "C:\Users\benmi\Documents\Thesis\Thesis Instructions\Results\RangeDepictionAllerror.jpg");



% text(100, 200, ['30m > distance > 20m maxpix', num2str(pixelMax5)], 'Color', 'w')
% text(100, 230, ['20m > distance > 10m maxpix', num2str(pixelMax6)], 'Color', 'w')
% text(100, 300, ['10m > distance maxpix', num2str(pixelMax7)], 'Color', 'w')
