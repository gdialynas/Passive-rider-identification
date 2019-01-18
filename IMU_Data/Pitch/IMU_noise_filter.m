function [y_filt] = IMU_noise_filter(u)

% filter characteristics
fs  = 100;
Fnorm = 13/(fs/2);           % Normalized frequency
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

% calculate delay as result of filtering
D = mean(grpdelay(df)) ; % filter delay in samples

% filtering
y_filt = NaN(size(u));

for i = 1:24
    u_filt      = filter(df,[u(:,i); zeros(D,1)]); % Append D zeros to the input data
    y_filt(:,i) = u_filt(D+1:end);
end

