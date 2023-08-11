function [FrameRate,WidthHeight] = v_GetVideoMetadata(FileName)
%
% VideoMetadata = v_GetVideoMetadata(FileName)
%
% Frame rate and dimensions (in pixels) of video.
%
% USAGE
%   - FileName: a string (e.g., 'raw_video.mp4')
%
% OUTPUT
%   - FrameRate:   in Hz, e.g., 20
%   - WidthHeight: in pixels, e.g., [800 896]
%
% Noah Milman and Lezio Bueno-Junior (2023)

%%
VidObj      = VideoReader(FileName);
FrameRate   = VidObj.FrameRate;
WidthHeight = [VidObj.Width VidObj.Height];

end
