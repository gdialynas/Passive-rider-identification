%% Designing reference signal

close all
clear all 
clc
 
%% Reference signal with aan amplitude of 0.25 m/s^2
fs = 100;
dt = 1/fs;
f  = 1;
T  = 0:dt:60-dt;
N  = T*fs;

t1_start = 0:dt:1-dt;
t2_start = 1:dt:2-dt;
t3_start = 2:dt:2.5-dt;
t4_start = 2.5:dt:3.5-dt;
t5_start = 3.5:dt:5;

t1_stop = 0:dt:1.5-dt;
t2_stop = 1.5:dt:2.5-dt;
t3_stop = 2.5:dt:3-dt;
t4_stop = 3:dt:4;

t_ref_start          = [t1_start t2_start t3_start t4_start t5_start]';
t_ref_stop           = [t1_stop t2_stop t3_stop t4_stop]';

%% Reference signal with an amplitude of 0.25 m/s^2
u1_start    = zeros(1,length(t1_start));
u2_start    = 0.25*sin(2*pi*f*t2_start);
u3_start    = zeros(1, length(t3_start));
u4_start    = 0.25*sin(2*pi*f*t4_start);
u5_start    = zeros(1,length(t5_start));

u1_stop     = zeros(1,length(t1_stop));
u2_stop     = -0.25*sin(2*pi*f*t2_stop);
u3_stop     = zeros(1, length(t3_stop));
u4_stop     = -0.25*sin(2*pi*f*t4_stop);

ref_signal_start  = [u1_start u2_start u3_start u4_start u5_start]';
ref_signal_stop   = [u1_stop u2_stop u3_stop u4_stop]';

%% Plot reference start and stop signal

figure(1)
subplot(211)
    %plot(t_ref_start, ref_signal_start)
    plot(ref_signal_start)
    ylim([-1 1])
    %xlim([0 5+dt])
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    title('Reference signal at the start')
subplot(212)
    %plot(t_ref_stop, ref_signal_stop)
    plot(ref_signal_stop)
    ylim([-1 1])
    %xlim([0 5+dt])
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    title('Reference signal at the end')
    
%% Create force template
close all

pert_length = zeros(1,length(N))';
force_temp = [ref_signal_start; pert_length; ref_signal_stop];
t_temp = (0:length(force_temp)-1).'*dt; % time vector

%% Plot force template against samples and time
figure(2)
    subplot(211)
    plot(force_temp)
    ylabel('Acceleration [m/s^2]')
    xlabel('Samples')
    title('Force template against samples')
    subplot(212)
    plot(t_temp, force_temp);
    ylabel('Acceleration [m/s^2]')
    title('Force template against duration time')
    xlabel('Time [s]')

%% Integrating Start ref., Stop ref. and force template
close all

% PVA signal for start reference
ref_acc_start = ref_signal_start;
ref_vel_start = cumtrapz(t_ref_start,ref_acc_start); 
ref_dis_start = cumtrapz(t_ref_start,ref_vel_start);

% PVA signal for end reference
ref_acc_stop = ref_signal_stop;
ref_vel_stop = cumtrapz(t_ref_stop,ref_acc_stop); 
ref_dis_stop = cumtrapz(t_ref_stop,ref_vel_stop);

% PVA signal for force template
force_temp_acc = force_temp;
force_temp_vel = cumtrapz(t_temp,force_temp_acc);
force_temp_dis = cumtrapz(t_temp,force_temp_vel);

%% Plotting PVA signals

figure('name', 'PVA signals start ref., force template and stop ref.')
subplot(331)
    grid on;
    plot(t_ref_start,ref_acc_start)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Acc. signal start reference')
subplot(334)
    grid on;
    plot(t_ref_start,ref_vel_start)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Vel. signal start reference')
subplot(337)
    grid on;
    plot(t_ref_start,ref_dis_start)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Dis. signal start reference')
subplot(332)
    grid on;
    plot(t_temp,force_temp_acc)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Acc. signal force template')
subplot(335)
    grid on;
    plot(t_temp,force_temp_vel)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Vel. signal force template')
subplot(338)
    grid on;
    plot(t_temp,force_temp_dis)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Dis. signal force template')
subplot(333)
    grid on;
    plot(t_ref_stop,ref_acc_stop)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Acc. signal stop reference')
subplot(336)
    grid on;
    plot(t_ref_stop,ref_vel_stop)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Vel. signal stop reference')
subplot(339)
    grid on;
    plot(t_ref_stop,ref_dis_stop)
    %xlim([0 5+dt])
    xlabel('Time [s]')
    title('Dis. signal stop reference')
    suptitle('PVA signals for start reference, force template and stop reference')

%% Storing data
close all

save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/reference signal/force_template_025ms2.mat','force_temp_dis','force_temp_vel','force_temp_acc')
save('/Users/jellewalingdehaan/Documents/Universiteit/Delft/Master Biomedical Engineering/Jaar 2/Graduation project/matlab/PVA signal/PVA signals/final perturbation signals/reference signal/ref_start_stop_025ms2.mat','ref_dis_start','ref_vel_start','ref_acc_start','ref_dis_stop','ref_vel_stop','ref_acc_stop')
