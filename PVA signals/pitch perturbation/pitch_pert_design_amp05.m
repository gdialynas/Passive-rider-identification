%% Pitch perturbation signal design with amplitudes of 0.5 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a pitch perturbation signal is designed. It's based on a
% filtered white noise with (reduced) power up to 10 Hz. 99,7% of the 
% acceleration amplitudes is between -0.5 and 0.5 m/s^2. The perturbation 
% signal has a duration of 60 sec. From the designed acceleration perturbation 
% a velocity and position signal are obtained by integration of the acceleration
% signal followed by the integration of the velocity signal. The platform 
% which is used is PVA controlled

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
mu_pitch      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 0.5 m/s^2
% is chosen since this gives the best FRF for the pitch motion within a
% frequency range of 0 - 10 Hz.
max_amp_pitch = 0.5; %m/s^2
sigma_pitch   = max_amp_pitch/3; %STD of signal 

% designing input signal (white noise)
u_pitch       = sigma_pitch.*randn(N,1)+mu_pitch;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_pitch)
    plot(t,max_amp_pitch*ones(size(t)),'r') 
    plot(t,-max_amp_pitch*ones(size(t)),'r') 
    title('pitch acc. signal in time domain with max. amp. of 0.5 m/s^2')
subplot(212)
    histfit(u_pitch)
    title('Distribution of acc. amplitudes within the white noise signal')
    
%% Butterworth filter design
close all

% A first-order filter response pitchs off at -6 dB per octave (-20 dB per 
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

% filtering of the pitch signal
u_pitch_filt    = filter(b,a,u_pitch);

figure(4)
    plot(t, u_pitch_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise pitch signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_pitch           = sigma_pitch^2; % variance of signal 
scale_pitch_filt    = sqrt(var_pitch)/std(u_pitch_filt);
u_pitch_filt_scaled = scale_pitch_filt.*u_pitch_filt;

%% Plotting in time domain

figure('name', 'pitch signals in time domain')
subplot(311)
    plot(t,u_pitch); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered pitch (white noise): \mu=', num2str(mean(u_pitch)),' \sigma=', num2str(std(u_pitch))]) 
subplot(312)
    plot(t,u_pitch_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered pitch (filtered white noise): \mu=', num2str(mean(u_pitch_filt)),' \sigma=', num2str(std(u_pitch_filt))])
subplot(313)
    plot(t,u_pitch_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered pitch scaled: \mu=', num2str(mean(u_pitch_filt_scaled)),' \sigma=', num2str(std(u_pitch_filt_scaled))])
    
%% Plotting in frequency domain
close all

% In order to check the power in the frequency range of interest the pitch
% input acc. signal is plotted in frequency domain.
U_pitch                 = fft(u_pitch);
U_pitch_filt            = fft(u_pitch_filt);
U_pitch_filt_scaled     = fft(u_pitch_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'pitch signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_pitch(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch: \mu=', num2str(mean(u_pitch)),' \sigma=', num2str(std(u_pitch))])
subplot(312) 
    plot(fv(1:N/2),abs(U_pitch_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered pitch: \mu=', num2str(mean(u_pitch_filt)),' \sigma=', num2str(std(u_pitch_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_pitch_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered pitch: \mu=', num2str(mean(u_pitch_filt_scaled)),' \sigma=', num2str(std(u_pitch_filt_scaled))])

%% Integrating pitch acceleration signal
close all

pitch_acc = u_pitch_filt_scaled;
pitch_vel = cumtrapz(t,pitch_acc);
pitch_dis = cumtrapz(t,pitch_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,pitch_acc)
    hold on; grid on;
    plot(t,pitch_vel)
    plot(t,pitch_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('pitch acceleration, velocity and position signal with drift')

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
pitch_acc_filt = filter(d,c,pitch_acc);
pitch_vel_filt = filter(d,c,pitch_vel);
pitch_dis_filt = filter(d,c,pitch_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,pitch_acc_filt)
    hold on; grid on;
    plot(t,pitch_vel_filt)
    plot(t,pitch_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('pitch acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_pitch_acc = fft(pitch_acc_filt);
U_pitch_vel = fft(pitch_vel_filt);
U_pitch_dis = fft(pitch_dis_filt);

figure('name', 'pitch signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_pitch_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch acc. signal: \mu=', num2str(mean(pitch_acc_filt)),' \sigma=', num2str(std(pitch_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_pitch_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch vel. signal: \mu=', num2str(mean(pitch_vel_filt)),' \sigma=', num2str(std(pitch_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_pitch_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch dis. signal: \mu=', num2str(mean(pitch_dis_filt)),' \sigma=', num2str(std(pitch_dis_filt))])

%% Scaling pitch acceleration signal
close all

scale_pitch_acc_filt  = sqrt(var_pitch)/std(pitch_acc_filt);
pitch_acc_filt_scaled = scale_pitch_acc_filt.*pitch_acc_filt;

figure()
subplot(211)
    plot(t,pitch_acc_filt);
    xlim([0 10])
    title(['pitch acc. signal not scaled: \mu=', num2str(mean(pitch_acc_filt)),' \sigma^2=', num2str(std(pitch_acc_filt))])
subplot(212)
    plot(t,pitch_acc_filt_scaled);
    xlim([0 10])
    title(['pitch acc. scaled signal: \mu=', num2str(mean(pitch_acc_filt_scaled)),' \sigma^2=', num2str(std(pitch_acc_filt_scaled))])

%% Integrating the pitch acc. signal
close all

pitch_vel_filt_scaled = cumtrapz(t,pitch_acc_filt_scaled);
pitch_dis_filt_scaled = cumtrapz(t,pitch_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,pitch_acc_filt_scaled);
    hold on;
    plot(t,pitch_vel_filt_scaled);
    plot(t,pitch_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_pitch_acc_scaled = fft(pitch_acc_filt_scaled);
U_pitch_vel_scaled = fft(pitch_vel_filt_scaled);
U_pitch_dis_scaled = fft(pitch_dis_filt_scaled);

figure('name', 'pitch signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_pitch_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['pitch acc. signal: \mu=', num2str(mean(pitch_acc_filt_scaled)),' \sigma=', num2str(std(pitch_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_pitch_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch vel. signal: \mu=', num2str(mean(pitch_vel_filt_scaled)),' \sigma=', num2str(std(pitch_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_pitch_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['pitch dis. signal: \mu=', num2str(mean(pitch_dis_filt_scaled)),' \sigma=', num2str(std(pitch_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

pitch_acc = pitch_acc_filt_scaled;
pitch_vel = pitch_vel_filt_scaled;
pitch_dis = pitch_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
pitch_acc_amp05 = [ref_acc_start; pitch_acc; ref_acc_stop];
pitch_vel_amp05 = [ref_vel_start; pitch_vel; ref_vel_stop];
pitch_dis_amp05 = [ref_dis_start; pitch_dis; ref_dis_stop];

t_pitch = (0:length(pitch_acc_amp05)-1).'*dt; % time vector

figure(2)
subplot(311)
plot(t_pitch, pitch_acc_amp05);
title('Final pitch acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_pitch, pitch_vel_amp05);
title('Final pitch vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_pitch, pitch_dis_amp05);
title('Final pitch dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(pitch_acc_amp05);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_pitch_acc_amp05 = fft(pitch_acc_amp05);

figure('name', 'pitch signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_pitch_acc_amp05(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final pitch acc. signal in freq. domain: \mu=', num2str(mean(pitch_acc_filt_scaled)),' \sigma=', num2str(std(pitch_acc_filt_scaled))])

%% Save signal
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/pitch perturbation/pitch_pert_amp05.mat','pitch_dis_amp05','pitch_vel_amp05','pitch_acc_amp05')
