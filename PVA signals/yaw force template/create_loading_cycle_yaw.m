clc
clear all

%% Conversion
% load your prepared signals in matlab
% position / Velocity / Acceleration for all directions
load('force_template_025ms2')

%% Example for one direction
%%{
temp_data = [force_temp_dis, force_temp_vel, force_temp_acc]';
fileID = fopen('Jelle_yaw_force_temp_025ms2.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}

%% Example for multi directions
%%{
%temp_data = [rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a]'; % array 18 signals
%temp_data = [rb3d, rb3v, rb3a]'; % array 18 signals
%fileID = fopen('Jelle_yaw_excitation.dat','w');
%fileID = fopen('Jelle_multi_excitations.dat','w');
%fwrite(fileID,temp_data,'float32','ieee-le');
%fclose(fileID);
%}


%% Check signals
%%{
filename = 'Jelle_yaw_force_temp_025ms2';
%filename = 'Jelle_multi_excitations';
header = loadSigRecHeader(filename);
data2 = loadSigRec(filename,header);

%%{
figure(1);
% R (yaw) position
subplot(311)
    hold all;
    plot(data2(:,1))
    plot(temp_data(1,:),'b--')
    plot([0 length(temp_data(1,:))],[25.0 25.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-25.0 -25.0]./180.*pi,'r')
    title('Yaw position signal')
% R (yaw)
subplot(312)
    hold all;
    plot(data2(:,2))
    plot(temp_data(2,:),'b--')
    plot([0 length(temp_data(1,:))],[41.0 41.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-41.0 -41.0]./180.*pi,'r')
    title('Yaw velocity signal')
% R (yaw)
subplot(313)
    hold all;
    plot(data2(:,3))
    plot(temp_data(3,:),'b--')
    plot([0 length(temp_data(1,:))],[510.0 510.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-510.0 -510.0]./180.*pi,'r')
    title('Yaw acceleration signal')
%}