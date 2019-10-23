% Author: Benjamin Miethig
% McMaster University, Dept. of Mechanical Engineering
% Email address: miethibt@mcmaster.ca  
% August 2019; Last revision: 24-Sep-2019
% Commented and modified by: Jiahong Dong

filepath = 'C:\Users\pc\Desktop\';
filename = 'testwinter2v1TempRangeVarying';
extension = '.mp4';

% v = VideoReader(filename) creates object v to read video data from the 
% file named filename.
video = VideoReader([filepath, filename, extension]);

% v = VideoWriter(filename) creates a VideoWriter object to write video 
% data to an AVI file with Motion JPEG compression.
croppedVideo = VideoWriter([filepath, strcat(filename, 'Cropped'), '.avi']);
croppedVideo.FrameRate = video.FrameRate;

% Start cropping the target video at 4 sec.
startTime = 4;
video.currentTime = startTime;
open(croppedVideo);

% writeVideo(v,frame) - writes one or more movie frames typically returned 
% by the getframe function.
% hasFrame(v) - returns logical 1 (true) if there is a video frame available
% to read from the file. Otherwise, it returns logical 0 (false).
while hasFrame(video)
    frame = readFrame(video);
    % adjust the height and width of the video
    % first input to frame is the height and second is the width
    croppedFrame = frame([85:784],[231:1105]);
    writeVideo(croppedVideo, croppedFrame);
end

close(croppedVideo);