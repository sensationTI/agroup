% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

clear;
Directory = ['\\cmht-fs.mcmaster.ca\data\projects\2036 - '...
    'Infrared Camera - Ben Miethig\Final Training Data\All_Combined\Test'];
ImageDirectory = '\All_Combined\Test';
labellingSessionLabels = '\testLabels.mat';
load([Directory, labellingSessionLabels])

% create a list of all classes:
classes = testLabelData.Properties.VariableNames;

% Parse through each image:
for k = 1: height(testLabelData)  
    % create base name for XML document
    % First, create the DOM node object and root element, and populate the
    % elements and the attributes of the node corresponding to the XML data.
    docNode = com.mathworks.xml.XMLUtils.createDocument('annotation');
    
    % Identify the root element, and set the version attribute.
    annotation = docNode.getDocumentElement;
    annotation.setAttribute('version','2.0');
    
    % note that none of the below will change for the FLIR A65 camera we use.
    % These apply to all images
    % Create the corresponding field that we need for annotation
    folder = docNode.createElement('folder');
    filename = docNode.createElement('filename');
    segmented = docNode.createElement('segmented');
    size = docNode.createElement('size');
    width = docNode.createElement('width');
    height = docNode.createElement('height');
    depth = docNode.createElement('depth');
    
    % iterate through the table and get file names
    imageName = testLabelData{k,1}{1};
    
    % Must figure out how to just get filename and folder from the gTruth
    % object: gTruth.DataSource.Source
    % Each element in this file has a child text node.
    % name of the folder in the XML file
    folder.appendChild(docNode.createTextNode([ImageDirectory, '\XML_Labels']));
    % name of the image in the XML file
    filename.appendChild(docNode.createTextNode(imageName));
    segmented.appendChild(docNode.createTextNode('0'));
    % size of the frame
    width.appendChild(docNode.createTextNode('875'));
    height.appendChild(docNode.createTextNode('700'));
    depth.appendChild(docNode.createTextNode('3'));
    
    % ensure elements get appended to the right level of annotation
    % append folder, filename, size, and segmented under annotation
    annotation.appendChild(folder);
    annotation.appendChild(filename);
    annotation.appendChild(segmented);
    annotation.appendChild(size);
    % append width, height, and depth under size
    size.appendChild(width);
    size.appendChild(height);
    size.appendChild(depth);
    
    % add object element. This will include the objects in the image and their
    % class, pose, truncated, difficult, and bounding box (which will include
    % the minimum and maximum x and y based on the bounding boxes we have drawn
    
    
    % must figure out how matlab saves the bounding boxes to specific classes
    % in the ADAS toolbox
    % ADAS Labeler saves the bounding boxes and associated images in two
    % different areas of the gTruth object derived from the "export labels"
    % saving option in groundTruthLabeler. The file names are saved in
    % "gTruth.DataSource.Source" and the bounding boxes and associated classes
    % are saved in "gTruth.LabelData" as a 2x2 time table
    % To access specific class bounding boxes (for the nth image):
    % gTruth.LabelData(n, 'classname').classname
    % example: for the 1st image's Ped data: (see 3ped1carLabels.mat file)
    % filename = gTruth.DataSource.Source(1)
    % BoundingBoxes = gTruth.LabelData(1, 'Ped').Ped{1}
    % Bounding boxes come in the form of: [column(xmin), row(ymin), width,
    % height].
    
    % iterate through every ckasses
    for j = 2:length(classes)
        table = testLabelData(k, classes{j});
        boundingBoxes = table{1,1}{1};
        % if there is a bounding box
        if ~isempty(boundingBoxes)
            for m = 1:length(boundingBoxes(:,1))
                % create an object field in the XML file
                obj = docNode.createElement('object');
                class = classes{j}; 
                % create a name field under object in the XML file
                name = docNode.createElement('name');
                name.appendChild(docNode.createTextNode(class));  
                % create a pose field under object in the XML file
                pose = docNode.createElement('pose');
                % leave unspecified pose for now
                pose.appendChild(docNode.createTextNode('Unspecified'));
                % create a truncated field under object in the XML file
                truncated = docNode.createElement('truncated');
                truncated.appendChild(docNode.createTextNode('0'));
                % create a difficult field under object in the XML file
                difficult = docNode.createElement('difficult');
                difficult.appendChild(docNode.createTextNode('0'));  
                % append each field to the correct location
                % name, pose, truncated, and difficult all go under object
                obj.appendChild(name);
                obj.appendChild(pose);
                obj.appendChild(truncated);
                obj.appendChild(difficult);     
                thisBondingBox = boundingBoxes(m,:);
                % create a bounding box filed
                box = docNode.createElement('bndbox');
                % add coordiantes of the bounding box
                % xmin - 
                % xmax - 
                % ymin - 
                % ymax - 
                xmin = docNode.createElement('xmin');
                % get the value
                xminbb = thisBondingBox(1);
                % write the value above into the XML file
                xmin.appendChild(docNode.createTextNode(num2str(xminbb)));
                ymin = docNode.createElement('ymin');
                yminbb = thisBondingBox(2);
                ymin.appendChild(docNode.createTextNode(num2str(yminbb)));
                xmax = docNode.createElement('xmax');
                xmaxbb = thisBondingBox(1) + thisBondingBox(3);
                xmax.appendChild(docNode.createTextNode(num2str(xmaxbb)));
                ymax = docNode.createElement('ymax');
                ymaxbb = thisBondingBox(2) + thisBondingBox(4);
                ymax.appendChild(docNode.createTextNode(num2str(ymaxbb)));
                
                % append to the corrent location
                % The hierarchy is: obj under annotation, xmin, xmax, ymin,
                % and ymax all under box. box under obj
                obj.appendChild(box);
                box.appendChild(xmin);
                box.appendChild(ymin);
                box.appendChild(xmax);
                box.appendChild(ymax);
                annotation.appendChild(obj);
            end
        end
    end
    
    % use char() to convert a cell to string
    imageName = strsplit(imageName, '.');
    % decalre the path and filename of .xml files
    xmlFileName = [Directory, '\XML_Labels\', char(imageName(1)),'.xml'];
    % writes the xml file
    xmlwrite(xmlFileName,docNode);
end
