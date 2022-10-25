% Input variables 

PFA = 10^-3;    %Probability of false alarm
RefWindow = 16; %total window size (is divided in 2 for leading and lagging)
guardCells = 2; %total number of guard cells (is divided in 2 for leading and lagging)(must be even number greater than 0)
referenceCells = RefWindow;


signal = RangeProfiles_AfterEqNotch(5000,:);

dataSize = length(signal);
threshold = CACFAR_Detector_1D(PFA, referenceCells, guardCells, dataSize, signal);
t = 1:1:length(signal);

DataAfterPowerLawDetector = abs(signal).^2; %realising signal power

TCA  = zeros([1  length(signal)]);  %initialise an array for threshold values

for CUT = 1: length(signal)
    if CUT <= RefWindow/2
        % Dr Abdul Gaffar: Reference window is not full of data, so cannot reliabilty perform detections for these CUTs  
        gCA = nan;  % Dr Abdul Gaffar
        
    elseif CUT > RefWindow/2 && CUT < length(signal) - RefWindow/2
       LaggingWindow = sum(DataAfterPowerLawDetector( (CUT-RefWindow/2):(CUT-guardCells/2))); 
       LeadingWindow = sum(DataAfterPowerLawDetector( (CUT+guardCells/2):(CUT+RefWindow/2))); 
       gCA = (LaggingWindow + LeadingWindow);
       
    elseif CUT >= length(signal) - RefWindow/2
       % Dr Abdul Gaffar: Reference window is not full of data, so cannot reliabilty perform detections for these CUTs
        gCA = nan;
       
    else
        print('error')
    end
            
    aCA = PFA^(-1/RefWindow)-1; %this is a scaling factor
    
    TCA(CUT) = aCA*gCA;  %threshold value
end

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
