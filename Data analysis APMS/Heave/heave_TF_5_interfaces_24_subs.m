%% Calculating the transfer functions (TFs) for the passive rider

% Author: Jelle Waling de Haan
% Graduation project: Passive Rider Identification 
% Script: Calculating individual TFs, TF mean rider, normalised TFs and normalised TF
% mean rider with STD.
% Last update: 04-03-2019
 
% This script calculates the raw individual TFs for 24 subjects. This means
% that for 24 subjects the gain, phase and coherence are calculated.
% Furthermore, TF of the mean rider (= average of 24 subjects) is
% calculated. Also, the normalised TFs for individual subjects and the mean
% rider are calculated. For all subjects the transfer functions in the seat 
% post, left Footpeg, right Footpeg, left handlebar and right handlebar 
% are calculated. 

clear all 
close all  
clc

%% Load in- and output signals and subject body masses
load('heave_acc_signals_SI_t1_t2')   % input signal (m/s^2)
load('heave_force_signals_SI_t1_t2') % output signal (N)

body_mass_24subs = xlsread('body_mass_24subs'); % the total body mass of 24 indvidual subjects

%% Rename signals and choose trial number
u_acc_signals = heave_acc_signals_SI_t1;    % Acc. signals 24 subjects trial 1 
%u_acc_signals = heave_acc_signals_SI_t2;   % Acc. signals 24 subjects trial 2 

y_force_signals = heave_force_signals_SI_t1;  % Force signals 24 subjects trial 1 
%y_force_signals = heave_force_signals_SI_t2; % Force signals 24 subjects trial 2 

clearvars   heave_acc_signals_SI_t1 heave_acc_signals_SI_t2... 
            heave_force_signals_SI_t1 heave_force_signals_SI_t2

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
fontsize_time_signals = 13;     % fontsize of figures for force time signals;
fontsize_indv_TF = 14;          % fontsize of individual TF's    

indv_color = [0.7 0.7 0.7];     % grey color for plots of indv. subjects 
x_color    = 'r';               % red color for plot mean rider x-direction
y_color    = 'g';               % green color for plot mean rider y-direction
z_color    = 'b';               % blue color for plot mean rider z-direction
wcoh_siglevel_color = 'k';

std_deci_acc    = 2;            % number of decimals for std in plots
t               = (0:N-1).'*dt; % time vector

x_ticks         = [0.17 0.5 1 2 4 8 12];        % numbers which are shown on the x-axes
x_lim           = [0.1667 12];                  % x-axis limit for frequency range
%y_ticks         = [10^-2 10^-1  10^0 10^1 10^2 10^3];
y_ticks       = [0 0.2 0.4 0.6 0.8 1];          % numbers which are shown on the x-axes
y_lim           = [10^-2 10^3];                 % y-axis limit for individual gain
y_ticks_norm    = [0.001 0.01 0.1 1 10];        % numbers which are shown on the y-axes
y_lim_norm      = [10^-4 10];                   % y-axis limit for normalised gain

std_shadow = 0.2;               % tranparency STD shadow

%% Plot signals in time domain
sub = 1;

figure()
subplot(3,6,1)
    plot(t,zeros(size(t)),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'X-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in longitudinal direction');
    lgd.FontSize = fontsize;
    title('Hexapod','FontSize',fontsize)
subplot(3,6,7)
    plot(t,zeros(size(t)),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'Y-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in lateral direction');
    lgd.FontSize = fontsize;
    title('Hexapod','FontSize',fontsize)
subplot(3,6,13)
    plot(t,u_acc_signals(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    ylabel({'Z-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in vertical direction');
    lgd.FontSize = fontsize;
    title(['Hexapod: \mu=', num2str(round(mean(u_acc_signals(:,sub)))),' \sigma=', num2str(round(std(u_acc_signals(:,sub)),std_deci_acc))],'FontSize',fontsize) 
subplot(3,6,2)
    plot(t,y_force_signals{1}(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_X: \mu=', num2str(round(mean(y_force_signals{1}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{1}(:,sub))))],'FontSize',fontsize);
subplot(3,6,8)
    plot(t,y_force_signals{2}(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_Y: \mu=', num2str(round(mean(y_force_signals{2}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{2}(:,sub))))],'FontSize',fontsize);
subplot(3,6,14)
    plot(t,y_force_signals{3}(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    xlabel('Time [s]');
    title(['SP_Z: \mu=', num2str(round(mean(y_force_signals{3}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{3}(:,sub))))],'FontSize',fontsize);
subplot(3,6,3)
    plot(t,y_force_signals{4}(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['FPL_X: \mu=', num2str(round(mean(y_force_signals{4}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{4}(:,sub))))],'FontSize',fontsize);
    set(gca,'FontSize',fontsize_time_signals)
subplot(3,6,15)
    plot(t,y_force_signals{5}(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]');
    title(['FPL_Z: \mu=', num2str(round(mean(y_force_signals{5}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{5}(:,sub))))],'FontSize',fontsize);
subplot(3,6,4)
    plot(t,y_force_signals{6}(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['FPR_X: \mu=', num2str(round(mean(y_force_signals{6}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{6}(:,sub))))],'FontSize',fontsize);
subplot(3,6,16)
    plot(t,y_force_signals{7}(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]');
    title(['FPR_Z: \mu=', num2str(round(mean(y_force_signals{7}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{7}(:,sub))))],'FontSize',fontsize);
subplot(3,6,5)
    plot(t,y_force_signals{8}(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title('HBL_X');
    title(['HBL_X: \mu=', num2str(round(mean(y_force_signals{8}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{8}(:,sub))))],'FontSize',fontsize);
subplot(3,6,11)
    plot(t,y_force_signals{9}(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBL_Y: \mu=', num2str(round(mean(y_force_signals{9}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{9}(:,sub))))],'FontSize',fontsize);
subplot(3,6,17)
    plot(t,y_force_signals{10}(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]');
    title(['HBL_Z: \mu=', num2str(round(mean(y_force_signals{10}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{10}(:,sub))))],'FontSize',fontsize);
subplot(3,6,6)
    plot(t,y_force_signals{11}(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_X: \mu=', num2str(round(mean(y_force_signals{11}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{11}(:,sub))))],'FontSize',fontsize);
subplot(3,6,12)
    plot(t,y_force_signals{12}(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_Y: \mu=', num2str(round(mean(y_force_signals{12}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{12}(:,sub))))],'FontSize',fontsize);
subplot(3,6,18)
    plot(t,y_force_signals{13}(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]');
    title(['HBR_Z: \mu=', num2str(round(mean(y_force_signals{13}(:,sub)))),' \sigma=', num2str(round(std(y_force_signals{13}(:,sub))))],'FontSize',fontsize);
   
%% Calculate mean and STD of force time signals of mean rider
u_acc_mean_rider         = mean(u_acc_signals,2);
%u_acc_mean_rider         = u_acc_mean_rider - mean(u_acc_mean_rider);

y_force_SP_X_mean_rider  = mean(y_force_signals{1},2);
y_force_SP_Y_mean_rider  = mean(y_force_signals{2},2);
y_force_SP_Z_mean_rider  = mean(y_force_signals{3},2);

y_force_FPL_X_mean_rider  = mean(y_force_signals{4},2);
y_force_FPL_Z_mean_rider  = mean(y_force_signals{5},2);

y_force_FPR_X_mean_rider  = mean(y_force_signals{6},2);
y_force_FPR_Z_mean_rider  = mean(y_force_signals{7},2);

y_force_HBL_X_mean_rider  = mean(y_force_signals{8},2);
y_force_HBL_Y_mean_rider  = mean(y_force_signals{9},2);
y_force_HBL_Z_mean_rider  = mean(y_force_signals{10},2);

y_force_HBR_X_mean_rider  = mean(y_force_signals{11},2);
y_force_HBR_Y_mean_rider  = mean(y_force_signals{12},2);
y_force_HBR_Z_mean_rider  = mean(y_force_signals{13},2);

figure()
subplot(3,6,1)
    plot(t,zeros(size(t)),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'X-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in longitudinal direction');
    lgd.FontSize = fontsize;
    title('Hexapod','FontSize',fontsize);
subplot(3,6,7)
    plot(t,zeros(size(t)),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'Y-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in lateral direction');
    lgd.FontSize = fontsize;
    title('Hexapod','FontSize',fontsize)
subplot(3,6,13)
    plot(t,u_acc_mean_rider,'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    ylabel({'Z-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in vertical direction');
    lgd.FontSize = fontsize;
    title(['Hexapod: \mu=', num2str(round(mean(u_acc_mean_rider))),' \sigma=', num2str(round(std(u_acc_mean_rider),std_deci_acc))],'FontSize',fontsize)
subplot(3,6,2) 
    plot(t,y_force_SP_X_mean_rider,'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_X: \mu=', num2str(round(mean(y_force_SP_X_mean_rider))),' \sigma=', num2str(round(std(y_force_SP_X_mean_rider)))],'FontSize',fontsize);
subplot(3,6,8)
    plot(t,y_force_SP_Y_mean_rider,'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_Y: \mu=', num2str(round(mean(y_force_SP_Y_mean_rider))),' \sigma=', num2str(round(std(y_force_SP_Y_mean_rider)))],'FontSize',fontsize);
subplot(3,6,14)
    plot(t,y_force_SP_Z_mean_rider,'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    xlabel('Time [s]','FontSize',fontsize);
    title(['SP_Z: \mu=', num2str(round(mean(y_force_SP_Z_mean_rider))),' \sigma=', num2str(round(std(y_force_SP_Z_mean_rider)))],'FontSize',fontsize);
subplot(3,6,3)
    plot(t,y_force_FPL_X_mean_rider,'Color', x_color); hold on; box off
    title(['FPL_X: \mu=', num2str(round(mean(y_force_FPL_X_mean_rider))),' \sigma=', num2str(round(std(y_force_FPL_X_mean_rider)))],'FontSize',fontsize);
subplot(3,6,15)
    plot(t,y_force_FPL_Z_mean_rider,'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['FPL_Z: \mu=', num2str(round(mean(y_force_FPL_Z_mean_rider))),' \sigma=', num2str(round(std(y_force_FPL_Z_mean_rider)))],'FontSize',fontsize);
subplot(3,6,4)
    plot(t,y_force_FPR_X_mean_rider,'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['FPR_X: \mu=', num2str(round(mean(y_force_FPR_X_mean_rider))),' \sigma=', num2str(round(std(y_force_FPR_X_mean_rider)))],'FontSize',fontsize);
subplot(3,6,16)
    plot(t,y_force_FPR_Z_mean_rider,'Color', z_color); hold on; box off
    xlabel('Time [s]','FontSize',fontsize);
    title(['FPR_Z: \mu=', num2str(round(mean(y_force_FPR_Z_mean_rider))),' \sigma=', num2str(round(std(y_force_FPR_Z_mean_rider)))],'FontSize',fontsize);
subplot(3,6,5)
    plot(t,y_force_HBL_X_mean_rider,'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title('HBL_X');
    title(['HBL_X: \mu=', num2str(round(mean(y_force_HBL_X_mean_rider))),' \sigma=', num2str(round(std(y_force_HBL_X_mean_rider)))],'FontSize',fontsize);
subplot(3,6,11)
    plot(t,y_force_HBL_Y_mean_rider,'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBL_Y: \mu=', num2str(round(mean(y_force_HBL_Y_mean_rider))),' \sigma=', num2str(round(std(y_force_HBL_Y_mean_rider)))],'FontSize',fontsize);
subplot(3,6,17)
    plot(t,y_force_HBL_Z_mean_rider,'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['HBL_Z: \mu=', num2str(round(mean(y_force_HBL_Z_mean_rider))),' \sigma=', num2str(round(std(y_force_HBL_Z_mean_rider)))],'FontSize',fontsize);
subplot(3,6,6)
    plot(t,y_force_HBR_X_mean_rider,'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_X: \mu=', num2str(round(mean(y_force_HBR_X_mean_rider))),' \sigma=', num2str(round(std(y_force_HBR_X_mean_rider)))],'FontSize',fontsize);
subplot(3,6,12)
    plot(t,y_force_HBR_Y_mean_rider,'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_Y: \mu=', num2str(round(mean(y_force_HBR_Y_mean_rider))),' \sigma=', num2str(round(std(y_force_HBR_Y_mean_rider)))],'FontSize',fontsize);
subplot(3,6,18)
    plot(t,y_force_HBR_Z_mean_rider,'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['HBR_Z: \mu=', num2str(round(mean(y_force_HBR_Z_mean_rider))),' \sigma=', num2str(round(std(y_force_HBR_Z_mean_rider)))],'FontSize',fontsize);
    
%% Prescribe force signals to interfaces and apply correct sign convention
% 24 individual subjects  
y_force_SP_X_24subs  = -y_force_signals{1};
y_force_SP_Y_24subs  = y_force_signals{2};
y_force_SP_Z_24subs  = -y_force_signals{3};

y_force_FPL_X_24subs = -y_force_signals{4};
y_force_FPL_Z_24subs = -y_force_signals{5};

y_force_FPR_X_24subs =  y_force_signals{6};
y_force_FPR_Z_24subs = -y_force_signals{7};

y_force_HBL_X_24subs = -y_force_signals{8}+0.14402*y_force_signals{10}; %taking out crosstalk for a vertical applied force
y_force_HBL_Y_24subs = -y_force_signals{9};
y_force_HBL_Z_24subs = -y_force_signals{10};

y_force_HBR_X_24subs = -y_force_signals{11}+0.14402*y_force_signals{13};
y_force_HBR_Y_24subs = y_force_signals{12};
y_force_HBR_Z_24subs = -y_force_signals{13};

%% Plot signals in frequency domain
% Auto-spectral density of input signal
U_acc_signals = fft(detrend(u_acc_signals(:,sub)));
U_acc_signals = U_acc_signals.*conj(U_acc_signals);

% Auto-spectral density of output signals
Y_force_SP_X_24subs  = fft(detrend(y_force_SP_X_24subs(:,sub))); 
Y_force_SP_X_24subs  = Y_force_SP_X_24subs.*conj(Y_force_SP_X_24subs);
Y_force_SP_Y_24subs  = fft(detrend(y_force_SP_Y_24subs(:,sub)));  
Y_force_SP_Y_24subs  = Y_force_SP_Y_24subs.*conj(Y_force_SP_Y_24subs);
Y_force_SP_Z_24subs  = fft(detrend(y_force_SP_Z_24subs(:,sub))); 
Y_force_SP_Z_24subs  = Y_force_SP_Z_24subs.*conj(Y_force_SP_Z_24subs);

Y_force_FPL_X_24subs  = fft(detrend(y_force_FPL_X_24subs(:,sub))); 
Y_force_FPL_X_24subs  = Y_force_FPL_X_24subs.*conj(Y_force_FPL_X_24subs);
Y_force_FPL_Z_24subs  = fft(detrend(y_force_FPL_Z_24subs(:,sub))); 
Y_force_FPL_Z_24subs  = Y_force_FPL_Z_24subs.*conj(Y_force_FPL_Z_24subs);  

Y_force_FPR_X_24subs  = fft(detrend(y_force_FPR_X_24subs(:,sub))); 
Y_force_FPR_X_24subs  = Y_force_FPR_X_24subs.*conj(Y_force_FPR_X_24subs);
Y_force_FPR_Z_24subs  = fft(detrend(y_force_FPR_Z_24subs(:,sub))); 
Y_force_FPR_Z_24subs  = Y_force_FPR_Z_24subs.*conj(Y_force_FPR_Z_24subs); 

Y_force_HBL_X_24subs  = fft(detrend(y_force_HBL_X_24subs(:,sub))); 
Y_force_HBL_X_24subs  = Y_force_HBL_X_24subs.*conj(Y_force_HBL_X_24subs);
Y_force_HBL_Y_24subs  = fft(detrend(y_force_HBL_Y_24subs(:,sub)));  
Y_force_HBL_Y_24subs  = Y_force_HBL_Y_24subs.*conj(Y_force_HBL_Y_24subs);
Y_force_HBL_Z_24subs  = fft(detrend(y_force_HBL_Z_24subs(:,sub))); 
Y_force_HBL_Z_24subs  = Y_force_HBL_Z_24subs.*conj(Y_force_HBL_Z_24subs);

Y_force_HBR_X_24subs  = fft(detrend(y_force_HBR_X_24subs(:,sub))); 
Y_force_HBR_X_24subs  = Y_force_HBR_X_24subs.*conj(Y_force_HBR_X_24subs);
Y_force_HBR_Y_24subs  = fft(detrend(y_force_HBR_Y_24subs(:,sub)));  
Y_force_HBR_Y_24subs  = Y_force_HBR_Y_24subs.*conj(Y_force_HBR_Y_24subs);
Y_force_HBR_Z_24subs  = fft(detrend(y_force_HBR_Z_24subs(:,sub))); 
Y_force_HBR_Z_24subs  = Y_force_HBR_Z_24subs.*conj(Y_force_HBR_Z_24subs);  

figure()
subplot(3,6,1)
    line([0,length(u_acc_signals(:,sub))],[0,0],'Color', x_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel({'\bf X-axis','Magnitude [-]'})
    title('Hexapod Acc.')
subplot(3,6,7)
    line([0,length(u_acc_signals(:,sub))],[0,0],'Color', y_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel({'\bf Y-axis','Magnitude [-]'})
    title('Hexapod Acc.')
subplot(3,6,13)
    loglog(fv(1:N/2),U_acc_signals(1:N/2),'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel({'\bf Z-axis','Magnitude [-]'})
    title('Hexapod Acc.')
subplot(3,6,2)
    loglog(fv(1:N/2),Y_force_SP_X_24subs(1:N/2),'Color', x_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force SP_X');
subplot(3,6,8)
    loglog(fv(1:N/2),Y_force_SP_Y_24subs(1:N/2),'Color', y_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force SP_Y');
subplot(3,6,14)
    loglog(fv(1:N/2),Y_force_SP_Z_24subs(1:N/2),'Color', z_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    xlabel('Frequency [Hz]');
    title('Force SP_Z');
subplot(3,6,3)
    loglog(fv(1:N/2),Y_force_FPL_X_24subs(1:N/2),'Color', x_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('FPL_X');
subplot(3,6,15)
    loglog(fv(1:N/2),Y_force_FPL_Z_24subs(1:N/2),'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [-]');
    title('Force FPL_Z');
subplot(3,6,4)
    loglog(fv(1:N/2),Y_force_FPR_X_24subs(1:N/2),'Color', x_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force FPR_X');
subplot(3,6,16)
    loglog(fv(1:N/2),Y_force_FPR_Z_24subs(1:N/2),'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [-]');
    title('Force FPR_Z');
subplot(3,6,5)
    loglog(fv(1:N/2),Y_force_HBL_X_24subs(1:N/2),'Color', x_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force HBL_X');
subplot(3,6,11)
    loglog(fv(1:N/2),Y_force_HBL_Y_24subs(1:N/2),'Color', y_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force HBL_Y');
subplot(3,6,17)
    loglog(fv(1:N/2),Y_force_HBL_Z_24subs(1:N/2),'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [-]');
    title('Force HBL_Z');
subplot(3,6,6)
    loglog(fv(1:N/2),Y_force_HBR_X_24subs(1:N/2),'Color', x_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force HBR_X');
subplot(3,6,12)
    loglog(fv(1:N/2),Y_force_HBR_Y_24subs(1:N/2),'Color', y_color); hold on; grid on; box off
    ylabel('Magnitude [-]');
    title('Force HBR_Y');
subplot(3,6,18)
    loglog(fv(1:N/2),Y_force_HBR_Z_24subs(1:N/2),'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel('Magnitude [-]');
    title('Force HBR_Z');
    suptitle('\bf Heave input and output signals in frequency domain');
    
%% Subtract mean from input and output signal
% Input signals
u_acc_signals        = subtract_mean(u_acc_signals);

% Output signals
y_force_SP_X_24subs  = subtract_mean(y_force_SP_X_24subs);
y_force_SP_Y_24subs  = subtract_mean(y_force_SP_Y_24subs);
y_force_SP_Z_24subs  = subtract_mean(y_force_SP_Z_24subs);

y_force_FPL_X_24subs = subtract_mean(y_force_FPL_X_24subs);
y_force_FPL_Z_24subs = subtract_mean(y_force_FPL_Z_24subs);

y_force_FPR_X_24subs = subtract_mean(y_force_FPR_X_24subs);
y_force_FPR_Z_24subs = subtract_mean(y_force_FPR_Z_24subs);

y_force_HBL_X_24subs = subtract_mean(y_force_HBL_X_24subs);
y_force_HBL_Y_24subs = subtract_mean(y_force_HBL_Y_24subs);
y_force_HBL_Z_24subs = subtract_mean(y_force_HBL_Z_24subs);

y_force_HBR_X_24subs = subtract_mean(y_force_HBR_X_24subs);
y_force_HBR_Y_24subs = subtract_mean(y_force_HBR_Y_24subs);
y_force_HBR_Z_24subs = subtract_mean(y_force_HBR_Z_24subs);

figure()
subplot(3,6,1)
    plot(t,zeros(size(t)),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'X-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in longitudinal direction');
    lgd.FontSize = fontsize;
    title('Hexapod Acc.','FontSize',fontsize)
subplot(3,6,7)
    plot(t,zeros(size(t)),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel({'Y-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in lateral direction');
    lgd.FontSize = fontsize;
    title('Hexapod Acc.','FontSize',fontsize)
subplot(3,6,13)
    plot(t,u_acc_signals(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    ylabel({'Z-axis','Acc. [m/s^2]'},'FontSize',fontsize)
    lgd = legend('Acc. and force in vertical direction');
    lgd.FontSize = fontsize;
    title(['Hexapod Acc.: \mu=', num2str(round(mean(u_acc_signals(:,sub)))),' \sigma=', num2str(round(std(u_acc_signals(:,sub)),std_deci_acc))],'FontSize',fontsize)
subplot(3,6,2) 
    plot(t,y_force_SP_X_24subs(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_X: \mu=', num2str(round(mean(y_force_SP_X_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_SP_X_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,8)
    plot(t,y_force_SP_Y_24subs(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    title(['SP_Y: \mu=', num2str(round(mean(y_force_SP_Y_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_SP_Y_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,14)
    plot(t,y_force_SP_Z_24subs(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    ylabel('Force [N]','FontSize',fontsize);
    xlabel('Time [s]','FontSize',fontsize);
    title(['SP_Z: \mu=', num2str(round(mean(y_force_SP_Z_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_SP_Z_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,3)
    plot(t,y_force_FPL_X_24subs(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['FPL_X: \mu=', num2str(round(mean(y_force_FPL_X_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_FPL_X_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,15)
    plot(t,y_force_FPL_Z_24subs(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['FPL_Z: \mu=', num2str(round(mean(y_force_FPL_Z_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_FPL_Z_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,4)
    plot(t,y_force_FPR_X_24subs(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['FPR_X: \mu=', num2str(round(mean(y_force_FPR_X_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_FPR_X_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,16)
    plot(t,y_force_FPR_Z_24subs(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['FPR_Z: \mu=', num2str(round(mean(y_force_FPR_Z_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_FPR_Z_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,5)
    plot(t,y_force_HBL_X_24subs(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title('HBL_X');
    title(['HBL_X: \mu=', num2str(round(mean(y_force_HBL_X_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBL_X_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,11)
    plot(t,y_force_HBL_Y_24subs(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBL_Y: \mu=', num2str(round(mean(y_force_HBL_Y_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBL_Y_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,17)
    plot(t,y_force_HBL_Z_24subs(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['HBL_Z: \mu=', num2str(round(mean(y_force_HBL_Z_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBL_Z_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,6)
    plot(t,y_force_HBR_X_24subs(:,sub),'Color', x_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_X: \mu=', num2str(round(mean(y_force_HBR_X_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBR_X_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,12)
    plot(t,y_force_HBR_Y_24subs(:,sub),'Color', y_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    title(['HBR_Y: \mu=', num2str(round(mean(y_force_HBR_Y_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBR_Y_24subs(:,sub))))],'FontSize',fontsize);
subplot(3,6,18)
    plot(t,y_force_HBR_Z_24subs(:,sub),'Color', z_color); hold on; box off
    set(gca,'FontSize',fontsize_time_signals)
    xlabel('Time [s]','FontSize',fontsize);
    title(['HBR_Z: \mu=', num2str(round(mean(y_force_HBR_Z_24subs(:,sub)))),' \sigma=', num2str(round(std(y_force_HBR_Z_24subs(:,sub))))],'FontSize',fontsize);
    
%% Welch averaging (time domain) 
% Welch averaging is averaging of the signals in time domain over N 
% segments. After averaging, for each segment the spectral densities are 
% calculated. This is done by the function welchspectrum.

Nsegment = 10;           % number of segments over which is averaged
nfft=round(N/Nsegment); % number of samples per segment
 
% Transfer functions 24 individual subjects
[wtf_SP_X,wfv]   = my_welch_method(u_acc_signals,y_force_SP_X_24subs,nfft,fs);
[wtf_SP_Y,~]     = my_welch_method(u_acc_signals,y_force_SP_Y_24subs,nfft,fs);
[wtf_SP_Z,~]     = my_welch_method(u_acc_signals,y_force_SP_Z_24subs,nfft,fs);

[wtf_FPL_X,~]    = my_welch_method(u_acc_signals,y_force_FPL_X_24subs,nfft,fs);
[wtf_FPL_Z,~]    = my_welch_method(u_acc_signals,y_force_FPL_Z_24subs,nfft,fs);

[wtf_FPR_X,~]    = my_welch_method(u_acc_signals,y_force_FPR_X_24subs,nfft,fs);
[wtf_FPR_Z,~]    = my_welch_method(u_acc_signals,y_force_FPR_Z_24subs,nfft,fs);

[wtf_HBL_X,~]    = my_welch_method(u_acc_signals,y_force_HBL_X_24subs,nfft,fs);
[wtf_HBL_Y,~]    = my_welch_method(u_acc_signals,y_force_HBL_Y_24subs,nfft,fs);
[wtf_HBL_Z,~]    = my_welch_method(u_acc_signals,y_force_HBL_Z_24subs,nfft,fs);

[wtf_HBR_X,~]    = my_welch_method(u_acc_signals,y_force_HBR_X_24subs,nfft,fs);
[wtf_HBR_Y,~]    = my_welch_method(u_acc_signals,y_force_HBR_Y_24subs,nfft,fs);
[wtf_HBR_Z,~]    = my_welch_method(u_acc_signals,y_force_HBR_Z_24subs,nfft,fs);

% We are only interested in the frequency range of 0.5 - 12 Hz. The 
% corresponding sample numbers can be based on the frequency vector wfv.
% low_samp    = 1;    % sample number that contains te lowest frequency (0.5 Hz)
% high_samp   = 73;   % sample number that contains the highest frequency (12 Hz)
% 
% wfv = wfv(low_samp:high_samp);
% 
% wtf_SP_X = wtf_SP_X(low_samp:high_samp,:);
% wtf_SP_Y = wtf_SP_Y(low_samp:high_samp,:);
% wtf_SP_Z = wtf_SP_Z(low_samp:high_samp,:);
% 
% wtf_FPL_X = wtf_FPL_X(low_samp:high_samp,:);
% wtf_FPL_Z = wtf_FPL_Z(low_samp:high_samp,:);
% 
% wtf_FPR_X = wtf_FPR_X(low_samp:high_samp,:);
% wtf_FPR_Z = wtf_FPR_Z(low_samp:high_samp,:);
% 
% wtf_HBL_X = wtf_HBL_X(low_samp:high_samp,:);
% wtf_HBL_Y = wtf_HBL_Y(low_samp:high_samp,:);
% wtf_HBL_Z = wtf_HBL_Z(low_samp:high_samp,:);
% 
% wtf_HBR_X = wtf_HBR_X(low_samp:high_samp,:);
% wtf_HBR_Y = wtf_HBR_Y(low_samp:high_samp,:);
% wtf_HBR_Z = wtf_HBR_Z(low_samp:high_samp,:);

%% Calculate the magnitude 
% 24 individual subjects 
wtf_mag_SP_X     = calc_TF_magnitude(wtf_SP_X);
wtf_mag_SP_Y     = calc_TF_magnitude(wtf_SP_Y);
wtf_mag_SP_Z     = calc_TF_magnitude(wtf_SP_Z);

wtf_mag_FPL_X    = calc_TF_magnitude(wtf_FPL_X);
wtf_mag_FPL_Z    = calc_TF_magnitude(wtf_FPL_Z);

wtf_mag_FPR_X    = calc_TF_magnitude(wtf_FPR_X);
wtf_mag_FPR_Z    = calc_TF_magnitude(wtf_FPR_Z);

wtf_mag_HBL_X    = calc_TF_magnitude(wtf_HBL_X);
wtf_mag_HBL_Y    = calc_TF_magnitude(wtf_HBL_Y);
wtf_mag_HBL_Z    = calc_TF_magnitude(wtf_HBL_Z);

wtf_mag_HBR_X    = calc_TF_magnitude(wtf_HBR_X);
wtf_mag_HBR_Y    = calc_TF_magnitude(wtf_HBR_Y);
wtf_mag_HBR_Z    = calc_TF_magnitude(wtf_HBR_Z);

% Mean rider
wtf_mag_SP_X_mean_rider     = mean(wtf_mag_SP_X,2);
wtf_mag_SP_Y_mean_rider     = mean(wtf_mag_SP_Y,2);
wtf_mag_SP_Z_mean_rider     = mean(wtf_mag_SP_Z,2);

wtf_mag_FPL_X_mean_rider    = mean(wtf_mag_FPL_X,2);
wtf_mag_FPL_Z_mean_rider    = mean(wtf_mag_FPL_Z,2);

wtf_mag_FPR_X_mean_rider    = mean(wtf_mag_FPR_X,2);
wtf_mag_FPR_Z_mean_rider    = mean(wtf_mag_FPR_Z,2);

wtf_mag_HBL_X_mean_rider    = mean(wtf_mag_HBL_X,2);
wtf_mag_HBL_Y_mean_rider    = mean(wtf_mag_HBL_Y,2);
wtf_mag_HBL_Z_mean_rider    = mean(wtf_mag_HBL_Z,2);

wtf_mag_HBR_X_mean_rider    = mean(wtf_mag_HBR_X,2);
wtf_mag_HBR_Y_mean_rider    = mean(wtf_mag_HBR_Y,2);
wtf_mag_HBR_Z_mean_rider    = mean(wtf_mag_HBR_Z,2);

%% Calculate the phase
% 24 individual subjects
wtf_phase_SP_X      = calc_TF_phase(wtf_SP_X);
wtf_phase_SP_Y      = calc_TF_phase(wtf_SP_Y);
wtf_phase_SP_Z      = calc_TF_phase(wtf_SP_Z);

wtf_phase_FPL_X     = calc_TF_phase(wtf_FPL_X);
wtf_phase_FPL_Z     = calc_TF_phase(wtf_FPL_Z);

wtf_phase_FPR_X     = calc_TF_phase(wtf_FPR_X);
wtf_phase_FPR_Z     = calc_TF_phase(wtf_FPR_Z);

wtf_phase_HBL_X     = calc_TF_phase(wtf_HBL_X);
wtf_phase_HBL_Y     = calc_TF_phase(wtf_HBL_Y);
wtf_phase_HBL_Z     = calc_TF_phase(wtf_HBL_Z);

wtf_phase_HBR_X     = calc_TF_phase(wtf_HBR_X);
wtf_phase_HBR_Y     = calc_TF_phase(wtf_HBR_Y);
wtf_phase_HBR_Z     = calc_TF_phase(wtf_HBR_Z);

% Phase scaling and unwrapping
tol = 180;      % tolerance for unwrapping the phase (= degrees)

wtf_phase_SP_X  = phase_scaling(wtf_phase_SP_X);
wtf_phase_SP_X  = unwrap(wtf_phase_SP_X,tol);
wtf_phase_SP_Y  = phase_scaling(wtf_phase_SP_Y);
wtf_phase_SP_Y = unwrap(wtf_phase_SP_Y,tol);
wtf_phase_SP_Z  = phase_scaling(wtf_phase_SP_Z);
wtf_phase_SP_Z  = unwrap(wtf_phase_SP_Z,tol);

wtf_phase_FPL_X = phase_scaling(wtf_phase_FPL_X);
wtf_phase_FPL_X = unwrap(wtf_phase_FPL_X,tol);
wtf_phase_FPL_Z = phase_scaling(wtf_phase_FPL_Z);
wtf_phase_FPL_Z = unwrap(wtf_phase_FPL_Z,tol);

wtf_phase_FPR_X = phase_scaling(wtf_phase_FPR_X);
wtf_phase_FPR_X = unwrap(wtf_phase_FPR_X,tol);
wtf_phase_FPR_Z = phase_scaling(wtf_phase_FPR_Z);
wtf_phase_FPR_Z = unwrap(wtf_phase_FPR_Z,tol);

wtf_phase_HBL_X = phase_scaling(wtf_phase_HBL_X);
wtf_phase_HBL_X = unwrap(wtf_phase_HBL_X,tol); 
%Phase scaling for handlebar X-axis change all positive phase values to negative
ind = wtf_phase_HBL_X>0;
wtf_phase_HBL_X(ind) = wtf_phase_HBL_X(ind) - 360;

wtf_phase_HBL_Y = phase_scaling(wtf_phase_HBL_Y);
wtf_phase_HBL_Y = unwrap(wtf_phase_HBL_Y,tol);
wtf_phase_HBL_Z = phase_scaling(wtf_phase_HBL_Z);
wtf_phase_HBL_Z = unwrap(wtf_phase_HBL_Z,tol);

wtf_phase_HBR_X = phase_scaling(wtf_phase_HBR_X);
wtf_phase_HBR_X = unwrap(wtf_phase_HBR_X,tol);
%Phase scaling for handlebar X-axis change all positive phase values to negative
ind = wtf_phase_HBR_X>0;
wtf_phase_HBR_X(ind) = wtf_phase_HBR_X(ind) - 360;

wtf_phase_HBR_Y = phase_scaling(wtf_phase_HBR_Y);
wtf_phase_HBR_Y = unwrap(wtf_phase_HBR_Y,tol);
wtf_phase_HBR_Z = phase_scaling(wtf_phase_HBR_Z);
wtf_phase_HBR_Z = unwrap(wtf_phase_HBR_Z,tol);

% Mean rider
wtf_phase_SP_X_mean_rider     = mean(wtf_phase_SP_X,2);
wtf_phase_SP_Y_mean_rider     = mean(wtf_phase_SP_Y,2);
wtf_phase_SP_Z_mean_rider     = mean(wtf_phase_SP_Z,2);

wtf_phase_FPL_X_mean_rider    = mean(wtf_phase_FPL_X,2);
wtf_phase_FPL_Z_mean_rider    = mean(wtf_phase_FPL_Z,2);

wtf_phase_FPR_X_mean_rider    = mean(wtf_phase_FPR_X,2);
wtf_phase_FPR_Z_mean_rider    = mean(wtf_phase_FPR_Z,2);

wtf_phase_HBL_X_mean_rider    = mean(wtf_phase_HBL_X,2);
wtf_phase_HBL_Y_mean_rider    = mean(wtf_phase_HBL_Y,2);
wtf_phase_HBL_Z_mean_rider    = mean(wtf_phase_HBL_Z,2);

wtf_phase_HBR_X_mean_rider    = mean(wtf_phase_HBR_X,2); 
wtf_phase_HBR_Y_mean_rider    = mean(wtf_phase_HBR_Y,2);
wtf_phase_HBR_Z_mean_rider    = mean(wtf_phase_HBR_Z,2);

%% Calculate the coherence
% 24 individual subjects
wcoh_SP_X     = calc_coherence(u_acc_signals,y_force_SP_X_24subs,nfft,fs);
wcoh_SP_Y     = calc_coherence(u_acc_signals,y_force_SP_Y_24subs,nfft,fs);
wcoh_SP_Z     = calc_coherence(u_acc_signals,y_force_SP_Z_24subs,nfft,fs);

wcoh_FPL_X     = calc_coherence(u_acc_signals,y_force_FPL_X_24subs,nfft,fs);
wcoh_FPL_Z     = calc_coherence(u_acc_signals,y_force_FPL_Z_24subs,nfft,fs);

wcoh_FPR_X     = calc_coherence(u_acc_signals,y_force_FPR_X_24subs,nfft,fs);
wcoh_FPR_Z     = calc_coherence(u_acc_signals,y_force_FPR_Z_24subs,nfft,fs);

wcoh_HBL_X     = calc_coherence(u_acc_signals,y_force_HBL_X_24subs,nfft,fs);
wcoh_HBL_Y     = calc_coherence(u_acc_signals,y_force_HBL_Y_24subs,nfft,fs);
wcoh_HBL_Z     = calc_coherence(u_acc_signals,y_force_HBL_Z_24subs,nfft,fs);

wcoh_HBR_X     = calc_coherence(u_acc_signals,y_force_HBR_X_24subs,nfft,fs);
wcoh_HBR_Y     = calc_coherence(u_acc_signals,y_force_HBR_Y_24subs,nfft,fs);
wcoh_HBR_Z     = calc_coherence(u_acc_signals,y_force_HBR_Z_24subs,nfft,fs);

% We are only interested in the frequency range of 0.5 - 12 Hz
% wcoh_SP_X = wcoh_SP_X(low_samp:high_samp,:);
% wcoh_SP_Y = wcoh_SP_Y(low_samp:high_samp,:);
% wcoh_SP_Z = wcoh_SP_Z(low_samp:high_samp,:);
% 
% wcoh_FPL_X = wcoh_FPL_X(low_samp:high_samp,:);
% wcoh_FPL_Z = wcoh_FPL_Z(low_samp:high_samp,:);
% 
% wcoh_FPR_X = wcoh_FPR_X(low_samp:high_samp,:);
% wcoh_FPR_Z = wcoh_FPR_Z(low_samp:high_samp,:);
% 
% wcoh_HBL_X = wcoh_HBL_X(low_samp:high_samp,:);
% wcoh_HBL_Y = wcoh_HBL_Y(low_samp:high_samp,:);
% wcoh_HBL_Z = wcoh_HBL_Z(low_samp:high_samp,:);
% 
% wcoh_HBR_X = wcoh_HBR_X(low_samp:high_samp,:);
% wcoh_HBR_Y = wcoh_HBR_Y(low_samp:high_samp,:);
% wcoh_HBR_Z = wcoh_HBR_Z(low_samp:high_samp,:);

% Mean rider
wcoh_SP_X_mean_rider     = mean(wcoh_SP_X,2);
wcoh_SP_Y_mean_rider     = mean(wcoh_SP_Y,2);
wcoh_SP_Z_mean_rider     = mean(wcoh_SP_Z,2);

wcoh_FPL_X_mean_rider    = mean(wcoh_FPL_X,2);
wcoh_FPL_Z_mean_rider    = mean(wcoh_FPL_Z,2);

wcoh_FPR_X_mean_rider    = mean(wcoh_FPR_X,2);
wcoh_FPR_Z_mean_rider    = mean(wcoh_FPR_Z,2);

wcoh_HBL_X_mean_rider    = mean(wcoh_HBL_X,2);
wcoh_HBL_Y_mean_rider    = mean(wcoh_HBL_Y,2);
wcoh_HBL_Z_mean_rider    = mean(wcoh_HBL_Z,2);

wcoh_HBR_X_mean_rider    = mean(wcoh_HBR_X,2);
wcoh_HBR_Y_mean_rider    = mean(wcoh_HBR_Y,2);
wcoh_HBR_Z_mean_rider    = mean(wcoh_HBR_Z,2);

% Calculate the significance level of the coherence
alpha = 0.05;                               % change taking statiscally the wrong descision. 
L_seg = Nsegment*0.5;                       % number of independent segments with 50% overlap
wcoh_siglevel = 1 - alpha^(1/(L_seg-1));    % significance level for coherence
%% plot gain of transfer functions of 24 subjects
figure('name','Gain 24 subjects and mean rider')
subplot(3,5,1)
    semilogx(wfv, wtf_mag_SP_X,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks) 
    %yticks(y_ticks)
    ylabel({'X-axis','Gain [kg]'},'FontSize',fontsize)
    title('Seat','FontSize',fontsize)
subplot(3,5,6)
    semilogx(wfv, wtf_mag_SP_Y, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    ylabel({'Y-axis','Gain [kg]'},'FontSize',fontsize)
subplot(3,5,11)
    semilogx(wfv, wtf_mag_SP_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    ylabel({'Z-axis','Gain [kg]'},'FontSize',fontsize)
    xlabel('Frequency [Hz]','FontSize',fontsize)
subplot(3,5,2)
    semilogx(wfv, wtf_mag_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    title('Foot peg left','FontSize',fontsize)
subplot(3,5,12)
    semilogx(wfv, wtf_mag_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize)
subplot(3,5,3)
    semilogx(wfv, wtf_mag_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    title('Foot peg right','FontSize',fontsize)
subplot(3,5,13)
    semilogx(wfv, wtf_mag_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize)
subplot(3,5,4)
    semilogx(wfv, wtf_mag_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off %1.14 is the crosstalk coefficient for the left handlebar for a vertical load
    semilogx(wfv, wtf_mag_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    title('Handlebar left','FontSize',fontsize)
subplot(3,5,9)
    semilogx(wfv, wtf_mag_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
subplot(3,5,14)
    semilogx(wfv, wtf_mag_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,5)
    semilogx(wfv, wtf_mag_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off %1.86 is the crosstalk coefficient for the right handlebar for a vertical load
    semilogx(wfv, wtf_mag_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    title('Handlebar right','FontSize',fontsize)
subplot(3,5,10)
    semilogx (wfv, wtf_mag_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
subplot(3,5,15)
    semilogx(wfv, wtf_mag_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_mag_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    xticks(x_ticks)
    %yticks(y_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
%% Find peaks in magnitude for seat 
magnitude=real(wtf_mag_SP_Z);
pksM1 = zeros(1,24);
locsM1 = zeros(1,24);

for i=1:24
[locsM1(1, i), pksM1(1, i)] = max_one(wfv(:,i), magnitude(:,i));
hold on
end
%scatter(locsM1,body_mass_24subs)
ylabel({'Z-axis','Gain [kg]'},'FontSize',fontsize)
xlabel('Frequency [Hz]','FontSize',fontsize);
[c,lags]= xcorr(locsM1,body_mass_24subs)
stem(lags,c)
    %% plot phase of transfer functions of 24 subjects
figure('name','Phase 24 subjects and mean rider')
subplot(3,5,1)
    semilogx(wfv, wtf_phase_SP_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    title('Seat','FontSize',fontsize)
    ylabel({'X-axis','Phase [deg]'},'FontSize',fontsize)
subplot(3,5,6)
    semilogx(wfv, wtf_phase_SP_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'Y-axis','Phase [deg]'},'FontSize',fontsize)
subplot(3,5,11)
    semilogx(wfv, wtf_phase_SP_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'Z-axis','Phase [deg]'},'FontSize',fontsize)
    xlabel('Frequency [Hz]','FontSize',fontsize)
subplot(3,5,2)
    semilogx(wfv, wtf_phase_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    title('Foot peg left','FontSize',fontsize)
subplot(3,5,12)
    semilogx(wfv, wtf_phase_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,3)
    semilogx(wfv, wtf_phase_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    title('Foot peg right','FontSize',fontsize)
subplot(3,5,13)
    semilogx(wfv, wtf_phase_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,4)
    semilogx(wfv, wtf_phase_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    title('Handlebar left','FontSize',fontsize)
subplot(3,5,9)
    semilogx(wfv, wtf_phase_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
subplot(3,5,14)
    semilogx(wfv, wtf_phase_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,5)
    semilogx(wfv, wtf_phase_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    title('Handlebar right','FontSize',fontsize)
subplot(3,5,10)
    semilogx(wfv, wtf_phase_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
subplot(3,5,15)
    semilogx(wfv, wtf_phase_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    set(gca,'FontSize',fontsize_indv_TF)
    xlim(x_lim)
    %ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
    
%% Plot coherence of transfer functions of 24 subjects
figure('name','Coherence 24 subjects and mean rider')
subplot(3,5,1)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_X, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    ylabel({'X-axis','Coherence [-]'},'FontSize',fontsize)
    title('Seat','FontSize',fontsize)
subplot(3,5,6)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_Y, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    ylabel({'Y-axis','Coherence [-]'},'FontSize',fontsize)
subplot(3,5,11)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_Z, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim) 
    xticks(x_ticks)
    ylabel({'Z-axis','Coherence [-]'},'FontSize',fontsize)
    xlabel('Frequency [Hz]','FontSize',fontsize)
subplot(3,5,2)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    title('Foot peg left','FontSize',fontsize)
subplot(3,5,12)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,3)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    title('Foot peg right','FontSize',fontsize)
subplot(3,5,13)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,4)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    title('Handlebar left','FontSize',fontsize)
subplot(3,5,9)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
subplot(3,5,14)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);
subplot(3,5,5)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    title('Handlebar right','FontSize',fontsize)
subplot(3,5,10)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
subplot(3,5,15)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    set(gca,'FontSize',fontsize_indv_TF)
    ylim([0 1])
    xlim(x_lim)
    xticks(x_ticks)
    xlabel('Frequency [Hz]','FontSize',fontsize);

 %%  Plot gain of mean rider with STD of 24 subjects shaded
figure('name','Gain std and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
    stdshade((wtf_mag_SP_X)',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim)
    ylabel({'X-axis','Gain [kg]'})
    xticks(x_ticks)
    title('Seat')
    legend('Gain in longitudinal direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
 
subplot(3,3,4)
    stdshade(wtf_mag_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks);
    ylabel({'Y-axis','Gain [kg]'});
    legend('Gain in lateral direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,7)
    stdshade(wtf_mag_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    ylabel({'Z-axis','Gain [kg]'})
    xlabel('Frequency [Hz]')
    legend('Gain in vertical direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,2)
    wtf_mag_FPLR_X=(wtf_mag_FPL_X+wtf_mag_FPR_X)/2; %merging left and right footpeg x axis
    stdshade(wtf_mag_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    title('Footpegs')
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,8)
    wtf_mag_FPLR_Z=(wtf_mag_FPL_Z+wtf_mag_FPR_Z)/2; %merging left and right footpeg z axis
    stdshade(wtf_mag_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
     title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
subplot(3,3,3)
    wtf_mag_HBLR_X=(wtf_mag_HBL_X+wtf_mag_HBR_X/2); %merging left and right handlebar x axis
    stdshade(wtf_mag_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    title('Handlebars')
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,6)
    wtf_mag_HBLR_Y=(wtf_mag_HBL_Y+wtf_mag_HBR_Y)/2; %merging left and right handlebar y axis
    stdshade(wtf_mag_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,9)
    wtf_mag_HBLR_Z=(wtf_mag_HBL_Z+wtf_mag_HBR_Z)/2; %merging left and right handlebar z axis
    stdshade(wtf_mag_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    
%%  Plot phase of mean rider with STD of 24 subjects shaded
figure('name','Phase std and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
    stdshade(wtf_phase_SP_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim)
%     ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'X-axis','Phase [deg]'})
%     title('Seat')
    legend('Phase in longitudinal direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,4)
    stdshade(wtf_phase_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks);
    ylabel({'Y-axis','Phase [deg]'});
    legend('Phase in lateral direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,7)
    stdshade(wtf_phase_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'Z-axis','Phase [deg]'})
    xlabel('Frequency [Hz]')
    legend('Phase in vertical direction');
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,2)
    wtf_phase_FPLR_X=(wtf_phase_FPL_X+wtf_phase_FPR_X)/2; %merging left and right footpeg x axis
    stdshade(wtf_phase_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
%     title('Footpegs')
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,8)
    wtf_phase_FPLR_Z=(wtf_phase_FPL_Z+wtf_phase_FPR_Z)/2; %merging left and right footpeg z axis
    stdshade(wtf_phase_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
     title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
subplot(3,3,3)
    wtf_phase_HBLR_X=(wtf_phase_HBL_X+wtf_phase_HBR_X)/2; %merging left and right handlebar x axis
    stdshade(wtf_phase_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
%     title('Handlebars')
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,6)
    wtf_phase_HBLR_Y=(wtf_phase_HBL_Y+wtf_phase_HBR_Y)/2; %merging left and right handlebar y axis
    stdshade(wtf_phase_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,9)
    wtf_phase_HBLR_Z=(wtf_phase_HBL_Z+wtf_phase_HBR_Z)/2; %merging left and right handlebar Z axis
    stdshade(wtf_phase_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim(x_lim);
%     ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
 
 %% Plot coherence of mean rider with STD of 24 subjects shaded
figure('name','Coherence std and mean rider')
    wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
    stdshade(wcoh_SP_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    ylabel({'X-axis','Coherence [-]'})
    set(gca, 'XScale', 'log','FontSize',fontsize)
    %title('Seat')
    legend('Coherence in longitudinal direction');
subplot(3,3,4)
    stdshade(wcoh_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    ylabel({'Y-axis','Coherence [-]'})
    set(gca, 'XScale', 'log','FontSize',fontsize)
    legend('Coherence in lateral direction');
subplot(3,3,7)
    stdshade(wcoh_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    ylabel({'Z-axis','Coherence [-]'})
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    legend('Coherence in vertical direction');
subplot(3,3,2)
    wcoh_phase_FPLR_X=(wcoh_FPL_X+wcoh_FPR_X)/2; %merging left and right footpeg
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle); hold on; grid on; box off
    stdshade(wcoh_phase_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    %title('Footpegs')
    legend('CSL');
subplot(3,3,8)
    wcoh_FPLR_Z=(wcoh_FPL_Z+wcoh_FPR_Z)/2; %merging left and right footpeg z axis
    stdshade(wcoh_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.5, 0]); % Set Title with correct Position
subplot(3,3,3)
    wcoh_HBLR_X=(wcoh_HBL_X+wcoh_HBR_X)/2; %merging left and right handlebar x axis
    stdshade(wcoh_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
    %title('Handlebars')
subplot(3,3,6)
    wcoh_HBLR_Y=(wcoh_HBL_Y+wcoh_HBR_Y)/2; %merging left and right handlebar y axis
    stdshade(wcoh_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
     ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    set(gca, 'XScale', 'log','FontSize',fontsize)
subplot(3,3,9)
    wcoh_HBLR_Z=(wcoh_HBL_Z+wcoh_HBR_Z)/2; %merging left and right handlebar z axis
    stdshade(wcoh_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    line([wfv(1),wfv(301)],[wcoh_siglevel,wcoh_siglevel], 'Color', wcoh_siglevel_color, 'linewidth', wcoh_siglevel_linewidth, 'LineStyle', wcoh_siglevel_linestyle);
    ylim([0 1])
    xlim(x_lim);
    xticks(x_ticks)
    yticks(y_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log','FontSize',fontsize)
 %% Calculate the standard deviation for each interface for 24 subjects
% % STD 24 individual subjects
% std_wtf_mag_SP_X = std(wtf_mag_SP_X);
% std_wtf_mag_SP_Y = std(wtf_mag_SP_Y);
% std_wtf_mag_SP_Z = std(wtf_mag_SP_Z);
% 
% std_wtf_mag_FPL_X = std(wtf_mag_FPL_X);
% std_wtf_mag_FPL_Z = std(wtf_mag_FPL_Z);
% 
% std_wtf_mag_FPR_X = std(wtf_mag_FPR_X);
% std_wtf_mag_FPR_Z = std(wtf_mag_FPR_Z);
% 
% std_wtf_mag_HBL_X = std(wtf_mag_HBL_X);
% std_wtf_mag_HBL_Y = std(wtf_mag_HBL_Y);
% std_wtf_mag_HBL_Z = std(wtf_mag_HBL_Z);
% 
% std_wtf_mag_HBR_X = std(wtf_mag_HBR_X);
% std_wtf_mag_HBR_Y = std(wtf_mag_HBR_Y);
% std_wtf_mag_HBR_Z = std(wtf_mag_HBR_Z); 
% 
% figure('name','The std in each interface of 24 subjects')
% subplot(3,5,1)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_X)
%     xlim([0 25])
%     title('Seat')
%     ylabel({'X-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,6)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Y)
%     xlim([0 25])
%     ylabel({'Y-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,11)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Z)
%     xlim([0 25])
%     ylabel({'Z-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,2)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_X)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject')
%     title('Foot peg left')
% subplot(3,5,12)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_Z)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,3)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_X)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Foot peg right')
% subplot(3,5,13)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_Z)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,4)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_X)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Handlebar left')
% subplot(3,5,9)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Y)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,14)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Z)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,5)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_X)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Handlebar right')
% subplot(3,5,10)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Y)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,15)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Z)
%     xlim([0 25])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     
 
 
 
%% Normalise transfer functions of subjects with the lowest freq. gain (= 0.5 Hz)
% Normalised transfer functions of individual subjects Trial 1
wtf_mag_SP_X_norm     = wtf_mag_SP_X./body_mass_24subs;
wtf_mag_SP_Y_norm     = wtf_mag_SP_Y./body_mass_24subs;
wtf_mag_SP_Z_norm     = wtf_mag_SP_Z./body_mass_24subs;

wtf_mag_FPL_X_norm    = wtf_mag_FPL_X./body_mass_24subs;
wtf_mag_FPL_Z_norm    = wtf_mag_FPL_Z./body_mass_24subs;

wtf_mag_FPR_X_norm    = wtf_mag_FPR_X./body_mass_24subs;
wtf_mag_FPR_Z_norm    = wtf_mag_FPR_Z./body_mass_24subs;

wtf_mag_HBL_X_norm    = wtf_mag_HBL_X./body_mass_24subs;
wtf_mag_HBL_Y_norm    = wtf_mag_HBL_Y./body_mass_24subs;
wtf_mag_HBL_Z_norm    = wtf_mag_HBL_Z./body_mass_24subs;

wtf_mag_HBR_X_norm    = wtf_mag_HBR_X./body_mass_24subs;
wtf_mag_HBR_Y_norm    = wtf_mag_HBR_Y./body_mass_24subs;
wtf_mag_HBR_Z_norm    = wtf_mag_HBR_Z./body_mass_24subs;

% Mean body mass of 24 subjects
mean_body_mass_24subs = mean(body_mass_24subs,2);

% Normalized transfer functions of mean rider of trial 1
wtf_mag_SP_X_mean_rider_norm     = wtf_mag_SP_X_mean_rider./mean_body_mass_24subs;
wtf_mag_SP_Y_mean_rider_norm     = wtf_mag_SP_Y_mean_rider./mean_body_mass_24subs;
wtf_mag_SP_Z_mean_rider_norm     = wtf_mag_SP_Z_mean_rider./mean_body_mass_24subs;

wtf_mag_FPL_X_mean_rider_norm    = wtf_mag_FPL_X_mean_rider./mean_body_mass_24subs;
wtf_mag_FPL_Z_mean_rider_norm    = wtf_mag_FPL_Z_mean_rider./mean_body_mass_24subs;

wtf_mag_FPR_X_mean_rider_norm    = wtf_mag_FPR_X_mean_rider./mean_body_mass_24subs;
wtf_mag_FPR_Z_mean_rider_norm    = wtf_mag_FPR_Z_mean_rider./mean_body_mass_24subs;

wtf_mag_HBL_X_mean_rider_norm    = wtf_mag_HBL_X_mean_rider./mean_body_mass_24subs;
wtf_mag_HBL_Y_mean_rider_norm    = wtf_mag_HBL_Y_mean_rider./mean_body_mass_24subs;
wtf_mag_HBL_Z_mean_rider_norm    = wtf_mag_HBL_Z_mean_rider./mean_body_mass_24subs;

wtf_mag_HBR_X_mean_rider_norm    = wtf_mag_HBR_X_mean_rider./mean_body_mass_24subs;
wtf_mag_HBR_Y_mean_rider_norm    = wtf_mag_HBR_Y_mean_rider./mean_body_mass_24subs;
wtf_mag_HBR_Z_mean_rider_norm    = wtf_mag_HBR_Z_mean_rider./mean_body_mass_24subs;

%% Plot normalised transfer functions
% figure('name','Normalised gain 24 subjects and mean rider')
% subplot(3,5,1)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_X_norm,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks) 
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     ylabel({'X-axis','Gain [-]'})
%     title('Seat')
% subplot(3,5,6)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_Y_norm, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     ylabel({'Y-axis','Gain [-]'})
% subplot(3,5,11)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     ylabel({'Z-axis','Gain [-]'})
%     xlabel('Frequency [Hz]')
% subplot(3,5,2)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPL_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPL_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Foot peg left')
% subplot(3,5,12)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPL_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPL_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]')
% subplot(3,5,3)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPR_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPR_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Foot peg right')
% subplot(3,5,13)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPR_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPR_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]')
% subplot(3,5,4)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Handlebar left')
% subplot(3,5,9)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_Y_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
% subplot(3,5,14)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm)
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]');
% subplot(3,5,5)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm)
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Handlebar right')
% subplot(3,5,10)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_Y_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
% subplot(3,5,15)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]');
%     suptitle('\bf Heave normalised gain plots for individual subjects and mean rider')

%% Calculate STD for determining the outliers after normalising the TF's
% % STD 24 subjects
% std_wtf_mag_SP_X_norm = std(wtf_mag_SP_X_norm);
% std_wtf_mag_SP_Y_norm = std(wtf_mag_SP_Y_norm);
% std_wtf_mag_SP_Z_norm = std(wtf_mag_SP_Z_norm);
% 
% std_wtf_mag_FPL_X_norm = std(wtf_mag_FPL_X_norm);
% std_wtf_mag_FPL_Z_norm = std(wtf_mag_FPL_Z_norm);
% 
% std_wtf_mag_FPR_X_norm = std(wtf_mag_FPR_X_norm);
% std_wtf_mag_FPR_Z_norm = std(wtf_mag_FPR_Z_norm);
% 
% std_wtf_mag_HBL_X_norm = std(wtf_mag_HBL_X_norm);
% std_wtf_mag_HBL_Y_norm = std(wtf_mag_HBL_Y_norm);
% std_wtf_mag_HBL_Z_norm = std(wtf_mag_HBL_Z_norm);
% 
% std_wtf_mag_HBR_X_norm = std(wtf_mag_HBR_X_norm);
% std_wtf_mag_HBR_Y_norm = std(wtf_mag_HBR_Y_norm);
% std_wtf_mag_HBR_Z_norm = std(wtf_mag_HBR_Z_norm);
% 
% figure('name','The std in each interface of 24 subjects')
% subplot(3,5,1)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_X_norm)
%     xlim([0 24])
%     title('Seat')
%     ylabel({'X-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,6)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Y_norm)
%     xlim([0 24])
%     ylabel({'Y-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,11)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Z_norm)
%     xlim([0 24])
%     ylabel({'Z-axis','STD[kg]'})
%     xlabel('Subject')
% subplot(3,5,2)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_X_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject')
%     title('Foot peg left')
% subplot(3,5,12)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_Z_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,3)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_X_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Foot peg right')
% subplot(3,5,13)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_Z_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,4)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_X_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Handlebar left')
% subplot(3,5,9)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Y_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,14)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Z_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,5)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_X_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
%     title('Handlebar right')
% subplot(3,5,10)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Y_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');
% subplot(3,5,15)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Z_norm)
%     xlim([0 24])
%     ylabel('STD[kg]');
%     xlabel('Subject');






