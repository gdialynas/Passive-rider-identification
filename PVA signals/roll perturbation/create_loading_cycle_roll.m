clc
clear all

%% Conversion
% load your prepared signals in matlab
% position / Velocity / Acceleration for all directions
load('roll_pert_amp1')

%% Example for one direction
%%{
temp_data = [roll_dis_amp1, roll_vel_amp1, roll_acc_amp1]';
fileID = fopen('Jelle_roll_excitation_amp1.dat','w');
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


%% Check signals
%%{
filename = 'Jelle_roll_excitation_amp1';
%filename = 'Jelle_multi_excitations';
header = loadSigRecHeader(filename);
data2 = loadSigRec(filename,header);

%%{
figure(1);
% P (roll) position
subplot(311)
    hold all;
    plot(data2(:,1))
    plot(temp_data(1,:),'b--')
    plot([0 length(temp_data(1,:))],[24.3 24.3]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-24.3 -24.3]./180.*pi,'r')
    title('Roll Position Signal')
% P (roll) velocity
subplot(312)
    hold all;
    plot(data2(:,2))
    plot(temp_data(2,:),'b--')
    plot([0 length(temp_data(1,:))],[35.0 35.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-35.0 -35.0]./180.*pi,'r')
    title('Roll Velocity Signal')
% P (roll) acceleration
subplot(313)
    hold all;
    plot(data2(:,3))
    plot(temp_data(3,:),'b--')
    plot([0 length(temp_data(1,:))],[260.0 260.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-260.0 -260.0]./180.*pi,'r')
    title('Roll Acceleration Signal')
%}