%% plotting fucntions
% Author: Motake Khothatso
% Date 18/10/2022

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
