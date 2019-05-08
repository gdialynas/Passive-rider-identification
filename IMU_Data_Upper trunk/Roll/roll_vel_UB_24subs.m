%% Processing and analysing raw roll IMU data for upperbody for 24 subjects

% This script processes the raw upperbody IMU data for 24 subjects into final
% angular velocity input signals suitable for system identification.

clear all
close all
clc 

%% Load files
% !!! CHANGE DESIGNED PERTURBATION FOR CORRECT MOTION HERE !!!
% Designed perturbation signal
load('roll_pert_amp1'); 
clearvars roll_acc_amp1 roll_dis_amp1

% !!! CHANGE mat-file FOR CORRECT MOTION HERE !!!
% Measured force signals
IMU_data  = load('cell_array_roll_upperbody_IMU_data_24subs.mat');

%% Define the correct sign convention here
des_pert    = -roll_vel_amp1;
clearvars roll_vel_amp1

%% Genereta cell structure (DO NOT CHANGE!)
IMU_data    = struct2cell(IMU_data);
offset      = cell2mat(IMU_data{1});
trial1      = cell2mat(IMU_data{2});
trial2      = cell2mat(IMU_data{3});

%% Plot raw angular velocity data
figure('name', 'Raw IMU data')
subplot(311)
    plot(offset)
    xlabel('Samples [-]')
    ylabel('Angular velocity [rad/s]')
    title('Offset trial');
subplot(312)
    plot(trial1)
    xlabel('Samples [-]')
    ylabel('Angular velocity [rad/s]')
    title('Perturbation trial 1');
subplot(313)
    plot(trial2)
    xlabel('Samples [-]')
    ylabel('Angular velocity [rad/s]')
    title('Perturbation trial 2');
    
%% Filtering IMU data for removing noise
close all
offset_filt = IMU_noise_filter(offset);
trial1_filt = IMU_noise_filter(trial1);
trial2_filt = IMU_noise_filter(trial2);

%% Plot unfiltered against filtered IMU data
figure('name','Unfiltered vs. filtered IMU data')
subplot(231)
    plot(offset)
%    ylim([8 12]);
%   xlim([0 7000]);
    ylabel('Angular velocity [rad/s]')
    title('Offset trial unfiltered');
subplot(234)
    plot(offset_filt)
%     ylim([8 12]);
%     xlim([0 7000]);
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    title('Offset trial filtered');
subplot(232)
    plot(trial1)
%     ylim([8 12]);
%     xlim([0 7000]);
    title('Trial 1 unfiltered');
subplot(235)
    plot(trial1_filt)
%     ylim([8 12]);
%     xlim([0 7000]);
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    title('Trial 1 filtered');
subplot(233)
    plot(trial2)
%     ylim([8 12]);
%     xlim([0 7000]);
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    title('Trial 2 unfiltered');
subplot(236)
    plot(trial2_filt)
%     ylim([8 12]);
%     xlim([0 7000]);
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    title('Trial 2 filtered');

%% Compare designed perturbation signal with measured IMU signal
close all
figure()
    hold on;
    plot(des_pert);
    plot(trial1_filt(:,1));
    legend('Des. perturbation', 'Mes. signal')

%% Calculate delay and align all measured interface forces with the designed signal 
close all 

% this function calculates for all participants the delay between the
% designed signal and the measured IMU signals for trial 1 and 2.
[t1_aligned, lag_t1] = my_xcov_function_IMU(des_pert, trial1_filt);
[t2_aligned, lag_t2] = my_xcov_function_IMU(des_pert, trial2_filt);

%% Resample the measured IMU data
% p and q define the resampling rate = p/q
p = 6500;
q = 6503;

t1_resampled = my_resample_function(t1_aligned,p,q);
t2_resampled = my_resample_function(t2_aligned,p,q);

%% Check here the effect of my_xcov fuction
% give in subject number here
subject = 15;

% calculate offset of IMU sensor for better comparison 
 error = mean(offset(1000:6000,subject));
% 
figure('name','Checking the effect of my_xcov fuction')
subplot(211)
    hold on;
    plot(des_pert)
    plot(t1_aligned{subject}-error)
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    legend('Des. perturbation', 'Raw Mes. signal')
subplot(212)
    hold on;
    plot(des_pert)
    plot(t1_resampled{subject}-error)
    ylabel('Angular velocity [rad/s]')
    xlabel('Samples [-]')
    legend('Des. perturbation', 'Aligned. Mes. signal')

%% Extract perturbation part from measured IMU signals
final_vel_t1 = extract_pert_part_IMU(t1_aligned);
final_vel_t2 = extract_pert_part_IMU(t2_aligned);

figure()
subplot(211)
    plot(final_vel_t1);
    xlim([0 1000]);
subplot(212)
    plot(final_vel_t2);
    xlim([0 1000]);
    
%% Store final vel. signals for system identification (SI) 
close all
%%% !!! CHANGE NAME IN CORRECT MOTION !!! %%%
roll_vel_upperbody_signals_SI_t1 = final_vel_t1; 
roll_vel_upperbody_signals_SI_t2 = final_vel_t2;

%%% !!! STORE IN SAME DIRECTORY THAT CONTAINS THE TRANSFER FUNCTION SCRIPT FOR RIDER ID !!! %%% 
save('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\IMU_data\Upperbody\Roll\roll_vel_upperbody_signals_SI_t1_t2.mat','roll_vel_upperbody_signals_SI_t1','roll_vel_upperbody_signals_SI_t2');
