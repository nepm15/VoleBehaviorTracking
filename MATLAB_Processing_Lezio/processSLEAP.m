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

% basic methods: distance btw animals, animal velocity.
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
