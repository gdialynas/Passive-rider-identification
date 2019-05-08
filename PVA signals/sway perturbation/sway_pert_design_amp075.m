%% Sway perturbation signal design with amplitudes of 0.75 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a sway perturbation signal is designed. It's based on a
% filtered white noise with (reduced) power up to 10 Hz. 99,7% of the 
% acceleration amplitudes is between -0.75 and 0.75 m/s^2. The perturbation 
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

% mean value of whithe noise signal. Needs to be specified
mu_sway      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 0.75 m/s^2
% is chosen since this gives the best FRF for the sway motion within a
% frequency range of 0 - 10 Hz.
max_amp_sway = 0.75; %m/s^2
sigma_sway   = max_amp_sway/3; %STD of signal 

% designing input signal (white noise)
u_sway       = sigma_sway.*randn(N,1)+mu_sway;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_sway)
    plot(t,max_amp_sway*ones(size(t)),'r') 
    plot(t,-max_amp_sway*ones(size(t)),'r') 
    title('sway acc. signal in time domain with max. amp. of 0.75 m/s^2')
subplot(212)
    histfit(u_sway)
    title('Distribution of acc. amplitudes within the white noise signal')
    
%% Butterworth filter design
close all

% A first-order filter response rolls off at -6 dB per octave (-20 dB per 
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

% filtering of the sway signal
u_sway_filt    = filter(b,a,u_sway);

figure(4)
    plot(t, u_sway_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise sway signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_sway           = sigma_sway^2; % variance of signal 
scale_sway_filt    = sqrt(var_sway)/std(u_sway_filt);
u_sway_filt_scaled = scale_sway_filt.*u_sway_filt;

%% Plotting in time domain

figure('name', 'sway signals in time domain')
subplot(311)
    plot(t,u_sway); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered sway (white noise): \mu=', num2str(mean(u_sway)),' \sigma=', num2str(std(u_sway))]) 
subplot(312)
    plot(t,u_sway_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered sway (filtered white noise): \mu=', num2str(mean(u_sway_filt)),' \sigma=', num2str(std(u_sway_filt))])
subplot(313)
    plot(t,u_sway_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered sway scaled: \mu=', num2str(mean(u_sway_filt_scaled)),' \sigma=', num2str(std(u_sway_filt_scaled))])
    
%% Plotting in frequency domain
close all

% In order to check the power in the frequency range of interest the sway
% input acc. signal is plotted in frequency domain.
U_sway                 = fft(u_sway);
U_sway_filt            = fft(u_sway_filt);
U_sway_filt_scaled     = fft(u_sway_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'sway signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_sway(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway: \mu=', num2str(mean(u_sway)),' \sigma=', num2str(std(u_sway))])
subplot(312) 
    plot(fv(1:N/2),abs(U_sway_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered sway: \mu=', num2str(mean(u_sway_filt)),' \sigma=', num2str(std(u_sway_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_sway_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered sway: \mu=', num2str(mean(u_sway_filt_scaled)),' \sigma=', num2str(std(u_sway_filt_scaled))])

%% Integrating sway acceleration signal
close all

sway_acc = u_sway_filt_scaled;
sway_vel = cumtrapz(t,sway_acc);
sway_dis = cumtrapz(t,sway_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,sway_acc)
    hold on; grid on;
    plot(t,sway_vel)
    plot(t,sway_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('sway acceleration, velocity and position signal with drift')

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
sway_acc_filt = filter(d,c,sway_acc);
sway_vel_filt = filter(d,c,sway_vel);
sway_dis_filt = filter(d,c,sway_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,sway_acc_filt)
    hold on; grid on;
    plot(t,sway_vel_filt)
    plot(t,sway_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('sway acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_sway_acc = fft(sway_acc_filt);
U_sway_vel = fft(sway_vel_filt);
U_sway_dis = fft(sway_dis_filt);

figure('name', 'sway signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_sway_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway acc. signal: \mu=', num2str(mean(sway_acc_filt)),' \sigma=', num2str(std(sway_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_sway_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway vel. signal: \mu=', num2str(mean(sway_vel_filt)),' \sigma=', num2str(std(sway_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_sway_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway dis. signal: \mu=', num2str(mean(sway_dis_filt)),' \sigma=', num2str(std(sway_dis_filt))])

%% Scaling sway acceleration signal
close all

scale_sway_acc_filt  = sqrt(var_sway)/std(sway_acc_filt);
sway_acc_filt_scaled = scale_sway_acc_filt.*sway_acc_filt;

figure()
subplot(211)
    plot(t,sway_acc_filt);
    xlim([0 10])
    title(['sway acc. signal not scaled: \mu=', num2str(mean(sway_acc_filt)),' \sigma^2=', num2str(std(sway_acc_filt))])
subplot(212)
    plot(t,sway_acc_filt_scaled);
    xlim([0 10])
    title(['sway acc. scaled signal: \mu=', num2str(mean(sway_acc_filt_scaled)),' \sigma^2=', num2str(std(sway_acc_filt_scaled))])

%% Integrating the sway acc. signal
close all

sway_vel_filt_scaled = cumtrapz(t,sway_acc_filt_scaled);
sway_dis_filt_scaled = cumtrapz(t,sway_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,sway_acc_filt_scaled);
    hold on;
    plot(t,sway_vel_filt_scaled);
    plot(t,sway_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_sway_acc_scaled = fft(sway_acc_filt_scaled);
U_sway_vel_scaled = fft(sway_vel_filt_scaled);
U_sway_dis_scaled = fft(sway_dis_filt_scaled);

figure('name', 'sway signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_sway_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['sway acc. signal: \mu=', num2str(mean(sway_acc_filt_scaled)),' \sigma=', num2str(std(sway_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_sway_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway vel. signal: \mu=', num2str(mean(sway_vel_filt_scaled)),' \sigma=', num2str(std(sway_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_sway_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['sway dis. signal: \mu=', num2str(mean(sway_dis_filt_scaled)),' \sigma=', num2str(std(sway_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

sway_acc = sway_acc_filt_scaled;
sway_vel = sway_vel_filt_scaled;
sway_dis = sway_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
sway_acc_amp075 = [ref_acc_start; sway_acc; ref_acc_stop];
sway_vel_amp075 = [ref_vel_start; sway_vel; ref_vel_stop];
sway_dis_amp075 = [ref_dis_start; sway_dis; ref_dis_stop];

t_sway = (0:length(sway_acc_amp075)-1).'*dt; % time vector

figure(2)
subplot(311)
plot(t_sway, sway_acc_amp075);
title('Final sway acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_sway, sway_vel_amp075);
title('Final sway vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_sway, sway_dis_amp075);
title('Final sway dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(sway_acc_amp075);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_sway_acc_amp075 = fft(sway_acc_amp075);

figure('name', 'sway signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_sway_acc_amp075(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final sway acc. signal in freq. domain: \mu=', num2str(mean(sway_acc_filt_scaled)),' \sigma=', num2str(std(sway_acc_filt_scaled))])

%% Save signal
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/sway perturbation/sway_pert_amp075.mat','sway_dis_amp075','sway_vel_amp075','sway_acc_amp075')
