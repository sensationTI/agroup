% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

% This program takes a list of folders where training data is stored and
% combines them into consistent names into one folder

%{
...finalImageDirectory = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\Final Training Data\'...
    'All_Combined'];
...
%}
finalDirectory = 'F:\All_Combined';

Directory = {};
labelData = {};
Directory{1} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Nov7_PartlyCloudy_8C'];
labelData{1} = 'DataLabelled.mat';

Directory{2} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Oct1_Misty_15C'];
labelData{2} = 'DataLabelled.mat';

Directory{3} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Oct3_Overcast_14C'];
labelData{3} = 'DataLabelled.mat';

Directory{4} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Oct30_SomeClouds_3C'];
labelData{4} = 'DataLabelled.mat';

Directory{5} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Nighttime_Aug21_Overcast_21C'];
labelData{5} = 'DataLabelled.mat';

Directory{6} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Oct31_Overcast_13C'];
labelData{6} = 'DataLabelled.mat';

Directory{7} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Nighttime_Nov15_Snowy_-1C'];
labelData{7} = 'DataLabelled.mat';
%%

load([Directory{1}, '\', labelData{1}]);
totalImages = 1;
newLabels2 = newLabels;
for k = 1:length(Directory)
    if k == 1
        for n = 1:length(newLabels{:,1})
            imageFilename = ['frame_', num2str(totalImages), '.jpg'];
            copyfile([Directory{1}, '\', newLabels{n,1}{1}],[finalDirectory,'\',imageFilename], 'f');
            totalImages = totalImages + 1;
            newLabels2{n,1}{1} = imageFilename;
        end
    else
        load([Directory{k}, '\', labelData{k}]);
        % put all labels into one table. These will get a new imageFilename
        % based on the combined image directory
        newLabels2 = [newLabels2; newLabels];
        for m = 1:length(newLabels{:,1})
            imageFilename = ['frame_', num2str(totalImages), '.jpg'];
            %copy image from original image folder to new folder with new
            %name
            copyfile([Directory{k}, '\',newLabels{m,1}{1}], [finalDirectory,'\',imageFilename], 'f')   
            newLabels2{totalImages,1}{1} = imageFilename;
            totalImages = totalImages + 1;
        end
    end
end

% Save the labels to the image folder
save([finalDirectory,'\', 'DataLabelled.mat'], 'newLabels2')
         