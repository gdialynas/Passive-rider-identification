%% Heave perturbation signal design with amplitudes of 1.0 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a heave perturbation signal is designed. It's based on a
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
mu_heave      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 1.0 m/s^2
% is chosen since this gives the best FRF for the heave motion within a
% frequency range of 0 - 10 Hz.
max_amp_heave = 1; %m/s^2
sigma_heave   = max_amp_heave/3; %STD of signal 

% designing input signal (white noise)
u_heave       = sigma_heave.*randn(N,1)+mu_heave;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_heave)
    plot(t,max_amp_heave*ones(size(t)),'r') 
    plot(t,-max_amp_heave*ones(size(t)),'r') 
    title('heave acc. signal in time domain with max. amp. of 1.0 m/s^2')
subplot(212)
    histfit(u_heave)
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

% filtering of the heave signal
u_heave_filt    = filter(b,a,u_heave);

figure(4)
    plot(t, u_heave_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise heave signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_heave           = sigma_heave^2; % variance of signal 
scale_heave_filt    = sqrt(var_heave)/std(u_heave_filt);
u_heave_filt_scaled = scale_heave_filt.*u_heave_filt;

%% Plotting in time domain

figure('name', 'heave signals in time domain')
subplot(311)
    plot(t,u_heave); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered heave (white noise): \mu=', num2str(mean(u_heave)),' \sigma=', num2str(std(u_heave))]) 
subplot(312)
    plot(t,u_heave_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered heave (filtered white noise): \mu=', num2str(mean(u_heave_filt)),' \sigma=', num2str(std(u_heave_filt))])
subplot(313)
    plot(t,u_heave_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered heave scaled: \mu=', num2str(mean(u_heave_filt_scaled)),' \sigma=', num2str(std(u_heave_filt_scaled))])
    
%% Plotting in frequency domain
close all

% In order to check the power in the frequency range of interest the heave
% input acc. signal is plotted in frequency domain.
U_heave                 = fft(u_heave);
U_heave_filt            = fft(u_heave_filt);
U_heave_filt_scaled     = fft(u_heave_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'heave signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_heave(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave: \mu=', num2str(mean(u_heave)),' \sigma=', num2str(std(u_heave))])
subplot(312) 
    plot(fv(1:N/2),abs(U_heave_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered heave: \mu=', num2str(mean(u_heave_filt)),' \sigma=', num2str(std(u_heave_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_heave_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered heave: \mu=', num2str(mean(u_heave_filt_scaled)),' \sigma=', num2str(std(u_heave_filt_scaled))])

%% Integrating heave acceleration signal
close all

heave_acc = u_heave_filt_scaled;
heave_vel = cumtrapz(t,heave_acc);
heave_dis = cumtrapz(t,heave_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,heave_acc)
    hold on; grid on;
    plot(t,heave_vel)
    plot(t,heave_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('heave acceleration, velocity and position signal with drift')

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
heave_acc_filt = filter(d,c,heave_acc);
heave_vel_filt = filter(d,c,heave_vel);
heave_dis_filt = filter(d,c,heave_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,heave_acc_filt)
    hold on; grid on;
    plot(t,heave_vel_filt)
    plot(t,heave_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('heave acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_heave_acc = fft(heave_acc_filt);
U_heave_vel = fft(heave_vel_filt);
U_heave_dis = fft(heave_dis_filt);

figure('name', 'heave signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_heave_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave acc. signal: \mu=', num2str(mean(heave_acc_filt)),' \sigma=', num2str(std(heave_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_heave_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave vel. signal: \mu=', num2str(mean(heave_vel_filt)),' \sigma=', num2str(std(heave_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_heave_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave dis. signal: \mu=', num2str(mean(heave_dis_filt)),' \sigma=', num2str(std(heave_dis_filt))])

%% Scaling heave acceleration signal
close all

scale_heave_acc_filt  = sqrt(var_heave)/std(heave_acc_filt);
heave_acc_filt_scaled = scale_heave_acc_filt.*heave_acc_filt;

figure()
subplot(211)
    plot(t,heave_acc_filt);
    xlim([0 10])
    title(['heave acc. signal not scaled: \mu=', num2str(mean(heave_acc_filt)),' \sigma^2=', num2str(std(heave_acc_filt))])
subplot(212)
    plot(t,heave_acc_filt_scaled);
    xlim([0 10])
    title(['heave acc. scaled signal: \mu=', num2str(mean(heave_acc_filt_scaled)),' \sigma^2=', num2str(std(heave_acc_filt_scaled))])

%% Integrating the heave acc. signal
close all

heave_vel_filt_scaled = cumtrapz(t,heave_acc_filt_scaled);
heave_dis_filt_scaled = cumtrapz(t,heave_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,heave_acc_filt_scaled);
    hold on;
    plot(t,heave_vel_filt_scaled);
    plot(t,heave_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_heave_acc_scaled = fft(heave_acc_filt_scaled);
U_heave_vel_scaled = fft(heave_vel_filt_scaled);
U_heave_dis_scaled = fft(heave_dis_filt_scaled);

figure('name', 'heave signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_heave_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['heave acc. signal: \mu=', num2str(mean(heave_acc_filt_scaled)),' \sigma=', num2str(std(heave_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_heave_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave vel. signal: \mu=', num2str(mean(heave_vel_filt_scaled)),' \sigma=', num2str(std(heave_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_heave_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['heave dis. signal: \mu=', num2str(mean(heave_dis_filt_scaled)),' \sigma=', num2str(std(heave_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

heave_acc = heave_acc_filt_scaled;
heave_vel = heave_vel_filt_scaled;
heave_dis = heave_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
heave_acc_amp1 = [ref_acc_start; heave_acc; ref_acc_stop];
heave_vel_amp1 = [ref_vel_start; heave_vel; ref_vel_stop];
heave_dis_amp1 = [ref_dis_start; heave_dis; ref_dis_stop];

t_heave = (0:length(heave_acc_amp1)-1).'*dt; % time vector

figure(2)
subplot(311)
plot(t_heave, heave_acc_amp1);
title('Final heave acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_heave, heave_vel_amp1);
title('Final heave vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_heave, heave_dis_amp1);
title('Final heave dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(heave_acc_amp1);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_heave_acc_amp1 = fft(heave_acc_amp1);

figure('name', 'heave signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_heave_acc_amp1(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final heave acc. signal in freq. domain: \mu=', num2str(mean(heave_acc_filt_scaled)),' \sigma=', num2str(std(heave_acc_filt_scaled))])

%% Save signal
save('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\m-files generating (PVA) perturbation signals\heave perturbation\heave_pert_amp1.mat','heave_dis_amp1','heave_vel_amp1','heave_acc_amp1')
