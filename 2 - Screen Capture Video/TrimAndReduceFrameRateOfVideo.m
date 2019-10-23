% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

filePath = 'C:\Users\pc\Desktop\';
fileName = 'testwinter2v1TempRangeVaryingCropped';
extension = '.avi';

% v = VideoReader(filename) creates object v to read video data from the 
% file named filename.
video = VideoReader([filePath, fileName, extension]);

% CurrentTime - property of the VideoReader object, timestamp of video to
% read
% Starting from the 4th frame
video.CurrentTime = 4 / video.FrameRate;
trimmedVideo = VideoWriter([filePath, fileName, 'FifthOfFrames.avi']); 
open(trimmedVideo)

while hasFrame(video)
    try
        % I = mat2gray(A,[amin amax]) converts the matrix A to an intensity 
        % image I that contains values in the range 0 (black) to 1 (white). 
        % amin and amax are the values in A that correspond to 0 and 1 in I. 
        % Values less than amin become 0, and values greater than amax become 1
        % I = mat2gray(A) sets the values of amin and amax to the minimum and 
        % maximum values in A
        img = mat2gray(readFrame(video));
        writeVideo(trimmedVideo,img); 
        % read every 5 frames
        video.CurrentTime = video.CurrentTime + 4 / video.FrameRate;
    catch
        close(trimmedVideo)
    end
end
close(trimmedVideo)
    