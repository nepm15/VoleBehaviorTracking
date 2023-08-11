function [CumulMap,HeightBins,WidthBins] = v_CumulativeMap(...
    AnimalPos,BehavVar,Params,varargin)
%
% [CumulMap,HeightBins,WidthBins] = v_CumulativeMap(AnimalPos,BehavVar,Params,varargin)
%
% Cumulative spatial map of a behavioral variable.
%
% EXPLANATION: A cell array (image height * image width) is created.
% For each video frame, the XY coordinates of a given cell are identified
% based on the position of the animal. The cell is then populated with
% the behavioral data (e.g., speed) from that frame. This is repeated
% across frames, thus populating the cell array in a cumulative manner.
% Data in each cell are finally averaged, resulting in the map.
%
% USAGE
%   - AnimalPos: two-column array, frames * XY coordinates.
%   - BehavVar:  single-column vector (length = number of frames)
%                containing behavioral measures, e.g., speed. The user is
%                responsible for the unit of measurement.
%   - Params: a parameter structure
%       -.HeightLims and WidthLims: assign each of these with a
%         pair of spatial limits, e.g., [5 15]. Can be in pixels, cm, etc.
%       -.BinSize: single spatial value to divide the map, e.g., 0.1.
%         The smaller the value, the more granular the map.
%
% OUTPUTS
%   - CumulMap:  matrix (image height * image width). Can be visualized
%                with imagesc.
%   - HeightBins and WidthBins (optional): axes for plotting.
%
% Bueno-Junior et al. (2023)

%% Spatial bins
if nargin == 2 % If Params are absent,...
    
    % ... divide raw height and raw width into arbitrary number of bins
    HeightBins  = linspace(...
        floor(min(AnimalPos(:,2))),ceil(max(AnimalPos(:,2))),100);
    WidthBins   = linspace(...
        floor(min(AnimalPos(:,1))),ceil(max(AnimalPos(:,1))),100);
    
else % If Params are present,...
    
     % ... check structure,...
     HeightLims = Params.HeightLims;
     WidthLims  = Params.WidthLims;
     BinSize    = Params.BinSize;
     
     % ... divide the region of interest into user-defined bins
     HeightBins = HeightLims(1)+BinSize:BinSize:HeightLims(2);
     WidthBins  = WidthLims(1)+BinSize:BinSize:WidthLims(2);
     if isempty(HeightBins) || isempty(WidthBins)
         error('Bin size exceeds image limits')
     end
end



%% Populate spatial bins
NumSeconds = size(AnimalPos,1);
CumulMap   = num2cell(nan(numel(HeightBins),numel(WidthBins)));
for SecIdx = 1:NumSeconds
    
    
    if (... % If within region of interest,...
            AnimalPos(SecIdx,2) > HeightBins(1) && ...
            AnimalPos(SecIdx,2) < HeightBins(end)) && (...
            AnimalPos(SecIdx,1) > WidthBins(1) && ...
            AnimalPos(SecIdx,1) < WidthBins(end))
        
        % ... find animal position...
        [~,NearestY] = min(abs(HeightBins-AnimalPos(SecIdx,2)));
        [~,NearestX] = min(abs(WidthBins-AnimalPos(SecIdx,1)));
        
        % ... and populate position with the behavioral measure
        CumulMap{NearestY,NearestX} = vertcat(...
            CumulMap{NearestY,NearestX},BehavVar(SecIdx));
    end
end



%% Average within each cell
for PixelIdx = 1:numel(CumulMap)
    
    CumulMap{PixelIdx} = mean(CumulMap{PixelIdx},'omitnan');
end



%% Construct the map (replace NaNs by zeros)
CumulMap = cell2mat(CumulMap);
CumulMap(isnan(CumulMap)) = 0;

end