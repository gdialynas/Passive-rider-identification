%% Calculating the transfer functions (TFs) for the passive rider

% This script calculates the raw individual TFs of the upper body for 24 
% subjects. This means that for 24 subjects the gain, phase and coherence 
% are calculated with the Welch's method. Furthermore, TF of the mean rider 
% (= average of 24 subjects) is calculated. 

clear all 
close all 
clc

%% Load in- and output signals and subject body masses
load('heave_acc_signals_SI_t1_t2')     % input signal 
load('heave_acc_UB_signals_SI_t1_t2')  % output signal 
load('surge_acc_signals_SI_t1_t2')     % input signal 
load('surge_acc_UB_signals_SI_t1_t2')  % output signal
load('sway_acc_signals_SI_t1_t2')      % input signal 
load('sway_acc_UB_signals_SI_t1_t2')   % output signal

%body_mass_24subs = xlsread('body_mass_24subs'); % the total body mass of 24 indvidual subjects

%% Rename signals and choose trial number

% Heave
u_heave_acc_hexapod_signals = heave_acc_signals_SI_t1;    % Input acc. signals 24 subjects trial 1 
% u_heave_acc_hexapod_signals = heave_acc_signals_SI_t2;  % Input acc. signals 24 subjects trial 2 

y_heave_acc_UB_signals = heave_acc_UB_signals_SI_t1;      % Force signals 24 subjects trial 1 
% y_heave_acc_UB_signals = heave_acc_UB_signals_SI_t2;    % Force signals 24 subjects trial 2 

% Surge
u_surge_acc_hexapod_signals = -surge_acc_signals_SI_t1;    % Input acc. signals 24 subjects trial 1 
% u_surge_acc_hexapod_signals = -surge_acc_signals_SI_t2;  % Input acc. signals 24 subjects trial 2 

y_surge_acc_UB_signals = surge_acc_UB_signals_SI_t1;      % Force signals 24 subjects trial 1 
% y_surge_acc_UB_signals = surge_acc_UB_signals_SI_t2;    % Force signals 24 subjects trial 2 

% Sway
u_sway_acc_hexapod_signals = sway_acc_signals_SI_t1;      % Input acc. signals 24 subjects trial 1 
% u_sway_acc_hexapod_signals = sway_acc_signals_SI_t2;    % Input acc. signals 24 subjects trial 2 

y_sway_acc_UB_signals = sway_acc_UB_signals_SI_t1;        % Force signals 24 subjects trial 1 
% y_sway_acc_UB_signals = sway_acc_UB_signals_SI_t2;      % Force signals 24 subjects trial 2 


clearvars   heave_acc_signals_SI_t1 heave_acc_signals_SI_t2... 
            heave_acc_UB_signals_SI_t1 heave_acc_UB_signals_SI_t2...
            surge_acc_signals_SI_t1 surge_acc_signals_SI_t2... 
            surge_acc_UB_signals_SI_t1 surge_acc_UB_signals_SI_t2...
            sway_acc_signals_SI_t1 sway_acc_signals_SI_t2... 
            sway_acc_UB_signals_SI_t1 sway_acc_UB_signals_SI_t2
        
%% Constants
N   = 6000;                     % number of samples
fs  = 100;                      % sample frequency 
dt  = 1/fs;                     % time step between two samples
T   = N * dt;                   % total observation time
fv  = (0:1/T:fs-(1/T))';        % frequency vector

indv_linewidth = 1;             % linewidth for plots of indv. subjects
mean_linewidth = 2;             % linewidth for plot of mean rider
ref_sub_linewidth = 1.5;        % linewidth for plot of reference subjects
wcoh_siglevel_linewidth = 1.5;  % linewidth for the significance coherence leven
wcoh_siglevel_linestyle = '--'; % dashed line for the significance coherence leven
fontsize = 16;                  % general fontsize of figures  

indv_color = [0.7 0.7 0.7];     % grey color for plots of indv. subjects 
x_color    = [1 0.25 0.25];     % red color for plot mean rider x-direction
y_color    = [0 0.8 0.4];       % green color for plot mean rider y-direction
z_color    = [0 0.4 0.8];       % blue color for plot mean rider z-direction
wcoh_siglevel_color = 'k';

ref_sub = [2,12,19:24];         % subjects with specific mass
%col_sub14 = [0.8 0 0];
%col_sub03 = [0.9 0.4 0];
%col_sub10 = [0 0.4 0.8];
%col_sub17 = [0 0.6 0.1];

std_deci_acc    = 2;            % number of decimals for std in plots
t               = (0:N-1).'*dt; % time vector

x_ticks       = [0.17 0.5 1 2 4 8 12];  % numbers which are shown on the x-axes
x_lim         = [0.1667 12];            % x-axis limit for frequency range
y_ticks       = [0 0.2 0.4 0.6 0.8 1];  % numbers which are shown on the y-axes
x_ticks_shade = [0.17 0.5 1 2 4 8 12];
x_lim_shade   = [0.1667 12];            % x-axis limit for frequency range

y_lim       = [10^-4 10];       % y-axis limit for normalised gain

std_shadow = 0.2;               % tranparency STD shadow

%% Subtract mean from input and output signal
% Input signals
u_heave_acc_hexapod_signals = subtract_mean(u_heave_acc_hexapod_signals);
u_surge_acc_hexapod_signals = subtract_mean(u_surge_acc_hexapod_signals);
u_sway_acc_hexapod_signals  = subtract_mean(u_sway_acc_hexapod_signals);

% Output signals 
y_heave_acc_UB_signals = subtract_mean(y_heave_acc_UB_signals);
y_surge_acc_UB_signals = subtract_mean(y_surge_acc_UB_signals);
y_sway_acc_UB_signals  = subtract_mean(y_sway_acc_UB_signals);

%% Welch averaging (time domain) 
% Welch averaging is averaging of the signals in time domain over N 
% segments. After averaging, for each segment the spectral densities are 
% calculated. This is done by the function welchspectrum.

Nsegment = 10;      % number of segment over which is averaged

nfft=round(N/Nsegment);
 
% Transfer functions 24 individual subjects
[wtf_UB_heave,wfv] = my_welch_method(u_heave_acc_hexapod_signals,y_heave_acc_UB_signals,nfft,fs);
[wtf_UB_surge,~]   = my_welch_method(u_surge_acc_hexapod_signals,y_surge_acc_UB_signals,nfft,fs);
[wtf_UB_sway,~]    = my_welch_method(u_sway_acc_hexapod_signals,y_sway_acc_UB_signals,nfft,fs);

%% Calculate the magnitude 
% 24 individual subjects 
wtf_mag_UB_heave  = calc_TF_magnitude(wtf_UB_heave);
wtf_mag_UB_surge  = calc_TF_magnitude(wtf_UB_surge);
wtf_mag_UB_sway   = calc_TF_magnitude(wtf_UB_sway);

% Mean rider
wtf_mag_UB_mean_rider_heave = mean(wtf_mag_UB_heave,2);
wtf_mag_UB_mean_rider_surge = mean(wtf_mag_UB_surge,2);
wtf_mag_UB_mean_rider_sway  = mean(wtf_mag_UB_sway,2);

%% Calculate the phase, scale phase and unwrap
% 24 individual subjects
wtf_phase_UB_heave = calc_TF_phase(wtf_UB_heave);
wtf_phase_UB_surge = calc_TF_phase(wtf_UB_surge);
wtf_phase_UB_sway  = calc_TF_phase(wtf_UB_sway);

% Phase scaling and unwrapping
tol = 180;                      % tolerance for unwrapping the phase (= degrees)

wtf_phase_UB_heave  = phase_scaling(wtf_phase_UB_heave);
wtf_phase_UB_heave  = unwrap(wtf_phase_UB_heave,tol);
wtf_phase_UB_surge  = phase_scaling(wtf_phase_UB_surge);
wtf_phase_UB_surge  = unwrap(wtf_phase_UB_surge,tol);
wtf_phase_UB_sway   = phase_scaling(wtf_phase_UB_sway);
wtf_phase_UB_sway   = unwrap(wtf_phase_UB_sway,tol);

% Mean rider
wtf_phase_UB_mean_rider_heave = mean(wtf_phase_UB_heave,2);
wtf_phase_UB_mean_rider_surge = mean(wtf_phase_UB_surge,2);
wtf_phase_UB_mean_rider_sway  = mean(wtf_phase_UB_sway,2);

%% Calculate the coherence
% 24 individual subjects
wcoh_UB_heave = calc_coherence(u_heave_acc_hexapod_signals,y_heave_acc_UB_signals,nfft,fs);
wcoh_UB_surge = calc_coherence(u_surge_acc_hexapod_signals,y_surge_acc_UB_signals,nfft,fs);
wcoh_UB_sway  = calc_coherence(u_sway_acc_hexapod_signals,y_sway_acc_UB_signals,nfft,fs);

% Mean rider
wcoh_UB_mean_rider_heave = mean(wcoh_UB_heave,2);
wcoh_UB_mean_rider_surge = mean(wcoh_UB_surge,2);
wcoh_UB_mean_rider_sway  = mean(wcoh_UB_sway,2);

% Calculate the significance level of the coherence
alpha = 0.05;                               % change taking statiscally the wrong descision. 
L_seg = Nsegment*0.5;                       % number of independent segments with 50% overlap
wcoh_siglevel = 1 - alpha^(1/(L_seg-1));    % significance level for coherence

%% Plot Gain, phase and coherence
figure('name','Gain, phase and coherence 24 subjects and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(331)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_mag_UB_surge,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_mag_UB_surge(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_mag_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim_shade)
    xticks(x_ticks)  
    ylabel({'Surge','X-axis'})
    set(gca,'FontSize',fontsize);
    %%lgd.FontSize = 13;
    title('Gain [-]');
subplot(332)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_phase_UB_surge, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_phase_UB_surge(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_phase_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim)
    ylim([-400  400]);
    xticks(x_ticks)
    set(gca,'FontSize',fontsize);
    title('Phase [deg]');
subplot(333)
    %hold on; grid on;
    p1 = semilogx(wfv, wcoh_UB_surge, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wcoh_UB_surge(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wcoh_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    p3 = line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca,'FontSize',fontsize);
    title('Coherence [-]');
    legend([p3(1)],'CSL')
subplot(334)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_mag_UB_sway,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_mag_UB_sway(:,ref_sub),'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_mag_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim_shade)
    xticks(x_ticks)  
    ylabel({'Sway','Y-axis'})
    set(gca,'FontSize',fontsize);
subplot(335)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_phase_UB_sway, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_phase_UB_sway(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_phase_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim)
    ylim([-200  200]);
    xticks(x_ticks)
    set(gca,'FontSize',fontsize);
subplot(336)
    %hold on; grid on;
    p1 = semilogx(wfv, wcoh_UB_sway, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wcoh_UB_sway(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wcoh_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    p3 = line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    set(gca,'FontSize',fontsize);
    legend([p3(1)],'CSL')
subplot(337)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_mag_UB_heave,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_mag_UB_heave(:,ref_sub),'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_mag_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim_shade)
    xticks(x_ticks)  
    ylabel({'Heave','Z-axis'})
    xlabel('Frequency [Hz]');
    set(gca,'FontSize',fontsize);
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
subplot(338)
    %hold on; grid on;
    p1 = semilogx(wfv, wtf_phase_UB_heave, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wtf_phase_UB_heave(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wtf_phase_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca,'FontSize',fontsize);
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
subplot(339)
    %hold on; grid on;
    p1 = semilogx(wfv, wcoh_UB_heave, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    p2 = semilogx(wfv(:,ref_sub), wcoh_UB_heave(:,ref_sub), 'linewidth', ref_sub_linewidth); hold on; grid on; box off
    %semilogx(wfv, wcoh_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    %set(p2, {'color'}, {col_sub14; col_sub03; col_sub10; col_sub17});
    p3 = line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca,'FontSize',fontsize);
    legend([p3(1)],'CSL')
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    
% figure('name','Gain, phase and coherence 24 subjects and mean rider')
% wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
% subplot(331)
%     %hold on; grid on;
%     semilogx(wfv, wtf_mag_UB_surge,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_mag_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim_shade)
%     xticks(x_ticks)  
%     ylabel('X-axis')
%     set(gca,'FontSize',fontsize);
%     title('Gain [-]');
% subplot(332)
%     %hold on; grid on;
%     semilogx(wfv, wtf_phase_UB_surge, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_phase_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     %ylim([-180  180]);
%     xticks(x_ticks)
%     set(gca,'FontSize',fontsize);
%     title('Phase [deg]');
% subplot(333)
%     %hold on; grid on;
%     semilogx(wfv, wcoh_UB_surge, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wcoh_UB_mean_rider_surge, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
%     ylim([0 1])
%     xlim(x_lim)
%     xticks(x_ticks)
%     xlabel('Frequency [Hz]');
%     set(gca,'FontSize',fontsize);
%     title('Coherence [-]');
% subplot(334)
%     %hold on; grid on;
%     semilogx(wfv, wtf_mag_UB_sway,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_mag_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim_shade)
%     xticks(x_ticks)  
%     ylabel('Y-axis')
%     set(gca,'FontSize',fontsize);
% subplot(335)
%     %hold on; grid on;
%     semilogx(wfv, wtf_phase_UB_sway, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_phase_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim)
%     %ylim([-180  180]);
%     xticks(x_ticks)
%     set(gca,'FontSize',fontsize);
% subplot(336)
%     %hold on; grid on;
%     semilogx(wfv, wcoh_UB_sway, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wcoh_UB_mean_rider_sway, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
%     ylim([0 1])
%     xlim(x_lim)
%     xticks(x_ticks)
%     set(gca,'FontSize',fontsize);
% subplot(337)
%     %hold on; grid on;
%     semilogx(wfv, wtf_mag_UB_heave,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_mag_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_shade)
%     xticks(x_ticks)  
%     ylabel('Z-axis')
%     xlabel('Frequency [Hz]');
%     set(gca,'FontSize',fontsize);
%     title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
% subplot(338)
%     %hold on; grid on;
%     semilogx(wfv, wtf_phase_UB_heave, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wtf_phase_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     %ylim([-180  180]);
%     xticks(x_ticks)
%     xlabel('Frequency [Hz]');
%     set(gca,'FontSize',fontsize);
%     title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
% subplot(339)
%     %hold on; grid on;
%     semilogx(wfv, wcoh_UB_heave, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     semilogx(wfv, wcoh_UB_mean_rider_heave, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
%     ylim([0 1])
%     xlim(x_lim)
%     xticks(x_ticks)
%     xlabel('Frequency [Hz]');
%     set(gca,'FontSize',fontsize);
%     title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
   
%% Plot Gain, phase and coherence with std shade
figure('name','Gain, phase and coherence 24 subjects and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(331)
    %hold on; grid on;
    stdshade(wtf_mag_UB_surge',std_shadow,x_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel({'Surge','X-axis'})
    set(gca, 'XScale', 'log','FontSize',fontsize)
    %legend('Longitudinal direction');
    title('Gain [-]');
subplot(332)
    stdshade(wtf_phase_UB_surge',std_shadow,x_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('Phase [deg]');
subplot(333)
    %hold on; grid on;
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_surge',std_shadow,x_color,wfv,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    legend('CSL')
    title('Coherence [-]');
subplot(334)
    %hold on; grid on;
    stdshade(wtf_mag_UB_sway',std_shadow,y_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel({'Sway','Y-axis'})
    %legend('Lateral direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(335)
    stdshade(wtf_phase_UB_sway',std_shadow,y_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(336)
    %hold on; grid on;
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_sway',std_shadow,y_color,wfv,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    legend('CSL')
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(337)
    %hold on; grid on;
    stdshade(wtf_mag_UB_heave',std_shadow,z_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade) 
    ylabel({'Heave','Z-axis'})
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    %legend('Vertical direction');
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
subplot(338)
    stdshade(wtf_phase_UB_heave',std_shadow,z_color,wfv,[]); hold on; grid on; box off
    xlim(x_lim_shade)
    xticks(x_ticks_shade)     
    %ylim([-180  180]);
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
subplot(339)
    %hold on; grid on;
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);hold on; grid on; box off
    stdshade(wcoh_UB_heave',std_shadow,z_color,wfv,[]); 
    ylim([0 1])
    xlim(x_lim_shade)
    xticks(x_ticks_shade)
    ylim([0  1]);
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    legend('CSL')