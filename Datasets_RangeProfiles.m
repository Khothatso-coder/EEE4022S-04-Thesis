% Applying CA-CFAR to each range line in the measured data. Visualise the detections by placing a black %X  over the detections found.  
% Author : Motake Edwin
% Date 18/10/2022

clear all;
clc;
close all;

% Reading the X-HRR raw data from CSIR
% The dataset should be in the directory specified 'D:\EEE4022S\OneDrive_2022-09-27\07 Radar datasets'
[FileName,radarDatasetPath,filter_index]=uigetfile('MultiSelect','on');
radarDataset = load([radarDatasetPath filesep FileName]);

% Extracting range profiles before, after the notch 
Range_Profiles_lagging = radarDataset.RangeLines_BeforeEq;
Range_Profiles_leading= radarDataset.RangeLines_AfterEq;
rangeProfiles= radarDataset.RangeLines_AfterEQ_Notch;

% Remove unwanted data
rangeProfiles= rangeProfiles(:, 400: end);

%% Extract critical radar parameters
 PRF_Hz = radarDataset.Info.PRF_Hz;
 Bandwidth_Hz = radarDataset.Info.Bandwidth_Hz;
 RangeStart_m = radarDataset.Info.RangeStart_m;
 BlindRange_m = radarDataset.Info.BlindRange_m;
 
[NumOfPulses,NumOfRangeBins]=size(rangeProfiles); %

%% Observing range profiles
% Plot settings
fontsize = 12;
clims=[-40 0];

% Normalise data to have a peak of 0dB or 1 in linear scale
[MaxRangeLine MaxIdx] = max(max(abs(rangeProfiles)));

% Plotting range lines
figure; axes('fontsize',fontsize);
imagesc(20*log10(abs(rangeProfiles)./MaxRangeLine),clims);
colorbar;
xlabel('Range (bins)','fontsize',fontsize);
ylabel('Number of pulses','fontsize',fontsize);
title('Range lines for three humans','fontsize',fontsize);
