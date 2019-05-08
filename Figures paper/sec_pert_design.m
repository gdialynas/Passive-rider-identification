close all
clc

load('roll_pert_amp1.mat');
load('heave_pert_amp1.mat');

%% Signal parameters

T       = 60;           % observation time. 
fs      = 100;          % samplin frequency
dt      = 1/fs;         % sample duration
N       = T*fs;         % number of samples in signal
t       = (0:N-1).'*dt; % time vector

roll = roll_acc_amp1(502:6501);
heave = heave_acc_amp1(502:6501);

figure(1)
plot(t,roll)
set(gca,'FontSize',20)

figure(1)
plot(t,heave)
set(gca,'FontSize',20)

%% Design perturbation signals
close all

% mean value of whithe noise signal. Need to be specified.
mu_roll      = 0; 
mu_heave     = 0; 

% standard deviation = measure for amplitude. A max. amplitude of 1.0 m/s^2
% is chosen since this gives the best FRF for the roll motion within a
% frequency range of 0 - 10 Hz.
max_amp_roll = 1; %m/s^2
sigma_roll   = max_amp_roll/3; %STD of signal

max_amp_heave = 1; %m/s^2
sigma_heave   = max_amp_heave/3; %STD of signal

% frequency vector
fv  = (0:1/T:fs-(1/T))';

ROLL = fft(roll);
HEAVE = fft(heave);

U_roll_acc = fft(detrend(roll));
U_roll_acc = U_roll_acc.*conj(U_roll_acc);

U_heave_acc = fft(detrend(heave));
U_heave_acc = U_heave_acc.*conj(U_heave_acc);

% figure();
% set(gca,'FontSize',20)
% subplot(311)
%     hold all;
%     plot(t,roll); box off; 
%     plot(t,max_amp_roll*ones(size(t)),'r') 
%     plot(t,-max_amp_roll*ones(size(t)),'r') 
%     xlabel('Time [s]')
%     ylabel('Acceleration [rad/s^2]')
%     title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
%     set(gca,'FontSize',15)
%     lgd = legend('Roll acc.','(-)3\sigma_{pert}');
%     lgd.FontSize = 12;
% subplot(312)
%     %plot(fv(1:N/2),abs(ROLL(1:N/2)))                       % normal scale abs(FFT) 
%     loglog(fv(1:N/2),U_roll_acc(1:N/2)); box off; grid on;  % loglog PSD
%     %plot(fv(1:N/2),U_roll_acc(1:N/2)); box off             % normal scale PSD
%     %xlim([0 12]);
%     xlabel('Frequency [Hz]')
%     ylabel('Magnitude [(rad/s^2)^2/Hz]')
%     %title('Frequency spectrum')
%     title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
%     set(gca,'FontSize',15)
% subplot(313)
%     histfit(roll); box off
%     xlabel('Acceleration [rad/s^2]')
%     ylabel('Samples')
%     title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.45, 0]); % Set Title with correct Position
%     %title(['\mu_{pert}=', num2str(mean(roll)),' \sigma_{pert}=', num2str(rms(roll))])
%     %lgd = legend(['\mu_{pert}=', num2str(mean(roll)),' \sigma_{pert}=', num2str(rms(roll))]);
%     str = {['\mu_{pert}=', num2str(mean(roll))],['\sigma_{pert}=', num2str(rms(roll))]};
%     text(1,200,str,'FontSize',20)
%     set(gca,'FontSize',15)

figure();
set(gca,'FontSize',20)
subplot(311)
    hold all;
    plot(t,heave,'color',[0 0.4470 0.7410]);
    plot(t,max_amp_heave*ones(size(t)),'r') 
    plot(t,-max_amp_heave*ones(size(t)),'r') 
    xlabel('Time [s]')
    ylabel('Acceleration [m/s^2]')
    ylim([-1.5 1.5])
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.44, 0]); % Set Title with correct Position
    set(gca,'FontSize',15)
    lgd = legend('Heave acc.','(-)3\sigma_{pert}');
    lgd.FontSize = 12;
subplot(312)
    %plot(fv(1:N/2),abs(HEAVE(1:N/2)))                       % normal scale abs(FFT) 
    %loglog(fv(1:N/2),U_heave_acc(1:N/2)); box off; grid on;  % loglog PSD
    bar(fv(1:N/2),U_heave_acc(1:N/2)); box off             % normal scale PSD
    %xlim([0 12]);
    xlabel('Frequency [Hz]')
    xlim([0 12])
    ylim([0 43000])
    ylabel('PSD [(m/s^2)^2/Hz]')
    %title('Frequency spectrum')
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.44, 0]); % Set Title with correct Position
    set(gca,'FontSize',15)
subplot(313)
    histfit(heave); box off
    xlabel('Acceleration [m/s^2]')
    ylabel('Samples')
    xlim([-1.3 1.3])
    ylim([0 250])
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.48, 0]); % Set Title with correct Position
    %title(['\mu_{pert}=', num2str(mean(roll)),' \sigma_{pert}=', num2str(rms(roll))])
    %lgd = legend(['\mu_{pert}=', num2str(mean(roll)),' \sigma_{pert}=', num2str(rms(roll))]);
    str = {['\mu_{pert}=', num2str(mean(heave))],['\sigma_{pert}=', num2str(rms(heave))]};
    text(0.95,180,str,'FontSize',20)
    set(gca,'FontSize',15)
    
%% Designing high pass filter for drift reduction/cancelation
close all

% As a resutl of integration the position signal shows drift. The solve for
% this the signal should be high filtered with a very low cutoff frequency
% in order to prevent drift and to maintain high power is low frequencies.

% defining high cutoff frequency
fc_high = 0.2;

% 2nd order butterworth filter
[d,c] = butter(2,fc_high/(fs/2),'high');

figure(1)
    freqz(d,c);

figure(2)
    H_high = freqz(d,c,floor(N/2));
    hold on;
    plot([0:1/(N/2-1):1],abs(H_high),'r','LineWidth',2);
    xlabel('Normalized frequency (x \pi rad/sample)')
    ylabel('Magnitude [-]')
    %title('Filter characteristics')
    set(gca,'FontSize',20)
    
%%
T1 = 69.02;
N1 = 6902;
t1       = (0:N1-1).'*dt; % time vector

figure()
subplot(211)
hold on
plot(t1,roll_acc_amp1)
plot(t1,max_amp_roll*ones(size(t1)),'r') 
plot(t1,-max_amp_roll*ones(size(t1)),'r')
xlim([0 T1])
xlabel('Time [s]')
ylabel('Acceleration [rad/s^2]')
lgd = legend('Roll acc.','(-)3\sigma_{pert}');
set(gca,'FontSize',20)
subplot(212)

figure()
subplot(211)
hold on
plot(t1,heave_acc_amp1)
plot(t1,max_amp_heave*ones(size(t1)),'r') 
plot(t1,-max_amp_heave*ones(size(t1)),'r')
xlim([0 T1])
xlabel('Time [s]')
ylabel('Acceleration [m/s^2]')
lgd = legend('Heave acc.','(-)3\sigma_{pert}');
set(gca,'FontSize',20)
subplot(212)

%% Example for one direction
close all 
%%{
temp_data = [roll_dis_amp1, roll_vel_amp1, roll_acc_amp1]';
fileID = fopen('Jelle_roll_excitation_amp1.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}

%%{
temp_data = [heave_dis_amp1, heave_vel_amp1, heave_acc_amp1]';
fileID = fopen('Jelle_heave_excitation_amp1.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}
%% Example for multi directions
%%{
%temp_data = [rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a]'; % array 18 signals
%temp_data = [rb3d, rb3v, rb3a]'; % array 18 signals
%fileID = fopen('Jelle_roll_excitation.dat','w');
%fileID = fopen('Jelle_multi_excitations.dat','w');
%fwrite(fileID,temp_data,'float32','ieee-le');
%fclose(fileID);
%}

%% PVA signals roll and heave
%%{
filename_roll = 'Jelle_roll_excitation_amp1';
%filename_roll = 'Jelle_multi_excitations';
header_roll = loadSigRecHeader(filename_roll);
data2_roll = loadSigRec(filename_roll,header_roll);
%%{
figure(1);
% P (roll) position
subplot(311)
    hold all;
    plot(t1,data2_roll(:,1))
    %plot(t1,temp_data(1,:),'b--')
    %plot(t1,24.3*ones(size(t1))./180.*pi,'r')
    %plot(t1,-24.3*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Angle (rad)')
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Position')
    set(gca,'FontSize',17)
% P (roll) velocity
subplot(312)
    hold all;
    plot(t1,data2_roll(:,2))
    %plot(t1,temp_data(2,:),'b--')
    %plot(t1,35.0*ones(size(t1))./180.*pi,'r')
    %plot(t1,-35.0*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Velocity (rad/s)')
    %title('Velocity')
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    set(gca,'FontSize',17)
% P (roll) acceleration
subplot(313)
    hold all;
    plot(t1,data2_roll(:,3))
    %plot(t1,temp_data(3,:),'b--')
    %plot(t1,260*ones(size(t1))./180.*pi,'r')
    %plot(t1,-260*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Acceleration (rad/s^2)')
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Acceleration')
    set(gca,'FontSize',17)
%}

%%{
filename_heave = 'Jelle_heave_excitation_amp1';
%filename_heave = 'Jelle_multi_excitations';
header_heave = loadSigRecHeader(filename_heave);
data2_heave = loadSigRec(filename_heave,header_heave);
%%{
figure(2);
% P (heave) position
subplot(311)
    hold all;
    plot(t1,data2_heave(:,1))
    %plot(t1,temp_data(1,:),'b--')
    %plot(t1,24.3*ones(size(t1))./180.*pi,'r')
    %plot(t1,-24.3*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Position (m)')
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Position')
    set(gca,'FontSize',17)
% P (heave) velocity
subplot(312)
    hold all;
    plot(t1,data2_heave(:,2))
    %plot(t1,temp_data(2,:),'b--')
    %plot(t1,35.0*ones(size(t1))./180.*pi,'r')
    %plot(t1,-35.0*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Velocity (m/s)')
    %title('Velocity')
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    set(gca,'FontSize',17)
% P (heave) acceleration
subplot(313)
    hold all;
    plot(t1,data2_heave(:,3))
    %plot(t1,temp_data(3,:),'b--')
    %plot(t1,260*ones(size(t1))./180.*pi,'r')
    %plot(t1,-260*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Acceleration (m/s^2)')
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Acceleration')
    set(gca,'FontSize',17)
%}

%% PVA signals roll and heave
%%{
filename_roll = 'Jelle_roll_excitation_amp1';
%filename_roll = 'Jelle_multi_excitations';
header_roll = loadSigRecHeader(filename_roll);
data2_roll = loadSigRec(filename_roll,header_roll);
%%{

%%{
filename_heave = 'Jelle_heave_excitation_amp1';
%filename_heave = 'Jelle_multi_excitations';
header_heave = loadSigRecHeader(filename_heave);
data2_heave = loadSigRec(filename_heave,header_heave);
%%{

figure(2);
% P (heave) position
subplot(321)
    hold all;
    plot(t1,data2_heave(:,1))
    %plot(t1,temp_data(1,:),'b--')
    %plot(t1,24.3*ones(size(t1))./180.*pi,'r')
    %plot(t1,-24.3*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    %xlabel('Time [s]');
    ylabel('Position (m)')
    title('(a)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position
    %title('Position')
    set(gca,'FontSize',17)
% P (heave) velocity
subplot(323)
    hold all;
    plot(t1,data2_heave(:,2))
    %plot(t1,temp_data(2,:),'b--')
    %plot(t1,35.0*ones(size(t1))./180.*pi,'r')
    %plot(t1,-35.0*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    ylim([-0.2 0.2])
    %xlabel('Time [s]');
    ylabel('Velocity (m/s)')
    %title('Velocity')
    title('(b)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position
    set(gca,'FontSize',17)
% P (heave) acceleration
subplot(325)
    hold all;
    plot(t1,data2_heave(:,3))
    %plot(t1,temp_data(3,:),'b--')
    %plot(t1,260*ones(size(t1))./180.*pi,'r')
    %plot(t1,-260*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Acceleration (m/s^2)')
    title('(c)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Acceleration')
    set(gca,'FontSize',17)
% P (roll) position
subplot(322)
    hold all;
    plot(t1,data2_roll(:,1))
    %plot(t1,temp_data(1,:),'b--')
    %plot(t1,24.3*ones(size(t1))./180.*pi,'r')
    %plot(t1,-24.3*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    %xlabel('Time [s]');
    ylabel('Angle (rad)')
    title('(d)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position
    %title('Position')
    set(gca,'FontSize',17)
% P (roll) velocity
subplot(324)
    hold all;
    plot(t1,data2_roll(:,2))
    %plot(t1,temp_data(2,:),'b--')
    %plot(t1,35.0*ones(size(t1))./180.*pi,'r')
    %plot(t1,-35.0*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    %xlabel('Time [s]');
    ylabel('Velocity (rad/s)')
    %title('Velocity')
    title('(e)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.3, 0]); % Set Title with correct Position
    set(gca,'FontSize',17)
% P (roll) acceleration
subplot(326)
    hold all;
    plot(t1,data2_roll(:,3))
    %plot(t1,temp_data(3,:),'b--')
    %plot(t1,260*ones(size(t1))./180.*pi,'r')
    %plot(t1,-260*ones(size(t1))./180.*pi,'r')
    xlim([0 T1])
    xlabel('Time [s]');
    ylabel('Acceleration (rad/s^2)')
    title('(f)','FontWeight','Normal', 'Units', 'normalized', 'Position', [0.5, -0.4, 0]); % Set Title with correct Position
    %title('Acceleration')
    set(gca,'FontSize',17)
%}


