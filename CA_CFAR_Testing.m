%% CA-CFAR detection demo
% testing the code with optimised parameters
% Author: Khothatso Motake
% Date 11/10/2022

% Input variables 

%parameters
%Probability of false alarm
PFA = 10^-4;

%Window size
windowSize = 32;

% number of guard cells
guardCells = 2;

referenceCells = windowSize;

% Trimming or limiting the dataset
signal = rangeProfiles(5000,:);

dataSize = length(signal);

t=1:1:dataSize;


%threshold = CA_CFAR_1D(PFA, guardCells, referenceCells, signal);  %getting threshold values

signalPower = abs(signal).^2; % data after signal power
CA_threshold  = zeros([1  dataSize]); 

% Apply the CA_CFAR detection for 1 dimensional window
for CUT = 1: dataSize
    if CUT <= windowSize/2
        g = nan;
        
    elseif CUT > windowSize/2 && CUT < dataSize - windowSize/2
       Reference_cells_lagging = sum(signalPower( (CUT-windowSize/2):(CUT-guardCells/2))); 
       Reference_cells_leading = sum(signalPower( (CUT+guardCells/2):(CUT+windowSize/2))); 
       g = (Reference_cells_lagging + Reference_cells_leading);
       
    elseif CUT >= dataSize - windowSize/2
        g = nan;
       
    else
        print('error')
    end
            
    alpha = PFA^(-1/windowSize)-1; %scaling factor
    
    CA_threshold(CUT) = alpha*g;  %threshold value
end


% data set size
Dimensions = size(signalPower);

% initialise the threshold array with zeros 
thresholdArr = zeros(Dimensions(1),Dimensions(2));

%apply the CA_CFAR function to every column 
for i = 1:Dimensions(1)
	threholdArr(i,:) = CA_CFAR_1D(PFA,guardCells,referenceCells, signalPower(i,:));
end

fig2 = figure(2);
plot(t, signalPower)
hold on
plot(t, CA_threshold)
legend('Signal' , 'Threshold');
xlabel('Bins');ylabel('Squared Signal Magnitude');
title('Time domain Signal Power and Threshold vs number of bins')
hold off