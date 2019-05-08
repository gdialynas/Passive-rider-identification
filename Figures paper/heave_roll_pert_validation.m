clear all
close all
clc

%% load files
IMU_offset  = xlsread('sub24_roll_input_gyr_X_OS');
gyr_trial1  = xlsread('sub24_roll_input_gyr_X_t1');

load('roll_pert_amp1');
load('heave_pert_amp1');
load('heave_IMU_sub24');

%roll_vel_amp1 = -roll_vel_amp1;
%roll_acc_amp1 = -roll_acc_amp1;

IMU_offset = -IMU_offset;
gyr_trial1 = -gyr_trial1;

%% Plot raw data
figure()
subplot(311)
    plot(IMU_offset);
subplot(312)
    plot(gyr_trial1);
subplot(313)
    plot(roll_vel_amp1);

%% Calc IMU offset
close all
error = mean(IMU_offset(1000:6000));

%% Solve for IMU offset
gyr_trial1_scaled = gyr_trial1 - error;

figure()
subplot(211)
    plot(gyr_trial1);
subplot(212)
    plot(gyr_trial1_scaled);

%% Filter signal to reduce noise
close all

fs  = 100;
Fnorm = 13/(fs/2);           % Normalized frequency
df = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

%grpdelay(df,2048,fs)   ; % plot group delay
D = mean(grpdelay(df)) ; % filter delay in samples

gyr_trial1_scaled_filt = filter(df,[gyr_trial1_scaled; zeros(D,1)]); % Append D zeros to the input data
gyr_trial1_scaled_filt = gyr_trial1_scaled_filt(D+1:end);

%%
figure()
subplot(211)
    plot(gyr_trial1_scaled);
    %xlim([0 1000]);
subplot(212)
    plot(gyr_trial1_scaled_filt);  
    %xlim([0 1000]);

%% Compare designed signal with measured signal
close all

figure()
grid on; hold on;
plot(roll_vel_amp1);
plot(gyr_trial1_scaled_filt);
legend('Des. signal', 'Mes. signal')

%% Calculate delay between signals
close all

[C12, lag1] = xcov(roll_vel_amp1,gyr_trial1_scaled_filt);

figure()
plot(lag1, C12/max(C12));

[~,I1] = max(abs(C12));
t12 = lag1(I1);

%% Aline signals
close all
%acc_trial1_filt = [zeros(abs(t12),1);acc_trial1_filt];
gyr_trial1_fit = gyr_trial1_scaled_filt(abs(t12):end);  

figure
grid on; hold on;
plot(roll_vel_amp1);
plot(gyr_trial1_fit);
legend('Des. signal', 'Mes. signal')

%% Resample measured signal
close all
gyr_trial1_resamp = resample(gyr_trial1_fit,6497,6499); % difference between peaks of final reference signal
gyr_trial1_resamp = gyr_trial1_resamp(1:6902);
heave_sub24 = heave_sub24(1:6902);

%%
% Signal parameters
T       = 69.02;           % observation time. 
fs      = 100;          % samplin frequency
dt      = 1/fs;         % sample duration
N       = T*fs;         % number of samples in signal
t       = (0:N-1).'*dt; % time vector

figure()
subplot(211)
    hold on;
    plot(t,gyr_trial1_resamp,'LineWidth',2)
    plot(t,roll_vel_amp1,'--','LineWidth',2)
    xlim([0 T])
    xlabel('Time [s]');
    ylabel('Velocity [rad/s]')
    lgd = legend('Measured sig. u(t)','Designed sig. p(t)');
    lgd.FontSize = 17;
    set(gca,'FontSize',20)
subplot(212)
    hold on;
    plot(t,gyr_trial1_resamp)
    plot(t,roll_vel_amp1,'--')
    xlim([0 T])
    xlabel('Time [s]');
    ylabel('Velocity [rad/s]')
    lgd = legend('Measured sig. u(t)','Designed sig. p(t)');
    lgd.FontSize = 17;
    set(gca,'FontSize',20)

figure()
subplot(211)
    hold on;
    plot(t,heave_sub24,'LineWidth',1.5)
    plot(t,-heave_acc_amp1,'--','LineWidth',1.5)
    xlim([0 T])
    xlabel('Time [s]');
    ylabel('Acceleration [m/s^2]')
    lgd = legend('Measured sig. u(t)','Designed sig. p(t)');
    lgd.FontSize = 17;
    set(gca,'FontSize',20)
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position
subplot(212)
    hold on;
    plot(t,gyr_trial1_resamp,'LineWidth',2)
    plot(t,roll_vel_amp1,'--','LineWidth',2)
    xlim([0 T])
    xlabel('Time [s]');
    ylabel('Velocity [rad/s]')
    lgd = legend('Measured sig. u(t)','Designed sig. p(t)');
    lgd.FontSize = 17;
    set(gca,'FontSize',20)
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position


