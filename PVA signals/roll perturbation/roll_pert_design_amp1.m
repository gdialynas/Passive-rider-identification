%% Roll perturbation signal design with amplitudes of 1.0 m/s^2

% Jelle Waling de Haan
% 30-07-18
% MSc project: passive rider identification

% In this script a roll perturbation signal is designed. It's based on a
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
mu_roll      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 1.0 m/s^2
% is chosen since this gives the best FRF for the roll motion within a
% frequency range of 0 - 10 Hz.
max_amp_roll = 1; %m/s^2
sigma_roll   = max_amp_roll/3; %STD of signal 

% designing input signal (white noise)
u_roll       = sigma_roll.*randn(N,1)+mu_roll;  

% plot signal in time domain and show the of distribution amplitudes within 
% the signal. 
figure(1)
subplot(211)
    hold all;
    plot(t,u_roll)
    plot(t,max_amp_roll*ones(size(t)),'r') 
    plot(t,-max_amp_roll*ones(size(t)),'r') 
    title('roll acc. signal in time domain with max. amp. of 1.0 m/s^2')
subplot(212)
    histfit(u_roll)
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

% filtering of the roll signal
u_roll_filt    = filter(b,a,u_roll);

figure(4)
    plot(t, u_roll_filt);
    ylabel('Acceleration [m/s^2]');
    xlabel('Time [s]');
    title('Filtered white noise roll signal in time domain')


%% Scaling signals
close all

% from previous follows that the amplitude is decreased as a result of
% filtering. Therefore, the signal has to be rescaled. 
var_roll           = sigma_roll^2; % variance of signal 
scale_roll_filt    = sqrt(var_roll)/std(u_roll_filt);
u_roll_filt_scaled = scale_roll_filt.*u_roll_filt;

%% Plotting in time domain

figure('name', 'roll signals in time domain')
subplot(311)
    plot(t,u_roll); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Unfiltered roll (white noise): \mu=', num2str(mean(u_roll)),' \sigma=', num2str(std(u_roll))]) 
subplot(312)
    plot(t,u_roll_filt); grid on;
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    xlim([0 10])
    title(['Filtered roll (filtered white noise): \mu=', num2str(mean(u_roll_filt)),' \sigma=', num2str(std(u_roll_filt))])
subplot(313)
    plot(t,u_roll_filt_scaled)
    xlim([0 10])
    ylabel('Amplitude [m/s^2]')
    xlabel('Time [s]')
    title(['Filtered roll scaled: \mu=', num2str(mean(u_roll_filt_scaled)),' \sigma=', num2str(std(u_roll_filt_scaled))])
    
%% Plotting in frequency domain
close all

% In order to check the power in the frequency range of interest the roll
% input acc. signal is plotted in frequency domain.
U_roll                 = fft(u_roll);
U_roll_filt            = fft(u_roll_filt);
U_roll_filt_scaled     = fft(u_roll_filt_scaled);

% frequency vector
fv  = (0:1/T:fs-(1/T))';

figure('name', 'roll signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_roll(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll: \mu=', num2str(mean(u_roll)),' \sigma=', num2str(std(u_roll))])
subplot(312) 
    plot(fv(1:N/2),abs(U_roll_filt(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['No scaled forward filtered roll: \mu=', num2str(mean(u_roll_filt)),' \sigma=', num2str(std(u_roll_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_roll_filt_scaled(1:N/2)))
    xlim([0 20])
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Scaled forward filtered roll: \mu=', num2str(mean(u_roll_filt_scaled)),' \sigma=', num2str(std(u_roll_filt_scaled))])

%% Integrating roll acceleration signal
close all

roll_acc = u_roll_filt_scaled;
roll_vel = cumtrapz(t,roll_acc);
roll_dis = cumtrapz(t,roll_vel);

figure('name', 'PVA signal in time domain with drift')
    plot(t,roll_acc)
    hold on; grid on;
    plot(t,roll_vel)
    plot(t,roll_dis)
    xlabel('Time [s]')
    legend('Acceleration','Velocity','Position');
    title('roll acceleration, velocity and position signal with drift')

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
    H_high = freqz(d,c,floor(N/2));
    hold on;
    plot([0:1/(N/2-1):1],abs(H_high),'r');
    xlabel('Normalized frequency (x \pi rad/sample)')
    ylabel('Magnitude')
    title('Filter characteristics')
    
% Solving for drift bij filtering
roll_acc_filt = filter(d,c,roll_acc);
roll_vel_filt = filter(d,c,roll_vel);
roll_dis_filt = filter(d,c,roll_dis);

%% Plotting PVA signal
close all 

figure('name', 'PVA signal in time domain')
    plot(t,roll_acc_filt)
    hold on; grid on;
    plot(t,roll_vel_filt)
    plot(t,roll_dis_filt)
    xlim([0 10])
    xlabel('Time [s]')
    title('roll acceleration, velocity and position signal without drift')
    
%% Plotting PVA signal in freq. domain
close all

U_roll_acc = fft(roll_acc_filt);
U_roll_vel = fft(roll_vel_filt);
U_roll_dis = fft(roll_dis_filt);

figure('name', 'roll signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_roll_acc(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll acc. signal: \mu=', num2str(mean(roll_acc_filt)),' \sigma=', num2str(std(roll_acc_filt))])
subplot(312) 
    plot(fv(1:N/2),abs(U_roll_vel(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll vel. signal: \mu=', num2str(mean(roll_vel_filt)),' \sigma=', num2str(std(roll_vel_filt))])
subplot(313)
    plot(fv(1:N/2),abs(U_roll_dis(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll dis. signal: \mu=', num2str(mean(roll_dis_filt)),' \sigma=', num2str(std(roll_dis_filt))])

%% Scaling roll acceleration signal
close all

scale_roll_acc_filt  = sqrt(var_roll)/std(roll_acc_filt);
roll_acc_filt_scaled = scale_roll_acc_filt.*roll_acc_filt;

figure()
subplot(211)
    plot(t,roll_acc_filt);
    xlim([0 10])
    title(['roll acc. signal not scaled: \mu=', num2str(mean(roll_acc_filt)),' \sigma^2=', num2str(std(roll_acc_filt))])
subplot(212)
    plot(t,roll_acc_filt_scaled);
    xlim([0 10])
    title(['roll acc. scaled signal: \mu=', num2str(mean(roll_acc_filt_scaled)),' \sigma^2=', num2str(std(roll_acc_filt_scaled))])

%% Integrating the roll acc. signal
close all

roll_vel_filt_scaled = cumtrapz(t,roll_acc_filt_scaled);
roll_dis_filt_scaled = cumtrapz(t,roll_vel_filt_scaled);

figure('name', 'Scaled PVA signal')
    plot(t,roll_acc_filt_scaled);
    hold on;
    plot(t,roll_vel_filt_scaled);
    plot(t,roll_dis_filt_scaled);
    xlim([0 10])
    xlabel('Time [s]')
    title('Scaled PVA signal without drift')

%% Plotting scaled PVA signal in freq. domain
close all

U_roll_acc_scaled = fft(roll_acc_filt_scaled);
U_roll_vel_scaled = fft(roll_vel_filt_scaled);
U_roll_dis_scaled = fft(roll_dis_filt_scaled);

figure('name', 'roll signal in freq. domain')
subplot(311)
    plot(fv(1:N/2),abs(U_roll_acc_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('magnitude')
    title(['roll acc. signal: \mu=', num2str(mean(roll_acc_filt_scaled)),' \sigma=', num2str(std(roll_acc_filt_scaled))])
subplot(312) 
    plot(fv(1:N/2),abs(U_roll_vel_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll vel. signal: \mu=', num2str(mean(roll_vel_filt_scaled)),' \sigma=', num2str(std(roll_vel_filt_scaled))])
subplot(313)
    plot(fv(1:N/2),abs(U_roll_dis_scaled(1:N/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['roll dis. signal: \mu=', num2str(mean(roll_dis_filt_scaled)),' \sigma=', num2str(std(roll_dis_filt_scaled))])

%% Rename variables for final PVA signal
close all

roll_acc = roll_acc_filt_scaled;
roll_vel = roll_vel_filt_scaled;
roll_dis = roll_dis_filt_scaled;

%% loading reference signal data
load('ref_start_stop_025ms2')

%% Constructing final PVA signal
roll_acc_amp1 = [ref_acc_start; roll_acc; ref_acc_stop];
roll_vel_amp1 = [ref_vel_start; roll_vel; ref_vel_stop];
roll_dis_amp1 = [ref_dis_start; roll_dis; ref_dis_stop];

t_roll = (0:length(roll_acc_amp1)-1).'*dt; % time vector

figure(2)
subplot(311)
plot(t_roll, roll_acc_amp1);
title('Final roll acc. signal')
xlabel('Time [s]')
ylabel('m/s^2')
subplot(312)
plot(t_roll, roll_vel_amp1);
title('Final roll vel. signal')
xlabel('Time [s]')
ylabel('m/s')
subplot(313)
plot(t_roll, roll_dis_amp1);
title('Final roll dis. signal')
xlabel('Time [s]')
ylabel('m')

%% Plotting final PVA signal in freq. domain
close all

fs       = 100;
T_pert   = 69.02;                   
N_pert   = length(roll_acc_amp1);
fv_pert  = (0:1/T_pert:fs-(1/T_pert))';   

U_roll_acc_amp1 = fft(roll_acc_amp1);

figure('name', 'roll signal in freq. domain')
    plot(fv_pert(1:N_pert/2),abs(U_roll_acc_amp1(1:N_pert/2)))
    xlabel('Frequency [Hz]')
    ylabel('Magnitude')
    title(['Final roll acc. signal in freq. domain: \mu=', num2str(mean(roll_acc_filt_scaled)),' \sigma=', num2str(std(roll_acc_filt_scaled))])

%% Save signal
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/roll perturbation/roll_pert_amp1.mat','roll_dis_amp1','roll_vel_amp1','roll_acc_amp1')
