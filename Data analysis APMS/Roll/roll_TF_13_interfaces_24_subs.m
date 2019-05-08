%% Calculating the transfer functions (TFs) for the passive rider

% Author: Jelle Waling de Haan
% Graduation project: Passive Rider Identification 
% Script: Calculating individual TFs, TF mean rider, normalised TFs and normalised TF
% mean rider with STD.
% Last update: 08-03-2019

% This script calculates the raw individual TFs for 24 subjects. This means
% that for 24 subjects the gain, phase and coherence are calculated.
% Furthermore, TF of the mean rider (= average of 24 subjects) is
% calculated. Also, the normalised TFs for individual subjects and the mean
% rider are calculated. For all subjects the transfer functions in the seat 
% post, left foot peg, right foot peg, left handlebar and right handlebar 
% are calculated. 

clear all 
close all  
clc

%% Load in- and output signals and subject body masses
load('roll_input_signals_SI_t1_t2')   % input signal (m/s^2)
load('roll_force_signals_SI_t1_t2') % output signal (N)

body_mass_24subs = xlsread('body_mass_24subs'); % the total body mass of 24 indvidual subjects

%% Rename signals and choose trial number

%u_ang_vel_signals = -roll_vel_signals_SI_t1;   % Ang. Vel. signals 24 subjects trial 1 
%u_ang_vel_signals = -roll_vel_signals_SI_t2;   % Ang. Vel. signals 24 subjects trial 2 

u_ang_acc_signals = -roll_acc_signals_SI_t1;   % Ang. Acc. signals 24 subjects trial 1 
%u_ang_acc_signals = -roll_acc_signals_SI_t2;   % Ang. Acc. signals 24 subjects trial 2

y_force_signals = roll_force_signals_SI_t1; % Force signals 24 subjects trial 1 
%y_force_signals = roll_force_signals_SI_t2; % Force signals 24 subjects trial 2 

clearvars   roll_vel_signals_SI_t1 roll_vel_signals_SI_t2... 
            roll_acc_signals_SI_t1 roll_acc_signals_SI_t2... 
            roll_force_signals_SI_t1 roll_force_signals_SI_t2

%% Constants
N   = 6000;                     % number of samples
fs  = 100;                      % sample frequency 
dt  = 1/fs;                     % time step between two samples
T   = N * dt;                   % total observation time
fv  = (0:1/T:fs-(1/T))';        % frequency vector

indv_linewidth = 1;             % linewidth for plots of indv. subjects
mean_linewidth = 2;             % linewidth for plot of mean rider

indv_color = [0.7 0.7 0.7];     % grey color for plots of indv. subjects 
x_color    = 'r';               % red color for plot mean rider x-direction
y_color    = 'g';               % green color for plot mean rider y-direction
z_color    = 'b';               % blue color for plot mean rider z-direction

%x_ticks      = [0.1333 0.4 0.8 2 4 8 10];    % numbers which are shown on the x-axes
x_ticks      = [0.17 0.5 1 2 4 8 12];        % numbers which are shown on the x-axes
x_lim_gain   = [0.16 12];                       % x-axis limit for frequency range
y_lim_gain   = [10^-2 10^4];                 % y-axis limit for individual gain
y_ticks_norm = [0.001 0.01 0.1 1 10];        % numbers which are shown on the y-axes
y_lim_norm   = [10^-4 10];                   % y-axis limit for normalised gain

std_shadow = 0.2;               % tranparency STD shadow

%% Plot signals in time domain
sub = 1;

figure()
subplot(3,6,1)
    plot(u_ang_acc_signals(:,sub),'Color', x_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bf X-axis','Acc. [rad/s^2]'})
    title(['Hexapod acc.: \mu=', num2str(mean(u_ang_acc_signals(:,sub))),' \sigma=', num2str(std(u_ang_acc_signals(:,sub)))])
subplot(3,6,7)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', y_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bf Y-axis','Acc. [rad/s^2]'})
    title('Hexapod acc.')
subplot(3,6,13)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bf Z-axis','Acc. [rad/s^2]'})
    title('Hexapod acc.')
subplot(3,6,2)
    plot(y_force_signals{1}(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['SP_X: \mu=', num2str(mean(y_force_signals{1}(:,sub))),' \sigma=', num2str(std(y_force_signals{1}(:,sub)))]);
subplot(3,6,8)
    plot(y_force_signals{2}(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['SP_Y: \mu=', num2str(mean(y_force_signals{2}(:,sub))),' \sigma=', num2str(std(y_force_signals{2}(:,sub)))]);
subplot(3,6,14)
    plot(y_force_signals{3}(:,sub),'Color', z_color); hold on; grid on; box off
    ylabel('Force [N]');
    xlabel('Samples [-]');
    title(['SP_Z: \mu=', num2str(mean(y_force_signals{3}(:,sub))),' \sigma=', num2str(std(y_force_signals{3}(:,sub)))]);
subplot(3,6,3)
    plot(y_force_signals{4}(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['FPL_X: \mu=', num2str(mean(y_force_signals{4}(:,sub))),' \sigma=', num2str(std(y_force_signals{4}(:,sub)))]);
subplot(3,6,15)
    plot(y_force_signals{5}(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['FPL_Z: \mu=', num2str(mean(y_force_signals{5}(:,sub))),' \sigma=', num2str(std(y_force_signals{5}(:,sub)))]);
subplot(3,6,4)
    plot(y_force_signals{6}(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['FPR_X: \mu=', num2str(mean(y_force_signals{6}(:,sub))),' \sigma=', num2str(std(y_force_signals{6}(:,sub)))]);
subplot(3,6,16)
    plot(y_force_signals{7}(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['FPL_Z: \mu=', num2str(mean(y_force_signals{7}(:,sub))),' \sigma=', num2str(std(y_force_signals{7}(:,sub)))]);
subplot(3,6,5)
    plot(y_force_signals{8}(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title('HBL_X');
    title(['HBL_X: \mu=', num2str(mean(y_force_signals{8}(:,sub))),' \sigma=', num2str(std(y_force_signals{8}(:,sub)))]);
subplot(3,6,11)
    plot(y_force_signals{9}(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBL_Y: \mu=', num2str(mean(y_force_signals{9}(:,sub))),' \sigma=', num2str(std(y_force_signals{9}(:,sub)))]);
subplot(3,6,17)
    plot(y_force_signals{10}(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['HBL_Z: \mu=', num2str(mean(y_force_signals{10}(:,sub))),' \sigma=', num2str(std(y_force_signals{10}(:,sub)))]);
subplot(3,6,6)
    plot(y_force_signals{11}(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBR_X: \mu=', num2str(mean(y_force_signals{11}(:,sub))),' \sigma=', num2str(std(y_force_signals{11}(:,sub)))]);
subplot(3,6,12)
    plot(y_force_signals{12}(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBR_Y: \mu=', num2str(mean(y_force_signals{12}(:,sub))),' \sigma=', num2str(std(y_force_signals{12}(:,sub)))]);
subplot(3,6,18)
    plot(y_force_signals{13}(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['HBR_Z: \mu=', num2str(mean(y_force_signals{13}(:,sub))),' \sigma=', num2str(std(y_force_signals{13}(:,sub)))]);
    suptitle('\bf Roll input and output signals in time domain');
    
%% Prescribe force signals to interfaces and apply correct sign convention
% 24 individual subjects   
y_force_SP_X_24subs  = -y_force_signals{1}-0.16*y_force_signals{2}; %taking out crosstalk for a lateral applied force;
y_force_SP_Y_24subs  =  y_force_signals{2};
y_force_SP_Z_24subs  =  y_force_signals{3}-0.38*y_force_signals{2}; %taking out crosstalk for a lateral applied force;

y_force_FPL_X_24subs = -y_force_signals{4};
y_force_FPL_Z_24subs = -y_force_signals{5};

y_force_FPR_X_24subs =  y_force_signals{6};
y_force_FPR_Z_24subs =  y_force_signals{7};

y_force_HBL_X_24subs =  y_force_signals{8}+0.14402*y_force_signals{10};%taking out crosstalk for a vertical applied force
y_force_HBL_Y_24subs = -y_force_signals{9};
y_force_HBL_Z_24subs = -y_force_signals{10};

y_force_HBR_X_24subs = -y_force_signals{11}-0.14402*y_force_signals{13};%taking out crosstalk for a vertical applied force
y_force_HBR_Y_24subs = -y_force_signals{12};
y_force_HBR_Z_24subs =  y_force_signals{13};

%% Plot signals in frequency domain
% Auto-spectral density of input signal
U_acc_signals = fft(detrend(u_ang_acc_signals(:,sub)));
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
    loglog(fv(1:N/2),U_acc_signals(1:N/2),'Color', x_color); hold on; grid on; box off
    xlabel('Frequency [Hz]')
    ylabel({'\bfX-axis','Magnitude [-]'})
    title('Hexapod Acc.')
subplot(3,6,7)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', y_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel({'\bfY-axis','Magnitude [-]'})
    title('Hexapod Acc.')
subplot(3,6,13)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', z_color); hold on; grid on; box off
    xlabel('Frequency [Hz]');
    ylabel({'\bfZ-axis','Magnitude [-]'})
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
    title('Force FPL_X');
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
    suptitle('\bf Roll input and output signals in frequency domain');

%% Convert angular acceleration to linear acceleration
% position vectors between hexapod IMU roll axis and the strain gauges at the interfaces (distance = meters) 
r_SP     = 0.665;
r_FPL    = sqrt((0.215^2)+(0.12^2)); % Pythagoras    
r_FPR    = sqrt((0.215^2)+(0.12^2)); % Pythagoras 
r_HBL_XZ = 0.925;                    
r_HBL_Y  = sqrt((0.955^2)+(0.17^2)); % Pythagoras 
r_HBR_XZ = 0.925;                    
r_HBR_Y  = sqrt((0.955^2)+(0.17^2)); % Pythagoras 

% calculating linear velocities 
u_lin_acc_signals_SP     = u_ang_acc_signals.*r_SP; 
u_lin_acc_signals_FPL    = u_ang_acc_signals.*r_FPL;
u_lin_acc_signals_FPR    = u_ang_acc_signals.*r_FPR;
u_lin_acc_signals_HBL_XZ = u_ang_acc_signals.*r_HBL_XZ;
u_lin_acc_signals_HBL_Y  = u_ang_acc_signals.*r_HBL_Y;
u_lin_acc_signals_HBR_XZ = u_ang_acc_signals.*r_HBR_XZ;
u_lin_acc_signals_HBR_Y  = u_ang_acc_signals.*r_HBR_Y;

figure()
subplot(711)
    plot(u_lin_acc_signals_SP);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity SP')
subplot(712)
    plot(u_lin_acc_signals_FPL);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity FPL')
subplot(713)
    plot(u_lin_acc_signals_FPR);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity FPR')
subplot(714)
    plot(u_lin_acc_signals_HBL_XZ);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBL_{XZ}')
subplot(715)
    plot(u_lin_acc_signals_HBL_Y);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBL_Y')
subplot(716)
    plot(u_lin_acc_signals_HBR_XZ);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBR_{XZ}')
subplot(717)
    plot(u_lin_acc_signals_HBR_Y);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBR_Y')
    %suptitle('\bf Linear roll accelerations at all interfaces')

%% Subtract mean from input and output signals
% Input signals
u_lin_acc_signals_SP_scaled     = subtract_mean(u_lin_acc_signals_SP); 
u_lin_acc_signals_FPL_scaled    = subtract_mean(u_lin_acc_signals_FPL);
u_lin_acc_signals_FPR_scaled    = subtract_mean(u_lin_acc_signals_FPR);
u_lin_acc_signals_HBL_XZ_scaled = subtract_mean(u_lin_acc_signals_HBL_XZ);
u_lin_acc_signals_HBL_Y_scaled  = subtract_mean(u_lin_acc_signals_HBL_Y);
u_lin_acc_signals_HBR_XZ_scaled = subtract_mean(u_lin_acc_signals_HBR_XZ);
u_lin_acc_signals_HBR_Y_scaled  = subtract_mean(u_lin_acc_signals_HBR_Y);

figure()
subplot(711)
    plot(u_lin_acc_signals_SP_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity SP')
subplot(712)
    plot(u_lin_acc_signals_FPL_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity FPL')
subplot(713)
    plot(u_lin_acc_signals_FPR_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity FPR')
subplot(714)
    plot(u_lin_acc_signals_HBL_XZ_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBL_{XZ}')
subplot(715)
    plot(u_lin_acc_signals_HBL_Y_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBL_Y')
subplot(716)
    plot(u_lin_acc_signals_HBR_XZ_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBR_{XZ}')
subplot(717)
    plot(u_lin_acc_signals_HBR_Y_scaled);
    ylabel('Acceleration (m/s^2)');
    title('Linear roll velocity HBR_Y')
    %suptitle('\bf Linear roll accelerations at all interfaces')

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
    plot(u_ang_acc_signals(:,sub),'Color', x_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bfX-axis','Acc. [rad/s^2]'})
    title(['Hexapod Acc.: \mu=', num2str(mean(u_ang_acc_signals(:,sub))),' \sigma=', num2str(std(u_ang_acc_signals(:,sub)))])
subplot(3,6,7)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', y_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bfY-axis','Acc. [rad/s^2]'})
    title('Hexapod Acc.')
subplot(3,6,13)
    line([0,length(u_ang_acc_signals(:,sub))],[0,0],'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel({'\bfZ-axis','Acc. [rad/s^2]'})
    title('Hexapod Acc.')
subplot(3,6,2)
    plot(y_force_SP_X_24subs(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['SP_X: \mu=', num2str(mean(y_force_SP_X_24subs(:,sub))),' \sigma=', num2str(std(y_force_SP_X_24subs(:,sub)))]);
subplot(3,6,8)
    plot(y_force_SP_Y_24subs(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['SP_Y: \mu=', num2str(mean(y_force_SP_Y_24subs(:,sub))),' \sigma=', num2str(std(y_force_SP_Y_24subs(:,sub)))]);
subplot(3,6,14)
    plot(y_force_SP_Z_24subs(:,sub),'Color', z_color); hold on; grid on; box off
    ylabel('Force [N]');
    xlabel('Samples [-]');
    title(['SP_Z: \mu=', num2str(mean(y_force_SP_Z_24subs(:,sub))),' \sigma=', num2str(std(y_force_SP_Z_24subs(:,sub)))]);
subplot(3,6,3)
    plot(y_force_FPL_X_24subs(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['FPL_X: \mu=', num2str(mean(y_force_FPL_X_24subs(:,sub))),' \sigma=', num2str(std(y_force_FPL_X_24subs(:,sub)))]);
subplot(3,6,15)
    plot(y_force_FPL_Z_24subs(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['FPL_Z: \mu=', num2str(mean(y_force_FPL_Z_24subs(:,sub))),' \sigma=', num2str(std(y_force_FPL_Z_24subs(:,sub)))]);
subplot(3,6,4)
    plot(y_force_FPR_X_24subs(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['FPR_X: \mu=', num2str(mean(y_force_FPR_X_24subs(:,sub))),' \sigma=', num2str(std(y_force_FPR_X_24subs(:,sub)))]);
subplot(3,6,16)
    plot(y_force_FPR_Z_24subs(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['FPL_Z: \mu=', num2str(mean(y_force_FPR_Z_24subs(:,sub))),' \sigma=', num2str(std(y_force_FPR_Z_24subs(:,sub)))]);
subplot(3,6,5)
    plot(y_force_HBL_X_24subs(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBL_X: \mu=', num2str(mean(y_force_HBL_X_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBL_X_24subs(:,sub)))]);
subplot(3,6,11)
    plot(y_force_HBL_Y_24subs(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBL_Y: \mu=', num2str(mean(y_force_HBL_Y_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBL_Y_24subs(:,sub)))]);
subplot(3,6,17)
    plot(y_force_HBL_Z_24subs(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['HBL_Z: \mu=', num2str(mean(y_force_HBL_Z_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBL_Z_24subs(:,sub)))]);
subplot(3,6,6)
    plot(y_force_HBR_X_24subs(:,sub),'Color', x_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBR_X: \mu=', num2str(mean(y_force_HBR_X_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBR_X_24subs(:,sub)))]);
subplot(3,6,12)
    plot(y_force_HBR_Y_24subs(:,sub),'Color', y_color); hold on; grid on; box off
    ylabel('Force [N]');
    title(['HBR_Y: \mu=', num2str(mean(y_force_HBR_Y_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBR_Y_24subs(:,sub)))]);
subplot(3,6,18)
    plot(y_force_HBR_Z_24subs(:,sub),'Color', z_color); hold on; grid on; box off
    xlabel('Samples [-]');
    ylabel('Force [N]');
    title(['HBR_Z: \mu=', num2str(mean(y_force_HBR_Z_24subs(:,sub))),' \sigma=', num2str(std(y_force_HBR_Z_24subs(:,sub)))]);
    suptitle('\bf Roll input and output signals with zero mean in time domain');

%% Welch averaging (time domain) 
% Welch averaging is averaging of the signals in time domain over N 
% segments. After averaging, for each segment the spectral densities are 
% calculated. This is done by the function welchspectrum.

Nsegment = 10;           % number of segments over which is averaged
nfft=round(N/Nsegment); % number of samples per segment
 
% Transfer functions 24 individual subjects
[wtf_SP_X,wfv]   = my_welch_method(u_lin_acc_signals_SP_scaled,y_force_SP_X_24subs,nfft,fs);
[wtf_SP_Y,~]     = my_welch_method(u_lin_acc_signals_SP_scaled,y_force_SP_Y_24subs,nfft,fs);
[wtf_SP_Z,~]     = my_welch_method(u_lin_acc_signals_SP_scaled,y_force_SP_Z_24subs,nfft,fs);

[wtf_FPL_X,~]    = my_welch_method(u_lin_acc_signals_FPL_scaled,y_force_FPL_X_24subs,nfft,fs);
[wtf_FPL_Z,~]    = my_welch_method(u_lin_acc_signals_FPL_scaled,y_force_FPL_Z_24subs,nfft,fs);

[wtf_FPR_X,~]    = my_welch_method(u_lin_acc_signals_FPR_scaled,y_force_FPR_X_24subs,nfft,fs);
[wtf_FPR_Z,~]    = my_welch_method(u_lin_acc_signals_FPR_scaled,y_force_FPR_Z_24subs,nfft,fs);

[wtf_HBL_X,~]    = my_welch_method(u_lin_acc_signals_HBL_XZ_scaled,y_force_HBL_X_24subs,nfft,fs);
[wtf_HBL_Y,~]    = my_welch_method(u_lin_acc_signals_HBL_Y_scaled,y_force_HBL_Y_24subs,nfft,fs);
[wtf_HBL_Z,~]    = my_welch_method(u_lin_acc_signals_HBL_XZ_scaled,y_force_HBL_Z_24subs,nfft,fs);

[wtf_HBR_X,~]    = my_welch_method(u_lin_acc_signals_HBR_XZ_scaled,y_force_HBR_X_24subs,nfft,fs);
[wtf_HBR_Y,~]    = my_welch_method(u_lin_acc_signals_HBR_Y_scaled,y_force_HBR_Y_24subs,nfft,fs);
[wtf_HBR_Z,~]    = my_welch_method(u_lin_acc_signals_HBR_XZ_scaled,y_force_HBR_Z_24subs,nfft,fs);

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

%%
% Phase scaling and unwrapping
tol = 180;      % tolerance for unwrapping the phase (= degrees)

wtf_phase_SP_X  = phase_scaling(wtf_phase_SP_X);
wtf_phase_SP_X  = unwrap(wtf_phase_SP_X,tol);
wtf_phase_SP_Y  = phase_scaling(wtf_phase_SP_Y);
wtf_phase_SP_Y  = unwrap(wtf_phase_SP_Y,tol);
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
wtf_phase_HBL_Y = phase_scaling(wtf_phase_HBL_Y);
wtf_phase_HBL_Y = unwrap(wtf_phase_HBL_Y,tol);
wtf_phase_HBL_Z = phase_scaling(wtf_phase_HBL_Z);
wtf_phase_HBL_Z = unwrap(wtf_phase_HBL_Z,tol);

wtf_phase_HBR_X = phase_scaling(wtf_phase_HBR_X);
wtf_phase_HBR_X = unwrap(wtf_phase_HBR_X,tol);
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
wcoh_SP_X     = calc_coherence(u_ang_acc_signals,y_force_SP_X_24subs,nfft,fs);
wcoh_SP_Y     = calc_coherence(u_ang_acc_signals,y_force_SP_Y_24subs,nfft,fs);
wcoh_SP_Z     = calc_coherence(u_ang_acc_signals,y_force_SP_Z_24subs,nfft,fs);

wcoh_FPL_X     = calc_coherence(u_ang_acc_signals,y_force_FPL_X_24subs,nfft,fs);
wcoh_FPL_Z     = calc_coherence(u_ang_acc_signals,y_force_FPL_Z_24subs,nfft,fs);

wcoh_FPR_X     = calc_coherence(u_ang_acc_signals,y_force_FPR_X_24subs,nfft,fs);
wcoh_FPR_Z     = calc_coherence(u_ang_acc_signals,y_force_FPR_Z_24subs,nfft,fs);

wcoh_HBL_X     = calc_coherence(u_ang_acc_signals,y_force_HBL_X_24subs,nfft,fs);
wcoh_HBL_Y     = calc_coherence(u_ang_acc_signals,y_force_HBL_Y_24subs,nfft,fs);
wcoh_HBL_Z     = calc_coherence(u_ang_acc_signals,y_force_HBL_Z_24subs,nfft,fs);

wcoh_HBR_X     = calc_coherence(u_ang_acc_signals,y_force_HBR_X_24subs,nfft,fs);
wcoh_HBR_Y     = calc_coherence(u_ang_acc_signals,y_force_HBR_Y_24subs,nfft,fs);
wcoh_HBR_Z     = calc_coherence(u_ang_acc_signals,y_force_HBR_Z_24subs,nfft,fs);

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

%% Plot gain of transfer functions of 24 subjects
figure('name','Gain 24 subjects and mean rider')
subplot(3,5,1)
    %hold on; grid on;
    loglog(wfv, wtf_mag_SP_X,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks) 
    ylim(y_lim_gain)
    ylabel({'X-axis','Gain [Ns^2/m]'})
    title('Seat post')
subplot(3,5,6)
    %hold on; grid on;
    loglog(wfv, wtf_mag_SP_Y, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    ylabel({'Y-axis','Gain [Ns^2/m]'})
subplot(3,5,11)
    %hold on; grid on;
    loglog(wfv, wtf_mag_SP_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    ylabel({'Z-axis','Gain [Ns^2/m]'})
    xlabel('Frequency [Hz]')
subplot(3,5,2)
    %hold on; grid on;
    loglog(wfv, wtf_mag_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    title('Foot peg left')
subplot(3,5,12)
    %hold on; grid on;
    loglog(wfv, wtf_mag_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    xlabel('Frequency [Hz]')
subplot(3,5,3)
    %hold on; grid on;
    loglog(wfv, wtf_mag_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    title('Foot peg right')
subplot(3,5,13)
    %hold on; grid on;
    loglog(wfv, wtf_mag_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    xlabel('Frequency [Hz]')
subplot(3,5,4)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    title('Handlebar left')
subplot(3,5,9)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
subplot(3,5,14)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    xlabel('Frequency [Hz]');
subplot(3,5,5)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    title('Handlebar right')
subplot(3,5,10)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
subplot(3,5,15)
    %hold on; grid on;
    loglog(wfv, wtf_mag_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    loglog(wfv, wtf_mag_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylim(y_lim_gain)
    xlabel('Frequency [Hz]');
    suptitle('\bf Roll gain plots for individual subjects and mean rider')
    
%% Plot phase of transfer functions of 24 subjects
figure('name','Phase 24 subjects and mean rider')
subplot(3,5,1)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_SP_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    title('Seat post')
    ylabel({'X-axis','Phase [deg]'})
subplot(3,5,6)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_SP_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    ylabel({'Y-axis','Phase [deg]'})
subplot(3,5,11)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_SP_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    ylabel({'Z-axis','Phase [deg]'})
    xlabel('Frequency [Hz]')
subplot(3,5,2)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    title('Foot peg left')
subplot(3,5,12)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,3)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    title('Foot peg right')
subplot(3,5,13)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,4)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    title('Handlebar left')
subplot(3,5,9)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
subplot(3,5,14)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,5)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    title('Handlebar right')
subplot(3,5,10)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
subplot(3,5,15)
    %hold on; grid on;
    semilogx(wfv, wtf_phase_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wtf_phase_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    xlim(x_lim_gain)
    %ylim([-180 180])
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    suptitle('\bf Roll phase plots for individual subjects and mean rider')
    
%% Plot coherence of transfer functions of 24 subjects
figure('name','Coherence 24 subjects and mean rider')
subplot(3,5,1)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_X, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylabel({'X-axis','\gamma^2 [-]'})
    title('Seat post')
subplot(3,5,6)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_Y, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    ylabel({'Y-axis','\gamma^2 [-]'})
subplot(3,5,11)
    %hold on; grid on;
    semilogx(wfv, wcoh_SP_Z, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_SP_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain) 
    xticks(x_ticks)
    ylabel({'Z-axis','\gamma^2 [-]'})
    xlabel('Frequency [Hz]')
subplot(3,5,2)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    title('Foot peg left')
subplot(3,5,12)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,3)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    title('Foot peg right')
subplot(3,5,13)
    %hold on; grid on;
    semilogx(wfv, wcoh_FPR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_FPR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,4)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    title('Handlebar left')
subplot(3,5,9)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
subplot(3,5,14)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBL_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBL_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
subplot(3,5,5)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_X, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_X_mean_rider, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    title('Handlebar right')
subplot(3,5,10)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_Y, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_Y_mean_rider, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
subplot(3,5,15)
    %hold on; grid on;
    semilogx(wfv, wcoh_HBR_Z, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
    semilogx(wfv, wcoh_HBR_Z_mean_rider, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
    ylim([0 1])
    xlim(x_lim_gain)
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    suptitle('\bf Roll coherence plots for individual subjects and mean rider')
 %%  Plot gain of mean rider with STD of 24 subjects shaded
figure('name','Gain std and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
stdshade((wtf_mag_SP_X)',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12])
%     ylim([-180  180]);
    ylabel({'X-axis','Gain [Ns^2/m]'})
    title('Seat')
    xticks(x_ticks)
    title('Seat')
    set(gca, 'XScale', 'log')
subplot(3,3,4)
stdshade(wtf_mag_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks);
    ylabel({'Y-axis','Gain [Ns^2/m]'});
    set(gca, 'XScale', 'log')
subplot(3,3,7)
stdshade(wtf_mag_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'Z-axis','Gain [Ns^2/m]'})
    xlabel('Frequency [Hz]')
    set(gca, 'XScale', 'log')
subplot(3,3,2)
wtf_mag_FPLR_X=(wtf_mag_FPL_X+wtf_mag_FPR_X)/2; %merging left and right footpeg x axis
stdshade(wtf_mag_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Footpegs')
subplot(3,3,8)
wtf_mag_FPLR_Z=(wtf_mag_FPL_Z+wtf_mag_FPR_Z)/2; %merging left and right footpeg z axis
stdshade(wtf_mag_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    xlabel('Frequency [Hz]');
subplot(3,3,3)
wtf_mag_HBLR_X=(wtf_mag_HBL_X+wtf_mag_HBR_X/2); %merging left and right handlebar x axis
stdshade(wtf_mag_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Handlebars')
subplot(3,3,6)
wtf_mag_HBLR_Y=(wtf_mag_HBL_Y+wtf_mag_HBR_Y)/2; %merging left and right handlebar y axis
 stdshade(wtf_mag_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
set(gca, 'XScale', 'log')
    xticks(x_ticks)
subplot(3,3,9)
wtf_mag_HBLR_Z=(wtf_mag_HBL_Z+wtf_mag_HBR_Z)/2; %merging left and right handlebar z axis
 stdshade(wtf_mag_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
     xlabel('Frequency [Hz]');
     set(gca, 'XScale', 'log')
 suptitle('\bf Roll gain plots mean rider')
%%  Plot phase of mean rider with STD of 24 subjects shaded
figure('name','Phase std and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
stdshade(wtf_phase_SP_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12])
%     ylim([-180  180]);
    ylabel({'X-axis','Gain [kg]'})
    xlabel('Frequency [Hz]')
    title('Seat')
    xticks(x_ticks)
    title('Seat')
    ylabel({'X-axis','Phase [deg]'})
    set(gca, 'XScale', 'log')
subplot(3,3,4)
stdshade(wtf_phase_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks);
    ylabel({'Y-axis','Phase [deg]'});
    set(gca, 'XScale', 'log')
subplot(3,3,7)
stdshade(wtf_phase_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    ylabel({'Z-axis','Phase [deg]'})
    xlabel('Frequency [Hz]')
    set(gca, 'XScale', 'log')
subplot(3,3,2)
wtf_phase_FPLR_X=(wtf_phase_FPL_X+wtf_phase_FPR_X)/2; %merging left and right footpeg x axis
stdshade(wtf_phase_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Footpegs')
subplot(3,3,8)
wtf_phase_FPLR_Z=(wtf_phase_FPL_Z+wtf_phase_FPR_Z)/2; %merging left and right footpeg z axis
stdshade(wtf_phase_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log')
subplot(3,3,3)
wtf_phase_HBLR_X=(wtf_phase_HBL_X+wtf_phase_HBR_X)/2; %merging left and right handlebar x axis
stdshade(wtf_phase_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Handlebars')
subplot(3,3,6)
wtf_phase_HBLR_Y=(wtf_phase_HBL_Y+wtf_phase_HBR_Y)/2; %merging left and right handlebar y axis
 stdshade(wtf_phase_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    xlabel('Frequency [Hz]');
subplot(3,3,9)
wtf_phase_HBLR_Z=(wtf_phase_HBL_Z+wtf_phase_HBR_Z)/2; %merging left and right handlebar Z axis
 stdshade(wtf_phase_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
    xlim([0.16 12]);
%     ylim([-180  180]);
    xticks(x_ticks)
     xlabel('Frequency [Hz]');
     set(gca, 'XScale', 'log')
 suptitle('\bf Roll phase plots mean rider')
 
%% Plot coherence of mean rider with STD of 24 subjects shaded
figure('name','Coherence std and mean rider')
wfv(1,1)=0.1; % make first elements of frequency vector none zero to allow stdshade function to work
subplot(3,3,1)
stdshade(wcoh_SP_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    ylabel({'X-axis','\gamma^2 [-]'})
    set(gca, 'XScale', 'log')
    title('Seat')
subplot(3,3,4)
stdshade(wcoh_SP_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
    ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    ylabel({'Y-axis','\gamma^2 [-]'})
    set(gca, 'XScale', 'log')
subplot(3,3,7)
stdshade(wcoh_SP_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
   ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    ylabel({'Z-axis','\gamma^2 [-]'})
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log')
subplot(3,3,2)
wcoh_phase_FPLR_X=(wcoh_FPL_X+wcoh_FPR_X)/2; %merging left and right footpeg
stdshade(wcoh_phase_FPLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Footpegs')
subplot(3,3,8)
wcoh_FPLR_Z=(wcoh_FPL_Z+wcoh_FPR_Z)/2; %merging left and right footpeg z axis
stdshade(wcoh_FPLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
     ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    xlabel('Frequency [Hz]');
    set(gca, 'XScale', 'log')
subplot(3,3,3)
wcoh_HBLR_X=(wcoh_HBL_X+wcoh_HBR_X)/2; %merging left and right handlebar x axis
stdshade(wcoh_HBLR_X',std_shadow,'r',wfv,[]); hold on; grid on; box off
    ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    title('Handlebars')
subplot(3,3,6)
wcoh_HBLR_Y=(wcoh_HBL_Y+wcoh_HBR_Y)/2; %merging left and right handlebar y axis
 stdshade(wcoh_HBLR_Y',std_shadow,'g',wfv,[]); hold on; grid on; box off
     ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
    set(gca, 'XScale', 'log')
    xlabel('Frequency [Hz]');
subplot(3,3,9)
wcoh_HBLR_Z=(wcoh_HBL_Z+wcoh_HBR_Z)/2; %merging left and right handlebar z axis
 stdshade(wcoh_HBLR_Z',std_shadow,'b',wfv,[]); hold on; grid on; box off
     ylim([0 1])
    xlim([0.16 12]);
    xticks(x_ticks)
     xlabel('Frequency [Hz]');
     set(gca, 'XScale', 'log')
 suptitle('\bf Roll coherence plots mean rider')
    
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
%     title('Seat post')
%     ylabel({'X-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,6)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Y)
%     xlim([0 25])
%     ylabel({'Y-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,11)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Z)
%     xlim([0 25])
%     ylabel({'Z-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,2)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_X)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject')
%     title('Foot peg left')
% subplot(3,5,12)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_Z)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,3)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_X)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Foot peg right')
% subplot(3,5,13)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_Z)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,4)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_X)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Handlebar left')
% subplot(3,5,9)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Y)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,14)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Z)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,5)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_X)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Handlebar right')
% subplot(3,5,10)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Y)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,15)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Z)
%     xlim([0 25])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     
%% Normalise transfer functions of subjects with the lowest freq. gain (= 0.5 Hz)
% % Normalised transfer functions of individual subjects Trial 1
% wtf_mag_SP_X_norm     = wtf_mag_SP_X./body_mass_24subs;
% wtf_mag_SP_Y_norm     = wtf_mag_SP_Y./body_mass_24subs;
% wtf_mag_SP_Z_norm     = wtf_mag_SP_Z./body_mass_24subs;
% 
% wtf_mag_FPL_X_norm    = wtf_mag_FPL_X./body_mass_24subs;
% wtf_mag_FPL_Z_norm    = wtf_mag_FPL_Z./body_mass_24subs;
% 
% wtf_mag_FPR_X_norm    = wtf_mag_FPR_X./body_mass_24subs;
% wtf_mag_FPR_Z_norm    = wtf_mag_FPR_Z./body_mass_24subs;
% 
% wtf_mag_HBL_X_norm    = wtf_mag_HBL_X./body_mass_24subs;
% wtf_mag_HBL_Y_norm    = wtf_mag_HBL_Y./body_mass_24subs;
% wtf_mag_HBL_Z_norm    = wtf_mag_HBL_Z./body_mass_24subs;
% 
% wtf_mag_HBR_X_norm    = wtf_mag_HBR_X./body_mass_24subs;
% wtf_mag_HBR_Y_norm    = wtf_mag_HBR_Y./body_mass_24subs;
% wtf_mag_HBR_Z_norm    = wtf_mag_HBR_Z./body_mass_24subs;
% 
% % Mean body mass of 24 subjects
% mean_body_mass_24subs = mean(body_mass_24subs,2);
% 
% % Normalized transfer functions of mean rider of trial 1
% wtf_mag_SP_X_mean_rider_norm     = wtf_mag_SP_X_mean_rider./mean_body_mass_24subs;
% wtf_mag_SP_Y_mean_rider_norm     = wtf_mag_SP_Y_mean_rider./mean_body_mass_24subs;
% wtf_mag_SP_Z_mean_rider_norm     = wtf_mag_SP_Z_mean_rider./mean_body_mass_24subs;
% 
% wtf_mag_FPL_X_mean_rider_norm    = wtf_mag_FPL_X_mean_rider./mean_body_mass_24subs;
% wtf_mag_FPL_Z_mean_rider_norm    = wtf_mag_FPL_Z_mean_rider./mean_body_mass_24subs;
% 
% wtf_mag_FPR_X_mean_rider_norm    = wtf_mag_FPR_X_mean_rider./mean_body_mass_24subs;
% wtf_mag_FPR_Z_mean_rider_norm    = wtf_mag_FPR_Z_mean_rider./mean_body_mass_24subs;
% 
% wtf_mag_HBL_X_mean_rider_norm    = wtf_mag_HBL_X_mean_rider./mean_body_mass_24subs;
% wtf_mag_HBL_Y_mean_rider_norm    = wtf_mag_HBL_Y_mean_rider./mean_body_mass_24subs;
% wtf_mag_HBL_Z_mean_rider_norm    = wtf_mag_HBL_Z_mean_rider./mean_body_mass_24subs;
% 
% wtf_mag_HBR_X_mean_rider_norm    = wtf_mag_HBR_X_mean_rider./mean_body_mass_24subs;
% wtf_mag_HBR_Y_mean_rider_norm    = wtf_mag_HBR_Y_mean_rider./mean_body_mass_24subs;
% wtf_mag_HBR_Z_mean_rider_norm    = wtf_mag_HBR_Z_mean_rider./mean_body_mass_24subs;

% %% Plot normalised transfer functions
% figure('name','Normalised gain 24 subjects and mean rider')
% subplot(3,5,1)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_X_norm,'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks) 
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     ylabel({'X-axis','Gain [-]'})
%     title('Seat post')
% subplot(3,5,6)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_Y_norm, 'Color', indv_color, 'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     ylabel({'Y-axis','Gain [-]'})
% subplot(3,5,11)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_SP_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_SP_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_gain)
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
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Foot peg left')
% subplot(3,5,12)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPL_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPL_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]')
% subplot(3,5,3)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPR_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPR_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Foot peg right')
% subplot(3,5,13)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_FPR_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_FPR_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]')
% subplot(3,5,4)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Handlebar left')
% subplot(3,5,9)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_Y_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
% subplot(3,5,14)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBL_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBL_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm)
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]');
% subplot(3,5,5)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_X_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_X_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', x_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm)
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     title('Handlebar right')
% subplot(3,5,10)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_Y_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_Y_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', y_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
% subplot(3,5,15)
%     %hold on; grid on;
%     loglog(wfv, wtf_mag_HBR_Z_norm, 'Color', indv_color,'linewidth', indv_linewidth); hold on; grid on; box off
%     loglog(wfv, wtf_mag_HBR_Z_mean_rider_norm, 'linewidth', mean_linewidth, 'Color', z_color); hold on; grid on; box off
%     xlim(x_lim_gain)
%     ylim(y_lim_norm)
%     xticks(x_ticks)
%     yticks(y_ticks_norm) 
%     yticklabels({'0.001', '0.01', '0.1', '1', '10'})
%     xlabel('Frequency [Hz]');
%     suptitle('\bf Roll normalised gain plots for individual subjects and mean rider')

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
%     title('Seat post')
%     ylabel({'X-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,6)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Y_norm)
%     xlim([0 24])
%     ylabel({'Y-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,11)
%     hold on; grid on;
%     bar(std_wtf_mag_SP_Z_norm)
%     xlim([0 24])
%     ylabel({'Z-axis','STD [kg]'})
%     xlabel('Subject')
% subplot(3,5,2)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_X_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject')
%     title('Foot peg left')
% subplot(3,5,12)
%     hold on; grid on;
%     bar(std_wtf_mag_FPL_Z_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,3)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_X_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Foot peg right')
% subplot(3,5,13)
%     hold on; grid on;
%     bar(std_wtf_mag_FPR_Z_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,4)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_X_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Handlebar left')
% subplot(3,5,9)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Y_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,14)
%     hold on; grid on;
%     bar(std_wtf_mag_HBL_Z_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,5)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_X_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
%     title('Handlebar right')
% subplot(3,5,10)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Y_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
% subplot(3,5,15)
%     hold on; grid on;
%     bar(std_wtf_mag_HBR_Z_norm)
%     xlim([0 24])
%     ylabel('STD [kg]');
%     xlabel('Subject');
