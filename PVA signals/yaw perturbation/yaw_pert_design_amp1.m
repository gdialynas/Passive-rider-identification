%% Yaw perturbation signal design with amplitudes of 1.0 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a yaw perturbation signal is designed. It's based on a
% filtered white noise with (reduced) power up to 10 Hz. 99,7% of the 
% acceleration amplitudes is between -1.0 and 1.0 m/s^2. The perturbation 
% signal has a duration of 60 sec. From the designed acceleration perturbation 
% a velocity and position signal are obtained by integration of the acceleration
% signal followed by the integration of the velocity signal. The platform 
% which is used is PVA controlled. 

clear all
close all
clc

%% Signal parameters

T       = 60;           % observation time. 
fs      = 100;          % samplin frequency
dt      = 1/fs;         % sample duration
N       = T*fs;         % number of samples in signal
t       = (0:N-1).'*dt; % time vector

%% Design perturbation signals

% mean value of whithe noise signal. Need to be specified.
mu_yaw      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 1.0 m/s^2
% is chosen since this gives the best FRF for the yaw motion within a
% frequency range of 0 - 10 Hz.
max_amp_yaw = 1; %m/s^2
sigma_yaw   = max_amp_yaw/3; %STD of signal 

% designing input signal (white noise)
u_yaw       = sigma_yaw.*randn(N,1)+mu_yaw;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_yaw)
    plot(t,max_amp_yaw*ones(size(t)),'r') 
    plot(t,-max_amp_yaw*ones(size(t)),'r') 
    title('yaw acc. signal in time domain with max. amp. of 1.0 m/s^2')
subplot(212)
    histfit(u_yaw)
    title('Distribution of acc. amplitudes within the white noise signal')
    
%% Butterworth filter design
close all

% A first-order filter response yaws off at -6 dB per octave (-20 dB per 
% decade). All first-order lowpass filters have the same normalized 
% frequency response. A second-order filter decreases at -12 dB per 
% octave, a third-order at -18 dB and so on. 

% cutoff frequency. Needs to be specified
fc_low          = 9;                        

% The firtst term of a butterworth filter represents the order of the
% filter, the second term is de cutoff frequenty with respect to the
% normalized frequency, the third term indicates that it is a low
% passfilter
[b,a]       = butter(5,fc_low/(fs/2),'low'); 

figure(2)
    freqz(b,a);

figure(3)
    H_low = freqz(b,a,floor(N/2));
    hold on;
    plot([0:1/(N/2-1):1],abs(H_low),'r');
    xlabel('normalized frequency (x \pi rad/sample)')
    ylabel('magnitude')
    title('Filter characteristics')

% filtering of the yaw signal
u_yaw_filt    = filter(b,a,u_yaw);

figure(4)
    plot(t, u_yaw_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise yaw signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_yaw           = sigma_yaw^2; % variance of signal 
scale_yaw_filt    = sqrt(var_yaw)/std(u_yaw_filt);
u_yaw_filt_scaled = scale_yaw_filt.*u_yaw_filt;

%% Plotting in time domain

figure('name', 'yaw signals in time domain')
subplot(311)
    plot(t,u_yaw); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered yaw (white noise): \mu=', num2str(mean(u_yaw)),' \sigma=', num2str(std(u_yaw))]) 
subplot(312)
    plot(t,u_yaw_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered yaw (filtered white noise): \mu=', num2str(mean(u_yaw_filt)),' \sigma=', num2str(std(u_yaw_filt))])
subplot(313)
    plot(t,u_yaw_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered yaw scaled: \mu=', num2str(mean(u_yaw_filt_scaled)),' \sigma=', num2str(std(u_yaw_filt_scaled))])
    
%% Plotting in frequency domain
close all

% In order to check the power in the frequency range of interest the yaw
% input acc. signal is plotted in frequency domain.
U_yaw                 = fft(u_yaw);
U_yaw_filt            = fft(u_yaw_filt);
U_yaw_filt_scaled     = fft(u_yaw_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'yaw signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_yaw(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw: \mu=', num2str(mean(u_yaw)),' \sigma=', num2str(std(u_yaw))])
subplot(312) 
    plot(fv(1:N/2),abs(U_yaw_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered yaw: \mu=', num2str(mean(u_yaw_filt)),' \sigma=', num2str(std(u_yaw_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_yaw_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered yaw: \mu=', num2str(mean(u_yaw_filt_scaled)),' \sigma=', num2str(std(u_yaw_filt_scaled))])

%% Integrating yaw acceleration signal
close all

yaw_acc = u_yaw_filt_scaled;
yaw_vel = cumtrapz(t,yaw_acc);
yaw_dis = cumtrapz(t,yaw_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,yaw_acc)
    hold on; grid on;
    plot(t,yaw_vel)
    plot(t,yaw_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('yaw acceleration, velocity and position signal with drift')

%% Designing high pass filter for drift reduction/cancelation
close all

% As a resutl of integration the position signal shows drift. The solve for
% this the signal should be high filtered with a very low cutoff frequency
% in order to prevent drift and to maintain high power is low frequencies.

% defining high cutoff frequency
fc_high = 0.2;

% 2nd order butterworth filter
[d,c] = butter(2,fc_high/(fs/2),'high');

figure(1)
    freqz(d,c);

figure(2)
    H_high = freqz(d,a,floor(N/2));
    hold on;
    plot([0:1/(N/2-1):1],abs(H_high),'r');
    xlabel('Normalized frequency (x \pi rad/sample)')
    ylabel('Magnitude')
    title('Filter characteristics')
    
% Solving for drift bij filtering
yaw_acc_filt = filter(d,c,yaw_acc);
yaw_vel_filt = filter(d,c,yaw_vel);
yaw_dis_filt = filter(d,c,yaw_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,yaw_acc_filt)
    hold on; grid on;
    plot(t,yaw_vel_filt)
    plot(t,yaw_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('yaw acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_yaw_acc = fft(yaw_acc_filt);
U_yaw_vel = fft(yaw_vel_filt);
U_yaw_dis = fft(yaw_dis_filt);

figure('name', 'yaw signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_yaw_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw acc. signal: \mu=', num2str(mean(yaw_acc_filt)),' \sigma=', num2str(std(yaw_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_yaw_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw vel. signal: \mu=', num2str(mean(yaw_vel_filt)),' \sigma=', num2str(std(yaw_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_yaw_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw dis. signal: \mu=', num2str(mean(yaw_dis_filt)),' \sigma=', num2str(std(yaw_dis_filt))])

%% Scaling yaw acceleration signal
close all

scale_yaw_acc_filt  = sqrt(var_yaw)/std(yaw_acc_filt);
yaw_acc_filt_scaled = scale_yaw_acc_filt.*yaw_acc_filt;

figure()
subplot(211)
    plot(t,yaw_acc_filt);
    xlim([0 10])
    title(['yaw acc. signal not scaled: \mu=', num2str(mean(yaw_acc_filt)),' \sigma^2=', num2str(std(yaw_acc_filt))])
subplot(212)
    plot(t,yaw_acc_filt_scaled);
    xlim([0 10])
    title(['yaw acc. scaled signal: \mu=', num2str(mean(yaw_acc_filt_scaled)),' \sigma^2=', num2str(std(yaw_acc_filt_scaled))])

%% Integrating the yaw acc. signal
close all

yaw_vel_filt_scaled = cumtrapz(t,yaw_acc_filt_scaled);
yaw_dis_filt_scaled = cumtrapz(t,yaw_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,yaw_acc_filt_scaled);
    hold on;
    plot(t,yaw_vel_filt_scaled);
    plot(t,yaw_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_yaw_acc_scaled = fft(yaw_acc_filt_scaled);
U_yaw_vel_scaled = fft(yaw_vel_filt_scaled);
U_yaw_dis_scaled = fft(yaw_dis_filt_scaled);

figure('name', 'yaw signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_yaw_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['yaw acc. signal: \mu=', num2str(mean(yaw_acc_filt_scaled)),' \sigma=', num2str(std(yaw_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_yaw_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw vel. signal: \mu=', num2str(mean(yaw_vel_filt_scaled)),' \sigma=', num2str(std(yaw_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_yaw_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['yaw dis. signal: \mu=', num2str(mean(yaw_dis_filt_scaled)),' \sigma=', num2str(std(yaw_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

yaw_acc = yaw_acc_filt_scaled;
yaw_vel = yaw_vel_filt_scaled;
yaw_dis = yaw_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
yaw_acc_amp1 = [ref_acc_start; yaw_acc; ref_acc_stop];
yaw_vel_amp1 = [ref_vel_start; yaw_vel; ref_vel_stop];
yaw_dis_amp1 = [ref_dis_start; yaw_dis; ref_dis_stop];

t_yaw = (0:length(yaw_acc_amp1)-1).'*dt; % time vector

figure(2)
subplot(311)
plot(t_yaw, yaw_acc_amp1);
title('Final yaw acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_yaw, yaw_vel_amp1);
title('Final yaw vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_yaw, yaw_dis_amp1);
title('Final yaw dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(yaw_acc_amp1);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_yaw_acc_amp1 = fft(yaw_acc_amp1);

figure('name', 'yaw signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_yaw_acc_amp1(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final yaw acc. signal in freq. domain: \mu=', num2str(mean(yaw_acc_filt_scaled)),' \sigma=', num2str(std(yaw_acc_filt_scaled))])

%% Save signal
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/yaw perturbation/yaw_pert_amp1.mat','yaw_dis_amp1','yaw_vel_amp1','yaw_acc_amp1')
