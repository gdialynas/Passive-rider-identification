function [offset, trial1, trial2] = solve_sensor_fusion(u,y) 

% input: u = raw force data (cells) of all participants for all trials
% input: y = is the mean error of the strain gauges (cells) for all participant groups
% output: = scaled force data for all participants for all trials 

% Cells with specific participants grouped for the offset trial, trial1 and
% trial2
sub1_OS        = u{1}(1);
sub2_6_OS      = u{1}(2:6);
sub7_OS        = u{1}(7);
sub8_10_OS     = u{1}(8:10);
sub11_13_OS    = u{1}(11:13);
sub14_15_OS    = u{1}(14:15);
sub16_20_OS    = u{1}(16:20);
sub21_24_OS    = u{1}(21:24);

sub1_t1        = u{2}(1);
sub2_6_t1      = u{2}(2:6);
sub7_t1        = u{2}(7);
sub8_10_t1     = u{2}(8:10);
sub11_13_t1    = u{2}(11:13);
sub14_15_t1    = u{2}(14:15);
sub16_20_t1    = u{2}(16:20);
sub21_24_t1    = u{2}(21:24);

sub1_t2        = u{3}(1);
sub2_6_t2      = u{3}(2:6);
sub7_t2        = u{3}(7);
sub8_10_t2     = u{3}(8:10);
sub11_13_t2    = u{3}(11:13);
sub14_15_t2    = u{3}(14:15);
sub16_20_t2    = u{3}(16:20);
sub21_24_t2    = u{3}(21:24);

% Converge from cell to matrix
sub1_OS        = cell2mat(sub1_OS);
sub2_6_OS      = cell2mat(sub2_6_OS);
sub7_OS        = cell2mat(sub7_OS);
sub8_10_OS     = cell2mat(sub8_10_OS);
sub11_13_OS    = cell2mat(sub11_13_OS);
sub14_15_OS    = cell2mat(sub14_15_OS);
sub16_20_OS    = cell2mat(sub16_20_OS);
sub21_24_OS    = cell2mat(sub21_24_OS);

sub1_t1        = cell2mat(sub1_t1);
sub2_6_t1      = cell2mat(sub2_6_t1);
sub7_t1        = cell2mat(sub7_t1);
sub8_10_t1     = cell2mat(sub8_10_t1);
sub11_13_t1    = cell2mat(sub11_13_t1);
sub14_15_t1    = cell2mat(sub14_15_t1);
sub16_20_t1    = cell2mat(sub16_20_t1);
sub21_24_t1    = cell2mat(sub21_24_t1);

sub1_t2        = cell2mat(sub1_t2);
sub2_6_t2      = cell2mat(sub2_6_t2);
sub7_t2        = cell2mat(sub7_t2);
sub8_10_t2     = cell2mat(sub8_10_t2);
sub11_13_t2    = cell2mat(sub11_13_t2);
sub14_15_t2    = cell2mat(sub14_15_t2);
sub16_20_t2    = cell2mat(sub16_20_t2);
sub21_24_t2    = cell2mat(sub21_24_t2);

% vector with mean errors of strain gauges
err_sub1       = repmat(y{1},1,1);
err_sub2_6     = repmat(y{2},1,5);
err_sub7       = repmat(y{3},1,1);
err_sub8_10    = repmat(y{4},1,3);
err_sub11_13   = repmat(y{5},1,3);
err_sub14_15   = repmat(y{6},1,2);
err_sub16_20   = repmat(y{7},1,5);
err_sub21_24   = repmat(y{8},1,4);

% Solve for error
scaled_sub1_OS      = sub1_OS - err_sub1; 
scaled_sub2_6_OS    = sub2_6_OS - err_sub2_6;
scaled_sub7_OS      = sub7_OS - err_sub7;
scaled_sub8_10_OS   = sub8_10_OS - err_sub8_10;
scaled_sub11_13_OS  = sub11_13_OS - err_sub11_13;
scaled_sub14_15_OS  = sub14_15_OS - err_sub14_15;
scaled_sub16_20_OS  = sub16_20_OS - err_sub16_20;
scaled_sub21_24_OS  = sub21_24_OS - err_sub21_24;

scaled_sub1_t1      = sub1_t1 - err_sub1; 
scaled_sub2_6_t1    = sub2_6_t1 - err_sub2_6;
scaled_sub7_t1      = sub7_t1 - err_sub7;
scaled_sub8_10_t1   = sub8_10_t1 - err_sub8_10;
scaled_sub11_13_t1  = sub11_13_t1 - err_sub11_13;
scaled_sub14_15_t1  = sub14_15_t1 - err_sub14_15;
scaled_sub16_20_t1  = sub16_20_t1 - err_sub16_20;
scaled_sub21_24_t1  = sub21_24_t1 - err_sub21_24;

scaled_sub1_t2      = sub1_t2 - err_sub1; 
scaled_sub2_6_t2    = sub2_6_t2 - err_sub2_6;
scaled_sub7_t2      = sub7_t2 - err_sub7;
scaled_sub8_10_t2   = sub8_10_t2 - err_sub8_10;
scaled_sub11_13_t2  = sub11_13_t2 - err_sub11_13;
scaled_sub14_15_t2  = sub14_15_t2 - err_sub14_15;
scaled_sub16_20_t2  = sub16_20_t2 - err_sub16_20;
scaled_sub21_24_t2  = sub21_24_t2 - err_sub21_24;

% Regenerate offset, trial1 and trial2 matrix

offset = [  scaled_sub1_OS, scaled_sub2_6_OS, scaled_sub7_OS, scaled_sub8_10_OS,...
            scaled_sub11_13_OS, scaled_sub14_15_OS, scaled_sub16_20_OS, scaled_sub21_24_OS];

trial1 = [  scaled_sub1_t1, scaled_sub2_6_t1, scaled_sub7_t1, scaled_sub8_10_t1,...
            scaled_sub11_13_t1, scaled_sub14_15_t1, scaled_sub16_20_t1, scaled_sub21_24_t1];
        
trial2 = [  scaled_sub1_t2, scaled_sub2_6_t2, scaled_sub7_t2, scaled_sub8_10_t2,...
            scaled_sub11_13_t2, scaled_sub14_15_t2, scaled_sub16_20_t2, scaled_sub21_24_t2];        
        
        