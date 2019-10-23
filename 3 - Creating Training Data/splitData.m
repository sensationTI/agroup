% the data we have must be converted into training, validation, and testing
% data in order to analyze the success of the network. The training data
% will consist of 70% of the total data. 15% will be allocated to
% validation, and 15% to testing. Rather than randomly take images and
% their respective labels, since the data is chronologically captured
% through video feeds, 14 out of 20 images will be allocated to training,
% and 3/20 to validation and testing respectively. These images will be
% taken as follows: 
% Training: image 1,2,3,5,7,8,10,11,13,14,16,17,18,20
% Validation: 4,12,19
% Testing: 6,9,15

imageDir = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_Only_Stationary'
trainingDirectory = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_Only_Stationary\Train'
validationDirectory = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_Only_Stationary\Validation'
testDirectory = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_Only_Stationary\Test'
load('C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\Combined_Only_Stationary\DataLabelled.mat');
allLabelData = newLabels2;%trainingData;


trainingRows = []
validationRows = []
testRows = []

% labelData{:,1} gives the total number of images
% Probably isn't necessary to copy all images AGAIN
for m = 1:length(allLabelData{:,1})
    remDiv = rem(m,20);
    if remDiv == 1 || remDiv == 2 || remDiv == 3 || remDiv == 5 || remDiv == 7 ||...
            remDiv == 8 || remDiv == 10 || remDiv == 11 || remDiv == 13 || ...
            remDiv == 14 || remDiv == 16 || remDiv == 17 || remDiv == 18 ||...
            remDiv == 20 || remDiv == 0
        trainingRows = [trainingRows m];
        frameName = strsplit(allLabelData{m,1}{1}, '\');
        copyfile([imageDir, '\', allLabelData{m,1}{1}], [trainingDirectory, '\', frameName{end}]);
    elseif remDiv == 4 || remDiv == 12 || remDiv == 19
        validationRows = [validationRows m];
        frameName = strsplit(allLabelData{m,1}{1}, '\');
        copyfile([imageDir, '\', allLabelData{m,1}{1}], [validationDirectory, '\', frameName{end}]);
    elseif remDiv == 6 || remDiv == 9 || remDiv == 15
        testRows = [testRows m];
        frameName = strsplit(allLabelData{m,1}{1}, '\');
        copyfile([imageDir, '\', allLabelData{m,1}{1}], [testDirectory, '\', frameName{end}]);
    end
end

trainingLabelData = allLabelData(trainingRows', :);
validationLabelData = allLabelData(validationRows', :);
testLabelData = allLabelData(testRows', :);

save([trainingDirectory, '\', 'trainingLabels.mat'], 'trainingLabelData');
save([validationDirectory, '\', 'validationLabels.mat'], 'validationLabelData');
save([testDirectory, '\', 'testLabels.mat'], 'testLabelData');

% copyfile(trainingData{m,1}{1}, [finalImageDirectory,'\',imageNames, num2str(totalImages), '.jpg']);

         
        
        
    
    
    
    