%% Processing and analysing raw sway force data for all interfaces for 24 subjects

% Author: Jelle Waling de Haan
% Graduation project: Passive Rider Identification 
% Script: Generating force signals for passive rider identification 
% Last update: 28-02-2019

% This script processes the raw sway force data for 24 subjects into
% force signals suitable for passive bicycle rider identification.

clear all
close all
clc  

%% Load files
% !!! LOAD DESIGNED PERTURBATION FOR CORRECT MOTION HERE !!!
% Designed perturbation signal
load('sway_pert_amp075'); 
clearvars sway_vel_amp075 sway_dis_amp075

% !!! LOAD mat-file FOR CORRECT MOTION HERE !!!
% Measured force signals
load('cell_array_sway_force_24subs.mat');

% Strain gauge offsets (for all motions the same)
load('mean_strain_gauge_OS_24subs');

% Crosstalk for handlebar forces in lateral direction
crosstalk_handlebars = xlsread('crosstalk_calibration_handlebars_sway.xlsx');

%% Define the correct sign convention
des_pert = sway_acc_amp075;

%% Genereta cell structure (DO NOT CHANGE!)
force_data = {sway_force_24subs_OS,sway_force_24subs_t1,sway_force_24subs_t2};
clearvars sway_force_24subs_OS sway_force_24subs_t1 sway_force_24subs_t2

%% Plot mean strain gauge offsets
figure('name','Strain gauge offsets for subject groups')
subplot(531)
    hold on
    bar(1,mean_strain_gauge_OS_24subs{1}(:,1));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,1));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,1));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,1));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,1));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,1));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,1));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,1));
    ylabel('Voltage [V]');
    title('SP_X');
subplot(532)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,3));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,3));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,3));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,3));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,3));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,3));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,3));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,3));
    ylabel('Voltage [V]');
    title('SP_Y');
subplot(533)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,2));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,2));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,2));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,2));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,2));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,2));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,2));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,2));
    ylabel('Voltage [V]');
    title('SP_Z');
subplot(534)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,4));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,4));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,4));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,4));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,4));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,4));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,4));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,4));
    ylabel('Voltage [V]');
    title('FPL_X');
subplot(535)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,5));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,5));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,5));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,5));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,5));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,5));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,5));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,5));
    ylabel('Voltage [V]');
    title('FPL_Z');
subplot(537)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,6));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,6));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,6));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,6));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,6));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,6));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,6));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,6));
    ylabel('Voltage [V]');
    title('FPR_X');
subplot(538)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,7));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,7));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,7));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,7));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,7));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,7));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,7));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,7));
    ylabel('Voltage [V]');
    title('FPR_Z');
subplot(5,3,10)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,8));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,8));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,8));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,8));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,8));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,8));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,8));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,8));
    ylabel('Voltage [V]');
    title('HBL_X');
subplot(5,3,11)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,10));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,10));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,10));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,10));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,10));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,10));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,10));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,10));
    ylabel('Voltage [V]');
    title('HBL_Y');
subplot(5,3,12)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,9));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,9));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,9));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,9));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,9));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,9));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,9));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,9));
    ylabel('Voltage [V]');
    title('HBL_Z');
subplot(5,3,13)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,12));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,12));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,12));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,12));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,12));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,12));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,12));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,12));
    ylabel('Voltage [V]');
    title('HBR_X');
subplot(5,3,14)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,13));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,13));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,13));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,13));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,13));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,13));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,13));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,13));
    ylabel('Voltage [V]');
    title('HBR_Y');
subplot(5,3,15)
    hold on;
    bar(1,mean_strain_gauge_OS_24subs{1}(:,11));
    bar(2,mean_strain_gauge_OS_24subs{2}(:,11));
    bar(3,mean_strain_gauge_OS_24subs{3}(:,11));
    bar(4,mean_strain_gauge_OS_24subs{4}(:,11));
    bar(5,mean_strain_gauge_OS_24subs{5}(:,11));
    bar(6,mean_strain_gauge_OS_24subs{6}(:,11));
    bar(7,mean_strain_gauge_OS_24subs{7}(:,11));
    bar(8,mean_strain_gauge_OS_24subs{8}(:,11));
    ylabel('Voltage [V]');
    title('HBR_Z');
    
%% Solve for sensor offset (DO NOT CHANGE!)
close all
% This function solves for the offset as a result of sensor fusion
[offset, trial1, trial2] = solve_sensor_fusion(force_data, mean_strain_gauge_OS_24subs); 

%% Subscribe forces to correct interfaces
% SP = seat post, FPL = Foot peg left, FPR = Foot peg right, HBL = handlebar left and HBR = handlebar right
% X = longitudinal, Y = lateral and Z = vertical

% column order in which the strain gauges measure the interface forces:
% SP_X, SP_Z, SP_Y, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Z, HBL_Y, HBR_Z,
% HBR_X, HBR_Y (13 forces)

% the CORRECT column order used in the analysis of this research is: 
% SP_X, SP_Y, SP_Z, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Y, HBL_Z, HBR_X, 
% HBR_Y, HBR_Z (13 forces)

% This function orders the columns in the CORRECT order (as stated above) for 
% all trials and combines all interface forces for 24 subjects
[interface_volt_OS, interface_volt_t1, interface_volt_t2] = combine_interface_forces_24subs(offset, trial1, trial2);

% Plot all interface voltages for 24 subs for the offset trial 
figure('name','Offset trial')
subplot(3,5,1)
hold on; grid on;
plot(interface_volt_OS{1})
ylabel({'X-direction','Voltage [V]'})
title('Seat post')
subplot(3,5,6)
hold on; grid on;
plot(interface_volt_OS{2})
ylabel({'Y-direction','Voltage [V]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_volt_OS{3})
ylabel({'Z-direction','Voltage [V]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_volt_OS{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_volt_OS{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_volt_OS{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_volt_OS{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_volt_OS{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_volt_OS{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_volt_OS{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_volt_OS{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_volt_OS{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_volt_OS{13})
xlabel('Samples [-]')

% Plot all interface voltages for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(interface_volt_t1{1})
title('Seat post')
ylabel({'X-direction','Voltage [V]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_volt_t1{2})
ylabel({'Y-direction','Voltage [V]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_volt_t1{3})
ylabel({'Z-direction','Voltage [V]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_volt_t1{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_volt_t1{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_volt_t1{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_volt_t1{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_volt_t1{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_volt_t1{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_volt_t1{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_volt_t1{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_volt_t1{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_volt_t1{13})
xlabel('Samples [-]')

% Plot all interface voltages for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(interface_volt_t2{1})
title('Seat post')
ylabel({'X-direction','Voltage [V]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_volt_t2{2})
ylabel({'Y-direction','Voltage [V]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_volt_t2{3})
ylabel({'Z-direction','Voltage [V]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_volt_t2{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_volt_t2{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_volt_t2{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_volt_t2{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_volt_t2{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_volt_t2{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_volt_t2{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_volt_t2{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_volt_t2{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_volt_t2{13})
xlabel('Samples [-]')

%% Convert to forces
close all
% This function converts the measured interface voltages to real forces by
% multiplying the measured interface voltages with a linear calibration
% equation of the corresponding strain gauges
interface_force_OS = convert_to_forces(interface_volt_OS); 
interface_force_t1 = convert_to_forces(interface_volt_t1); 
interface_force_t2 = convert_to_forces(interface_volt_t2); 

% Plot all interface forces for 24 subs for the offset trial
figure('name','Offset trial')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_OS{1})
ylabel({'X-direction','Force [N]'})
title('Seat post')
subplot(3,5,6)
hold on; grid on;
plot(interface_force_OS{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_OS{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_OS{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_OS{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_OS{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_OS{7})
xlabel('Samples [-]')
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
xlabel('Samples [-]')
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
xlabel('Samples [-]')

% Plot all interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_t1{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_t1{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_t1{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_t1{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_t1{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_t1{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_t1{7})
xlabel('Samples [-]')
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
xlabel('Samples [-]')
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
xlabel('Samples [-]')

% Plot all interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_t2{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_t2{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_t2{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_t2{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_t2{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_t2{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_t2{7})
xlabel('Samples [-]')
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
xlabel('Samples [-]')
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
xlabel('Samples [-]')

%% Apply right-handed Cartesian coordinate frame
close all
% This functions applies a right-handed Cartesian coordinate frame to the
% all interfaces for 24 subjects.
interface_force_sign_OS = righthanded_cartesian_frame(interface_force_OS);
interface_force_sign_t1 = righthanded_cartesian_frame(interface_force_t1);
interface_force_sign_t2 = righthanded_cartesian_frame(interface_force_t2);

% Plot all interface forces for 24 subs for the offset trial
figure('name','Offset trial')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_sign_OS{1})
ylabel({'X-direction','Force [N]'})
title('Seat post')
subplot(3,5,6)
hold on; grid on;
plot(interface_force_sign_OS{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_sign_OS{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_sign_OS{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_sign_OS{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_sign_OS{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_sign_OS{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_force_sign_OS{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_sign_OS{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_sign_OS{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_force_sign_OS{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_sign_OS{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_sign_OS{13})
xlabel('Samples [-]')

% Plot all interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_sign_t1{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_sign_t1{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_sign_t1{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_sign_t1{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_sign_t1{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_sign_t1{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_sign_t1{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_force_sign_t1{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_sign_t1{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_sign_t1{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_force_sign_t1{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_sign_t1{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_sign_t1{13})
xlabel('Samples [-]')

% Plot all interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_sign_t2{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_sign_t2{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_sign_t2{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_sign_t2{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_sign_t2{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_sign_t2{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_sign_t2{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_force_sign_t2{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_sign_t2{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_sign_t2{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_force_sign_t2{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_sign_t2{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_sign_t2{13})
xlabel('Samples [-]')

%% Subtract offset from forces
% interface_force_scaled_OS = subtract_offset(interface_force_sign_OS);
% interface_force_scaled_t1 = subtract_offset(interface_force_sign_t1);
% interface_force_scaled_t2 = subtract_offset(interface_force_sign_t2);
% 
% % Plot all interface voltages for 24 subs for the offset trial 
% figure('name','Offset trial')
% subplot(3,5,1)
% hold on; grid on;
% plot(interface_force_scaled_OS{1})
% ylabel({'X-direction','Voltage [mV]'})
% title('Seat post')
% subplot(3,5,6)
% hold on; grid on;
% plot(interface_force_scaled_OS{2})
% ylabel({'Y-direction','Voltage [mV]'})
% subplot(3,5,11)
% hold on; grid on;
% plot(interface_force_scaled_OS{3})
% ylabel({'Z-direction','Voltage [mV]'})
% xlabel('Samples [-]')
% subplot(3,5,2)
% hold on; grid on;
% plot(interface_force_scaled_OS{4})
% title('Foot peg left')
% subplot(3,5,12)
% hold on; grid on;
% plot(interface_force_scaled_OS{5})
% xlabel('Samples [-]')
% subplot(3,5,3)
% hold on; grid on;
% plot(interface_force_scaled_OS{6})
% title('Foot peg right')
% subplot(3,5,13)
% hold on; grid on;
% plot(interface_force_scaled_OS{7})
% xlabel('Samples [-]')
% subplot(3,5,4)
% hold on; grid on;
% plot(interface_force_scaled_OS{8})
% title('Handlebar left')
% subplot(3,5,9)
% hold on; grid on;
% plot(interface_force_scaled_OS{9}(:,1))
% subplot(3,5,14)
% hold on; grid on;
% plot(interface_force_scaled_OS{10})
% xlabel('Samples [-]')
% subplot(3,5,5)
% hold on; grid on;
% plot(interface_force_scaled_OS{11})
% title('Handlebar right')
% subplot(3,5,10)
% hold on; grid on;
% plot(interface_force_scaled_OS{12})
% subplot(3,5,15)
% hold on; grid on;
% plot(interface_force_scaled_OS{13})
% xlabel('Samples [-]')
% 
% % Plot all interface voltages for 24 subs for trial 1
% figure('name', 'trial 1')
% subplot(3,5,1)
% hold on; grid on;
% plot(interface_force_scaled_t1{1})
% title('Seat post')
% ylabel({'X-direction','Voltage [mV]'})
% subplot(3,5,6)
% hold on; grid on;
% plot(interface_force_scaled_t1{2})
% ylabel({'Y-direction','Voltage [mV]'})
% subplot(3,5,11)
% hold on; grid on;
% plot(interface_force_scaled_t1{3})
% ylabel({'Z-direction','Voltage [mV]'})
% xlabel('Samples [-]')
% subplot(3,5,2)
% hold on; grid on;
% plot(interface_force_scaled_t1{4})
% title('Foot peg left')
% subplot(3,5,12)
% hold on; grid on;
% plot(interface_force_scaled_t1{5})
% xlabel('Samples [-]')
% subplot(3,5,3)
% hold on; grid on;
% plot(interface_force_scaled_t1{6})
% title('Foot peg right')
% subplot(3,5,13)
% hold on; grid on;
% plot(interface_force_scaled_t1{7})
% xlabel('Samples [-]')
% subplot(3,5,4)
% hold on; grid on;
% plot(interface_force_scaled_t1{8})
% title('Handlebar left')
% subplot(3,5,9)
% hold on; grid on;
% plot(interface_force_scaled_t1{9}(:,1))
% subplot(3,5,14)
% hold on; grid on;
% plot(interface_force_scaled_t1{10})
% xlabel('Samples [-]')
% subplot(3,5,5)
% hold on; grid on;
% plot(interface_force_scaled_t1{11})
% title('Handlebar right')
% subplot(3,5,10)
% hold on; grid on;
% plot(interface_force_scaled_t1{12})
% subplot(3,5,15)
% hold on; grid on;
% plot(interface_force_scaled_t1{13})
% xlabel('Samples [-]')
% 
% % Plot all interface voltages for 24 subs for trial 2
% figure('name','Trial 2')
% subplot(3,5,1)
% hold on; grid on;
% plot(interface_force_scaled_t2{1})
% title('Seat post')
% ylabel({'X-direction','Voltage [mV]'})
% subplot(3,5,6)
% hold on; grid on;
% plot(interface_force_scaled_t2{2})
% ylabel({'Y-direction','Voltage [mV]'})
% subplot(3,5,11)
% hold on; grid on;
% plot(interface_force_scaled_t2{3})
% ylabel({'Z-direction','Voltage [mV]'})
% xlabel('Samples [-]')
% subplot(3,5,2)
% hold on; grid on;
% plot(interface_force_scaled_t2{4})
% title('Foot peg left')
% subplot(3,5,12)
% hold on; grid on;
% plot(interface_force_scaled_t2{5})
% xlabel('Samples [-]')
% subplot(3,5,3)
% hold on; grid on;
% plot(interface_force_scaled_t2{6})
% title('Foot peg right')
% subplot(3,5,13)
% hold on; grid on;
% plot(interface_force_scaled_t2{7})
% xlabel('Samples [-]')
% subplot(3,5,4)
% hold on; grid on;
% plot(interface_force_scaled_t2{8})
% title('Handlebar left')
% subplot(3,5,9)
% hold on; grid on;
% plot(interface_force_scaled_t2{9}(:,1))
% subplot(3,5,14)
% hold on; grid on;
% plot(interface_force_scaled_t2{10})
% xlabel('Samples [-]')
% subplot(3,5,5)
% hold on; grid on;
% plot(interface_force_scaled_t2{11})
% title('Handlebar right')
% subplot(3,5,10)
% hold on; grid on;
% plot(interface_force_scaled_t2{12})
% subplot(3,5,15)
% hold on; grid on;
% plot(interface_force_scaled_t2{13})
% xlabel('Samples [-]')

%% Solve for seatpost inclination
close all
% This function calculates the perpendicular components in longitudinal and 
% vertical direction with respect to a seat post inclination of 28 degrees. 
interface_force_incl_t1 = solve_seatpost_inclination(interface_force_sign_t1);
interface_force_incl_t2 = solve_seatpost_inclination(interface_force_sign_t2);

% interface_force_incl_t1 = solve_seatpost_inclination(interface_force_scaled_t1);
% interface_force_incl_t2 = solve_seatpost_inclination(interface_force_scaled_t2);

%% Solve crosstalk handlebars
% extract lateral forces of both handlbars
interface_force_HBL_Y_t1 = interface_force_incl_t1{9};
interface_force_HBR_Y_t1 = interface_force_incl_t1{12};
interface_force_HBL_Y_t2 = interface_force_incl_t2{9};
interface_force_HBR_Y_t2 = interface_force_incl_t2{12};

% extract crosstalk ratio's to downscale lateral forces in the handlebars
cross_scaling_factor_HBL_Y = crosstalk_handlebars(1:24,4)';
cross_scaling_factor_HBR_Y = crosstalk_handlebars(1:24,7)';

% downscale lateral forces in the handlebars
interface_force_HBL_Y_t1_scaled = interface_force_HBL_Y_t1./cross_scaling_factor_HBL_Y;
interface_force_HBR_Y_t1_scaled = interface_force_HBR_Y_t1./cross_scaling_factor_HBR_Y;
interface_force_HBL_Y_t2_scaled = interface_force_HBL_Y_t2./cross_scaling_factor_HBL_Y;
interface_force_HBR_Y_t2_scaled = interface_force_HBR_Y_t2./cross_scaling_factor_HBR_Y;

% generate new cells with all interface forces
interface_force_cross_t1 = {interface_force_incl_t1{1:8},interface_force_HBL_Y_t1_scaled,interface_force_incl_t1{10:11},...
                            interface_force_HBR_Y_t1_scaled,interface_force_incl_t1{13}};
interface_force_cross_t2 = {interface_force_incl_t2{1:8},interface_force_HBL_Y_t2_scaled,interface_force_incl_t2{10:11},...
                            interface_force_HBR_Y_t2_scaled,interface_force_incl_t2{13}};
                        
% Plot all interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_cross_t1{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_cross_t1{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_cross_t1{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_cross_t1{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_cross_t1{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_cross_t1{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_cross_t1{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_force_cross_t1{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_cross_t1{9})
%ylim([-5 5])
subplot(3,5,14)
hold on; grid on;
plot(interface_force_cross_t1{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_force_cross_t1{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_cross_t1{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_cross_t1{13})
xlabel('Samples [-]')

% Plot all interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(interface_force_cross_t2{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(interface_force_cross_t2{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(interface_force_cross_t2{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(interface_force_cross_t2{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(interface_force_cross_t2{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(interface_force_cross_t2{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(interface_force_cross_t2{7})
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(interface_force_cross_t2{8})
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(interface_force_cross_t2{9})
subplot(3,5,14)
hold on; grid on;
plot(interface_force_cross_t2{10})
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(interface_force_cross_t2{11})
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(interface_force_cross_t2{12})
subplot(3,5,15)
hold on; grid on;
plot(interface_force_cross_t2{13})
xlabel('Samples [-]')

%% Filter force signals
close all
% This function filters the force signals with with a low-pass filter with
% cutoff-frequency of (13(fs/2)). This means that all frequencies higher
% than are filtered. Filter characteristics can be adjusted in the
% function.
interface_force_filt_t1 = force_noise_filter(interface_force_cross_t1);
interface_force_filt_t2 = force_noise_filter(interface_force_cross_t2);
        
%% Calculate delay and align all measured interface forces with the designed signal 
close all 
% This function calculates for all subjects the delay between the
% designed signal and the measured interface forces for trial 1 and 2.
[t1_aligned, lag_t1] = my_xcov_function(des_pert, interface_force_filt_t1);
[t2_aligned, lag_t2] = my_xcov_function(des_pert, interface_force_filt_t2);

%% Extract perturbation part from measured signals
% This function extracts for all measured interface forces only the
% perturbation part for 24 subjects
final_forces_t1    = extract_pert_part(t1_aligned);
final_forces_t2    = extract_pert_part(t2_aligned);

% Plot all final interface forces for 24 subs for trial 1
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t1{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t1{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t1{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t1{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t1{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t1{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t1{7})
xlabel('Samples [-]')
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
xlabel('Samples [-]')
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
xlabel('Samples [-]')

% Plot all final interface forces for 24 subs for trial 2
figure('name','Trial 2')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t2{1})
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t2{2})
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t2{3})
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t2{4})
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t2{5})
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t2{6})
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t2{7})
xlabel('Samples [-]')
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
xlabel('Samples [-]')
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
xlabel('Samples [-]')

%% Analyse individual participant 
participant     = 1; % change this to the participant which should be compared

% Plot all interface forces for trial 1
figure('name', 'Validation trial 1')
subplot(3,5,1)
hold on; grid on;
plot(final_forces_t1{1}(:,participant),'b');
title('Seat post')
ylabel({'X-direction','Force [N]'})
subplot(3,5,6)
hold on; grid on;
plot(final_forces_t1{2}(:,participant),'b');
ylabel({'Y-direction','Force [N]'})
subplot(3,5,11)
hold on; grid on;
plot(final_forces_t1{3}(:,participant),'b');
ylabel({'Z-direction','Force [N]'})
xlabel('Samples [-]')
subplot(3,5,2)
hold on; grid on;
plot(final_forces_t1{4}(:,participant),'b');
title('Foot peg left')
subplot(3,5,12)
hold on; grid on;
plot(final_forces_t1{5}(:,participant),'b');
xlabel('Samples [-]')
subplot(3,5,3)
hold on; grid on;
plot(final_forces_t1{6}(:,participant),'b');
title('Foot peg right')
subplot(3,5,13)
hold on; grid on;
plot(final_forces_t1{7}(:,participant),'b');
xlabel('Samples [-]')
subplot(3,5,4)
hold on; grid on;
plot(final_forces_t1{8}(:,participant),'b');
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(final_forces_t1{9}(:,participant),'b');
subplot(3,5,14)
hold on; grid on;
plot(final_forces_t1{10}(:,participant),'b');
xlabel('Samples [-]')
subplot(3,5,5)
hold on; grid on;
plot(final_forces_t1{11}(:,participant),'b');
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(final_forces_t1{12}(:,participant),'b');
subplot(3,5,15)
hold on; grid on;
plot(final_forces_t1{13}(:,participant),'b');
xlabel('Samples [-]')

%%% !!! UNCOMMENT BELOW WHEN COMPARING DATA FROM TRIAL 2 !!! %%%

% Plot all interface forces for trial 2
% figure('name', 'Validation trial 2')
% subplot(3,5,1)
% hold on; grid on;
% plot(final_forces_t2{1}(:,participant),'b');
% title('Seat post')
% ylabel({'X-direction','Force [N]'})
% subplot(3,5,6)
% hold on; grid on;
% plot(final_forces_t2{2}(:,participant),'b');
% ylabel({'Y-direction','Force [N]'})
% subplot(3,5,11)
% hold on; grid on;
% plot(final_forces_t2{3}(:,participant),'b');
% ylabel({'Z-direction','Force [N]'})
% xlabel('Samples [-]')
% subplot(3,5,2)
% hold on; grid on;
% plot(final_forces_t2{4}(:,participant),'b');
% title('Foot peg left')
% subplot(3,5,12)
% hold on; grid on;
% plot(final_forces_t2{5}(:,participant),'b');
% xlabel('Samples [-]')
% subplot(3,5,3)
% hold on; grid on;
% plot(final_forces_t2{6}(:,participant),'b');
% title('Foot peg right')
% subplot(3,5,13)
% hold on; grid on;
% plot(final_forces_t2{7}(:,participant),'b');
% xlabel('Samples [-]')
% subplot(3,5,4)
% hold on; grid on;
% plot(final_forces_t2{8}(:,participant),'b');
% title('Handlebar left')
% subplot(3,5,9)
% hold on; grid on;
% plot(final_forces_t2{9}(:,participant),'b');
% subplot(3,5,14)
% hold on; grid on;
% plot(final_forces_t2{10}(:,participant),'b');
% xlabel('Samples [-]')
% subplot(3,5,5)
% hold on; grid on;
% plot(final_forces_t2{11}(:,participant),'b');
% title('Handlebar right')
% subplot(3,5,10)
% hold on; grid on;
% plot(final_forces_t2{12}(:,participant),'b');
% subplot(3,5,15)
% hold on; grid on;
% plot(final_forces_t2{13}(:,participant),'b');
% xlabel('Samples [-]')

%% Store final force signals for system identification (SI) 
%%% !!! CHANGE NAME IN CORRECT MOTION !!! %%%
sway_force_signals_SI_t1 = final_forces_t1; 
sway_force_signals_SI_t2 = final_forces_t2;

%%% !!! STORE IN SAME DIRECTORY THAT CONTAINS THE TRANSFER FUNCTION SCRIPT FOR RIDER ID !!! %%% 
save('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\Sway\Sway strain gauge data\sway_force_signals_SI_t1_t2.mat','sway_force_signals_SI_t1','sway_force_signals_SI_t2');