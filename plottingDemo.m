%% Plotting functions
%This program plots rangle profiles placing an X aligned with
%the position of the target detected in 1 dimensional
% Author: Khothatso Motake
% Date 11/10/2022

%parameters
%Probability of false alarm
PFA = 1e-6;

%Window size
windowSize = 12;

% number of guard cells
guardCells = 2;

% Getting the size of rangeprofiles from Datasets_RangeProfiles.m
dataSize = size(rangeProfiles);
Rows = size(rangeProfiles,1); % rows
NumOfRows = dataSize(1);

Columns = size(rangeProfiles,2); % columns
NumOfColumns = dataSize(2);
dataSize = NumOfColumns;

targetsArr = [];

for i = 1:1:NumOfRows;    
    rangeProfileArray = rangeProfiles(i,:);
    
    targetsArr = [targetsArr; CA_CFAR_1D(PFA,guardCells, dataSize, rangeProfileArray)];
end

% Plot Range Profiles
fontsize1 = 12;
clims = [-40 0];

% Normalise the data
[MaxRangeLine MaxIdx] = max(max(abs(rangeProfiles)));

% Plot range lines
figure; axes('fontsize',fontsize1);
imagesc(20*log10(abs(rangeProfiles)./MaxRangeLine),clims);
colorbar;
xlabel('Range (bins)','fontsize',fontsize1);
ylabel('Range bins','fontsize',fontsize1);
title('Range profiles','fontsize',fontsize1);
hold on

% Aligning x marks on the plot
for i = 1:1:NumOfRows;
    for j = 1:1:NumOfColumns;
        if targetsArr(i,j) > 0;
            text(j,i,'x');
        end
    end
end
hold off


