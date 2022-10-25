% Function For CA-CFAR, defineRefWind by paramters: PFA; Window Size; Guard Cells, and the magnitude of signal, outputing the Threshold
% Author: Khothatso MotakedataLen
% Date 11/10/2022
function [thresholdArray] = X_CA_CFAR(signalMag, windowSize, guardCells,PFA)

    referenceWindow = (windowSize)*2; % Reference window double the window size
    
    % Size of the measured input dataset
    dataLen = length(signalMag);
    
    % Initialise the CFAR threshold CFAR with ones for the data length
    thresholdArr = zeros(dataLen,1);

    % Defining the threshold function from lagging and leading cells
    for i = 1:dataLen
        CUT = i;
	    if(CUT < windowSize+guardCells+1 || CUT > dataLen - (windowSize+guardCells+1))
		    thresholdArr(CUT) = 1;
		    continue;
	    end
    % Total length = referenceWindowdow/2
    % Define training cells before and after the cell under test as lagging
    % and leading reference cells
    Reference_cells_lagging = signalMag(CUT-windowSize-guardCells:CUT-1-guardCells);

    Reference_cells_leading = signalMag(CUT+1+guardCells:CUT+windowSize+guardCells);
    
    % Take the sum of on both sides of the CUT
    Sum_Reference_cells = sum(Reference_cells_lagging)+sum(Reference_cells_leading);

    % work out the average of reference cells  
    g = Sum_Reference_cells./referenceWindow;

    % compurte scaling factor alpha
    alpha = referenceWindow*(PFA^(-1/(referenceWindow))-1);

    % Return threshold array with columns 
    thresholdArr(CUT) = g*alpha;
    
    end

% Set the return array to T_CA_CFAR function
thresholdArray = thresholdArr;

end