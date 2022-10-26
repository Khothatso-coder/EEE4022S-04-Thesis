%% Applying Cell averaging CFAR technique for one dimensional CFAR window
%Function For CA-CFAR, defineRefWind by paramters: PFA; dataSize; Guard Cells, and the magnitude of signal, outputing the Threshold
% Author: Khothatso Motake
% Date 11/10/2022

function [CACFAR_1D] = CA_CFAR(PFA, guardCells, dataSize, radarSignal) % dataSize is the total number of samples    
  

    % Perform CA-CFAR processing after the power law detector.
    DataAfterPowerLawDetector = abs(radarSignal).^2; 
    % figure;plot(DataAfterPowerLawDetector(1:100));title("data after the power law detector")

    referenceWindow = (dataSize)*2; % Reference window double the data size
    
    % Size of the measured input dataset
    dataLen = length(radarSignal);
    
    % Initialise the CFAR threshold CFAR with ones for the data length
    thresholdArr = zeros([1  dataLen]);


    % Defining the threshold function from lagging and leading cells
    for CUT = 1:dataLen
   % Total length = referenceWindowdow/2
        if CUT <= referenceWindow/2
            g = nan;
            
        elseif(CUT < referenceWindow/2 || CUT > dataLen - referenceWindow)
            Reference_cells_lagging = sum(DataAfterPowerLawDetector( (CUT-referenceWindow/2):(CUT-guardCells))); 
            Reference_cells_leading = sum(DataAfterPowerLawDetector( (CUT+guardCells):(CUT+referenceWindow/2)));
            Sum_Reference_cells = Reference_cells_lagging + Reference_cells_leading;

            % work out the average of reference cells  
            g = Sum_Reference_cells./referenceWindow;
		
            thresholdArr(CUT) = 1;

		elseif CUT >= length(signal) - referenceCells/2
            g = nan;
           
        else
            print('The current cell is not found')
        end
        
    % Define training cells before and after the cell under test as lagging
    % and leading reference cells
    %Reference_cells_lagging = radarSignal(CUT-dataSize-guardCells:CUT-1-guardCells);
    %Reference_cells_leading = radarSignal(CUT+1+guardCells:CUT+dataSize+guardCells);

    
    % Take the sum of on both sides of the CUT
    %Sum_Reference_cells = sum(Reference_cells_lagging)+sum(Reference_cells_leading);

    % compurte scaling factor alpha
    alpha = referenceWindow*(PFA^(-1/(referenceWindow))-1);

    % Return threshold array with columns 
    thresholdArr(CUT) = g*alpha;
    
    end

     % Verifying if detection are working properly
    %detectionsArr = zeros([1 length(radarSignal)]);

    %NumberOfFalseAlarms=0;

    %for i = 1:length(radarSignal)
        %if DataAfterPowerLawDetector(i) >= thresholdArr(i)
         %   detectionsArr(i) = DataAfterPowerLawDetector(i);
         %   NumberOfFalseAlarms = NumberOfFalseAlarms + 1;
     %   end
   % end
    
    %PFA_simulation = NumberOfFalseAlarms/(dataSize - referenceWindow); 
    %PFA_error = abs(((PFA - PFA_simulation)/PFA)*100) ;  
    
                       
    %CACFAR_1D = detectionsArr;

% Set the return array to T_CA_CFAR function
CACFAR_1D = thresholdArr;

end