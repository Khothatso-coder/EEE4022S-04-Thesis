%% CA-CFAR detection demo
% testing the code with optimised parameters
% Author: Khothatso Motake
% Date 11/10/2022

% Input variables 

%parameters
%Probability of false alarm
PFA = 1e-6;

%Window size
windowSize = 12;

% number of guard cells
guardCells = 2;

referenceCells = windowSize;


signal = RangeProfiles_AfterEqNotch(5000,:);

dataSize = length(signal);
threshold = CA_CFAR_1D(PFA, guardCells, dataSize, signal);
t = 1:1:length(signal);

DataAfterPowerLawDetector = abs(signal).^2; %realising signal power

TCA  = zeros([1  length(signal)]);  %initialise an array for threshold values

fig4 = figure(4);
ax4 = axes('Parent', fig4);
plot(ax4, t, DataAfterPowerLawDetector)
title('Signal Power and Threshold vs Bin')
hold on
plot(ax4, t, TCA)
legend('Signal' , 'Threshold');
xlabel('Bin');
ylabel('Power');
hold off
