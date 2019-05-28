%% Processing and analysing raw sway force data for all interfaces for 24 subjects

% This script processes the raw sway force data for 24 subjects into final
% force signals suitable for system identification.

clear all
close all
clc 

%% Load files

% !!! CHANGE DESIGNED PERTURBATION FOR CORRECT MOTION HERE !!!
% Designed perturbation signal
load('sway_pert_amp075'); 
clearvars sway_vel_amp075 sway_dis_amp075

% !!! CHANGE mat-file FOR CORRECT MOTION HERE !!!
% Measured force signals
force_data  = load('cell_array_sway_force_24subs.mat');

% Strain gauge offsets (for all motions the same)
sensor_data = load('mean_strain_gauge_OS_24subs');

%% Define the correct sign convention here
des_pert    = sway_acc_amp075;

%% Genereta cell structure (DO NOT CHANGE!)
force_data  = struct2cell(force_data);
cell_strain = struct2cell(sensor_data);

%% Solve for sensor offset (DO NOT CHANGE!)

% this function solves for the offset as a result of sensor fusion
[offset, trial1, trial2] = solve_sensor_fusion(force_data, cell_strain); 

%% Subscribe forces to correct interfaces
% SP = seat post, FPL = foot pegs left, FPR = foot pegs right, HBL = handlebar left and HBR = handlebar right
% X = longitudinal, Y = lateral and Z = vertical

% column order in which the strain gauges measure the interface forces:
% SP_X, SP_Z, SP_Y, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Z, HBL_Y, HBR_Z,
% HBR_X, HBR_Y (13 forces)

% the CORRECT column order used in the analysis of this research is: 
% SP_X, SP_Y, SP_Z, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Y, HBL_Z, HBR_X, 
% HBR_Y, HBR_Z (13 forces)

% this function orders the columns in the CORRECT order (comment above) for 
% all trials and combines all interface forces for 24 subjects
[interface_force_OS, interface_force_t1, interface_force_t2] = combine_interface_forces_24subs(offset, trial1, trial2);

%% Plot scaled interface forces for all trials for 24 subjects

% plot all interface forces for 24 subs for the offset trial 
figure('name','Offset trial')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_OS{1})
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(interface_force_OS{2})
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(interface_force_OS{3})
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_OS{4})
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_OS{5})
subplot(3,5,3)
hold on; grid on;
plot(interface_force_OS{6})
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_OS{7})
subplot(3,5,4)
hold on; grid on;
plot(interface_force_OS{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_OS{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_OS{10})
subplot(3,5,5)
hold on; grid on;
plot(interface_force_OS{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_OS{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_OS{13})

% plot all interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_t1{1})
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(interface_force_t1{2})
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(interface_force_t1{3})
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_t1{4})
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_t1{5})
subplot(3,5,3)
hold on; grid on;
plot(interface_force_t1{6})
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_t1{7})
subplot(3,5,4)
hold on; grid on;
plot(interface_force_t1{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_t1{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_t1{10})
subplot(3,5,5)
hold on; grid on;
plot(interface_force_t1{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_t1{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_t1{13})

% plot all interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_t2{1})
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(interface_force_t2{2})
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(interface_force_t2{3})
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_t2{4})
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_t2{5})
subplot(3,5,3)
hold on; grid on;
plot(interface_force_t2{6})
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_t2{7})
subplot(3,5,4)
hold on; grid on;
plot(interface_force_t2{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_t2{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_t2{10})
subplot(3,5,5)
hold on; grid on;
plot(interface_force_t2{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_t2{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_t2{13})

%% Calculate delay and align all measured interface forces with the designed signal 
close all 

% this function calculates for all participants the delay between the
% designed signal and the measured interface forces for trial 1 and 2.
[t1_aligned, lag_t1] = my_xcov_function(des_pert, interface_force_t1);
[t2_aligned, lag_t2] = my_xcov_function(des_pert, interface_force_t2);

%% Extract perturbation part from measured signals

% this function extracts for all measured interface forces only the
% perturbation part for 24 subjects
pert_part_t1 = extract_pert_part(t1_aligned);
pert_part_t2 = extract_pert_part(t2_aligned);

%% Convert to real forces

% this function converts the measured interface forces to real forces by
% multiplying all measured interface forces with a linear calibrated
% formula of the corresponding strain gauges
final_forces_t1 = convert_to_forces(pert_part_t1);
final_forces_t2 = convert_to_forces(pert_part_t2);

%% Plot the final interface forces of 24 subjects

% plot all final interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t1{1})
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t1{2})
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t1{3})
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t1{4})
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t1{5})
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t1{6})
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t1{7})
subplot(3,5,4)
hold on; grid on;
plot(final_forces_t1{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(final_forces_t1{9})
subplot(3,5,14)
hold on; grid on;
plot(final_forces_t1{10})
subplot(3,5,5)
hold on; grid on;
plot(final_forces_t1{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(final_forces_t1{12})
subplot(3,5,15)
hold on; grid on;
plot(final_forces_t1{13})

% plot all final interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t2{1})
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t2{2})
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t2{3})
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t2{4})
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t2{5})
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t2{6})
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t2{7})
subplot(3,5,4)
hold on; grid on;
plot(final_forces_t2{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(final_forces_t2{9})
subplot(3,5,14)
hold on; grid on;
plot(final_forces_t2{10})
subplot(3,5,5)
hold on; grid on;
plot(final_forces_t2{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(final_forces_t2{12})
subplot(3,5,15)
hold on; grid on;
plot(final_forces_t2{13})

%% Validation of this automatic script 

% this section validates the result of this script by comparing de result
% (= final interface forces) with the manually calculated interface forces
% for one participant. The manual results for one participant are
% calculated by the m-file: script_validation_indv_subject.m (FIRTST RUN
% THIS m-file BEFORE RUNNING THIS SECTION!!!)

indv_sub = load('validation_force_indv_sub.mat'); % interface forces manually calculated
cell_indv_sub   = struct2cell(indv_sub);
mat_indv_sub    = cell2mat(cell_indv_sub); 

participant     = 1; % change this to the participant which should be compared

% plot all interface forces from this script, and from the script which
% calculates the interface force manually for trial 1
figure('name', 'Validation trial 1')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t1{1}(:,participant),'b');
plot(mat_indv_sub(:,1),'r')%,'LineStyle','--');
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t1{2}(:,participant),'b');
plot(mat_indv_sub(:,2),'r')%,'LineStyle','--');
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t1{3}(:,participant),'b');
plot(mat_indv_sub(:,3),'r')%,'LineStyle','--');
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t1{4}(:,participant),'b');
plot(mat_indv_sub(:,4),'r')%,'LineStyle','--');
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t1{5}(:,participant),'b');
plot(mat_indv_sub(:,5),'r')%,'LineStyle','--');
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t1{6}(:,participant),'b');
plot(mat_indv_sub(:,6),'r')%,'LineStyle','--');
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t1{7}(:,participant),'b');
plot(mat_indv_sub(:,7),'r')%,'LineStyle','--');
subplot(3,5,4)
hold on; grid on;
plot(final_forces_t1{8}(:,participant),'b');
plot(mat_indv_sub(:,8),'r')%,'LineStyle','--');
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(final_forces_t1{9}(:,participant),'b');
plot(mat_indv_sub(:,9),'r')%,'LineStyle','--');
subplot(3,5,14)
hold on; grid on;
plot(final_forces_t1{10}(:,participant),'b');
plot(mat_indv_sub(:,10),'r')%,'LineStyle','--');
subplot(3,5,5)
hold on; grid on;
plot(final_forces_t1{11}(:,participant),'b');
plot(mat_indv_sub(:,11),'r')%,'LineStyle','--');
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(final_forces_t1{12}(:,participant),'b');
plot(mat_indv_sub(:,12),'r')%,'LineStyle','--');
subplot(3,5,15)
hold on; grid on;
plot(final_forces_t1{13}(:,participant),'b');
plot(mat_indv_sub(:,13),'r')%,'LineStyle','--');

%%% !!! UNCOMMENT BELOW WHEN COMPARING DATA FROM TRIAL 2 !!! %%%

% plot all interface forces from this script, and from the script which
% calculates the interface force manually for trial 2

% figure('name', 'Validation trial 2')
% subplot(3,5,1)
% hold on; grid on;
% plot(forces_t2{1}(:,participant),'b');
% plot(mat_indv_sub(:,1),'r')%,'LineStyle','--');
% title('Seat post')
% ylabel('X-direction')
% subplot(3,5,6)
% hold on; grid on;
% plot(forces_t2{2}(:,participant),'b');
% plot(mat_indv_sub(:,2),'r')%,'LineStyle','--');
% ylabel('Y-direction')
% subplot(3,5,11)
% hold on; grid on;
% plot(forces_t2{3}(:,participant),'b');
% plot(mat_indv_sub(:,3),'r')%,'LineStyle','--');
% ylabel('Z-direction')
% subplot(3,5,2)
% hold on; grid on;
% plot(forces_t2{4}(:,participant),'b');
% plot(mat_indv_sub(:,4),'r')%,'LineStyle','--');
% title('Foot pegs left')
% subplot(3,5,12)
% hold on; grid on;
% plot(forces_t2{5}(:,participant),'b');
% plot(mat_indv_sub(:,5),'r')%,'LineStyle','--');
% subplot(3,5,3)
% hold on; grid on;
% plot(forces_t2{6}(:,participant),'b');
% plot(mat_indv_sub(:,6),'r')%,'LineStyle','--');
% title('Foot pegs right')
% subplot(3,5,13)
% hold on; grid on;
% plot(forces_t2{7}(:,participant),'b');
% plot(mat_indv_sub(:,7),'r')%,'LineStyle','--');
% subplot(3,5,4)
% hold on; grid on;
% plot(forces_t2{8}(:,participant),'b');
% plot(mat_indv_sub(:,8),'r')%,'LineStyle','--');
% title('Handlebar left')
% subplot(3,5,9)
% hold on; grid on;
% plot(forces_t2{9}(:,participant),'b');
% plot(mat_indv_sub(:,9),'r')%,'LineStyle','--');
% subplot(3,5,14)
% hold on; grid on;
% plot(forces_t2{10}(:,participant),'b');
% plot(mat_indv_sub(:,10),'r')%,'LineStyle','--');
% subplot(3,5,5)
% hold on; grid on;
% plot(forces_t2{11}(:,participant),'b');
% plot(mat_indv_sub(:,11),'r')%,'LineStyle','--');
% title('Handlebar right')
% subplot(3,5,10)
% hold on; grid on;
% plot(forces_t2{12}(:,participant),'b');
% plot(mat_indv_sub(:,12),'r')%,'LineStyle','--');
% subplot(3,5,15)
% hold on; grid on;
% plot(forces_t2{13}(:,participant),'b');
% plot(mat_indv_sub(:,13),'r')%,'LineStyle','--');

%% Store final force signals for system identification (SI) 

%%% !!! CHANGE NAME IN CORRECT MOTION !!! %%%
sway_force_signals_SI_t1 = final_forces_t1; 
sway_force_signals_SI_t2 = final_forces_t2;

%%% !!! STORE IN SAME DIRECTORY THAT CONTAINS THE TRANSFER FUNCTION SCRIPT FOR RIDER ID !!! %%% 
save('D:\gdialynas\Desktop\My files\Passive rider project\Msc_Jelle_de_hann\Force_Data\Sway\sway_force_signals_SI_t1_t2.mat','sway_force_signals_SI_t1','sway_force_signals_SI_t2');