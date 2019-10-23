% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

% This code was made to investigate how the RCNN in matlab is trained and
% in what format its labelled images are saved. The first part of this
% program merely explores how/where each bounding box is structured around
% the stop signs

% load('rcnnStopSigns.mat')
% load('stopSigns.mat')
% load( 'layers')
% classes = {'Ped', 'Dog', 'Car', 'PedSit', 'Bik'};
directory = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - Infrared Camera '...
    '- Ben Miethig\ITEC Conference Paper\Labelled_IR_Data\'...
    'Nighttime_Nov15_Snowy_-1C'];
% get all the .jpg files in above folder, the order of the image is ramdom
image = dir([directory,'\*.jpg']);
% sort by the file name
imageSorted = natsortfiles({image.name});
% getTrainData = load([imageDir,'\DataLabelleddog4TempRange164to240HalfOfFrames.mat']) 
% ['DataLabelledOct1v3vid3MistyTempRange90to130FifthOfFrames.mat']);
% ['DataLabelledOct1v3vid3MistyTempRange90to130FifthOfFrames.mat']);
getTrainData = load([directory,'\DataLabelled.mat']);
trainingData = getTrainData.newLabels;
% get all the class names
classes = trainingData.Properties.VariableNames(2:end);

for x = 1:100: length(trainingData{:,1})% length(gTruth.LabelData{:,1})  
    imshow(strcat(image(x).folder, '\', imageSorted{x}))
    hold on
    for j = 1:length(classes)
        table = trainingData;%timetable2table(gTruth.LabelData(x, classes{j}));
        boundingBoxes = table{x,1+j}{1};
        if isempty(boundingBoxes)           
        else         
            rect = boundingBoxes;%stopSigns(x, 2).stopSign{1}; %returns the 2nd column of the x row of the table found in "stopSigns"
            for k = 1:length(boundingBoxes(:,1));
                % for k = 1:size(rect, 1)
                rectangle('Position',rect(k,:), 'Edgecolor', 'r');
                text(rect(k,1), rect(k,2)+rect(k,4)+8, classes{j}, 'FontSize', 12, 'Color', 'green')
            end   
        end
    end
    pause(0.5)
    % saveas(gcf,strcat(filename));    
end
