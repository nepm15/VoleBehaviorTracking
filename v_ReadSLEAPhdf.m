function [Tracks,NodeNames,InstScores] = v_ReadSLEAPhdf(FileName)
%
% [Tracks,NodeNames,TrackOccup] = v_ReadSLEAPhdf(FileName)
%
% Loads hdf file from SLEAP. Based on:
% https://sleap.ai/api/sleap.io.convert.html#module-sleap.io.convert
%
% USAGE
%   - FileName: a string (e.g., 'labels.v001.000_raw_video.analysis.h5')
%
% OUTPUT
%   - Tracks:     4D matrix: frames * nodes * XY coordinates * animals
%   - NodeNames:  cell array with node names
%
% Noah Milman and Lezio Bueno Jr (2023)

%%
Tracks     = h5read(FileName,'/tracks');
NodeNames  = h5read(FileName,'/node_names');
InstScores = h5read(FileName,'/instance_scores');

end
