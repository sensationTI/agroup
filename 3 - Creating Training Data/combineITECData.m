% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

% This script takes every labelled frame from each data folder, renamed
% them, and then put them in a new folder.

%{
...finalImageDirectory = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\Final Training Data\'...
    'Combined_Only_Stationary'];
...
%}
finalDirectory = 'F:\Combined_Only_Stationary';

Directory = {};
Directory{1} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Nov7_PartlyCloudy_8C'];

Directory{2} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper\'...
    'Labelled_IR_Data\Daytime_Oct30_SomeClouds_3C'];

Directory{3} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper'...
    '\Labelled_IR_Data\Daytime_Oct31_Overcast_13C'];

Directory{4} = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\ITEC Conference Paper'...
    '\Labelled_IR_Data\Daytime_Oct3_Overcast_14C'];


%%
% a possible way to simplify the original code. Name and ordering needs to
% be fixed.
%{
...
newLabels2 = {};
totalImages = 1;
for k = 1:length(imageDirectory)
    load([imageDirectory{k}, '\DataLabelled.mat']);    
    newLabels2 = [newLabels2; newLabels];
    for n = 1:length(newLabels{:,1})
        imageFilename = ['frame_', num2str(totalImages), '.jpg'];
        copyfile ([imageDirectory{k}, '\', newLabels{n,1}{1}], [finalImageDirectory,'\',imageFilename], 'f');
        totalImages = totalImages + 1;
        newLabels2{n,1}{1} = imageFilename;
    end
end
...
%}
%%

load([Directory{1}, '\DataLabelled.mat']);
% newLabels2 - concatenate all previous leabels and store them in here
newLabels2 = newLabels;
% total number of frames
totalImages = 1;

for k = 1:length(Directory)
    if k == 1
        for n = 1:length(newLabels{:,1})
            imageFilename = ['frame_', num2str(totalImages), '.jpg'];
            copyfile ([Directory{1}, '\', newLabels{n,1}{1}], [finalDirectory,'\',imageFilename], 'f');
            totalImages = totalImages + 1;
            newLabels2{n,1}{1} = imageFilename;
        end
    else
        load([Directory{k}, '\DataLabelled.mat']);
        % put all labels into one table. These will get a new imageFilename
        % based on the combined image directory
        newLabels2 = [newLabels2; newLabels];
        for m = 1:length(newLabels{:,1})
            imageFilename = ['frame_', num2str(totalImages), '.jpg'];

            %copy image from original image folder to new folder with new
            %name
            copyfile([Directory{k}, '\', newLabels{m,1}{1}], [finalDirectory,'\',imageFilename])
            newLabels2{totalImages,1}{1} = imageFilename;
            totalImages = totalImages + 1;
        end
    end
end

% Save the labels to the image folder
save([finalDirectory,'\', 'DataLabelled.mat'], 'newLabels2')
         