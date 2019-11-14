function [IoUdetected, IoUdetectedWithConfidence] = openCSV(fileName, pathName, classes)


% this takes a csv file produced from the yolov2 algorithm and puts all
% results into a table that can be used with IoU_calc.m

% open csv file
detections = openRawCSV([pathName, '\', fileName]);

%erase top row
detections(1,:) = [];



% bbox = cell(1,length(classes));
bbox = cell(1,length(classes)+1);
bboxAndConf= cell(1,length(classes)+1);

for k = 1:size(detections, 1)
    % split topleft coordinates into x and y values
    splitTL = regexp(detections.topleft(k),'\,','split');
    
    %x-value:
    splitTL2 = regexp(splitTL{1}, '\:', 'split');
    TLx = str2num(splitTL2{2});
    %y-value
    splitTL3 = regexp(splitTL{2}, '\:', 'split');
    splitTL3 = regexp(splitTL3{2}, '\}', 'split');
    TLy = str2num(splitTL3{1});
    
    %split bottomright coordinates into x and y values
    splitBR = regexp(detections.bottomright(k),'\,','split');
    
    %x-value:
    splitBR2 = regexp(splitBR{1}, '\:', 'split');
    BRx = str2num(splitBR2{2});
    %y-value
    splitBR3 = regexp(splitBR{2}, '\:', 'split');
    splitBR3 = regexp(splitBR3{2}, '\}', 'split');
    BRy = str2num(splitBR3{1});
    
    % need to know which class the label falls into via "index"
    [maximum, index] = max(detections.label(k)==classes);
    
%     bbox{index} = [bbox{index}; TLx, TLy, BRx-TLx, BRy-TLy];
%     bbox{index+1} = [bbox{index+1}; TLx, TLy, BRx-TLx, BRy-TLy];
%     commented out of original OpenCSV_fixed
    bbox{index+1} = [bbox{index+1}; TLx, TLy, BRx-TLx, BRy-TLy];
    bboxAndConf{index+1} = [bboxAndConf{index+1}; TLx, TLy, BRx-TLx, BRy-TLy, detections.confidence(k)];
end

bbox{1} = [fileName(1:end-3), 'jpg'];
bboxAndConf{1} = [fileName(1:end-3), 'jpg'];
% Create final comparison table
%initialize table for checking if detections match
IoUdetected = cell2table(bbox,'VariableNames', ['imageFilename', classes]);
% IoUdetected = cell2table(bbox,'VariableNames', classes);
IoUdetectedWithConfidence = cell2table(bboxAndConf,'VariableNames', ['imageFilename', classes]);

end

