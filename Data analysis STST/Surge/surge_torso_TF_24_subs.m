%% Calculating the transfer functions (TFs) for the passive rider

% This script calculates the raw individual TFs of the upper body for 24 
% subjects. This means that for 24 subjects the gain, phase and coherence 
% are calculated with the Welch's method. Furthermore, TF of the mean rider 
% (= average of 24 subjects) is calculated. 

clear all 
close all 
clc

%% Load in- and output signals and subject body masses
load('surge_acc_signals_SI_t1_t2')     % input signal 
load('surge_acc_UB_signals_SI_t1_t2')          % output signal 

%body_mass_24subs = xlsread('body_mass_24subs'); % the total body mass of 24 indvidual subjects

%% Rename signals and choose trial number
u_acc_hexapod_signals = -surge_acc_signals_SI_t1;    % Input acc. signals 24 subjects trial 1 
% u_acc_hexapod_signals = -surge_acc_signals_SI_t2;   % Input acc. signals 24 subjects trial 2 

y_acc_UB_signals = surge_acc_UB_signals_SI_t1;  % Force signals 24 subjects trial 1 
% y_acc_UB_signals = surge_acc_UB_signals_SI_t2; % Force signals 24 subjects trial 2 

clearvars   surge_acc_signals_SI_t1 surge_acc_signals_SI_t2... 
            surge_acc_UB_signals_SI_t1 surge_acc_UB_signals_SI_t2

%% Constants
N   = 6000;                     % number of samples
fs  = 100;                      % sample frequency 
dt  = 1/fs;                     % time step between two samples
T   = N * dt;                   % total observation time
fv  = (0:1/T:fs-(1/T))';        % frequency vector

indv_linewidth = 1;             % linewidth for plots of indv. subjects
mean_linewidth = 2;             % linewidth for plot of mean rider
wcoh_siglevel_linewidth = 1.5;  % linewidth for the significance coherence leven
wcoh_siglevel_linestyle = '--'; % dashed line for the significance coherence leven
fontsize = 16;                  % general fontsize of figures  

indv_color = [0.7 0.7 0.7];     % grey color for plots of indv. subjects 
x_color    = 'r';               % red color for plot mean rider x-direction
y_color    = 'g';               % green color for plot mean rider y-direction
z_color    = 'b';               % blue color for plot mean rider z-direction
wcoh_siglevel_color = 'k';

std_deci_acc    = 2;            % number of decimals for std in plots
t               = (0:N-1).'*dt; % time vector

x_ticks       = [0.17 0.5 1 2 4 8 12];  % numbers which are shown on the x-axes
y_ticks       = [0 0.2 0.4 0.6 0.8 1];  % numbers which are shown on the x-axes

x_lim         = [0.1667 12];            % x-axis limit for frequency range
x_ticks_shade = [0.17 0.5 1 2 4 8 12];
x_lim_shade   = [0.1667 12];            % x-axis limit for frequency range

y_lim       = [10^-4 10];       % y-axis limit for normalised gain

std_shadow = 0.15;               % tranparency STD shadow

%% Subtract mean from input and output signal
% Input signals
u_acc_hexapod_signals = subtract_mean(u_acc_hexapod_signals);

% Output signals 
y_acc_UB_signals = subtract_mean(y_acc_UB_signals);

%% Welch averaging (time domain) 
% Welch averaging is averaging of the signals in time domain over N 
% segments. After averaging, for each segment the spectral densities are 
% calculated. This is done by the function welchspectrum.

Nsegment = 10;      % number of segment over which is averaged

nfft=round(N/Nsegment);

%% Calculate transfer function with Welch avaraging  
% Transfer functions 24 individual subjects
[wtf_UB,wfv]   = my_welch_method(u_acc_hexapod_signals,y_acc_UB_signals,nfft,fs);

% We are only interested in the frequency range of 0.5 - 12 Hz. The 
% corresponding sample numbers can be based on the frequency vector wfv.
% low_samp    = 1;    % sample number that contains te lowest frequency (0.5 Hz)
% high_samp   = 25;   % sample number that contains the highest frequency (12 Hz)
% 
% wfv = wfv(low_samp:high_samp);
% 
% wtf_UB = wtf_UB(low_samp:high_samp,:);

%% Calculate the magnitude 
% 24 individual subjects 
wtf_mag_UB     = calc_TF_magnitude(wtf_UB);

% Mean rider
wtf_mag_UB_mean_rider     = mean(wtf_mag_UB,2);

%% Calculate the phase, scale phase and unwrap
% 24 individual subjects
wtf_phase_UB     = calc_TF_phase(wtf_UB);

tol = 180;      % tolerance for unwrapping the phase (= degrees)

% Phase scaling and unwrapping
wtf_phase_UB  = phase_scaling(wtf_phase_UB);
wtf_phase_UB  = unwrap(wtf_phase_UB,tol);

% Mean rider
wtf_phase_UB_mean_rider = mean(wtf_phase_UB,2);

%% Calculate the coherence
% 24 individual subjects
wcoh_UB     = calc_coherence(u_acc_hexapod_signals,y_acc_UB_signals,nfft,fs);

% We are only interested in the frequency range of 0.5 - 12 Hz
%wcoh_UB = wcoh_UB(low_samp:high_samp,:);

% Mean rider
wcoh_UB_mean_rider     = mean(wcoh_UB,2);

% Calculate the significance level of the coherence
alpha = 0.05;                               % change taking statiscally the wrong descision. 
L_seg = Nsegment*0.5;                       % number of independent segments with 50% overlap
wcoh_siglevel = 1 - alpha^(1/(L_seg-1));    % significance level for coherence

%% Plot Gain, phase and coherence
figure('name','Gain, phase and coherence 24 subjects and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(311)
    %hold on; grid on;
    semilogx(wfv, wtf_mag_UB,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_UB_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks)  
    ylabel({'X-axis','Gain [-]'})
    set(gca,'FontSize',fontsize);
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.25, 0]); % Set Title with correct Position
subplot(312)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_UB, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_UB_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'X-axis','Phase [deg]'})
    set(gca,'FontSize',fontsize);
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.25, 0]); % Set Title with correct Position
subplot(313)
    %hold on; grid on;
    semilogx(wfv, wcoh_UB, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_UB_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    ylabel({'X-axis','\gamma^2 [-]'})
    xlabel('Frequency [Hz]');
    set(gca,'FontSize',fontsize);
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position

%% Plot Gain, phase and coherence with std shade

[average_phase_X,std_phase_X]=averagePhase(wtf_UB);

figure('name','Gain, phase and coherence 24 subjects and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(311)
subplot(311)
    %hold on; grid on;
    stdshade(wtf_mag_UB',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylabel({'X-axis','Gain [-]'})
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.25, 0]); % Set Title with correct Position
subplot(312)
   stdshade2(average_phase_X,std_phase_X,std_shadow,x_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    ylabel({'X-axis','Phase [deg]'})
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.25, 0]); % Set Title with correct Position
subplot(313)
    %hold on; grid on;
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB',std_shadow,x_color,wfv,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    ylabel({'X-axis','\gamma^2 [-]'})
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
    legend('CSL')