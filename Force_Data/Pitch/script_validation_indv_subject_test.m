%% Validation test of automatic script with individual participant

% Author: Jelle Waling de Haan
% Graduation project: Passive Rider Identification 
% Script: calculates manually the interface force signals for one subject 
% Last update: 23-01-2019

% This script calculates manually all interface forces for one particpant
% for one specific motion (surge, sway, heave, roll, pitch or yaw). Finally,
% it stores the final forces in the same directory that contains the
% automatic script which calculates the interface forces for 24 subjects
% automatically. The result of this script can be compared to the result of
% the automatic m-file by fitting both results in one figure to validate
% the correctness of the automatic script. 

clear all
close all
clc

%% Load data files (DO CHANGE!)
% !!! CHANGE EXCEL FILES FOR SPECIFIC PARTICIPANT HERE !!!
% force data of all interfaces for one participant
cell_raw_data_sub_t1  = csvimport('sub01_heave_t1.xls'); % t1 = trial 1
cell_raw_data_sub_t2  = csvimport('sub01_heave_t2.xls'); % t2 = trial 2

% !!! CHANGE DESIGNED PERTURBATION FOR CORRECT MOTION HERE !!! 
% Designed perturbation signal (for all participants the same)
load('heave_pert_amp1'); % designed signal is used for signal alignment
clearvars heave_vel_amp1 heave_dis_amp1

%% Sign convention (DO CHANGE!)
des_pert = -heave_acc_amp1; 

%% Convert cell arrays to matrices (DO NOT CHANGE!)
mat_raw_data_sub_t1   = convert_cellarray_to_matrix(cell_raw_data_sub_t1); % t1 = trial 1
mat_raw_data_sub_t2   = convert_cellarray_to_matrix(cell_raw_data_sub_t2); % t2 = trial 2

%% Delete last 3 columns (contains useless data) (DO NOT CHANGE!)
mat_force_data_sub_t1     = mat_raw_data_sub_t1(:,1:13); % t1 = trial 1
mat_force_data_sub_t2     = mat_raw_data_sub_t2(:,1:13); % t2 = trial 2

%% Load sensor fusion data strain gauges (DO CHANGE!)
sensor_fusion_data  = load('mean_strain_gauge_OS_24subs');
sensor_offset       = struct2cell(sensor_fusion_data);

% !!!! CHOOSE/UNCOMMENT CORRECT SENSOR OFFSET FOR PARTICIPANT HERE !!!!
% for subject 1 use this error:
offset_sub = sensor_offset{1,1}{1};

% for subjects 2, 3, 4, 5, and 6 use this error:
%offset_sub = sensor_offset{1,1}{2};

% for subject 7 use this error:
%offset_sub = sensor_offset{1,1}{3};

% for subjects 8, 9 and 10 use this error:
%offset_sub = sensor_offset{1,1}{4};

% for subjects 11, 12 and 13 use this offset:
%offset_sub = sensor_offset{1,1}{5};

% for subjects 14 and 15 uses this offset:
%offset_sub = sensor_offset{1,1}{6};

% for subjects 16, 17, 18, 19 and 20 use this offset:
%offset_sub = sensor_offset{1,1}{7};

% for subjects 21, 22, 23 and 24 use this offset:
%offset_sub = sensor_offset{1,1}{8};

%% Solve for sensor fusion strain gauges (DO NOT CHANGE!)
scaled_force_data_sub_t1 = mat_force_data_sub_t1 - offset_sub; % t1 = trial 1
scaled_force_data_sub_t2 = mat_force_data_sub_t2 - offset_sub; % t2 = trial 2

%% Order all forces in the correct order (DO NOT CHANGE!)
% SP = seat post, FPL = foot pegs left, FPR = foot pegs right, HBL = handlebar left and HBR = handlebar right
% X = longitudinal, Y = lateral and Z = vertical

% column order in which the strain gauges measure the interface forces:
% SP_X, SP_Z, SP_Y, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Z, HBL_Y, HBR_Z,
% HBR_X, HBR_Y (13 forces)

% the CORRECT column order used in the analysis of this research is: 
% SP_X, SP_Y, SP_Z, FPL_X, FPL_Z, FPR_X, FPR_Z, HBL_X, HBL_Y, HBL_Z, HBR_X, 
% HBR_Y, HBR_Z (13 forces)
force_data_t1 = scaled_force_data_sub_t1(:,[1 3 2 4 5 6 7 8 10 9 12 13 11]); % t1 = trial 1
force_data_t2 = scaled_force_data_sub_t2(:,[1 3 2 4 5 6 7 8 10 9 12 13 11]); % t2 = trial 2

%% Plot all interface forces for one subject for trial 1 and 2
figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(force_data_t1(:,1))
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(force_data_t1(:,2))
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(force_data_t1(:,3))
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(force_data_t1(:,4))
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(force_data_t1(:,5))
subplot(3,5,3)
hold on; grid on;
plot(force_data_t1(:,6))
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(force_data_t1(:,7))
subplot(3,5,4)
hold on; grid on;
plot(force_data_t1(:,8))
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(force_data_t1(:,9))
subplot(3,5,14)
hold on; grid on;
plot(force_data_t1(:,10))
subplot(3,5,5)
hold on; grid on;
plot(force_data_t1(:,11))
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(force_data_t1(:,12))
subplot(3,5,15)
hold on; grid on;
plot(force_data_t1(:,13))

figure('name', 'trial 2')
subplot(3,5,1)
hold on; grid on;
plot(force_data_t2(:,1))
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(force_data_t2(:,2))
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(force_data_t2(:,3))
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(force_data_t2(:,4))
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(force_data_t2(:,5))
subplot(3,5,3)
hold on; grid on;
plot(force_data_t2(:,6))
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(force_data_t2(:,7))
subplot(3,5,4)
hold on; grid on;
plot(force_data_t2(:,8))
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(force_data_t2(:,9))
subplot(3,5,14)
hold on; grid on;
plot(force_data_t2(:,10))
subplot(3,5,5)
hold on; grid on;
plot(force_data_t2(:,11))
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(force_data_t2(:,12))
subplot(3,5,15)
hold on; grid on;
plot(force_data_t2(:,13))

%% Convert to real forces 
close all
% Each interface force is multiplied by a linear calibration formula for
% the corresponding strain gauge
force_SP_X  = 59.861.*force_data_t1(:,1)-1.426;
force_SP_Y  = 38.842.*force_data_t1(:,2)+18.909;
force_SP_Z  = 314.64.*force_data_t1(:,3)-6.7404;

force_FPL_X = 42.298.*force_data_t1(:,4)+0.0009;
force_FPL_Z = 41.414.*force_data_t1(:,5)+0.2628;

force_FPR_X = 42.4.*force_data_t1(:,6)+0.0324;
force_FPR_Z = 41.604.*force_data_t1(:,7)+0.6129;

force_HBL_X = 22.996.*force_data_t1(:,8)-0.4607;
force_HBL_Y = 454.8.*force_data_t1(:,9)-16.278;
force_HBL_Z = 23.034.*force_data_t1(:,10)-0.5227;

force_HBR_X = 24.693.*force_data_t1(:,11)-0.6072;
force_HBR_Y = 382.65.*force_data_t1(:,12)-0.2251;
force_HBR_Z = 24.806.*force_data_t1(:,13)-0.6285;

figure('name', 'trial 1')
subplot(3,5,1)
hold on; grid on;
plot(force_SP_X)
title('Seat post')
ylabel('X-direction')
subplot(3,5,6)
hold on; grid on;
plot(force_SP_Y)
ylabel('Y-direction')
subplot(3,5,11)
hold on; grid on;
plot(force_SP_Z)
ylabel('Z-direction')
subplot(3,5,2)
hold on; grid on;
plot(force_FPL_X)
title('Foot pegs left')
subplot(3,5,12)
hold on; grid on;
plot(force_FPL_Z)
subplot(3,5,3)
hold on; grid on;
plot(force_FPR_X)
title('Foot pegs right')
subplot(3,5,13)
hold on; grid on;
plot(force_FPR_Z)
subplot(3,5,4)
hold on; grid on;
plot(force_HBL_X)
title('Handlebar left')
subplot(3,5,9)
hold on; grid on;
plot(force_HBL_Y)
subplot(3,5,14)
hold on; grid on;
plot(force_HBL_Z)
subplot(3,5,5)
hold on; grid on;
plot(force_HBR_X)
title('Handlebar right')
subplot(3,5,10)
hold on; grid on;
plot(force_HBR_Y)
subplot(3,5,15)
hold on; grid on;
plot(force_HBR_Z)

%% Solve for seatpost inclination 
inclination_SP = 28*(pi/180); % radians

force_SP_X = force_SP_X.*cos(inclination_SP); 
force_SP_Z = force_SP_Z.*cos(inclination_SP); 

%% Filter force signals
% filter characteristics
fs    = 100;
Fnorm = 13/(fs/2);           % Normalized frequency
df    = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

% calculate delay as result of filtering
D = mean(grpdelay(df)) ; % filter delay in samples

force_SP_X_filt = filter(df,[force_SP_X; zeros(D,1)]); % Append D zeros to the input data
force_SP_X_filt = force_SP_X_filt(D+1:end);
force_SP_Y_filt = filter(df,[force_SP_Y; zeros(D,1)]); % Append D zeros to the input data
force_SP_Y_filt = force_SP_Y_filt(D+1:end);
force_SP_Z_filt = filter(df,[force_SP_Z; zeros(D,1)]); % Append D zeros to the input data
force_SP_Z_filt = force_SP_Z_filt(D+1:end);

force_FPL_X_filt = filter(df,[force_FPL_X; zeros(D,1)]); % Append D zeros to the input data
force_FPL_X_filt = force_FPL_X_filt(D+1:end);
force_FPL_Z_filt = filter(df,[force_FPL_Z; zeros(D,1)]); % Append D zeros to the input data
force_FPL_Z_filt = force_FPL_Z_filt(D+1:end);

force_FPR_X_filt = filter(df,[force_FPR_X; zeros(D,1)]); % Append D zeros to the input data
force_FPR_X_filt = force_FPR_X_filt(D+1:end);
force_FPR_Z_filt = filter(df,[force_FPR_Z; zeros(D,1)]); % Append D zeros to the input data
force_FPR_Z_filt = force_FPR_Z_filt(D+1:end);

force_HBL_X_filt = filter(df,[force_HBL_X; zeros(D,1)]); % Append D zeros to the input data
force_HBL_X_filt = force_HBL_X_filt(D+1:end);
force_HBL_Y_filt = filter(df,[force_HBL_Y; zeros(D,1)]); % Append D zeros to the input data
force_HBL_Y_filt = force_HBL_Y_filt(D+1:end);
force_HBL_Z_filt = filter(df,[force_HBL_Z; zeros(D,1)]); % Append D zeros to the input data
force_HBL_Z_filt = force_HBL_Z_filt(D+1:end);

force_HBR_X_filt = filter(df,[force_HBR_X; zeros(D,1)]); % Append D zeros to the input data
force_HBR_X_filt = force_HBR_X_filt(D+1:end);
force_HBR_Y_filt = filter(df,[force_HBR_Y; zeros(D,1)]); % Append D zeros to the input data
force_HBR_Y_filt = force_HBR_Y_filt(D+1:end);
force_HBR_Z_filt = filter(df,[force_HBR_Z; zeros(D,1)]); % Append D zeros to the input data
force_HBR_Z_filt = force_HBR_Z_filt(D+1:end);

%% Calculate lag between signals and align signals with designed signal for trial 1
close all
%%% !!! CHANGE THIS TO t2 WHEN INTERESTED IN TRIAL 2 !!! %%%
% calculate delay between designed signal and measured force signals of trial 1
[C1, lag1]      = xcov(des_pert,force_SP_X_filt);
[C2, lag2]      = xcov(des_pert,force_SP_Y_filt);
[C3, lag3]      = xcov(des_pert,force_SP_Z_filt);
[C4, lag4]      = xcov(des_pert,force_FPL_X_filt);
[C5, lag5]      = xcov(des_pert,force_FPL_Z_filt);
[C6, lag6]      = xcov(des_pert,force_FPR_X_filt);
[C7, lag7]      = xcov(des_pert,force_FPR_Z_filt);
[C8, lag8]      = xcov(des_pert,force_HBL_X_filt);
[C9, lag9]      = xcov(des_pert,force_HBL_Y_filt);
[C10, lag10]    = xcov(des_pert,force_HBL_Z_filt);
[C11, lag11]    = xcov(des_pert,force_HBR_X_filt);
[C12, lag12]    = xcov(des_pert,force_HBR_Y_filt);
[C13, lag13]    = xcov(des_pert,force_HBR_Z_filt);

% calculate for each force the sample number at which the cross-covariance is
% equal to 1 (= perfect correlation)
[~,I1]  = max(abs(C1));
t1      = lag1(I1);
[~,I2]  = max(abs(C2));
t2      = lag2(I2);
[~,I3]  = max(abs(C3));
t3      = lag3(I3);
[~,I4]  = max(abs(C4));
t4      = lag4(I4);
[~,I5]  = max(abs(C5));
t5      = lag5(I5);
[~,I6]  = max(abs(C6));
t6      = lag6(I6);
[~,I7]  = max(abs(C7));
t7      = lag7(I7);
[~,I8]  = max(abs(C8));
t8      = lag8(I8);
[~,I9]  = max(abs(C9));
t9      = lag9(I9);
[~,I10] = max(abs(C10));
t10     = lag10(I10);
[~,I11] = max(abs(C11));
t11     = lag11(I11);
[~,I12] = max(abs(C12));
t12     = lag12(I12);
[~,I13] = max(abs(C13));
t13     = lag13(I13);

%%% !!! CHANGE THIS TO t2 WHEN INTERESTED IN TRIAL 2 !!! %%%
% align force signals by shifting in time with the calculated lags
scaled_force_SP_X   = force_SP_X;
scaled_force_SP_X   = scaled_force_SP_X(abs(t1):end);
scaled_force_SP_Y   = force_SP_Y;
scaled_force_SP_Y   = scaled_force_SP_Y(abs(t2):end);
scaled_force_SP_Z   = force_SP_Z;
scaled_force_SP_Z   = scaled_force_SP_Z(abs(t3):end);
scaled_force_FPL_X  = force_FPL_X;
scaled_force_FPL_X  = scaled_force_FPL_X(abs(t4):end);
scaled_force_FPL_Z  = force_FPL_Z;
scaled_force_FPL_Z  = scaled_force_FPL_Z(abs(t5):end);
scaled_force_FPR_X  = force_FPR_X;
scaled_force_FPR_X  = scaled_force_FPR_X(abs(t6):end);
scaled_force_FPR_Z  = force_FPR_Z;
scaled_force_FPR_Z  = scaled_force_FPR_Z(abs(t7):end);
scaled_force_HBL_X  = force_HBL_X;
scaled_force_HBL_X  = scaled_force_HBL_X(abs(t8):end);
scaled_force_HBL_Y  = force_HBL_Y;
scaled_force_HBL_Y  = scaled_force_HBL_Y(abs(t9):end);
scaled_force_HBL_Z  = force_HBL_Z;
scaled_force_HBL_Z  = scaled_force_HBL_Z(abs(t10):end);
scaled_force_HBR_X  = force_HBR_X;
scaled_force_HBR_X  = scaled_force_HBR_X(abs(t11):end);
scaled_force_HBR_Y  = force_HBR_Y;
scaled_force_HBR_Y  = scaled_force_HBR_Y(abs(t12):end);
scaled_force_HBR_Z  = force_HBR_Z;
scaled_force_HBR_Z  = scaled_force_HBR_Z(abs(t13):end);

%% Extract only perturbation part from measured force signals
% Since the measured signals are aligned with the des. signal the
% perturbation part is between samples 502 and 6501 (# samples = 6000)
pert_part_SP_X  = scaled_force_SP_X(502:6501);
pert_part_SP_Y  = scaled_force_SP_Y(502:6501);
pert_part_SP_Z  = scaled_force_SP_Z(502:6501);

pert_part_FPL_X = scaled_force_FPL_X(502:6501);
pert_part_FPL_Z = scaled_force_FPL_Z(502:6501);

pert_part_FPR_X = scaled_force_FPR_X(502:6501);
pert_part_FPR_Z = scaled_force_FPR_Z(502:6501);

pert_part_HBL_X = scaled_force_HBL_X(502:6501);
pert_part_HBL_Y = scaled_force_HBL_Y(502:6501);
pert_part_HBL_Z = scaled_force_HBL_Z(502:6501);

pert_part_HBR_X = scaled_force_HBR_X(502:6501);
pert_part_HBR_Y = scaled_force_HBR_Y(502:6501);
pert_part_HBR_Z = scaled_force_HBR_Z(502:6501);

%% Put all final forces in a matrix and store
total_force_indv_sub_t1 = [ pert_part_SP_X, pert_part_SP_Y, pert_part_SP_Z,...
                            pert_part_FPL_X, pert_part_FPL_Z,...
                            pert_part_FPR_X, pert_part_FPR_Z,...
                            pert_part_HBL_X, pert_part_HBL_Y, pert_part_HBL_Z,...
                            pert_part_HBR_X, pert_part_HBR_Y, pert_part_HBR_Z];

% Store the final force matrix in the same directory as your automated script m-file (for 24 subjects)                       
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/Analysis/data analysis/24 subjects/Heave/Heave strain gauge data/validation_force_indv_sub_test.mat','total_force_indv_sub_t1')
