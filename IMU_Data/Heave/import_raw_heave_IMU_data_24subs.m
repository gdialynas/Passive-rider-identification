clear all
close all
clc

%% Load raw data

%%% !!! CHANGE HERE ALL EXCEL FILES TO THE CORRECT MOTION AND SUBJECT !!!
%%% !!! GIVE IN CORRECT COLUMN NUMBER FOR SPECIFIC MOTION SECTION DELETE
%%% ROWS ... SIZE COLUMNS !!!

% load data offset trial for 24 participants (OS = offset trial)
raw_IMU_data_sub01_OS = xlsread('IMU_hexapod_sub01_heave_OS_00B4220E.xls');
raw_IMU_data_sub02_OS = xlsread('IMU_hexapod_sub02_heave_OS_00B4220E.xls');
raw_IMU_data_sub03_OS = xlsread('IMU_hexapod_sub03_heave_OS_00B4220E.xls');
raw_IMU_data_sub04_OS = xlsread('IMU_hexapod_sub04_heave_OS_00B4220E.xls');
raw_IMU_data_sub05_OS = xlsread('IMU_hexapod_sub05_heave_OS_00B4220E.xls');
raw_IMU_data_sub06_OS = xlsread('IMU_hexapod_sub06_heave_OS_00B4220E.xls');
raw_IMU_data_sub07_OS = xlsread('IMU_hexapod_sub07_heave_OS_00B4220E.xls');
raw_IMU_data_sub08_OS = xlsread('IMU_hexapod_sub08_heave_OS_00B4220E.xls');
raw_IMU_data_sub09_OS = xlsread('IMU_hexapod_sub09_heave_OS_00B4220E.xls');
raw_IMU_data_sub10_OS = xlsread('IMU_hexapod_sub10_heave_OS_00B4220E.xls');
raw_IMU_data_sub11_OS = xlsread('IMU_hexapod_sub11_heave_OS_00B4220E.xls');
raw_IMU_data_sub12_OS = xlsread('IMU_hexapod_sub12_heave_OS_00B4220E.xls');
raw_IMU_data_sub13_OS = xlsread('IMU_hexapod_sub13_heave_OS_00B4220E.xls');
raw_IMU_data_sub14_OS = xlsread('IMU_hexapod_sub14_heave_OS_00B4220E.xls');
raw_IMU_data_sub15_OS = xlsread('IMU_hexapod_sub15_heave_OS_00B4220E.xls');
raw_IMU_data_sub16_OS = xlsread('IMU_hexapod_sub16_heave_OS_00B4220E.xls');
raw_IMU_data_sub17_OS = xlsread('IMU_hexapod_sub17_heave_OS_00B4220E.xls');
raw_IMU_data_sub18_OS = xlsread('IMU_hexapod_sub18_heave_OS_00B4220E.xls');
raw_IMU_data_sub19_OS = xlsread('IMU_hexapod_sub19_heave_OS_00B4220E.xls');
raw_IMU_data_sub20_OS = xlsread('IMU_hexapod_sub20_heave_OS_00B4220E.xls');
raw_IMU_data_sub21_OS = xlsread('IMU_hexapod_sub21_heave_OS_00B4220E.xls');
raw_IMU_data_sub22_OS = xlsread('IMU_hexapod_sub22_heave_OS_00B4220E.xls');
raw_IMU_data_sub23_OS = xlsread('IMU_hexapod_sub23_heave_OS_00B4220E.xls');
raw_IMU_data_sub24_OS = xlsread('IMU_hexapod_sub24_heave_OS_00B4220E.xls');

% load data first trial 24 participants (t1 = trial 1)
raw_IMU_data_sub01_t1 = xlsread('IMU_hexapod_sub01_heave_t1_00B4220E.xls');
raw_IMU_data_sub02_t1 = xlsread('IMU_hexapod_sub02_heave_t1_00B4220E.xls');
raw_IMU_data_sub03_t1 = xlsread('IMU_hexapod_sub03_heave_t1_00B4220E.xls');
raw_IMU_data_sub04_t1 = xlsread('IMU_hexapod_sub04_heave_t1_00B4220E.xls');
raw_IMU_data_sub05_t1 = xlsread('IMU_hexapod_sub05_heave_t1_00B4220E.xls');
raw_IMU_data_sub06_t1 = xlsread('IMU_hexapod_sub06_heave_t1_00B4220E.xls');
raw_IMU_data_sub07_t1 = xlsread('IMU_hexapod_sub07_heave_t1_00B4220E.xls');
raw_IMU_data_sub08_t1 = xlsread('IMU_hexapod_sub08_heave_t1_00B4220E.xls');
raw_IMU_data_sub09_t1 = xlsread('IMU_hexapod_sub09_heave_t1_00B4220E.xls');
raw_IMU_data_sub10_t1 = xlsread('IMU_hexapod_sub10_heave_t1_00B4220E.xls');
raw_IMU_data_sub11_t1 = xlsread('IMU_hexapod_sub11_heave_t1_00B4220E.xls');
raw_IMU_data_sub12_t1 = xlsread('IMU_hexapod_sub12_heave_t1_00B4220E.xls');
raw_IMU_data_sub13_t1 = xlsread('IMU_hexapod_sub13_heave_t1_00B4220E.xls');
raw_IMU_data_sub14_t1 = xlsread('IMU_hexapod_sub14_heave_t1_00B4220E.xls');
raw_IMU_data_sub15_t1 = xlsread('IMU_hexapod_sub15_heave_t1_00B4220E.xls');
raw_IMU_data_sub16_t1 = xlsread('IMU_hexapod_sub16_heave_t1_00B4220E.xls');
raw_IMU_data_sub17_t1 = xlsread('IMU_hexapod_sub17_heave_t1_00B4220E.xls');
raw_IMU_data_sub18_t1 = xlsread('IMU_hexapod_sub18_heave_t1_00B4220E.xls');
raw_IMU_data_sub19_t1 = xlsread('IMU_hexapod_sub19_heave_t1_00B4220E.xls');
raw_IMU_data_sub20_t1 = xlsread('IMU_hexapod_sub20_heave_t1_00B4220E.xls');
raw_IMU_data_sub21_t1 = xlsread('IMU_hexapod_sub21_heave_t1_00B4220E.xls');
raw_IMU_data_sub22_t1 = xlsread('IMU_hexapod_sub22_heave_t1_00B4220E.xls');
raw_IMU_data_sub23_t1 = xlsread('IMU_hexapod_sub23_heave_t1_00B4220E.xls');
raw_IMU_data_sub24_t1 = xlsread('IMU_hexapod_sub24_heave_t1_00B4220E.xls');

% load data second trial for 24 participants (t2 = trial 2)
raw_IMU_data_sub01_t2 = xlsread('IMU_hexapod_sub01_heave_t2_00B4220E.xls');
raw_IMU_data_sub02_t2 = xlsread('IMU_hexapod_sub02_heave_t2_00B4220E.xls');
raw_IMU_data_sub03_t2 = xlsread('IMU_hexapod_sub03_heave_t2_00B4220E.xls');
raw_IMU_data_sub04_t2 = xlsread('IMU_hexapod_sub04_heave_t2_00B4220E.xls');
raw_IMU_data_sub05_t2 = xlsread('IMU_hexapod_sub05_heave_t2_00B4220E.xls');
raw_IMU_data_sub06_t2 = xlsread('IMU_hexapod_sub06_heave_t2_00B4220E.xls');
raw_IMU_data_sub07_t2 = xlsread('IMU_hexapod_sub07_heave_t2_00B4220E.xls');
raw_IMU_data_sub08_t2 = xlsread('IMU_hexapod_sub08_heave_t2_00B4220E.xls');
raw_IMU_data_sub09_t2 = xlsread('IMU_hexapod_sub09_heave_t2_00B4220E.xls');
raw_IMU_data_sub10_t2 = xlsread('IMU_hexapod_sub10_heave_t2_00B4220E.xls');
raw_IMU_data_sub11_t2 = xlsread('IMU_hexapod_sub11_heave_t2_00B4220E.xls');
raw_IMU_data_sub12_t2 = xlsread('IMU_hexapod_sub12_heave_t2_00B4220E.xls');
raw_IMU_data_sub13_t2 = xlsread('IMU_hexapod_sub13_heave_t2_00B4220E.xls');
raw_IMU_data_sub14_t2 = xlsread('IMU_hexapod_sub14_heave_t2_00B4220E.xls');
raw_IMU_data_sub15_t2 = xlsread('IMU_hexapod_sub15_heave_t2_00B4220E.xls');
raw_IMU_data_sub16_t2 = xlsread('IMU_hexapod_sub16_heave_t2_00B4220E.xls');
raw_IMU_data_sub17_t2 = xlsread('IMU_hexapod_sub17_heave_t2_00B4220E.xls');
raw_IMU_data_sub18_t2 = xlsread('IMU_hexapod_sub18_heave_t2_00B4220E.xls');
raw_IMU_data_sub19_t2 = xlsread('IMU_hexapod_sub19_heave_t2_00B4220E.xls');
raw_IMU_data_sub20_t2 = xlsread('IMU_hexapod_sub20_heave_t2_00B4220E.xls');
raw_IMU_data_sub21_t2 = xlsread('IMU_hexapod_sub21_heave_t2_00B4220E.xls');
raw_IMU_data_sub22_t2 = xlsread('IMU_hexapod_sub22_heave_t2_00B4220E.xls');
raw_IMU_data_sub23_t2 = xlsread('IMU_hexapod_sub23_heave_t2_00B4220E.xls');
raw_IMU_data_sub24_t2 = xlsread('IMU_hexapod_sub24_heave_t2_00B4220E.xls');

%% Delete rows and columns with no or useless data and make equal sized columns

% CHANGE THIS TO THE COLUMN NUMBER WHICH CONTAINS THE HEAVE ACC. DATA
col_heave_acc = 9;

% The minimal column length is N = 7000;
N = 7000;

% Ordered IMU data offset trial
ordered_IMU_data_sub01_OS = raw_IMU_data_sub01_OS(6:N,col_heave_acc);
ordered_IMU_data_sub02_OS = raw_IMU_data_sub02_OS(6:N,col_heave_acc);
ordered_IMU_data_sub03_OS = raw_IMU_data_sub03_OS(6:N,col_heave_acc);
ordered_IMU_data_sub04_OS = raw_IMU_data_sub04_OS(6:N,col_heave_acc);
ordered_IMU_data_sub05_OS = raw_IMU_data_sub05_OS(6:N,col_heave_acc);
ordered_IMU_data_sub06_OS = raw_IMU_data_sub06_OS(6:N,col_heave_acc);
ordered_IMU_data_sub07_OS = raw_IMU_data_sub07_OS(6:N,col_heave_acc);
ordered_IMU_data_sub08_OS = raw_IMU_data_sub08_OS(6:N,col_heave_acc);
ordered_IMU_data_sub09_OS = raw_IMU_data_sub09_OS(6:N,col_heave_acc);
ordered_IMU_data_sub10_OS = raw_IMU_data_sub10_OS(6:N,col_heave_acc);
ordered_IMU_data_sub11_OS = raw_IMU_data_sub11_OS(6:N,col_heave_acc);
ordered_IMU_data_sub12_OS = raw_IMU_data_sub12_OS(6:N,col_heave_acc);
ordered_IMU_data_sub13_OS = raw_IMU_data_sub13_OS(6:N,col_heave_acc);
ordered_IMU_data_sub14_OS = raw_IMU_data_sub14_OS(6:N,col_heave_acc);
ordered_IMU_data_sub15_OS = raw_IMU_data_sub15_OS(6:N,col_heave_acc);
ordered_IMU_data_sub16_OS = raw_IMU_data_sub16_OS(6:N,col_heave_acc);
ordered_IMU_data_sub17_OS = raw_IMU_data_sub17_OS(6:N,col_heave_acc);
ordered_IMU_data_sub18_OS = raw_IMU_data_sub18_OS(6:N,col_heave_acc);
ordered_IMU_data_sub19_OS = raw_IMU_data_sub19_OS(6:N,col_heave_acc);
ordered_IMU_data_sub20_OS = raw_IMU_data_sub20_OS(6:N,col_heave_acc);
ordered_IMU_data_sub21_OS = raw_IMU_data_sub21_OS(6:N,col_heave_acc);
ordered_IMU_data_sub22_OS = raw_IMU_data_sub22_OS(6:N,col_heave_acc);
ordered_IMU_data_sub23_OS = raw_IMU_data_sub23_OS(6:N,col_heave_acc);
ordered_IMU_data_sub24_OS = raw_IMU_data_sub24_OS(6:N,col_heave_acc);

% Ordered IMU data trial 1
ordered_IMU_data_sub01_t1 = raw_IMU_data_sub01_t1(6:N,col_heave_acc);
ordered_IMU_data_sub02_t1 = raw_IMU_data_sub02_t1(6:N,col_heave_acc);
ordered_IMU_data_sub03_t1 = raw_IMU_data_sub03_t1(6:N,col_heave_acc);
ordered_IMU_data_sub04_t1 = raw_IMU_data_sub04_t1(6:N,col_heave_acc);
ordered_IMU_data_sub05_t1 = raw_IMU_data_sub05_t1(6:N,col_heave_acc);
ordered_IMU_data_sub06_t1 = raw_IMU_data_sub06_t1(6:N,col_heave_acc);
ordered_IMU_data_sub07_t1 = raw_IMU_data_sub07_t1(6:N,col_heave_acc);
ordered_IMU_data_sub08_t1 = raw_IMU_data_sub08_t1(6:N,col_heave_acc);
ordered_IMU_data_sub09_t1 = raw_IMU_data_sub09_t1(6:N,col_heave_acc);
ordered_IMU_data_sub10_t1 = raw_IMU_data_sub10_t1(6:N,col_heave_acc);
ordered_IMU_data_sub11_t1 = raw_IMU_data_sub11_t1(6:N,col_heave_acc);
ordered_IMU_data_sub12_t1 = raw_IMU_data_sub12_t1(6:N,col_heave_acc);
ordered_IMU_data_sub13_t1 = raw_IMU_data_sub13_t1(6:N,col_heave_acc);
ordered_IMU_data_sub14_t1 = raw_IMU_data_sub14_t1(6:N,col_heave_acc);
ordered_IMU_data_sub15_t1 = raw_IMU_data_sub15_t1(6:N,col_heave_acc);
ordered_IMU_data_sub16_t1 = raw_IMU_data_sub16_t1(6:N,col_heave_acc);
ordered_IMU_data_sub17_t1 = raw_IMU_data_sub17_t1(6:N,col_heave_acc);
ordered_IMU_data_sub18_t1 = raw_IMU_data_sub18_t1(6:N,col_heave_acc);
ordered_IMU_data_sub19_t1 = raw_IMU_data_sub19_t1(6:N,col_heave_acc);
ordered_IMU_data_sub20_t1 = raw_IMU_data_sub20_t1(6:N,col_heave_acc);
ordered_IMU_data_sub21_t1 = raw_IMU_data_sub21_t1(6:N,col_heave_acc);
ordered_IMU_data_sub22_t1 = raw_IMU_data_sub22_t1(6:N,col_heave_acc);
ordered_IMU_data_sub23_t1 = raw_IMU_data_sub23_t1(6:N,col_heave_acc);
ordered_IMU_data_sub24_t1 = raw_IMU_data_sub24_t1(6:N,col_heave_acc);

% Ordered IMU data trial 2
ordered_IMU_data_sub01_t2 = raw_IMU_data_sub01_t2(6:N,col_heave_acc);
ordered_IMU_data_sub02_t2 = raw_IMU_data_sub02_t2(6:N,col_heave_acc);
ordered_IMU_data_sub03_t2 = raw_IMU_data_sub03_t2(6:N,col_heave_acc);
ordered_IMU_data_sub04_t2 = raw_IMU_data_sub04_t2(6:N,col_heave_acc);
ordered_IMU_data_sub05_t2 = raw_IMU_data_sub05_t2(6:N,col_heave_acc);
ordered_IMU_data_sub06_t2 = raw_IMU_data_sub06_t2(6:N,col_heave_acc);
ordered_IMU_data_sub07_t2 = raw_IMU_data_sub07_t2(6:N,col_heave_acc);
ordered_IMU_data_sub08_t2 = raw_IMU_data_sub08_t2(6:N,col_heave_acc);
ordered_IMU_data_sub09_t2 = raw_IMU_data_sub09_t2(6:N,col_heave_acc);
ordered_IMU_data_sub10_t2 = raw_IMU_data_sub10_t2(6:N,col_heave_acc);
ordered_IMU_data_sub11_t2 = raw_IMU_data_sub11_t2(6:N,col_heave_acc);
ordered_IMU_data_sub12_t2 = raw_IMU_data_sub12_t2(6:N,col_heave_acc);
ordered_IMU_data_sub13_t2 = raw_IMU_data_sub13_t2(6:N,col_heave_acc);
ordered_IMU_data_sub14_t2 = raw_IMU_data_sub14_t2(6:N,col_heave_acc);
ordered_IMU_data_sub15_t2 = raw_IMU_data_sub15_t2(6:N,col_heave_acc);
ordered_IMU_data_sub16_t2 = raw_IMU_data_sub16_t2(6:N,col_heave_acc);
ordered_IMU_data_sub17_t2 = raw_IMU_data_sub17_t2(6:N,col_heave_acc);
ordered_IMU_data_sub18_t2 = raw_IMU_data_sub18_t2(6:N,col_heave_acc);
ordered_IMU_data_sub19_t2 = raw_IMU_data_sub19_t2(6:N,col_heave_acc);
ordered_IMU_data_sub20_t2 = raw_IMU_data_sub20_t2(6:N,col_heave_acc);
ordered_IMU_data_sub21_t2 = raw_IMU_data_sub21_t2(6:N,col_heave_acc);
ordered_IMU_data_sub22_t2 = raw_IMU_data_sub22_t2(6:N,col_heave_acc);
ordered_IMU_data_sub23_t2 = raw_IMU_data_sub23_t2(6:N,col_heave_acc);
ordered_IMU_data_sub24_t2 = raw_IMU_data_sub24_t2(6:N,col_heave_acc);

%% When interested in all data measured by the IMU (thus other accelerations run this file)

% Ordered IMU data offset trial
% ordered_IMU_data_sub01_OS = raw_IMU_data_sub01_OS(6:N,7:25);
% ordered_IMU_data_sub02_OS = raw_IMU_data_sub02_OS(6:N,7:25);
% ordered_IMU_data_sub03_OS = raw_IMU_data_sub03_OS(6:N,7:25);
% ordered_IMU_data_sub04_OS = raw_IMU_data_sub04_OS(6:N,7:25);
% ordered_IMU_data_sub05_OS = raw_IMU_data_sub05_OS(6:N,7:25);
% ordered_IMU_data_sub06_OS = raw_IMU_data_sub06_OS(6:N,7:25);
% ordered_IMU_data_sub07_OS = raw_IMU_data_sub07_OS(6:N,7:25);
% ordered_IMU_data_sub08_OS = raw_IMU_data_sub08_OS(6:N,7:25);
% ordered_IMU_data_sub09_OS = raw_IMU_data_sub09_OS(6:N,7:25);
% ordered_IMU_data_sub10_OS = raw_IMU_data_sub10_OS(6:N,7:25);
% ordered_IMU_data_sub11_OS = raw_IMU_data_sub11_OS(6:N,7:25);
% ordered_IMU_data_sub12_OS = raw_IMU_data_sub12_OS(6:N,7:25);
% ordered_IMU_data_sub13_OS = raw_IMU_data_sub13_OS(6:N,7:25);
% ordered_IMU_data_sub14_OS = raw_IMU_data_sub14_OS(6:N,7:25);
% ordered_IMU_data_sub15_OS = raw_IMU_data_sub15_OS(6:N,7:25);
% ordered_IMU_data_sub16_OS = raw_IMU_data_sub16_OS(6:N,7:25);
% ordered_IMU_data_sub17_OS = raw_IMU_data_sub17_OS(6:N,7:25);
% ordered_IMU_data_sub18_OS = raw_IMU_data_sub18_OS(6:N,7:25);
% ordered_IMU_data_sub19_OS = raw_IMU_data_sub19_OS(6:N,7:25);
% ordered_IMU_data_sub20_OS = raw_IMU_data_sub20_OS(6:N,7:25);
% ordered_IMU_data_sub21_OS = raw_IMU_data_sub21_OS(6:N,7:25);
% ordered_IMU_data_sub22_OS = raw_IMU_data_sub22_OS(6:N,7:25);
% ordered_IMU_data_sub23_OS = raw_IMU_data_sub23_OS(6:N,7:25);
% ordered_IMU_data_sub24_OS = raw_IMU_data_sub24_OS(6:N,7:25);

% Ordered IMU data trial 1
% ordered_IMU_data_sub01_t1 = raw_IMU_data_sub01_t1(6:N,7:25);
% ordered_IMU_data_sub02_t1 = raw_IMU_data_sub02_t1(6:N,7:25);
% ordered_IMU_data_sub03_t1 = raw_IMU_data_sub03_t1(6:N,7:25);
% ordered_IMU_data_sub04_t1 = raw_IMU_data_sub04_t1(6:N,7:25);
% ordered_IMU_data_sub05_t1 = raw_IMU_data_sub05_t1(6:N,7:25);
% ordered_IMU_data_sub06_t1 = raw_IMU_data_sub06_t1(6:N,7:25);
% ordered_IMU_data_sub07_t1 = raw_IMU_data_sub07_t1(6:N,7:25);
% ordered_IMU_data_sub08_t1 = raw_IMU_data_sub08_t1(6:N,7:25);
% ordered_IMU_data_sub09_t1 = raw_IMU_data_sub09_t1(6:N,7:25);
% ordered_IMU_data_sub10_t1 = raw_IMU_data_sub10_t1(6:N,7:25);
% ordered_IMU_data_sub11_t1 = raw_IMU_data_sub11_t1(6:N,7:25);
% ordered_IMU_data_sub12_t1 = raw_IMU_data_sub12_t1(6:N,7:25);
% ordered_IMU_data_sub13_t1 = raw_IMU_data_sub13_t1(6:N,7:25);
% ordered_IMU_data_sub14_t1 = raw_IMU_data_sub14_t1(6:N,7:25);
% ordered_IMU_data_sub15_t1 = raw_IMU_data_sub15_t1(6:N,7:25);
% ordered_IMU_data_sub16_t1 = raw_IMU_data_sub16_t1(6:N,7:25);
% ordered_IMU_data_sub17_t1 = raw_IMU_data_sub17_t1(6:N,7:25);
% ordered_IMU_data_sub18_t1 = raw_IMU_data_sub18_t1(6:N,7:25);
% ordered_IMU_data_sub19_t1 = raw_IMU_data_sub19_t1(6:N,7:25);
% ordered_IMU_data_sub20_t1 = raw_IMU_data_sub20_t1(6:N,7:25);
% ordered_IMU_data_sub21_t1 = raw_IMU_data_sub21_t1(6:N,7:25);
% ordered_IMU_data_sub22_t1 = raw_IMU_data_sub22_t1(6:N,7:25);
% ordered_IMU_data_sub23_t1 = raw_IMU_data_sub23_t1(6:N,7:25);
% ordered_IMU_data_sub24_t1 = raw_IMU_data_sub24_t1(6:N,7:25);

% Ordered IMU data trial 2
% ordered_IMU_data_sub01_t2 = raw_IMU_data_sub01_t2(6:N,7:25);
% ordered_IMU_data_sub02_t2 = raw_IMU_data_sub02_t2(6:N,7:25);
% ordered_IMU_data_sub03_t2 = raw_IMU_data_sub03_t2(6:N,7:25);
% ordered_IMU_data_sub04_t2 = raw_IMU_data_sub04_t2(6:N,7:25);
% ordered_IMU_data_sub05_t2 = raw_IMU_data_sub05_t2(6:N,7:25);
% ordered_IMU_data_sub06_t2 = raw_IMU_data_sub06_t2(6:N,7:25);
% ordered_IMU_data_sub07_t2 = raw_IMU_data_sub07_t2(6:N,7:25);
% ordered_IMU_data_sub08_t2 = raw_IMU_data_sub08_t2(6:N,7:25);
% ordered_IMU_data_sub09_t2 = raw_IMU_data_sub09_t2(6:N,7:25);
% ordered_IMU_data_sub10_t2 = raw_IMU_data_sub10_t2(6:N,7:25);
% ordered_IMU_data_sub11_t2 = raw_IMU_data_sub11_t2(6:N,7:25);
% ordered_IMU_data_sub12_t2 = raw_IMU_data_sub12_t2(6:N,7:25);
% ordered_IMU_data_sub13_t2 = raw_IMU_data_sub13_t2(6:N,7:25);
% ordered_IMU_data_sub14_t2 = raw_IMU_data_sub14_t2(6:N,7:25);
% ordered_IMU_data_sub15_t2 = raw_IMU_data_sub15_t2(6:N,7:25);
% ordered_IMU_data_sub16_t2 = raw_IMU_data_sub16_t2(6:N,7:25);
% ordered_IMU_data_sub17_t2 = raw_IMU_data_sub17_t2(6:N,7:25);
% ordered_IMU_data_sub18_t2 = raw_IMU_data_sub18_t2(6:N,7:25);
% ordered_IMU_data_sub19_t2 = raw_IMU_data_sub19_t2(6:N,7:25);
% ordered_IMU_data_sub20_t2 = raw_IMU_data_sub20_t2(6:N,7:25);
% ordered_IMU_data_sub21_t2 = raw_IMU_data_sub21_t2(6:N,7:25);
% ordered_IMU_data_sub22_t2 = raw_IMU_data_sub22_t2(6:N,7:25);
% ordered_IMU_data_sub23_t2 = raw_IMU_data_sub23_t2(6:N,7:25);
% ordered_IMU_data_sub24_t2 = raw_IMU_data_sub24_t2(6:N,7:25);

%% Generate total IMU data matrices
% Generate one cell array with IMU data from the offset trial for 24 participants
mat_total_IMU_data_24subs_OS  = {   ordered_IMU_data_sub01_OS, ordered_IMU_data_sub02_OS, ordered_IMU_data_sub03_OS, ordered_IMU_data_sub04_OS, ordered_IMU_data_sub05_OS,...
                                    ordered_IMU_data_sub06_OS, ordered_IMU_data_sub07_OS, ordered_IMU_data_sub08_OS, ordered_IMU_data_sub09_OS, ordered_IMU_data_sub10_OS,...
                                    ordered_IMU_data_sub11_OS, ordered_IMU_data_sub12_OS, ordered_IMU_data_sub13_OS, ordered_IMU_data_sub14_OS, ordered_IMU_data_sub15_OS,...
                                    ordered_IMU_data_sub16_OS, ordered_IMU_data_sub17_OS, ordered_IMU_data_sub18_OS, ordered_IMU_data_sub19_OS, ordered_IMU_data_sub20_OS,...
                                    ordered_IMU_data_sub21_OS, ordered_IMU_data_sub22_OS, ordered_IMU_data_sub23_OS, ordered_IMU_data_sub24_OS};

% Generate one cell array with all IMU data from the first trials for 24 participants
mat_total_IMU_data_24subs_t1  = {   ordered_IMU_data_sub01_t1, ordered_IMU_data_sub02_t1, ordered_IMU_data_sub03_t1, ordered_IMU_data_sub04_t1, ordered_IMU_data_sub05_t1,...
                                    ordered_IMU_data_sub06_t1, ordered_IMU_data_sub07_t1, ordered_IMU_data_sub08_t1, ordered_IMU_data_sub09_t1, ordered_IMU_data_sub10_t1,...
                                    ordered_IMU_data_sub11_t1, ordered_IMU_data_sub12_t1, ordered_IMU_data_sub13_t1, ordered_IMU_data_sub14_t1, ordered_IMU_data_sub15_t1,...
                                    ordered_IMU_data_sub16_t1, ordered_IMU_data_sub17_t1, ordered_IMU_data_sub18_t1, ordered_IMU_data_sub19_t1, ordered_IMU_data_sub20_t1,...
                                    ordered_IMU_data_sub21_t1, ordered_IMU_data_sub22_t1, ordered_IMU_data_sub23_t1, ordered_IMU_data_sub24_t1};

% Generate one cell array with all IMU data from the second trials for 24 participants
mat_total_IMU_data_24subs_t2  = {   ordered_IMU_data_sub01_t2, ordered_IMU_data_sub02_t2, ordered_IMU_data_sub03_t2, ordered_IMU_data_sub04_t2, ordered_IMU_data_sub05_t2,...
                                    ordered_IMU_data_sub06_t2, ordered_IMU_data_sub07_t2, ordered_IMU_data_sub08_t2, ordered_IMU_data_sub09_t2, ordered_IMU_data_sub10_t2,...
                                    ordered_IMU_data_sub11_t2, ordered_IMU_data_sub12_t2, ordered_IMU_data_sub13_t2, ordered_IMU_data_sub14_t2, ordered_IMU_data_sub15_t2,...
                                    ordered_IMU_data_sub16_t2, ordered_IMU_data_sub17_t2, ordered_IMU_data_sub18_t2, ordered_IMU_data_sub19_t2, ordered_IMU_data_sub20_t2,...
                                    ordered_IMU_data_sub21_t2, ordered_IMU_data_sub22_t2, ordered_IMU_data_sub23_t2, ordered_IMU_data_sub24_t2};

%% Save data (CHANGE IN THE CORRECT DIRECTORY and write name of motion in .mat file!)
% Store all interface forces in a .mat files for 24 participants for all trials 
save(   '/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/Analysis/data analysis/24 subjects/Heave/Heave IMU data/cell_array_heave_IMU_data_24subs.mat',...
        'mat_total_IMU_data_24subs_OS','mat_total_IMU_data_24subs_t1','mat_total_IMU_data_24subs_t2');
    