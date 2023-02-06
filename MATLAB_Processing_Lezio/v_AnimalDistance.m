function AnimalDist = v_AnimalDistance(TestCoords,RefCoords)
%
% AnimalDist = v_AnimalDistance(TestCoords,RefCoords)
%
% Distance between two animals or between an animal and a fixed point in
% space, e.g., a fixed object, a corner, the center of the cage. The user
% is responsible for the spatial units, e.g., pixels, centimers.
%
% Do not use this function if the fixed spatial reference has a length,
% e.g., a home-cage divider.
%
% USAGE
%   - TestCoords: frames * XY coordinates (i.e., two column array).
%   - RefCoords:  two options
%                 1. Frames * XY coordinates (i.e., two column array).
%                    Applicable for distance between two animals. Number
%                    of frames must be the same as TestCoords.
%                 2. Single XY coordinate, e.g., [15 20].
%                    Use this if the reference is a fixed point in space.
%
% OUTPUT
%   - AnimalDist: vector, same length as TestCoords.
%
% Bueno-Junior et al. (2023)

%% 
if size(RefCoords,1) == 1 % If fixed spatial reference
    RefCoords = repmat(RefCoords,size(TestCoords,1),1);
end

CoordDiff  = abs(diff(cat(3,TestCoords,RefCoords),1,3));
AnimalDist = hypot(CoordDiff(:,1),CoordDiff(:,2));

end