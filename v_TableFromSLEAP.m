function CoordTable = v_TableFromSLEAP(Tracks,InstScores)
%
% CoordTable = v_TableFromSLEAP(Tracks,InstScores)
%
% Re-organizes SLEAP matrix into a table.
%
% USAGE
%   - Tracks:     4D matrix: frames * nodes * XY coordinates * animals
%                 See v_ReadSLEAPhdf.m
%   - InstScores: frames * instance scores.
%                 See v_ReadSLEAPhdf.m
%
% OUTPUT
%   - CoordTable: three-column table (height = number of frames).
%                 Column 1: data (each cell = node * XY coordinate).
%                 Column 2: track IDs.
%                 Column 3: instance scores per track ID.
%
% Noah Milman and Lezio Bueno Jr (2023)

%%
CoordTable = cell(size(Tracks,1),2);
Progress = 0;
fprintf(1,'Constructing table from SLEAP: %1d%%\n',Progress);
for FrameIdx = 1:size(Tracks,1)
    
    Progress = 100*(FrameIdx/size(Tracks,1));
    fprintf(1,'\b\b\b\b%3.0f%%',Progress)
    
    ReshFrame = Tracks(FrameIdx,:,:,:);
    ReshFrame = permute(ReshFrame,[2 3 4 1]);
    
    WhereTrack = logical(permute(sum(sum(~isnan(ReshFrame),1),2),[3 2 1]));
    CoordTable{FrameIdx,1} = ReshFrame(:,:,WhereTrack);
    CoordTable{FrameIdx,2} = find(WhereTrack);
    CoordTable{FrameIdx,3} = InstScores(FrameIdx,WhereTrack);
end
fprintf('\n')
CoordTable = cell2table(CoordTable,'VariableNames',...
    {'XYcoords','TrackIDs','InstScores'});

end
