%% Applying CA-CFAR technique to simulated 1-D and 2-D vector data for verification purposes.
% Applying CA-CFAR to each range line in the measured data. Visualise the detections by placing a black %X  over the detections found.  
% Author : Motake Edwin
% Date 18/10/2022

clear all;
close all;

% Read8ing the X-HRR raw data from CSIR
% The dataset should be in the directory specified 'D:\EEE4022S\OneDrive_2022-09-27\07 Radar datasets'
[FileName,radarDatasetPath,filter_index]=uigetfile('MultiSelect','on');
radarDataset = load([radarDatasetPath filesep FileName]);

% Extracting range profiles before, after the notch 
Range_Profiles_lagging = radarDataset.RangeLines_BeforeEq;
Range_Profiles_leading= radarDataset.RangeLines_AfterEq;
rangeProfiles= radarDataset.RangeLines_AfterEQ_Notch;

% Remove unwanted data
rangeProfiles= rangeProfiles(:, 400: end);

%% Extract other radar parameters
 PRF_Hz = radarDataset.Info.PRF_Hz;
 Bandwidth_Hz = radarDataset.Info.Bandwidth_Hz;
 RangeStart_m = radarDataset.Info.RangeStart_m;
 BlindRange_m = radarDataset.Info.BlindRange_m;
 
[NumOfPulses,NumOfRangeBins]=size(rangeProfiles);
% Apply CA-CFAR technique to simulated 2-D matrix data, to simulate a Range-Doppler map, for verification purposes.     
% Defining number of Columns & Rows

A = size(rangeProfiles,1); % rows                                         
B = size(rangeProfiles,2); % columns

%% plotting the time domain with x mark

%start bin
startBin = 400;

% window_size * 2
winSize = 18;
    
%Guard cells
guardCells = 4;

%Reference Cells length
Reference_Cell = (winSize) * 2;

%define desired Pfa
PFA = 1e-6;

%Data after Power Law 
signalMag = abs(rangeProfiles).^2;

% data set size
signalDim = size(signalMag);

% initialise the threshold array with zeros 
thresholdArr = zeros(signalDim(1),signalDim(2));

%apply the CA_CFAR function to every column 
for i = 1:signalDim(1)
	threholdArr(i,:) = CA_CFAR(signalMag(i,:), winSize, guardCells, PFA);
end

Detections_rt = double((signalMag-thresholdArr)>0);

%define PRI in hertz

PRI = 1/PRF_Hz;

%define light of speed
c = 3e8;

%convert from range bins to range (m)
range = 400*(c/(2*Bandwidth_Hz)):1*(c/(2*Bandwidth_Hz)):(NumOfRangeBins+399)*(c/(2*Bandwidth_Hz));

%convert num of pulse axis to time(s) axis
t= 0:PRI:PRI*A;

fontsize1 = 12;
clims = [-40 0];

% Normalise data to have a peak of 0dB or 1 in linear scale
[MaxRangeLine MaxIdx] = max(max(abs(rangeProfiles)));

% Plot range lines
figure; axes('fontsize',fontsize1);
imagesc(range,t,20*log10(abs(rangeProfiles)./MaxRangeLine),clims);
colorbar;
xlabel('Range(m)','fontsize',fontsize1);
ylabel('Time(s)','fontsize',fontsize1);
title('Time-Domain Detection with X mark','fontsize',fontsize1);

% plotting with 'x' on the target detected in the time domain
x_plot_time_range(Detections_rt,rangeProfiles,c,Bandwidth_Hz,PRI,startBin);

%% plotting the range doppler map with x mark
% generate Range-Doppler map(s) on the measured data and perform CA-CFAR along each the Doppler dimension
% define Win_Len
winLen = 512;                                            

% convert Win_Len to CPI
CPI_s= winLen*1/PRF_Hz;                  

count = 1+ floor((size(rangeProfiles,1)-winLen)/winLen); % taking the size of the row

% array with generated range-Doppler maps and range bins
arrayCol = zeros(count,size(rangeProfiles,2));

% take a small subset of the range profiles 
segment = rangeProfiles(start:winLen+start-1,:);

%apply hamming window function to suppress the sidelobes 
hammerWindow = repmat(hamming(winLen),1,size(segment,2));		

windowOut= segment*hammerWindow;	

segRow_fft = fft(windowOut,[],1); % FFT on the row dimension only

segCol_fft = fft(windowOut,[],2); % FFT on the column dimension only

segPower = abs(segRow_fft).^2;						% apply power law

powerDim = size(segPower); % size of the s domain values 

thresholdSeg = zeros(powerDim(1),powerDim(2));				%set threshold array

%apply to CA-CFAR function to each row and column to estimate the threshold levels
for i = 1:powerDim(1)
	threholdSeg(i,:) = CA_CFAR(signalMag(i,:), winSize, guardCells, PFA);
end

% set up the frequency axis
% fs = 

%% Combine the detections from the time-domain and the Range-Doppler map to improve detection performance
winLen_td = 525;
CoherentProcessingInterval_s_td = winLen_td*1/PRF_Hz; 
start_td = 1;


					

% x-mark alignment in the time domain
function x_plot_time_range(detectionArray, dt_Arr, c, bandwidth, PRI, start_bin)

A = size(dt_Arr,1);                                         
B = size(dt_Arr,2);

for m = 1:A   
    for n = start_bin:B+start_bin-1   
       if detectionArray(m,n-start_bin+1) > 0
            text(n*(c/(2*bandwidth)),m*PRI,'X');
        end
    end
end

end

% x-mark alignment in the frequency range domain
function x_plot_range_doppler(detectionArray, dt_Arr, c, bandwidth, PRF, Win_Len,start_bin)
X = size(dt_Arr,1);                                         
Y = size(dt_Arr,2);

for x = 1:X   
    for y = 1:Y   
       if detectionArray(x,y) > 0
            text((y+start_bin-1)*(c/(2*bandwidth)),(x-(Win_Len/2)-1)*(PRF/Win_Len),'X');
        end
    end
end

end

% Combine the detections from the time-domain and the Range-Doppler map
function detectionsCombined_plot(detection_arr, count, start_td, hop_length_td,start_bin,c,bandwidth,PRF)

% iterate throough each rows of combined detection domains 
for r = 1:count             
    for e = 1:size(detection_arr,2)             
        if detection_arr(r,e)>0
            plot((e+start_bin-1)*(c/(2*bandwidth)),(start_td:start_td + hop_length_td - 1)*(1/PRF),'kx','MarkerSize',12); %plots the full CPI column corresponding to range bins
        end
    end
    start_td = start_td + hop_length_td;
end

end


