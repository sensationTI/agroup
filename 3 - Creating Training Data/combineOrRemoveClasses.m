% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong


% This script will combine or delete unwanted classes from a table of
% labelled data. This is likely just used to combine non-uniform and
% uniform temperature pedestrians which may be necessary due to the
% subjective nature of labelling objects.

% Load the table containing the labelled data
load(['\\cmht-fs.mcmaster.ca\data\projects\2036 - Infrared Camera - '...
    'Ben Miethig\Thesis Instructions\Raw Data\All_Combined\Train'...
    '\trainingLabels']);
labelledData = trainingLabelData;
finalDirectory = 'F:\All_Combined\Train';

% combine the desired classes. Since only pedestrians are to be combined,
% this will be hardcoded. The non-uniform and uniform (PDC and PDU) are
% contained in columns 10 and 11. The classes and corresponding column
% numbers are as follows. May also want to combine bikes and sitting pedestrians
% to one class but for now not:
trainingLabelData.Properties.VariableNames
% CRO = 2
% BUS = 3
% This class is no longer used
% SUV = 4 
% CAR = 5
% DGS = 6
% DGL = 7
% BIK = 8
% PDS = 9
% PDC = 10
% PDU = 11

% combine columns 10 and 11:
for m = 1:length(labelledData{:,1})
   labelledData{m,10}{1} = [labelledData{m,10}{1}; labelledData{m,11}{1}];
end

% remove the unwanted classes
% add the columns you want included in the row vector below. Omit the ones
% you do not want to include. 
tableClasses = [1, 10]; %,2,3,5,6,7,8,9];
labelledData = labelledData(:, sort(tableClasses));

save([finalDirectory, '\refinedLabels.mat'], 'labelledData')