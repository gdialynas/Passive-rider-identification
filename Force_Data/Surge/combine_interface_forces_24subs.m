function [interface_force_OS, interface_force_t1, interface_force_t2] = combine_interface_forces_24subs(offset, trial1, trial2)

% combine forces from similar interfaces for the offset trial for 24
% participant 
[OS_01, OS_02, OS_03, OS_04, OS_05, OS_06, OS_07, OS_08, OS_09, OS_10, OS_11, OS_12, OS_13] = extract_individual_interface_forces(offset);

force_SP_X_OS     = OS_01;
force_SP_Y_OS     = OS_02;
force_SP_Z_OS     = OS_03;
force_FPL_X_OS    = OS_04;
force_FPL_Z_OS    = OS_05;
force_FPR_X_OS    = OS_06;
force_FPR_Z_OS    = OS_07;
force_HBL_X_OS    = OS_08;
force_HBL_Y_OS    = OS_09;
force_HBL_Z_OS    = OS_10;
force_HBR_X_OS    = OS_11;
force_HBR_Y_OS    = OS_12;
force_HBR_Z_OS    = OS_13;

% combine forces from similar interfaces for the first trial for 24
% participant 
[t1_01, t1_02, t1_03, t1_04, t1_05, t1_06, t1_07, t1_08, t1_09, t1_10, t1_11, t1_12, t1_13] = extract_individual_interface_forces(trial1);

force_SP_X_t1     = t1_01;
force_SP_Y_t1     = t1_02;
force_SP_Z_t1     = t1_03;
force_FPL_X_t1    = t1_04;
force_FPL_Z_t1    = t1_05;
force_FPR_X_t1    = t1_06;
force_FPR_Z_t1    = t1_07;
force_HBL_X_t1    = t1_08;
force_HBL_Y_t1    = t1_09;
force_HBL_Z_t1    = t1_10;
force_HBR_X_t1    = t1_11;
force_HBR_Y_t1    = t1_12;
force_HBR_Z_t1    = t1_13;

% combine forces from similar interfaces for the second trial for 24
% participant 
[t2_01, t2_02, t2_03, t2_04, t2_05, t2_06, t2_07, t2_08, t2_09, t2_10, t2_11, t2_12, t2_13] = extract_individual_interface_forces(trial2);

force_SP_X_t2     = t2_01;
force_SP_Y_t2     = t2_02;
force_SP_Z_t2     = t2_03;
force_FPL_X_t2    = t2_04;
force_FPL_Z_t2    = t2_05;
force_FPR_X_t2    = t2_06;
force_FPR_Z_t2    = t2_07;
force_HBL_X_t2    = t2_08;
force_HBL_Y_t2    = t2_09;
force_HBL_Z_t2    = t2_10;
force_HBR_X_t2    = t2_11;
force_HBR_Y_t2    = t2_12;
force_HBR_Z_t2    = t2_13;

%% Save variables for offset, trial1 and trial2

interface_force_OS = {  force_SP_X_OS,force_SP_Y_OS,force_SP_Z_OS,...
                        force_FPL_X_OS,force_FPL_Z_OS,...
                        force_FPR_X_OS,force_FPR_Z_OS,...
                        force_HBL_X_OS,force_HBL_Y_OS,force_HBL_Z_OS,...
                        force_HBR_X_OS,force_HBR_Y_OS,force_HBR_Z_OS};
                    
interface_force_t1 = {  force_SP_X_t1,force_SP_Y_t1,force_SP_Z_t1,...
                        force_FPL_X_t1,force_FPL_Z_t1,...
                        force_FPR_X_t1,force_FPR_Z_t1,...
                        force_HBL_X_t1,force_HBL_Y_t1,force_HBL_Z_t1,...
                        force_HBR_X_t1,force_HBR_Y_t1,force_HBR_Z_t1};                    
                    
interface_force_t2 = {  force_SP_X_t2,force_SP_Y_t2,force_SP_Z_t2,...
                        force_FPL_X_t2,force_FPL_Z_t2,...
                        force_FPR_X_t2,force_FPR_Z_t2,...
                        force_HBL_X_t2,force_HBL_Y_t2,force_HBL_Z_t2,...
                        force_HBR_X_t2,force_HBR_Y_t2,force_HBR_Z_t2};
                    