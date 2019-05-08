%% surge perturbation signal design with amplitudes of 0.75 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a surge perturbation signal is designed. It's based on a
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
mu_surge      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 0.75 m/s^2
% is chosen since this gives the best FRF for the surge motion within a
% frequency range of 0 - 10 Hz.
max_amp_surge = 0.75; %m/s^2
sigma_surge   = max_amp_surge/3; %STD of signal 

% designing input signal (white noise)
u_surge       = sigma_surge.*randn(N,1)+mu_surge;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_surge)
    plot(t,max_amp_surge*ones(size(t)),'r') 
    plot(t,-max_amp_surge*ones(size(t)),'r') 
    title('Surge acc. signal in time domain with max. amp. of 0.75 m/s^2')
subplot(212)
    histfit(u_surge)
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

% filtering of the surge signal
u_surge_filt    = filter(b,a,u_surge);

figure(4)
    plot(t, u_surge_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise surge signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_surge           = sigma_surge^2; % variance of signal 
scale_surge_filt    = sqrt(var_surge)/std(u_surge_filt);
u_surge_filt_scaled = scale_surge_filt.*u_surge_filt;

%% Plotting in time domain

figure('name', 'surge signals in time domain')
subplot(311)
    plot(t,u_surge); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered surge (white noise): \mu=', num2str(mean(u_surge)),' \sigma=', num2str(std(u_surge))]) 
subplot(312)
    plot(t,u_surge_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered surge (filtered white noise): \mu=', num2str(mean(u_surge_filt)),' \sigma=', num2str(std(u_surge_filt))])
subplot(313)
    plot(t,u_surge_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered surge scaled: \mu=', num2str(mean(u_surge_filt_scaled)),' \sigma=', num2str(std(u_surge_filt_scaled))])
    
%% Plotting in frequency domain
close all

% in order to check the power in the frequency range of interest the surge
% input acc. signal is plotted in frequency domain.
U_surge                 = fft(u_surge);
U_surge_filt            = fft(u_surge_filt);
U_surge_filt_scaled     = fft(u_surge_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'surge signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_surge(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['surge: \mu=', num2str(mean(u_surge)),' \sigma=', num2str(std(u_surge))])
subplot(312) 
    plot(fv(1:N/2),abs(U_surge_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered surge: \mu=', num2str(mean(u_surge_filt)),' \sigma=', num2str(std(u_surge_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_surge_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered surge: \mu=', num2str(mean(u_surge_filt_scaled)),' \sigma=', num2str(std(u_surge_filt_scaled))])

%% Integrating surge acceleration signal
close all

surge_acc = u_surge_filt_scaled;
surge_vel = cumtrapz(t,surge_acc);
surge_dis = cumtrapz(t,surge_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,surge_acc)
    hold on; grid on;
    plot(t,surge_vel)
    plot(t,surge_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('Surge acceleration, velocity and position signal with drift')

%% Designing high pass filter for drift reduction/cancelation
close all

% As a resutl of integration the position signal shows drift. The solve for
% this the signal should be high filtered with a very low cutoff frequency
% in order to prevent drift and to maintain high power is low frequencies.

% defining high cutoff frequency
fc_high = 0.2;

% 2nd order butterworth filter
[d,c] = butter(2,fc_high/(fs/2),'high');

figure(5)
    freqz(d,c);

figure(6)
    H_high = freqz(d,a,floor(N/2));
    hold on;
    plot([0:1/(N/2-1):1],abs(H_high),'r');
    xlabel('Normalized frequency (x \pi rad/sample)')
    ylabel('Magnitude')
    title('Filter characteristics')
    
% Solving for drift bij filtering
surge_acc_filt = filter(d,c,surge_acc);
surge_vel_filt = filter(d,c,surge_vel);
surge_dis_filt = filter(d,c,surge_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,surge_acc_filt)
    hold on; grid on;
    plot(t,surge_vel_filt)
    plot(t,surge_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('Surge acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_surge_acc = fft(surge_acc_filt);
U_surge_vel = fft(surge_vel_filt);
U_surge_dis = fft(surge_dis_filt);

figure('name', 'surge signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_surge_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['surge acc. signal: \mu=', num2str(mean(surge_acc_filt)),' \sigma=', num2str(std(surge_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_surge_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['surge vel. signal: \mu=', num2str(mean(surge_vel_filt)),' \sigma=', num2str(std(surge_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_surge_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['surge dis. signal: \mu=', num2str(mean(surge_dis_filt)),' \sigma=', num2str(std(surge_dis_filt))])

%% Scaling surge acceleration signal
close all

scale_surge_acc_filt  = sqrt(var_surge)/std(surge_acc_filt);
surge_acc_filt_scaled = scale_surge_acc_filt.*surge_acc_filt;

figure()
subplot(211)
    plot(t,surge_acc_filt);
    xlim([0 10])
    title(['surge acc. signal not scaled: \mu=', num2str(mean(surge_acc_filt)),' \sigma^2=', num2str(std(surge_acc_filt))])
subplot(212)
    plot(t,surge_acc_filt_scaled);
    xlim([0 10])
    title(['surge acc. scaled signal: \mu=', num2str(mean(surge_acc_filt_scaled)),' \sigma^2=', num2str(std(surge_acc_filt_scaled))])

%% Integrating the surge acc. signal
close all

surge_vel_filt_scaled = cumtrapz(t,surge_acc_filt_scaled);
surge_dis_filt_scaled = cumtrapz(t,surge_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,surge_acc_filt_scaled);
    hold on;
    plot(t,surge_vel_filt_scaled);
    plot(t,surge_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_surge_acc_scaled = fft(surge_acc_filt_scaled);
U_surge_vel_scaled = fft(surge_vel_filt_scaled);
U_surge_dis_scaled = fft(surge_dis_filt_scaled);

figure('name', 'surge signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_surge_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['Surge acc. signal: \mu=', num2str(mean(surge_acc_filt_scaled)),' \sigma=', num2str(std(surge_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_surge_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Surge vel. signal: \mu=', num2str(mean(surge_vel_filt_scaled)),' \sigma=', num2str(std(surge_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_surge_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Surge dis. signal: \mu=', num2str(mean(surge_dis_filt_scaled)),' \sigma=', num2str(std(surge_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

surge_acc = surge_acc_filt_scaled;
surge_vel = surge_vel_filt_scaled;
surge_dis = surge_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
surge_acc_amp075 = [ref_acc_start; surge_acc; ref_acc_stop];
surge_vel_amp075 = [ref_vel_start; surge_vel; ref_vel_stop];
surge_dis_amp075 = [ref_dis_start; surge_dis; ref_dis_stop];

t_surge = (0:length(surge_acc_amp075)-1).'*dt; % time vector

figure(7)
subplot(311)
plot(t_surge, surge_acc_amp075);
title('Final surge acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_surge, surge_vel_amp075);
title('Final surge vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_surge, surge_dis_amp075);
title('Final surge dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(surge_acc_amp075);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_surge_acc_amp075 = fft(surge_acc_amp075);

figure('name', 'surge signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_surge_acc_amp075(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final surge acc. signal in freq. domain: \mu=', num2str(mean(surge_acc_filt_scaled)),' \sigma=', num2str(std(surge_acc_filt_scaled))])

%% Save signal
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/surge perturbation/surge_pert_amp075.mat','surge_dis_amp075','surge_vel_amp075','surge_acc_amp075')
