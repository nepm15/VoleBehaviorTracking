%% Read in sample output using various outputs

% Noah Milman and Lezio Bueno-Junior (2023)

%% Step1 read in video metadata:
FileName = '/Users/milma/Documents/OHSU/SHARP/Voles/SLEAP_scoring/11_28_22_1_male_cropped.mp4';
[FrameRate,WidthHeight] = v_GetVideoMetadata(FileName);

%% Step2 read in SLEAP h5 output file
hdFileName = '/Users/milma/Documents/OHSU/SHARP/Voles/SLEAP_scoring/11_28_22_test/output/labels.v005_post_training8a_ID_corrected.000_11_28_22_1_male_cropped.analysis.h5';
[Tracks,NodeNames,InstScores] = v_ReadSLEAPhdf(hdFileName);

%% Step3 convert to table format
CoordTable = v_TableFromSLEAP(Tracks,InstScores);

%% Analyze the dataset

% get coordinates of each node from animal/track across time
% find index of node of interest

% nose_idx = find(contains('nose',NodeNames));
% L_ear_idx = find(NodeNames == 'L_ear');
% R_ear_idx = find(NodeNames == 'R_ear');
% A_back_idx = find(NodeNames == 'A_back');
% P_back_idx = find(NodeNames == 'P_back');
% shoulder_idx = find(NodeNames == 'shoulder');
% tail_idx = find(NodeNames == 'tail_base');

% verify your track ids match what you're looking for 
% find frames where instance/animal are found (and exclude missing idx) 
% convert trackIDs to a searchable array
trackIDs_mat = table2array(CoordTable(:,2));

for i = 1:length(trackIDs_mat)
    % only care about indices where we can find both/ two animals
    if length(trackIDs_mat{i,1}) > 1
        trackA(i) = trackIDs_mat{i,1}(1,1);
        trackB(i) = trackIDs_mat{i,1}(2,1);
    end
end

% grab the exact frames that each track contains .
% THIS WILL ONLY WORK IF THEY'RE sorted upstream in SLEAP. confirm that
% they are ordered
% track1_idx = find(contains(string(cell2mat(CoordTable.TrackIDs(:))), "1"));
% track2_idx = find(contains(string(cell2mat(CoordTable.TrackIDs(:))), "2"));
track1_idx = find(trackA == 1);
track2_idx = find(trackB == 2);

% find overlap of both instances found (this should be indentical for now)
% because we only looked at frames with two animals
%track1_track2_idx = intersect(track1_idx, track2_idx);

% population % of frames that the instance was found
track1_found = length(track1_idx) / size(CoordTable,1) * 100;
track2_found = length(track2_idx) / size(CoordTable,1) * 100;
%track1_track2_found = length(track1_track2_idx) / size(CoordTable,1) * 100;

% CoordTable.XYCoord{Frame, 1}(Node, X (1) or Y (2), TrackID)
% ex. coordinates of each node across time for one animal

for i = track1_idx
    nose1(i,:) = CoordTable.XYcoords{i,1}(1,:,1);
    Lear1(i,:) = CoordTable.XYcoords{i,1}(2,:,1);
    Rear1(i,:) = CoordTable.XYcoords{i,1}(3,:,1);
    Aback1(i,:) = CoordTable.XYcoords{i,1}(4,:,1);
    Pback1(i,:) = CoordTable.XYcoords{i,1}(5,:,1);
    shoulder1(i,:) = CoordTable.XYcoords{i,1}(6,:,1);
    tailbase1(i,:) = CoordTable.XYcoords{i,1}(7,:,1);
end

% next animal
for i = track2_idx
    nose2(i,:) = CoordTable.XYcoords{i,1}(1,:,2);
    Lear2(i,:) = CoordTable.XYcoords{i,1}(2,:,2);
    Rear2(i,:) = CoordTable.XYcoords{i,1}(3,:,2);
    Aback2(i,:) = CoordTable.XYcoords{i,1}(4,:,2);
    Pback2(i,:) = CoordTable.XYcoords{i,1}(5,:,2);
    shoulder2(i,:) = CoordTable.XYcoords{i,1}(6,:,2);
    tailbase2(i,:) = CoordTable.XYcoords{i,1}(7,:,2);
end

% plot location of nose during whole video:
figure();
plot(nose1(:,1), nose1(:,2), 'x');
hold on;
plot(nose2(:,1), nose2(:,2), 'o', 'Color', 'r');

% plot location of tailbase during whole video:
figure();
plot(tailbase1(:,1), tailbase1(:,2), 'x');
hold on;
plot(tailbase2(:,1), tailbase2(:,2), 'o', 'Color', 'r');

% basic methods: distance btw animals, animal velocity.
% distance between noses
for n = 1:length(nose1)
    vole_distance_btw_nose_px(n) = sqrt((nose2(n,1) - nose1(n,1))^2 + (nose2(n,2) - nose1(n,2))^2);
end

% plot distance between across time
figure();
scatter(1:length(nose2), vole_distance_btw_nose_px);

% velocity
% https://www.mathworks.com/matlabcentral/answers/385326-calculate-velocity-from-position-and-time
% use num frames and frame rate to determine distance traveled
% use anterior back to track distance
% we dont quite know what the scale of the video is (to be determined) but
% lets pretend 10000 pixels are 1 mm...
scale = 1/10000; % mm / pixel
% find distance between frames for animal 1
for a = 1:length(track1_idx) - 1 
    idx1 = track1_idx(a);
    idx2 = track1_idx(a+1);
    dist_btw_frame(a) = sqrt((Aback1(idx2,1) - Aback1(idx1,1))^2 + (Aback1(idx2,2) - Aback1(idx1,2))^2);
    animal1_velocity(a) = dist_btw_frame(a) * FrameRate * scale; % pixel/frame * frame/second * millimeter/ pixel
end

% average velocity of animalA
figure(); 
plot(animal1_velocity);
xlabel('Frame');
ylabel('mm per second');


% heat map of each animal
% from soares et al:
% Finally, using data in 1 s bins, we created spatial maps depicting both area occupancy and body direction (Figure
% 4). A 100 x 100 cell array was created in Matlab to represent a 2 mm grid of the home cage quadrant 
% (quadrant dimensions: 20 x 20 cm). The cell array was cumulatively populated with body direction values across time bins, 
% according to the animal%s position at each time bin. We then averaged the values per cell, 
% which resulted in the maps. Six maps were created per individual, 
% corresponding to the light/dark periods of Days 1-3. 
% Such maps were arranged three-dimensionally, 
% and Z scored across the 3rd dimension within males or 
% females (represented by averages per group in the heatmaps of Figure 4). 
% We then averaged each map vertically to obtain body direction vs. distance to divider curves. 


%% plot skeleton of animal in 2-D space
% % connect head nodes (nose, ears, shoulder)
% head_nodes = [1,2,3,6];
% figure();
% for a = head_nodes
%     plot(CoordTable.XYcoords{733,1}(a,1,1), CoordTable.XYcoords{733,1}(a,2,1), 'b-x', 'Color', 'k') % XY-coord of animal 1
%     hold on;
% end
