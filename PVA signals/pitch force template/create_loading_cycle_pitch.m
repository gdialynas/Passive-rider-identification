clc
clear all

%% Conversion
% load your prepared signals in matlab
% position / Velocity / Acceleration for all directions
load('force_template_025ms2')

%% Example for one direction
%%{
temp_data = [force_temp_dis, force_temp_vel, force_temp_acc]';
fileID = fopen('Jelle_pitch_force_temp_025ms2.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}

%% Example for multi directions
%%{
%temp_data = [rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a]'; % array 18 signals
%temp_data = [rb3d, rb3v, rb3a]'; % array 18 signals
%fileID = fopen('Jelle_pitch_excitation.dat','w');
%fileID = fopen('Jelle_multi_excitations.dat','w');
%fwrite(fileID,temp_data,'float32','ieee-le');
%fclose(fileID);
%}


%% Check signals
%%{
filename = 'Jelle_pitch_force_temp_025ms2';
%filename = 'Jelle_multi_excitations';
header = loadSigRecHeader(filename);
data2 = loadSigRec(filename,header);

%%{
figure(1);
% Q (pitch) position
subplot(311)
    hold all;
    plot(data2(:,1))
    plot(temp_data(1,:),'b--')
    plot([0 length(temp_data(1,:))],[28.4 28.4]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-25.4 -25.4]./180.*pi,'r')
    title('Pitch position signal')
% Q (pitch) velocity
subplot(312)
    hold all;
    plot(data2(:,2))
    plot(temp_data(2,:),'b--')
    plot([0 length(temp_data(1,:))],[38.0 38.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-38.0 -38.0]./180.*pi,'r')
    title('Pitch velocity signal')
% Q (pitch) acceleration
subplot(313)
    hold all;
    plot(data2(:,3))
    plot(temp_data(3,:),'b--')
    plot([0 length(temp_data(1,:))],[260.0 260.0]./180.*pi,'r')
    plot([0 length(temp_data(1,:))],[-260.0 -260.0]./180.*pi,'r')
    title('Pitch acceleration signal')