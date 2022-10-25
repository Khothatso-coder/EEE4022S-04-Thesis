% Apply the CA-CFAR algorithm to simulated data in MATLAB
% Author: Khothatso Motake
% Date 11/10/2022

clear all;
close all;

% Simulate data of Data_Length 100000,m
Data_Length = 100000;  
% Complex data (I and Q values).
y_complex = randn(1,Data_Length) + 1i*randn(1,Data_Length);

% Perform CA-CFAR processing after the power law detector.
DataAfterPowerLawDetector = abs(y_complex).^2; 
figure;plot(DataAfterPowerLawDetector(1:100));title("data after the power law detector");

% To implement CA-CFAR, need to define the following parameters:
PFA = 10^-3;

N = 32;% Window Size
RefWin = N*2; %Number of Reference Cells
guard_cells = 2; %Guard cells - 3/4

% First work out the average of reference cells

Reference_cells = zeros(N,Data_Length);

for i = 1:N
    I = randn(1,Data_Length);
    Q = randn(1,Data_Length);
    Reference_cells(i,:) = (I + 1j*Q)/sqrt(2);
end

%T_CFAR = zeros(Data_Length,1);
%T_CFAR = CA_CFAR_Function(PFA, N, guard_cells, DataAfterPowerLawDetector);
%for i = 1:Data_Length
 %   CUT = i;
	%if(CUT <N+guard_cells+1 || CUT > Data_Length - (N+guard_cells+1))
	%	T_CFAR(CUT) = 1;
	%	continue;
	%end
    %RefCells_lagging = DataAfterPowerLawDetector(CUT-N-guard_cells:CUT-1-guard_cells);
	%RefCells_leading = DataAfterPowerLawDetector(CUT+1+guard_cells:CUT+N+guard_cells);
	
	%Sum_Reference_cells = sum(RefCells_lagging)+sum(RefCells_leading);
	%g = Sum_Reference_cells./RefWin;
    %disp("average of reference cells(g) = ");
    %disp(g); 

	%alpha = RefWin*(PFA^(-1/(RefWin))-1);
    %disp("scaling factor alpha = ");
    %disp(alpha);

	%T_CFAR(CUT) = g*alpha;
    %disp("Threshold T= ");
   % disp(T_CFAR(CUT));
%end

Reference_cells_AD = abs(Reference_cells).^2;

%Reference_cells_lagging = DataAfterPowerLawDetector(34:49); % Dr. YAG
%Reference_cells_leading = DataAfterPowerLawDetector(51:66);

%Sum_Reference_cells = sum(Reference_cells_lagging)+sum(Reference_cells_leading);
Sum_Reference_cells = sum(Reference_cells_AD,1);

g = Sum_Reference_cells./N;
disp("average of reference cells(g) = ");
disp(g);

% scaling factor alpha,
alpha = N*(PFA^(-1/(N))-1);
disp("scaling factor alpha = ");
disp(alpha);

% Threshold
T = g*alpha;
disp("Threshold T= ");
disp(T);

I_test = randn(Data_Length,1);
Q_test = randn(Data_Length,1);
Test_Signal = (I_test + 1j*Q_test)/sqrt(2);
Test_AD = abs(Test_Signal).^2;

False_Alarms = sum((Test_AD.'-T)>0);
disp("False_Alarms = ")
disp(False_Alarms)

Simulated_Pfa = False_Alarms/Data_Length;
disp("Simulated_Pfa = ")
disp(Simulated_Pfa)

Pfa_Error = 100*(Simulated_Pfa-PFA)/PFA;
disp("Pfa error = ");
disp(Pfa_Error);

