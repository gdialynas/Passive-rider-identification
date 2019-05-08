clear all
close all
clc

load('heave_pert_amp1.mat');

%% Signal parameters

T       = 60;           % observation time. 
fs      = 100;          % samplin frequency
dt      = 1/fs;         % sample duration
N       = T*fs;         % number of samples in signal
t       = (0:N-1).'*dt; % time vector

heave = heave_acc_amp1(502:6501);

figure(1)
plot(t,heave)
set(gca,'FontSize',20)

%% Design perturbation signals
close all

% mean value of whithe noise signal. Need to be specified.
mu_heave      = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 1.0 m/s^2
% is chosen since this gives the best FRF for the heave motion within a
% frequency range of 0 - 10 Hz.
max_amp_heave = 1; %m/s^2
sigma_heave   = max_amp_heave/3; %STD of signal

% frequency vector
fv  = (0:1/T:fs-(1/T))';

Heave = fft(heave);

figure();
set(gca,'FontSize',20)
subplot(311)
    hold all;
    plot(t,heave)
    plot(t,max_amp_heave*ones(size(t)),'r') 
    plot(t,-max_amp_heave*ones(size(t)),'r') 
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.44, 0]); % Set Title with correct Position
    set(gca,'FontSize',15)
    lgd = legend('heave acc.','(-)3\sigma_{pert}');
    lgd.FontSize = 15;
subplot(312)
    plot(fv(1:N/2),abs(Heave(1:N/2)))
    xlim([0 10]);
    xlabel('Frequency [Hz]')
    ylabel('Magnitude [-]')
    %title('Frequency spectrum')
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.44, 0]); % Set Title with correct Position
    set(gca,'FontSize',15)
subplot(313)
    histfit(heave)
    xlabel('Acceleration [m/s^2]')
    ylabel('Samples')
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.48, 0]); % Set Title with correct Position
    %title(['\mu_{pert}=', num2str(mean(heave)),' \sigma_{pert}=', num2str(std(heave))])
    %lgd = legend(['\mu_{pert}=', num2str(mean(heave)),' \sigma_{pert}=', num2str(std(heave))]);
    str = {['\mu_{pert}=', num2str(mean(heave))],['\sigma_{pert}=', num2str(std(heave))]};
    text(1,200,str,'FontSize',20)
    set(gca,'FontSize',15)

