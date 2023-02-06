function LocomSpeed = v_LocomSpeed(InCoords)
%
% LocomSpeed = v_LocomSpeed(InCoords)
%
% Locomotion speed: hypotenuse of the XY coordinate differences between
% adjacens frames. The user is responsible for the units, e.g.,
% pixels/frame, centimers/frame, pixels/sec, centimeters/sec.
%
% USAGE
%   - InCoords: frames * XY coordinates (i.e., two column array).
%
% OUTPUT
%   - LocomSpeed: vector, same length as InCoords.
%
% Bueno-Junior et al. (2023)

%%
CoordDiff  = diff(InCoords);
LocomSpeed = [0;hypot(CoordDiff(:,1),CoordDiff(:,2))];

end