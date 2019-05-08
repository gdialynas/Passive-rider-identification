clc
clear all

%% Conversion
% load your prepared signals in matlab
% position / Velocity / Acceleration for all directions
load('sway_pert_amp075')

%% Example for one direction
%%{
temp_data = [sway_dis_amp075, sway_vel_amp075, sway_acc_amp075]';
fileID = fopen('Jelle_sway_excitation_amp075.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}

%% Example for multi directions
%%{
%temp_data = [rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a]'; % array 18 signals
%temp_data = [rb3d, rb3v, rb3a]'; % array 18 signals
%fileID = fopen('Jelle_sway_excitation.dat','w');
%fileID = fopen('Jelle_multi_excitations.dat','w');
%fwrite(fileID,temp_data,'float32','ieee-le');
%fclose(fileID);
%}


%% Check signals
%%{
filename = 'Jelle_sway_excitation_amp075';
%filename = 'Jelle_multi_excitations';
header = loadSigRecHeader(filename);
data2 = loadSigRec(filename,header);

% Y (sway)
subplot(311)
    hold all;
    plot(data2(:,1))
    plot(temp_data(1,:),'b--')
    plot([0 length(temp_data(1,:))],[0.51 0.51],'r')
    plot([0 length(temp_data(1,:))],[-0.51 -0.51],'r')
    title('Sway Position Signal')
subplot(312)
    hold all;
    plot(data2(:,2))
    plot(temp_data(2,:),'b--')
    plot([0 length(temp_data(1,:))],[0.81 0.81],'r')
    plot([0 length(temp_data(1,:))],[-0.81 -0.81],'r')
    title('Sway Velocity Signal')
subplot(313)
    hold all;
    plot(data2(:,3))
    plot(temp_data(3,:),'b--')
    plot([0 length(temp_data(1,:))],[7.1 7.1],'r')
    plot([0 length(temp_data(1,:))],[-7.1 -7.1],'r')
    title('Sway Acceleration Signal')