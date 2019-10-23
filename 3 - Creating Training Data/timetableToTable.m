% This script takes a timetable formed from the matlab Ground Truth Labeler
% App and converts it into a table of the form required for Matlab's CNN
% training algorithms. The headers in this table are "imageFilename" and
% all of the classes we are detecting

% this is only thing that needs to be altered
driveDirectory = 'C:\Users\benmi\Documents\Thesis\Driving Data\Nov 15 - Snowy - Nighttime'
labellingSessionLabels = 'testwinter1v1TempRange-88to-03FifthOfFramesLabels.mat'
vidFrames = 'testwinter1v1TempRange-88to-03FifthOfFrames'

% load the labelling session
load([driveDirectory, '\', labellingSessionLabels])

% get timetable with annotations from the labelling session
timetable = gTruth.LabelData;

% convery timetable to a regular table without the time column
trainingData = timetable2table(timetable, 'ConvertRowTimes', false);

% get filenames of images in data:
imageFilename = {};
imageDirectoryAndName = [driveDirectory, '\', vidFrames, '\frame'];
CRO = {};
for k = 1:length(trainingData{:,1})
    if length(trainingData{1,:})==9
        CRO{end+1} = [];
    end        
    imageFilename{end+1} = [imageDirectoryAndName, num2str(k), '.jpg'];
end

if length(trainingData{1,:})==9
    trainingData.CRO = CRO';
end
trainingData.imageFilename = imageFilename';

% Put the file names in the first column of the table (may not be
% necessary)
trainingData = fliplr(trainingData);

%% Remove empty rows and "empty" images
% Remove any empty rows. Note that we might not actually want to do this:

% This function removes all of the empty rows, or "empty frames" from the
% labelled data from the ground truth labelling session. It requires a
% table which is made from the timetableToTable script

idx = all(cellfun(@isempty,trainingData{:,2:end}),2);

% Delete all images that do not have a label associated with them
% Uncomment this to delete the images
for k = 1:length(trainingData{:,1})
    if idx(k)
        delete([imageDirectoryAndName, num2str(k), '.jpg'])
    end
end

trainingData(idx,:)=[];

% need to save this afterwards
save([driveDirectory,'\', vidFrames, '\', 'DataLabelled',vidFrames,'.mat'], 'trainingData')

%%
% May want to eliminate columns without any entries as well:
% trainingData = trainingData(:, [1,2,3,5,6]) % this is an example of how
% to do it
