%% Generate cell arrays for all interface forces for 24 subjects

% This script is generated because matlab cannot compile directly the force
% data excel files from LABVIEW. This script first imports the csv files, 
% after which the cell arrays are converted to mat array to delete the last
% three columns (useless data). Finally all raw force data is combined for
% the offset trial, trial 1 and trial 2 in cell arrays. These arrays should
% be stored in the directory which contains the script for processing and 
% analysing the force data
 
clear all
close all
clc

%% Load measured force data

%%% !!! CHANGE HERE ALL EXCEL FILES TO THE CORRECT MOTION AND SUBJECT !!!

% load data offset trial for 24 participants (OS = offset trial)
cell_data_sub01_OS  = csvimport('sub01_sway_OS.xls');
cell_data_sub02_OS  = csvimport('sub02_sway_OS.csv');
cell_data_sub03_OS  = csvimport('sub03_sway_OS.xls');
cell_data_sub04_OS  = csvimport('sub04_sway_OS.xls');
cell_data_sub05_OS  = csvimport('sub05_sway_OS.xls');
cell_data_sub06_OS  = csvimport('sub06_sway_OS.xls');
cell_data_sub07_OS  = csvimport('sub07_sway_OS.xls');
cell_data_sub08_OS  = csvimport('sub08_sway_OS.xls');
cell_data_sub09_OS  = csvimport('sub09_sway_OS.xls');
cell_data_sub10_OS  = csvimport('sub10_sway_OS.xls');
cell_data_sub11_OS  = csvimport('sub11_sway_OS.xls');
cell_data_sub12_OS  = csvimport('sub12_sway_OS.xls');
cell_data_sub13_OS  = csvimport('sub13_sway_OS.xls');
cell_data_sub14_OS  = csvimport('sub14_sway_OS.xls');
cell_data_sub15_OS  = csvimport('sub15_sway_OS.xls');
cell_data_sub16_OS  = csvimport('sub16_sway_OS.xls');
cell_data_sub17_OS  = csvimport('sub17_sway_OS.xls');
cell_data_sub18_OS  = csvimport('sub18_sway_OS.xls');
cell_data_sub19_OS  = csvimport('sub19_sway_OS.xls');
cell_data_sub20_OS  = csvimport('sub20_sway_OS.xls');
cell_data_sub21_OS  = csvimport('sub21_sway_OS.xls');
cell_data_sub22_OS  = csvimport('sub22_sway_OS.xls');
cell_data_sub23_OS  = csvimport('sub23_sway_OS.xls');
cell_data_sub24_OS  = csvimport('sub24_sway_OS.xls');

% load data first trial 24 participants (t1 = trial 1)
cell_data_sub01_t1  = csvimport('sub01_sway_t1.xls');
cell_data_sub02_t1  = csvimport('sub02_sway_t1.xls');
cell_data_sub03_t1  = csvimport('sub03_sway_t1.xls');
cell_data_sub04_t1  = csvimport('sub04_sway_t1.xls');
cell_data_sub05_t1  = csvimport('sub05_sway_t1.xls');
cell_data_sub06_t1  = csvimport('sub06_sway_t1.xls');
cell_data_sub07_t1  = csvimport('sub07_sway_t1.xls');
cell_data_sub08_t1  = csvimport('sub08_sway_t1.xls');
cell_data_sub09_t1  = csvimport('sub09_sway_t1.xls');
cell_data_sub10_t1  = csvimport('sub10_sway_t1.xls');
cell_data_sub11_t1  = csvimport('sub11_sway_t1.xls');
cell_data_sub12_t1  = csvimport('sub12_sway_t1.xls');
cell_data_sub13_t1  = csvimport('sub13_sway_t1.xls');
cell_data_sub14_t1  = csvimport('sub14_sway_t1.xls');
cell_data_sub15_t1  = csvimport('sub15_sway_t1.xls');
cell_data_sub16_t1  = csvimport('sub16_sway_t1.xls');
cell_data_sub17_t1  = csvimport('sub17_sway_t1.xls');
cell_data_sub18_t1  = csvimport('sub18_sway_t1.xls');
cell_data_sub19_t1  = csvimport('sub19_sway_t1.xls');
cell_data_sub20_t1  = csvimport('sub20_sway_t1.xls');
cell_data_sub21_t1  = csvimport('sub21_sway_t1.xls');
cell_data_sub22_t1  = csvimport('sub22_sway_t1.xls');
cell_data_sub23_t1  = csvimport('sub23_sway_t1.xls');
cell_data_sub24_t1  = csvimport('sub24_sway_t1.xls');

% load data second trial for 24 participants (t2 = trial 2)
cell_data_sub01_t2  = csvimport('sub01_sway_t2.xls');
cell_data_sub02_t2  = csvimport('sub02_sway_t2.xls');
cell_data_sub03_t2  = csvimport('sub03_sway_t2.xls');
cell_data_sub04_t2  = csvimport('sub04_sway_t2.xls');
cell_data_sub05_t2  = csvimport('sub05_sway_t2.xls');
cell_data_sub06_t2  = csvimport('sub06_sway_t2.xls');
cell_data_sub07_t2  = csvimport('sub07_sway_t2.xls');
cell_data_sub08_t2  = csvimport('sub08_sway_t2.xls');
cell_data_sub09_t2  = csvimport('sub09_sway_t2.xls');
cell_data_sub10_t2  = csvimport('sub10_sway_t2.xls');
cell_data_sub11_t2  = csvimport('sub11_sway_t2.xls');
cell_data_sub12_t2  = csvimport('sub12_sway_t2.xls');
cell_data_sub13_t2  = csvimport('sub13_sway_t2.xls');
cell_data_sub14_t2  = csvimport('sub14_sway_t2.xls');
cell_data_sub15_t2  = csvimport('sub15_sway_t2.xls');
cell_data_sub16_t2  = csvimport('sub16_sway_t2.xls');
cell_data_sub17_t2  = csvimport('sub17_sway_t2.xls');
cell_data_sub18_t2  = csvimport('sub18_sway_t2.xls');
cell_data_sub19_t2  = csvimport('sub19_sway_t2.xls');
cell_data_sub20_t2  = csvimport('sub20_sway_t2.xls');
cell_data_sub21_t2  = csvimport('sub21_sway_t2.xls');
cell_data_sub22_t2  = csvimport('sub22_sway_t2.xls');
cell_data_sub23_t2  = csvimport('sub23_sway_t2.xls');
cell_data_sub24_t2  = csvimport('sub24_sway_t2.xls');

%% Convert cell arrays to matrices
% Convert cell arrays to matrices for offset trial for 24 participants
mat_data_sub01_OS   = convert_cellarray_to_matrix(cell_data_sub01_OS);
mat_data_sub02_OS   = convert_cellarray_to_matrix(cell_data_sub02_OS);
mat_data_sub03_OS   = convert_cellarray_to_matrix(cell_data_sub03_OS);
mat_data_sub04_OS   = convert_cellarray_to_matrix(cell_data_sub04_OS);
mat_data_sub05_OS   = convert_cellarray_to_matrix(cell_data_sub05_OS);
mat_data_sub06_OS   = convert_cellarray_to_matrix(cell_data_sub06_OS);
mat_data_sub07_OS   = convert_cellarray_to_matrix(cell_data_sub07_OS);
mat_data_sub08_OS   = convert_cellarray_to_matrix(cell_data_sub08_OS);
mat_data_sub09_OS   = convert_cellarray_to_matrix(cell_data_sub09_OS);
mat_data_sub10_OS   = convert_cellarray_to_matrix(cell_data_sub10_OS);
mat_data_sub11_OS   = convert_cellarray_to_matrix(cell_data_sub11_OS);
mat_data_sub12_OS   = convert_cellarray_to_matrix(cell_data_sub12_OS);
mat_data_sub13_OS   = convert_cellarray_to_matrix(cell_data_sub13_OS);
mat_data_sub14_OS   = convert_cellarray_to_matrix(cell_data_sub14_OS);
mat_data_sub15_OS   = convert_cellarray_to_matrix(cell_data_sub15_OS);
mat_data_sub16_OS   = convert_cellarray_to_matrix(cell_data_sub16_OS);
mat_data_sub17_OS   = convert_cellarray_to_matrix(cell_data_sub17_OS);
mat_data_sub18_OS   = convert_cellarray_to_matrix(cell_data_sub18_OS);
mat_data_sub19_OS   = convert_cellarray_to_matrix(cell_data_sub19_OS);
mat_data_sub20_OS   = convert_cellarray_to_matrix(cell_data_sub20_OS);
mat_data_sub21_OS   = convert_cellarray_to_matrix(cell_data_sub21_OS);
mat_data_sub22_OS   = convert_cellarray_to_matrix(cell_data_sub22_OS);
mat_data_sub23_OS   = convert_cellarray_to_matrix(cell_data_sub23_OS);
mat_data_sub24_OS   = convert_cellarray_to_matrix(cell_data_sub24_OS);

% Convert cell arrays to matrices for first trial for 24 participants
mat_data_sub01_t1   = convert_cellarray_to_matrix(cell_data_sub01_t1);
mat_data_sub02_t1   = convert_cellarray_to_matrix(cell_data_sub02_t1);
mat_data_sub03_t1   = convert_cellarray_to_matrix(cell_data_sub03_t1);
mat_data_sub04_t1   = convert_cellarray_to_matrix(cell_data_sub04_t1);
mat_data_sub05_t1   = convert_cellarray_to_matrix(cell_data_sub05_t1);
mat_data_sub06_t1   = convert_cellarray_to_matrix(cell_data_sub06_t1);
mat_data_sub07_t1   = convert_cellarray_to_matrix(cell_data_sub07_t1);
mat_data_sub08_t1   = convert_cellarray_to_matrix(cell_data_sub08_t1);
mat_data_sub09_t1   = convert_cellarray_to_matrix(cell_data_sub09_t1);
mat_data_sub10_t1   = convert_cellarray_to_matrix(cell_data_sub10_t1);
mat_data_sub11_t1   = convert_cellarray_to_matrix(cell_data_sub11_t1);
mat_data_sub12_t1   = convert_cellarray_to_matrix(cell_data_sub12_t1);
mat_data_sub13_t1   = convert_cellarray_to_matrix(cell_data_sub13_t1);
mat_data_sub14_t1   = convert_cellarray_to_matrix(cell_data_sub14_t1);
mat_data_sub15_t1   = convert_cellarray_to_matrix(cell_data_sub15_t1);
mat_data_sub16_t1   = convert_cellarray_to_matrix(cell_data_sub16_t1);
mat_data_sub17_t1   = convert_cellarray_to_matrix(cell_data_sub17_t1);
mat_data_sub18_t1   = convert_cellarray_to_matrix(cell_data_sub18_t1);
mat_data_sub19_t1   = convert_cellarray_to_matrix(cell_data_sub19_t1);
mat_data_sub20_t1   = convert_cellarray_to_matrix(cell_data_sub20_t1);
mat_data_sub21_t1   = convert_cellarray_to_matrix(cell_data_sub21_t1);
mat_data_sub22_t1   = convert_cellarray_to_matrix(cell_data_sub22_t1);
mat_data_sub23_t1   = convert_cellarray_to_matrix(cell_data_sub23_t1);
mat_data_sub24_t1   = convert_cellarray_to_matrix(cell_data_sub24_t1);

% Convert cell arrays to matrices for second trial for 24 participants
mat_data_sub01_t2   = convert_cellarray_to_matrix(cell_data_sub01_t2);
mat_data_sub02_t2   = convert_cellarray_to_matrix(cell_data_sub02_t2);
mat_data_sub03_t2   = convert_cellarray_to_matrix(cell_data_sub03_t2);
mat_data_sub04_t2   = convert_cellarray_to_matrix(cell_data_sub04_t2);
mat_data_sub05_t2   = convert_cellarray_to_matrix(cell_data_sub05_t2);
mat_data_sub06_t2   = convert_cellarray_to_matrix(cell_data_sub06_t2);
mat_data_sub07_t2   = convert_cellarray_to_matrix(cell_data_sub07_t2);
mat_data_sub08_t2   = convert_cellarray_to_matrix(cell_data_sub08_t2);
mat_data_sub09_t2   = convert_cellarray_to_matrix(cell_data_sub09_t2);
mat_data_sub10_t2   = convert_cellarray_to_matrix(cell_data_sub10_t2);
mat_data_sub11_t2   = convert_cellarray_to_matrix(cell_data_sub11_t2);
mat_data_sub12_t2   = convert_cellarray_to_matrix(cell_data_sub12_t2);
mat_data_sub13_t2   = convert_cellarray_to_matrix(cell_data_sub13_t2);
mat_data_sub14_t2   = convert_cellarray_to_matrix(cell_data_sub14_t2);
mat_data_sub15_t2   = convert_cellarray_to_matrix(cell_data_sub15_t2);
mat_data_sub16_t2   = convert_cellarray_to_matrix(cell_data_sub16_t2);
mat_data_sub17_t2   = convert_cellarray_to_matrix(cell_data_sub17_t2);
mat_data_sub18_t2   = convert_cellarray_to_matrix(cell_data_sub18_t2);
mat_data_sub19_t2   = convert_cellarray_to_matrix(cell_data_sub19_t2);
mat_data_sub20_t2   = convert_cellarray_to_matrix(cell_data_sub20_t2);
mat_data_sub21_t2   = convert_cellarray_to_matrix(cell_data_sub21_t2);
mat_data_sub22_t2   = convert_cellarray_to_matrix(cell_data_sub22_t2);
mat_data_sub23_t2   = convert_cellarray_to_matrix(cell_data_sub23_t2);
mat_data_sub24_t2   = convert_cellarray_to_matrix(cell_data_sub24_t2);

%% Delete 3 last columns
% Delete last 3 columns (no force data) for offset trials for 24 participants 
mat_force_data_sub01_OS     = mat_data_sub01_OS(:,1:13);
mat_force_data_sub02_OS     = mat_data_sub02_OS(:,1:13);
mat_force_data_sub03_OS     = mat_data_sub03_OS(:,1:13);
mat_force_data_sub04_OS     = mat_data_sub04_OS(:,1:13);
mat_force_data_sub05_OS     = mat_data_sub05_OS(:,1:13);
mat_force_data_sub06_OS     = mat_data_sub06_OS(:,1:13);
mat_force_data_sub07_OS     = mat_data_sub07_OS(:,1:13);
mat_force_data_sub08_OS     = mat_data_sub08_OS(:,1:13);
mat_force_data_sub09_OS     = mat_data_sub09_OS(:,1:13);
mat_force_data_sub10_OS     = mat_data_sub10_OS(:,1:13);
mat_force_data_sub11_OS     = mat_data_sub11_OS(:,1:13);
mat_force_data_sub12_OS     = mat_data_sub12_OS(:,1:13);
mat_force_data_sub13_OS     = mat_data_sub13_OS(:,1:13);
mat_force_data_sub14_OS     = mat_data_sub14_OS(:,1:13);
mat_force_data_sub15_OS     = mat_data_sub15_OS(:,1:13);
mat_force_data_sub16_OS     = mat_data_sub16_OS(:,1:13);
mat_force_data_sub17_OS     = mat_data_sub17_OS(:,1:13);
mat_force_data_sub18_OS     = mat_data_sub18_OS(:,1:13);
mat_force_data_sub19_OS     = mat_data_sub19_OS(:,1:13);
mat_force_data_sub20_OS     = mat_data_sub20_OS(:,1:13);
mat_force_data_sub21_OS     = mat_data_sub21_OS(:,1:13);
mat_force_data_sub22_OS     = mat_data_sub22_OS(:,1:13);
mat_force_data_sub23_OS     = mat_data_sub23_OS(:,1:13);
mat_force_data_sub24_OS     = mat_data_sub24_OS(:,1:13);

% Delete last 3 columns (no force data) for first trials for 24 participants 
mat_force_data_sub01_t1     = mat_data_sub01_t1(:,1:13);
mat_force_data_sub02_t1     = mat_data_sub02_t1(:,1:13);
mat_force_data_sub03_t1     = mat_data_sub03_t1(:,1:13);
mat_force_data_sub04_t1     = mat_data_sub04_t1(:,1:13);
mat_force_data_sub05_t1     = mat_data_sub05_t1(:,1:13);
mat_force_data_sub06_t1     = mat_data_sub06_t1(:,1:13);
mat_force_data_sub07_t1     = mat_data_sub07_t1(:,1:13);
mat_force_data_sub08_t1     = mat_data_sub08_t1(:,1:13);
mat_force_data_sub09_t1     = mat_data_sub09_t1(:,1:13);
mat_force_data_sub10_t1     = mat_data_sub10_t1(:,1:13);
mat_force_data_sub11_t1     = mat_data_sub11_t1(:,1:13);
mat_force_data_sub12_t1     = mat_data_sub12_t1(:,1:13);
mat_force_data_sub13_t1     = mat_data_sub13_t1(:,1:13);
mat_force_data_sub14_t1     = mat_data_sub14_t1(:,1:13);
mat_force_data_sub15_t1     = mat_data_sub15_t1(:,1:13);
mat_force_data_sub16_t1     = mat_data_sub16_t1(:,1:13);
mat_force_data_sub17_t1     = mat_data_sub17_t1(:,1:13);
mat_force_data_sub18_t1     = mat_data_sub18_t1(:,1:13);
mat_force_data_sub19_t1     = mat_data_sub19_t1(:,1:13);
mat_force_data_sub20_t1     = mat_data_sub20_t1(:,1:13);
mat_force_data_sub21_t1     = mat_data_sub21_t1(:,1:13);
mat_force_data_sub22_t1     = mat_data_sub22_t1(:,1:13);
mat_force_data_sub23_t1     = mat_data_sub23_t1(:,1:13);
mat_force_data_sub24_t1     = mat_data_sub24_t1(:,1:13);

% Delete last 3 columns (no force data) for second trials for 24 participants 
mat_force_data_sub01_t2     = mat_data_sub01_t2(:,1:13);
mat_force_data_sub02_t2     = mat_data_sub02_t2(:,1:13);
mat_force_data_sub03_t2     = mat_data_sub03_t2(:,1:13);
mat_force_data_sub04_t2     = mat_data_sub04_t2(:,1:13);
mat_force_data_sub05_t2     = mat_data_sub05_t2(:,1:13);
mat_force_data_sub06_t2     = mat_data_sub06_t2(:,1:13);
mat_force_data_sub07_t2     = mat_data_sub07_t2(:,1:13);
mat_force_data_sub08_t2     = mat_data_sub08_t2(:,1:13);
mat_force_data_sub09_t2     = mat_data_sub09_t2(:,1:13);
mat_force_data_sub10_t2     = mat_data_sub10_t2(:,1:13);
mat_force_data_sub11_t2     = mat_data_sub11_t2(:,1:13);
mat_force_data_sub12_t2     = mat_data_sub12_t2(:,1:13);
mat_force_data_sub13_t2     = mat_data_sub13_t2(:,1:13);
mat_force_data_sub14_t2     = mat_data_sub14_t2(:,1:13);
mat_force_data_sub15_t2     = mat_data_sub15_t2(:,1:13);
mat_force_data_sub16_t2     = mat_data_sub16_t2(:,1:13);
mat_force_data_sub17_t2     = mat_data_sub17_t2(:,1:13);
mat_force_data_sub18_t2     = mat_data_sub18_t2(:,1:13);
mat_force_data_sub19_t2     = mat_data_sub19_t2(:,1:13);
mat_force_data_sub20_t2     = mat_data_sub20_t2(:,1:13);
mat_force_data_sub21_t2     = mat_data_sub21_t2(:,1:13);
mat_force_data_sub22_t2     = mat_data_sub22_t2(:,1:13);
mat_force_data_sub23_t2     = mat_data_sub23_t2(:,1:13);
mat_force_data_sub24_t2     = mat_data_sub24_t2(:,1:13);

%% Generate total force matrices
% Generate one cell array with force data from the offset trials for 24 participants
sway_force_24subs_OS  = {  mat_force_data_sub01_OS, mat_force_data_sub02_OS, mat_force_data_sub03_OS, mat_force_data_sub04_OS, mat_force_data_sub05_OS,...
                                mat_force_data_sub06_OS, mat_force_data_sub07_OS, mat_force_data_sub08_OS, mat_force_data_sub09_OS, mat_force_data_sub10_OS,...
                                mat_force_data_sub11_OS, mat_force_data_sub12_OS, mat_force_data_sub13_OS, mat_force_data_sub14_OS, mat_force_data_sub15_OS,...
                                mat_force_data_sub16_OS, mat_force_data_sub17_OS, mat_force_data_sub18_OS, mat_force_data_sub19_OS, mat_force_data_sub20_OS,...
                                mat_force_data_sub21_OS, mat_force_data_sub22_OS, mat_force_data_sub23_OS, mat_force_data_sub24_OS};

% Generate one cell array with all force data from the first trials for 24 participants
sway_force_24subs_t1  = {  mat_force_data_sub01_t1, mat_force_data_sub02_t1, mat_force_data_sub03_t1, mat_force_data_sub04_t1, mat_force_data_sub05_t1,...
                                mat_force_data_sub06_t1, mat_force_data_sub07_t1, mat_force_data_sub08_t1, mat_force_data_sub09_t1, mat_force_data_sub10_t1,...
                                mat_force_data_sub11_t1, mat_force_data_sub12_t1, mat_force_data_sub13_t1, mat_force_data_sub14_t1, mat_force_data_sub15_t1,...
                                mat_force_data_sub16_t1, mat_force_data_sub17_t1, mat_force_data_sub18_t1, mat_force_data_sub19_t1, mat_force_data_sub20_t1,...
                                mat_force_data_sub21_t1, mat_force_data_sub22_t1, mat_force_data_sub23_t1, mat_force_data_sub24_t1};
                
% Generate one cell array with all force data from the second trials for 24 participants
sway_force_24subs_t2  = {  mat_force_data_sub01_t2, mat_force_data_sub02_t2, mat_force_data_sub03_t2, mat_force_data_sub04_t2, mat_force_data_sub05_t2,...
                                mat_force_data_sub06_t2, mat_force_data_sub07_t2, mat_force_data_sub08_t2, mat_force_data_sub09_t2, mat_force_data_sub10_t2,...
                                mat_force_data_sub11_t2, mat_force_data_sub12_t2, mat_force_data_sub13_t2, mat_force_data_sub14_t2, mat_force_data_sub15_t2,...
                                mat_force_data_sub16_t2, mat_force_data_sub17_t2, mat_force_data_sub18_t2, mat_force_data_sub19_t2, mat_force_data_sub20_t2,...
                                mat_force_data_sub21_t2, mat_force_data_sub22_t2, mat_force_data_sub23_t2, mat_force_data_sub24_t2};

%% Save data (CHANGE IN THE CORRECT DIRECTORY and write name of motion in .mat file!)
% Store all interface forces in a .mat files for 24 participants for all trials 
save(   'D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\Sway\Sway strain gauge data\cell_array_sway_force_24subs.mat',...
        'sway_force_24subs_OS','sway_force_24subs_t1','sway_force_24subs_t2');
    