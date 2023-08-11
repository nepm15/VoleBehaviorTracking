%% Read in sample output using various outputs

% Noah Milman and Lezio Bueno-Junior (2023)

%% Step1 read in video metadata:
FileName = '/Users/milma/Documents/OHSU/SHARP/Voles/SLEAP_scoring/sample_videos/converted__11_28_22_1_male_cropped.mp4';
[FrameRate,WidthHeight] = v_GetVideoMetadata(FileName);

%% Step2 read in SLEAP h5 output file
hdFileName = '/Users/milma/Documents/OHSU/SHARP/Voles/SLEAP_scoring/11_28_22_test/output/labels.v005_post_training8a_ID_corrected.000_11_28_22_1_male_cropped.analysis.h5';
[Tracks,NodeNames,InstScores] = v_ReadSLEAPhdf(hdFileName);

%% Step3 convert to table format
CoordTable = v_TableFromSLEAP(Tracks,InstScores);
