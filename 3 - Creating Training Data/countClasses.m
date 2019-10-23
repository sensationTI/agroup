% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

imageDirectory = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - Infrared Camera'...
    '- Ben Miethig\Driving Data CMHT Drive\Nov 15 - Snowy - Nighttime\'...
    'testwinter1v1TempRange-88to-03FifthOfFrames\'];
% imageDirectorySorted = natsortfiles({imageDirectory.name}); 
% this was here originally... natsortfiles sorts image file names in the
% order 1,2,3,4,5,6,7,8,9,10,11,... instead of 1, 11,...,2,20,...
getTrainData = load([imageDirectory,'DataLabelledtestwinter1v1TempRange-88to-03FifthOfFrames.mat']);
trainingData = getTrainData.trainingData;
classes = {trainingData.Properties.VariableNames{2:end}};
counts = zeros(1, length(classes));
for x =1: length(trainingData{:,1})
for j = 1:length(classes)
    table = trainingData;%timetable2table(gTruth.LabelData(x, classes{j}));
    boundingBoxes = table{x,1+j}{1};
    if length(boundingBoxes)==0
    
    else
    
    counts(j) = counts(j) + length(boundingBoxes(:,1));
    
    end
end
end
[char(classes'), num2str(counts')]
['total frames', num2str(length(trainingData{:,1}))]
