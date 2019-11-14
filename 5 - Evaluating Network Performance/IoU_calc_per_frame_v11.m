% This program takes the output of a detection algorithm (its identified
% class and its bounding box) and generates its performance metrics against
% the ground truth data FOR A SINGLE FRAME, which is derived from manually labelled driving
% videos, the same type of data used to train the algorithms (assuming the
% algorithm is trained via supervised learning)
% Note: sometimes not all cars are labelled in data so verification that
% all frames are labelled correctly should be done upon evaluating each
% frame.
% See my literature review for a detailed explaination of these metrics or
% the following sources: 
% https://medium.com/@jonathan_hui/map-mean-average-precision-for-object-detection-45c121a31173

% Intersection of Union (IoU) - did the predicted bounding box properly detect
% the ground truth object?
% IoU = (area of bounding box overlap)/(area of union)

% Step 1: Do the bounding boxes coincide with ground-truth objects? This
% occurs if their IoU is greater than 0.5 (this is a user-set parameter)

% Load the ground truth and detected tables
% may want to incorporate this to work with the IoUdetectTableGen.m script
% (convert to a function with inputs being filepaths)
clear

% ground truth
load("C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\All_Combined\Validation\validationLabels.mat");
% detected boxes
load("C:\Users\benmi\Documents\Thesis\Algorithm Performance\YOLOv2\7 Classes Trained on All Data\epoch-step 29250\All Data Val\IoUdetectedWithConfidence.mat");
IoUtruth = validationLabelData;
IoUdetected = IoUdetectedWithConfidence;
imgPath = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\Ground Truth Data\All_Combined\Validation';
excSavePath = 'C:\Users\benmi\Documents\Thesis\Algorithm Performance\YOLOv2\7 Classes Trained on All Data\epoch-step 29250\All Data Val';

% Algorithm
alg = 'YOLOv2';
% Number of epoches or steps
epoches = '29250';
% Number of Classes
numClasses = '7';
% ground truth data
data = 'All';
version = 'Valid';

% Desired detection/confidence score threshold:
threshold = 0.4;
threshtxt = '0p4';

% establish required IoU value to confirm a detection
requiredIoU = 0.4;
IoUtxt = '0p4';



imgSavePath = ['C:\Users\benmi\Documents\Thesis\Algorithm Performance\YOLOv2\7 Classes Trained on All Data\epoch-step 29250\All Data Val'];


% display the images? y/n = 1/0
dispRaw = 0;
dispResults = 0;
saveResults = 0;
if dispResults == 1
    pauseTime = 0;
end


tic
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

% CRO = 1;
% BIK = 1;
% PDU = 1;
% PDC = 1;
% PDS = 1;
% CAR = 0;
% BUS = 0;
% DGS = 1;
% DGL = 1;
% SUV = 0;

% remove unwanted classes
if CRO == 0
    IoUtruth.CRO = [];
    IoUdetected.CRO = [];
end
if BIK == 0
    IoUtruth.BIK = [];
    IoUdetected.BIK = [];
end
if PDU == 0
    IoUtruth.PDU = [];
    IoUdetected.PDU = [];
end
if PDC == 0
    IoUtruth.PDC = [];
    IoUdetected.PDC = [];
end
if PDS == 0
    IoUtruth.PDS = [];
    IoUdetected.PDS = [];
end
if CAR == 0
    IoUtruth.CAR = [];
    IoUdetected.CAR = [];
end
if BUS == 0
    IoUtruth.BUS = [];
    IoUdetected.BUS = [];
end
if DGS == 0    
    IoUtruth.DGS = [];
    IoUdetected.DGS = [];
end
if DGL == 0      
    IoUtruth.DGL = [];
    IoUdetected.DGL = [];
end
if SUV == 0
    IoUtruth.SUV = [];
    IoUdetected.SUV = [];    
end
    
for y = 1:size(IoUtruth,1) %203%1:size(IoUtruth,1) %100
img1 = imread([imgPath, '\',IoUtruth{y,1}{1}]);
%Initialize Bounding boxes of true and detected labelled images from input
%information
rectTruth = cell(1,length({IoUtruth.Properties.VariableNames{:}})-1);
rectDetect = cell(1,length({IoUdetected.Properties.VariableNames{:}})-1);;
rectTruthLabel = [];
rectDetectLabel = [];
numTruth = cell(1,length({IoUtruth.Properties.VariableNames{:}})-1);
numDet = cell(1,length({IoUtruth.Properties.VariableNames{:}})-1);

%setting up cells with detections
for i = 2:length({IoUtruth.Properties.VariableNames{:}})
    rectTruth{i-1} = [rectTruth{i-1};  IoUtruth{y,i}{1}];
    rectTruthLabel = [rectTruthLabel; IoUtruth.Properties.VariableNames{i}];
    numTruth{i-1} = size(IoUtruth{y,i}{1},1);
    rectDetectLabel= [rectDetectLabel; IoUdetected.Properties.VariableNames{i}];
    % only say that the object is detected if its confidence score is above
    % a certain value (specified by user at beginning of script)
    for n = 1:size(IoUdetected{y,i}{1},1)
        if IoUdetected{y,i}{1}(n,5)>=threshold
            rectDetect{i-1} = [rectDetect{i-1}; IoUdetected{y,i}{1}(n,1:5)]; 
        end
    end
    numDet{i-1} = size(rectDetect{i-1},1);
end 

% Display detected and true bounding boxes on image
if dispRaw == 1
figure
imshow(img1)
hold on

% Display ground truth bounding boxes
for j = 1:length(rectTruth)
    if length(rectTruth{j})>0
    for k = 1:length(rectTruth{j}(:,1));
        rectangle('Position',rectTruth{j}(k,:), 'Edgecolor', 'g');
        text(rectTruth{j}(k,1), rectTruth{j}(k,2)+rectTruth{j}(k,4)+8, IoUtruth.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'green')        
    end
    else
    end
end

% display detected bounding boxes
for j = 1:length(rectDetect)
    if length(rectDetect{j})>0
        for k = 1:length(rectDetect{j}(:,1));

            rectangle('Position',rectDetect{j}(k,1:4), 'Edgecolor', 'r');
%             img1 = insertShape(img1,'FilledRectangle',rectDetect{j}(k,:),'Color','red');
            text(rectDetect{j}(k,1), rectDetect{j}(k,2)-8, IoUdetected.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'red')
        end
    else
    end
end
end

% Evaluate if any existing detections overlap any ground-truth objects:
% For each detection, see if there is any box overlap, if yes, compute the
% IoU for these boxes. Also note that the classes must match to perform
% IoU.

classes = {IoUtruth.Properties.VariableNames{:}};
classes = classes(2:end);

for k = 1:length(classes)
    % verify the column exists in the output data and which column
    % corresponds to the class. Commenting this line out because the
    % detected classes should always match up with the truth
%     [~, idx] = ismember(classes(k), IoUdetected.Properties.VariableNames);
%     detectionsInClass = IoUdetected{y,idx}{1}
    if size(rectDetect{k},1)>0
        detectionsInClass = rectDetect{k}(:,1:4);
    else
        detectionsInClass = rectDetect{k};
    end
    
    % see how many detections were made by algorithm and compare this to
    % the objects known from the ground truth
    numDetectionsInClass = size(detectionsInClass,1);
    trueDetections = IoUtruth{y,1+k}{1};
    numTrueDetections = size(trueDetections,1);
    IoU{k} = zeros(numDetectionsInClass, numTrueDetections);
    for m = 1:numDetectionsInClass
        for n = 1:numTrueDetections
            % remove zero elements
            A = detectionsInClass(m,:);
            A(A==0) = 1;
            % bboxOverlapRatio is the same as the Intersection over Union: https://www.mathworks.com/help/vision/ref/bboxoverlapratio.html
            IoU{k}(m,n) = bboxOverlapRatio(A,  trueDetections(n,:), 'Union');%detectionsInClass(m,:),  trueDetections(n,:), 'Union');
        end
    end
end

% IoU for ALL classes
IoUNew = cell(length(classes),length(classes));
for k = 1:length(classes)
    % verify the column exists in the output data and which column
    % corresponds to the class. Commenting this line out because the
    % detected classes should always match up with the truth
    if size(rectDetect{k},1)>0
        detectionsInClass = rectDetect{k}(:,1:4);
    else
        detectionsInClass = rectDetect{k};
    end

    % see how many detections were made by algorithm and compare this to
    % the objects known from all ground truth objects
    numDetectionsInClass = size(detectionsInClass,1);

    for m = 1:numDetectionsInClass
        for p = 1:size(rectTruth,2)
            numTrueDetections = size(rectTruth{1,p},1);
            trueDetections = rectTruth{1,p};
            for n = 1:numTrueDetections
                IoUNew{k,p}(m,n) = 0;%zeros(numDetectionsInClass, numTrueDetections);
                % remove zero elements
                A = detectionsInClass(m,:);
                A(A==0) = 1;
            % bboxOverlapRatio is the same as the Intersection over Union: https://www.mathworks.com/help/vision/ref/bboxoverlapratio.html
            % k is row (detections), p is column (true detections)
                IoUNew{k,p}(m,n) = bboxOverlapRatio(A,  trueDetections(n,:), 'Union');
            end
        end
    end
end


% Need to determine how many true positives and negatives and false
% postive and negatives exist:

% True positive (TP) occurs if the IoU is greater than the required IoU
% threshold between a detection and a ground truth. A false positive (FP) occurs
% if a detection has been made on a non-existant object in frame (false alarm). A false
% negative (FN) occurs if a true object is missed (missed detection). True negative (TN) occurs when you
% don't detect the obj when it is not present anyway (not important for us)

% Each column of IoU{} corresponds to a true object. Each row corresponds
% to a detected object. These will be used to determine the TP, FP, and FN
% The indexes here tell you which bounding box corresponds with each
% detection/ground truth


TP = zeros(1, size(IoUNew,1));
TPstats = zeros(1, size(IoUNew,1));
FP = zeros(1, size(IoUNew,1));
FN = zeros(1, size(IoUNew,1));
TPCE = zeros(size(IoUNew));

rectFN = rectTruth;
rectFNref = rectTruth;
rectFP = rectDetect;
rectFPref = rectDetect;
rectTP = cell(1,length({IoUtruth.Properties.VariableNames{:}}));
rectTP{1} = IoUtruth{y,1}{1};

% This method of TP can lead to more for more TP object detections due to a 
% lack of 1:1 target to detection ratio. To prevent this from messing up the
% TP stats, a TP_corr variable will be introduced. Also, TPCE can cause
% multiple TP detections for certain ground truth objects. therefore
% include TCPE in the TP_corr value
% True positives:
for p = 1:size(IoUNew,1)
    for q = 1:size(IoUNew,2)        
        if size(IoUNew{p,q})>0
            % m is number of detections in class
            % n is number of truth boxes in class
            for m = 1:size(IoUNew{p,q},1)
                for n = 1:size(IoUNew{p,q},2)
                    if p==q
                        if IoUNew{p,q}(m,n)>requiredIoU
                            TP(p) = TP(p) + 1;
                            % if there are multiple TP for two detections,
                            % make sure to only use one of them. This
                            % requires Non-max suppression. 
                            if sum(rectFN{q}(n,:))>1
%                                 rectTP{q+1}(n,:) = {{rectFNref{q}(n,:)},{classes{q}}, {rectFPref{p}(m,:)}, {classes{p}}, {IoUNew{p,q}(m,n)}};
                                rectTP{q+1} = {{rectFNref{q}(n,:)},{classes{q}}, {rectFPref{p}(m,:)}, {classes{p}}, {IoUNew{p,q}(m,n)}};
                            else
                                rectTP{q+1}{1}{1} = [rectTP{q+1}{1}{1}; rectFNref{p}(n,:)];
                                rectTP{q+1}{3}{1} = [rectTP{q+1}{3}{1}; rectFPref{p}(m,:)]; 
                                rectTP{q+1}{4}{1} = {rectTP{q+1}{4}{1}; classes{p}}; 
                                rectTP{q+1}{5}{1} = [rectTP{q+1}{5}{1}; IoUNew{p,q}(m,n)];
%                                 rectTP{q+1}{n,1}{1} = [rectTP{q+1}{n,1}{1}; rectFNref{p}(n,:)];
%                                 rectTP{q+1}{n,3}{1} = [rectTP{q+1}{n,3}{1}; rectFPref{p}(m,:)]; 
%                                 rectTP{q+1}{n,4}{1} = {rectTP{q+1}{n,4}{1}; classes{p}}; 
%                                 rectTP{q+1}{n,5}{1} = [rectTP{q+1}{n,5}{1}; IoUNew{p,q}(m,n)]; 
                            end
                            rectFN{q}(n,:) = rectFN{q}(n,:)-rectFN{q}(n,:);
                            rectFP{p}(m,:) = rectFP{p}(m,:)-rectFP{p}(m,:);
                        end
                    end
                    if p~=q
                        if IoUNew{p,q}(m,n)>requiredIoU
                            TPCE(p,q) = TPCE(p,q)+1;
                            if sum(rectFN{q}(n,:))>0
                                rectTP{q+1} = {{rectFNref{q}(n,:)},{classes{q}}, {rectFPref{p}(m,:)}, {classes{p}}, {IoUNew{p,q}(m,n)}};
%                                 rectTP{q+1}(n,:) = {{rectFNref{q}(n,:)},{classes{q}}, {rectFPref{p}(m,:)}, {classes{p}}, {IoUNew{p,q}(m,n)}};
                            else
                                rectTP{q+1}{1}{1} = [rectTP{q+1}{1}{1}; rectFNref{q}(n,:)]; % changed the p in FNref to q
%                                 rectTP{q+1}{1}{1} = [rectTP{q+1}{1}{1}; rectFNref{p}(n,:)];
                                rectTP{q+1}{3}{1} = [rectTP{q+1}{3}{1}; rectFPref{p}(m,:)]; 
                                rectTP{q+1}{4}{1} = {rectTP{q+1}{4}{1}; classes{p}}; 
                                rectTP{q+1}{5}{1} = [rectTP{q+1}{5}{1}; IoUNew{p,q}(m,n)];
                            end
%                             if sum(rectFN{q}(n,:))>0
%                                 rectTP{q+1}(n,:) = {{rectFN{q}(n,:)},{classes{q}}, {rectFP{p}(m,:)}, {classes{p}}, {IoUNew{p,q}(m,n)}};
%                             else
%                                 rectTP{q+1}{1}{1} = [rectTP{q+1}{1}{1}; rectFN{p}(n,:)];
%                                 rectTP{q+1}{3}{1} = [rectTP{q+1}{3}{1}; rectFP{p}(m,:)]; 
%                                 rectTP{q+1}{4}{1} = {rectTP{q+1}{4}{1}; classes{p}}; 
%                                 rectTP{q+1}{5}{1} = [rectTP{q+1}{5}{1}; IoUNew{p,q}(m,n)];
%                             end
                            rectFN{q}(n,:) = rectFN{q}(n,:)-rectFN{q}(n,:);
                            rectFP{p}(m,:) = rectFP{p}(m,:)-rectFP{p}(m,:);
                        end                            
                    end
                end
            end
        end
    end
end

% get a double true positive if the ground truth object is correctly
% classified as the proper class AND incorrectly classified as another
% class.
% moving TP_corr to inside FN loop? Need to include TPCE in TP Corr and
% correcting this below the FN loop
TP_corr=TP;    
% corrected True positives
% for v = 1:length(TP)
%     if (TP_corr(v)>= ((numTruth{v}))) || (sum(TPCE(:,v))>=(numTruth{v})) % + sum(TPCE(:,v))
%         TP_corr(v)=numTruth{v};
%     end
%     if (TP_corr(v)) == numTruth{v}%+sum(TPCE(:,v))) == numTruth{v} % was == (June 4th, 2019 in v6)
%         TP_corr(v)=numTruth{v};
%     end
% end

% False Negatives:
for r = 1:length(TP)
%     for s=1:length(TP)
    totalDetTruths = TP(r) + sum(TPCE(:,r));
    TP_corr(r) = TP(r) + sum(TPCE(:,r));
    if totalDetTruths>=numTruth{r}
    else
        FN(r) = numTruth{r}-totalDetTruths;
    end
    TP_corr(r) = numTruth{r}-FN(r);
end


% False Positives
for r = 1:length(TP)
%     for s=1:length(TP)
    totalDets = TP(r) + sum(TPCE(r,:));
    if totalDets>=numDet{r}
    else
        FP(r) = numDet{r}-totalDets;
    end
end

% Precision for all classes in one frame: 
% Note that this only works if the class itself is identified properly. If
% the object is identified as a PDU instead of a PDC, this will not be able
% to differentiate.
precision = (TP(:)./(TP(:) + FP(:)))';

% Recall for all classes in one frame:
recall = (TP(:)./(TP(:) + FN(:)))';

% archive all information from all frames
if y == 1 || exist('IoUTable')==0
    IoUTable = array2table(IoUNew,'VariableNames',classes);
    recallTable = array2table(recall,'VariableNames',classes);
    precisionTable = array2table(precision,'VariableNames',classes);
    % get total number of TP, TPCE, FN, and FP for all frames
    TPNumTable = array2table(TP,'VariableNames',classes);%TPstats,'VariableNames',classes);
    TP_corrNumTable = array2table(TP_corr,'VariableNames',classes);
    TPCENumTable = array2table(TPCE,'VariableNames',classes);
    FPNumTable = array2table(FP,'VariableNames',classes);
    FNNumTable = array2table(FN,'VariableNames',classes);
    numTruthTable = array2table(numTruth,'VariableNames',classes);
    numDetTable = array2table(numDet,'VariableNames',classes);
    rectFNTable = array2table(rectFN,'VariableNames',classes);
    rectFPTable = array2table(rectFP,'VariableNames',classes);
    rectTPTable = array2table(rectTP,'VariableNames',{'imageFilename', classes{:}});
else
    % need evaluation metrics to be in table form
    IoUTableAdd = array2table(IoUNew,'VariableNames',classes);
    recallTableAdd = array2table(recall,'VariableNames',classes);
    precisionTableAdd = array2table(precision,'VariableNames',classes);
    TPNumTableAdd = array2table(TP,'VariableNames',classes);
    TP_corrNumTableAdd = array2table(TP_corr,'VariableNames',classes);
    TPCENumTableAdd = array2table(TPCE,'VariableNames',classes);
    FPNumTableAdd = array2table(FP,'VariableNames',classes);
    FNNumTableAdd = array2table(FN,'VariableNames',classes);
    numTruthTableAdd = array2table(numTruth,'VariableNames',classes);
    numDetTableAdd = array2table(numDet,'VariableNames',classes);
    rectFNTableAdd = array2table(rectFN,'VariableNames',classes);
    rectFPTableAdd = array2table(rectFP,'VariableNames',classes);
    rectTPTableAdd = array2table(rectTP,'VariableNames',{'imageFilename', classes{:}});

    IoUTable = [IoUTable; IoUTableAdd];
    recallTable = [recallTable; recallTableAdd];
    precisionTable = [precisionTable; precisionTableAdd];
    TPNumTable = [TPNumTable; TPNumTableAdd];
    TP_corrNumTable = [TP_corrNumTable; TP_corrNumTableAdd];
    TPCENumTable = [TPCENumTable; TPCENumTableAdd];
    FPNumTable = [FPNumTable; FPNumTableAdd];
    FNNumTable = [FNNumTable; FNNumTableAdd];
    numTruthTable = [numTruthTable; numTruthTableAdd];
    numDetTable = [numDetTable; numDetTableAdd];
    rectFNTable = [rectFNTable; rectFNTableAdd];
    rectFPTable = [rectFPTable; rectFPTableAdd];
    rectTPTable = [rectTPTable; rectTPTableAdd];
    
end

% Display results of detection
if or(dispResults,saveResults) == 1
figure
imshow(img1)
hold on

% Display TPCE and TP
for j = 1:size(IoUNew,1)
    for k = 1:size(IoUNew,2)
%         if k ~= j
        if size(IoUNew{j,k})>0
            % m is detections
            % n is truth boxes
            for m = 1:size(IoUNew{j,k},1)
                for n = 1:size(IoUNew{j,k},2)               
                    if IoUNew{j,k}(m,n)>requiredIoU
                        % disp TPCE
                        if k ~= j
                            rectangle('Position',rectDetect{j}(m,1:4), 'Edgecolor', 'm');%TPindex{j}(k),:), 'Edgecolor', 'g');
                            text(rectDetect{j}(m,1), rectDetect{j}(m,2)+rectDetect{j}(m,4)+8, IoUtruth.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'red')
                            rectangle('Position',rectTruth{k}(n,:), 'Edgecolor', 'm');
                            text(rectTruth{k}(n,1), rectTruth{k}(n,2)+rectTruth{k}(n,4)+8, IoUtruth.Properties.VariableNames{k+1}, 'FontSize', 12, 'Color', 'g')
                        end
                        % disp TP
                        if k==j
                            rectangle('Position',rectDetect{j}(m,1:4), 'Edgecolor', 'g');%TPindex{j}(k),:), 'Edgecolor', 'g');
                            text(rectDetect{j}(m,1), rectDetect{j}(m,2)+rectDetect{j}(m,4)+8, IoUtruth.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'g')
                        end
                    end
                end
            end    
        end
        
    end
end
            
% Display FN
for j = 1:length(rectFN)
    if length(rectFN{j})>0
    for k = 1:size(rectFN{j},1);
        if sum(rectFN{j}(k,:))>0 
            n = k%FNindex{j}(k);;
            rectangle('Position',rectFN{j}(k,:), 'Edgecolor', 'r');
            text(rectFN{j}(n,1), rectFN{j}(n,2)+rectFN{j}(n,4)+8, IoUtruth.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'r')        
        end   
    end
    end
end
% Display FP
for j = 1:length(rectFP)
    if length(rectFP{j})>0
    for k = 1:size(rectFP{j},1);
        if sum(rectFP{j}(k,:))>0 
            n = k%FNindex{j}(k);
            rectangle('Position',rectFP{j}(k,1:4), 'Edgecolor', 'b');
            text(rectFP{j}(n,1), rectFP{j}(n,2)+rectFP{j}(n,4)+8, IoUtruth.Properties.VariableNames{j+1}, 'FontSize', 12, 'Color', 'b')        
        end   
    end
    end
end

pause(pauseTime)
end
if saveResults == 1
    saveas(gcf, [imgSavePath, '\', IoUdetected.imageFilename{y,1}(1:end-4), '_thresh_', num2str(threshold), '_IoU_', num2str(requiredIoU),'.jpg'])
end
close all
end

toc

% don't include mAP performance metric:
% get AP for each class:
% APtable = cell(1,length(classes)+1);
% for k=1:length(classes)
%     APtable{k} = trimTable(IoUdetected, k+1);
% end
% % final entry is the mAP
% AP = cell(1,length(classes)+1);
% for k=1:length(classes)
%     [AP{k},~,~] = calcAP(APtable{k}, IoUtruth, k+1, requiredIoU);
% end
% %mAP
% AP{end} = sum([AP{1:end-1}])/length([AP{1:end-1}]);

% number of expected detections (from ground truth labels)
%Crowd:
% expectedCRO = sum([numTruthTable.CRO{:}]);
%PDU;
expectedPDU = sum([numTruthTable.PDU{:}]);
%PDC
expectedPDC = sum([numTruthTable.PDC{:}]);
%BIK
% expectedBIK = sum([numTruthTable.BIK{:}]);
expected = cell(1,length(classes)+1);

% number of total expected detections (from algorithm) total = TP+FN+TPCE
% OR total = TP_corr+FN
% true positive detections from algorithm. Going to use TP_corr for TP
% calculations
% TP_CRO = sum(TPNumTable.CRO);
% TP_PDU = sum(TPNumTable.PDU);
% TP_PDC = sum(TPNumTable.PDC);
% TP_BIK = sum(TPNumTable.BIK);

TP_final = cell(1,length(classes)+1);
TPCE_final = cell(1,length(classes)+1);
FP_final = cell(1,length(classes)+1);
FN_final = cell(1,length(classes)+1);
TP_final_nonCorr = cell(1,length(classes)+1);

for k = 1:length(classes)
    TP_final{k} = sum(TP_corrNumTable{:,k});
%     TP_corr_final{k} = sum(TP_corrNumTable{:,k});
    TPCE_final{k} = sum(TPCENumTable{:,k});
    FP_final{k} = sum(FPNumTable{:,k});
    FN_final{k} = sum(FNNumTable{:,k});
    expected{k} = sum([numTruthTable{:,k}{:}]);
    TP_final_nonCorr{k} = sum(TPNumTable{:,k});
end

% TP_all = [] represented in final column of TP_final
% FN_all = []
% FP_all = []
for k = 1:length(classes)
    if k==1
        TP_final{end}=0;
%         TP_corr_final{end}=0;
        TPCE_final{end}=0;
        FP_final{end}=0;
        FN_final{end}=0;
        expected{end}=0;
    end
    TP_final{end} = TP_final{end} + TP_final{k};
%     TP_corr_final{end} = TP_corr_final{end} + TP_corr_final{k}
    TPCE_final{end} = TPCE_final{end} + TPCE_final{k};
    FP_final{end} = FP_final{end} + FP_final{k};
    FN_final{end} = FN_final{end} + FN_final{k};
    TP_final_nonCorr{end} = TP_final_nonCorr{end}+TP_final_nonCorr{k};
    expected{end} = expected{end} + expected{k};
end

TP_final_nonCorr{end} = sum([TP_final_nonCorr{1:end-1}]);

recall_final = cell(1,length(classes)+1);
precision_final = cell(1,length(classes)+1);
F1 = cell(1,length(classes)+1);
F2 = cell(1,length(classes)+1);


% confusion matrix: **Use TP or TP_corr?
% TP/TPCE are represented in class x class matrix. The FN of all classes is
% shown in the second last row. The last row shows the total expected
% detections based on the ground Truth data. If the summation of each
% column is greater than the expected detections, this means multiple
% detections were made (and confirmed) on the same ground truth target.
% This is ok. The last column shows the total false positives for each
% class. The last column and second last row entry is the total number of
% false positives, true positives, and false negatives for the frames. 
confMat = zeros(length(classes),length(classes));

for x = 1:size(TPNumTable,1)
    beg = 1+(x-1)*length(classes);
    last = 1+(x-1)*length(classes)+length(classes)-1;
    confMat = confMat+diag(TPNumTable{x,:})+TPCENumTable{beg:last,1:length(classes)};
end

% precision should only be using the true TP targets, not the TPCE targets
% as the recall uses as well. This means all of my results are wrong...
% This will be fixed later. Focus on writing for now. This version corrects that issue. 
TPCE_dets = cell(1,length(classes)+1);
for i = 1:size(TPCE_dets,2)
    TPCE_dets{i}=0;
end
for j = 1:size(confMat,1)
    for k = 1:size(confMat,2)
        if j==k
        else
            TPCE_dets{j} = TPCE_dets{j} + confMat(j,k);
        end
    end
end
TPCE_dets{end} = sum([TPCE_dets{1:end-1}]);


for k = 1:(length(classes)+1)
    recall_final{k} = TP_final{k}/(TP_final{k}+FN_final{k});
%     precision_final{k} = TP_final{k}/(TP_final{k}+FP_final{k});
%     precision_final{k} = (TP_final{k}-(TPCE_final{k}))/(TP_final{k}+FP_final{k});
%     precision_final{k} = (TP_final_nonCorr{k})/(TP_final{k}+FP_final{k});
    precision_final{k} = (TP_final_nonCorr{k})/(TP_final_nonCorr{k}+FP_final{k}+TPCE_dets{k});
    F1{k} = 2*precision_final{k}*recall_final{k}/(precision_final{k}+recall_final{k});
    F2{k} = 5*precision_final{k}*recall_final{k}/(4*precision_final{k}+recall_final{k});
end

% add the number of false positive and false negatives to the confusion
% matrix in a new last column (for FP) and a new last row (for FN)
% FP: 
% scratch that, putting FP in a row now too (June 4th)
% confMatEnd = [FP_final{:}]';
% call last call cumulative values
confMatEnd = [];
for b = 1:size(confMat,1)
    confMatEnd = [confMatEnd, sum(confMat(b,:))];
end
% confMatEnd = [NaN, NaN, NaN]';
% confMat(:,length(classes)+1) = confMatEnd(1:end-1);
confMat(:,end+1) = confMatEnd';

 % FN:
% confMatLast = [FN_final{:}];
confMat(end+1,:) = [FN_final{:}];
% TP and TPCE
% confMatSum = TP_final{end}+FN_final{end}+FP_final{end}+TPCE_final{end};
% confMat(length(classes)+1,:) = [confMatLast(1:end-1) confMatSum];
confMat(end+1,:) = [FP_final{:}];
% expected number of targets
confExpected = [expected{:}];
confMat(end+1,:) = [confExpected];
% corrected TP for all classes
confMat(end+1,:) = [TP_final{:}];
% recall for each class
confMat(end+1,:) = [recall_final{1,:}];
% precision in final column
confMat(end+1,:) = [precision_final{1,:}];
% ignore APcalc
% confMat(end+1,:) = [AP{1,:}]; 
% F1 and F2 scores
confMat(end+1,:) = [F1{1,:}];
confMat(end+1,:) = [F2{1,:}];

% % precision in final column
% confMat(:,end+1) = [precision_final{1,:} NaN NaN NaN NaN]'


    

% % create a table that can be exported with images to get statistical values
% stats = [recall_BIK, recall_CRO, recall_PDU, recall_PDC, recall_allf;...
%     precision_BIK, precision_CRO, precision_PDU, precision_PDC, precision_allf];
% statsVars = {'BIK', 'CRO', 'PDU', 'PDC', 'All'}; 
% stats = [[recall_final{1,:}]; [precision_final{1,:}]];
% statsVars = classes; 
% statsVars{end+1} = 'All';
% statRowNames = {'Recall', 'Precision'};
% 
% statsTable = array2table(stats,'VariableNames',statsVars, 'RowNames', statRowNames);
%filename too long :(
filename = [excSavePath, '\',alg,'_ep', epoches, '_clas', numClasses, data, '', '_th', threshtxt, '_IoU', IoUtxt, 'v', version,'.xlsx'];
% writetable(statsTable,filename,'Sheet',1,'Range','D1','WriteRowNames', true);

confMatCols = classes;
confMatCols{end+1} = 'Cumulative';
% confMatCols{end+1} = 'FP';
% confMatCols{end+1} = 'Precision';
confRowNames = classes;
confRowNames{end+1} = 'FN';
confRowNames{end+1} = 'FP';
confRowNames{end+1} = 'Expected # of Obj';
confRowNames{end+1} = 'Corrected TP';
confRowNames{end+1} = 'Recall';
confRowNames{end+1} = 'Precision';
% confRowNames{end+1} = 'AP';
confRowNames{end+1} = 'F1 Score';
confRowNames{end+1} = 'F2 Score';
confMatTable = array2table(confMat,'VariableNames',confMatCols,'RowNames',confRowNames);
writetable(confMatTable,filename,'Sheet',1,'Range','D5', 'WriteRowNames', true);


