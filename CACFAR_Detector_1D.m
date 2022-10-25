function CA = CACFAR(PFA, referenceCells, guardCells, dataSize, signal)
    % dataSize is total number of samples 
    % guard cells is half of what is used (either side, so GC = 1 has 2)
       
    t = 1:1:length(signal);
   
    DataAfterPowerLawDetector = abs(signal).^2; %realising signal power
    TCA  = zeros([1  length(signal)]);
    
    for CUT = 1: length(signal)
        if CUT <= referenceCells/2
            gCA = nan;
        
        elseif CUT > referenceCells/2 && CUT < length(signal) - referenceCells/2
            LaggingWindow = sum(DataAfterPowerLawDetector( (CUT-referenceCells/2):(CUT-guardCells))); 
            LeadingWindow = sum(DataAfterPowerLawDetector( (CUT+guardCells):(CUT+referenceCells/2))); 
            gCA = LaggingWindow + LeadingWindow;
       
        elseif CUT >= length(signal) - referenceCells/2
            gCA = nan; 
       
        else
            print('error')
        end
        aCA = PFA^(-1/referenceCells)-1; %this is a scaling factor
        TCA(CUT) = aCA*gCA;  %threshold value
    end
    
    %checking detections
    detections = zeros([1 length(signal)]);
    % PFA_simulation = 0;
    NumberOfFalseAlarms = 0; % Dr Abdul Gaffar

    for i = 1:length(signal)
        if DataAfterPowerLawDetector(i) >= TCA(i)
            detections(i) = DataAfterPowerLawDetector(i);
            NumberOfFalseAlarms = NumberOfFalseAlarms + 1;
        end
    end
    
    PFA_simulation = NumberOfFalseAlarms/(dataSize - referenceCells); 
    PFA_error = abs(((PFA - PFA_simulation)/PFA)*100) ;  
    
                       
    CA = detections;
    
%      fig4 = figure(4);
%      ax4 = axes('Parent', fig4);
%      plot(ax4, t, DataAfterPowerLawDetector)
%      title('Signal Power and Threshold vs Time')
%      hold on
%      plot(ax4, t, TCA)
%      legend('Signal' , 'Threshold');
%      hold off
end