% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

filepath = 'C:\Users\pc\Desktop\';
filename = 'testwinter1v1TempRange-88to-03FifthOfFrames';
extension = '.avi';

% v = VideoReader(filename) creates object v to read video data from the 
% file named filename.
video = VideoReader([filepath, filename, extension]);
% CurrentTime - property of the VideoReader object, timestamp of video to
% read
video.CurrentTime = 0;
% The current frame number
k = 0;

while hasFrame(video)
    % readFrame(v) reads the next available video frame from the file 
    % associated with v.
    % I = mat2gray(A,[amin amax]) converts the matrix A to an intensity 
    % image I that contains values in the range 0 (black) to 1 (white). 
    % amin and amax are the values in A that correspond to 0 and 1 in I. 
    % Values less than amin become 0, and values greater than amax become 1
    % I = mat2gray(A) sets the values of amin and amax to the minimum and 
    % maximum values in A
    image = mat2gray(readFrame(video));
    imwrite(image, ['C:\Users\pc\Desktop\frame data\Nighttime_Nov15_Snowy_-1C_', num2str(k), '.jpg']);
    k = k + 1;       
end
    