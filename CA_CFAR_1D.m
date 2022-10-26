%% Applying Cell averaging CFAR technique for one dimensional CFAR window
%Function For CA-CFAR, defineRefWind by paramters: PFA; dataSize; Guard Cells, and the magnitude of signal, outputing the Threshold
% Author: Khothatso Motake
% Date 11/10/2022

function [CACFAR_1D] = CA_CFAR(PFA,  windowSize, guardCells, radarSignal) % dataSize is the total number of samples    
  

    % Perform CA-CFAR processing after the power law detector.
    signalPower = abs(radarSignal).^2; 
    % figure;plot(DataAfterPowerLawDetector(1:100));title("data after the power law detector")

    %referenceCells = (windowSize)*2; % Reference window double the data size
    referenceCells = windowSize;

    % Size of the measured input dataset
    dataLen = length(radarSignal);
    
    % Initialise the CFAR threshold CFAR with ones for the data length
    thresholdArr = zeros([1  dataLen]);


    % Defining the threshold function from lagging and leading cells
    for CUT = 1:dataLen
   % Total length = referenceWindowdow/2
        if CUT <= referenceCells/2
            g = nan;
            
        elseif(CUT < referenceCells/2 && CUT > dataLen - referenceCells)
            Reference_cells_lagging = sum(signalPower( (CUT-referenceCells/2):(CUT-guardCells))); 
            Reference_cells_leading = sum(signalPower( (CUT+guardCells):(CUT+referenceCells/2)));
            Sum_Reference_cells = Reference_cells_lagging + Reference_cells_leading;
         
        %elseif(CUT < referenceWindow/2 || CUT > dataLen - referenceWindow)
		    %thresholdArr(CUT) = 1;

         % work out the average of reference cells  
         g = Sum_Reference_cells./referenceCells;
	    
         thresholdArr(CUT) = 1;

		elseif CUT >= dataLen - referenceCells/2
            g = nan;
    % Define training cells before and after the cell under test as lagging
    % and leading reference cells
    %Reference_cells_lagging = radarSignal(CUT-dataSize-guardCells:CUT-1-guardCells);
    %Reference_cells_leading = radarSignal(CUT+1+guardCells:CUT+dataSize+guardCells);

    
    % Take the sum of on both sides of the CUT
    %Sum_Reference_cells = sum(Reference_cells_lagging)+sum(Reference_cells_leading);

    % compurte scaling factor alpha
        alpha = PFA^(-1/(referenceCells))-1;

    % Return threshold array with columns 
        thresholdArr(CUT) = g*alpha;
    
    end

     % Verifying if detection are working properly
    detectionsArr = zeros([1 length(radarSignal)]);
    NumberOfFalseAlarms=0;

    for i = 1:length(radarSignal)
        if signalPower(i) >= thresholdArr(i)
            detectionsArr(i) = signalPower(i);
            NumberOfFalseAlarms = NumberOfFalseAlarms + 1;
        end
    end
    
    % From simulated data
    PFA_simulation = NumberOfFalseAlarms/(dataLen - referenceCells);

    PFA_error = abs(((PFA - PFA_simulation)/PFA)*100) ;  
    
                       
    CACFAR_1D = detectionsArr;

% Set the return array to T_CA_CFAR function
%CACFAR_1D = thresholdArr;

end