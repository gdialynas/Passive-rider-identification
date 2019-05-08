clc
clear all

%% Conversion
% load your prepared signals in matlab
% position / Velocity / Acceleration for all directions
load('force_template_025ms2') %SIGNALEN ZIJN PRECIES HETZELFDE DUS GEBRUIK GEWOON DE heave075

%% Example for one direction
%%{
temp_data = [force_temp_dis, force_temp_vel, force_temp_acc]';
fileID = fopen('Jelle_heave_force_temp_025ms2.dat','w');
fwrite(fileID,temp_data,'float32','ieee-le');
fclose(fileID);
%}

%% Example for multi directions
%%{
%temp_data = [rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a, rb3d, rb3v, rb3a]'; % array 18 signals
%temp_data = [rb3d, rb3v, rb3a]'; % array 18 signals
%fileID = fopen('Jelle_heave_excitation.dat','w');
%fileID = fopen('Jelle_multi_excitations.dat','w');
%fwrite(fileID,temp_data,'float32','ieee-le');
%fclose(fileID);
%}


%% Check signals
%%{
filename = 'Jelle_heave_force_temp_025ms2';
%filename = 'Jelle_multi_excitations';
header = loadSigRecHeader(filename);
data2 = loadSigRec(filename,header);

%%{
figure(1);
% Z (heave) position
subplot(311)
    hold all;
    plot(data2(:,1))
    plot(temp_data(1,:),'b--')
    plot([0 length(temp_data(1,:))],[0.42 0.42],'r')
    plot([0 length(temp_data(1,:))],[-0.42 -0.42],'r')
    title('Heave Position Signal')
% Z (heave) velocity
subplot(312)
    hold all;
    plot(data2(:,2))
    plot(temp_data(2,:),'b--')
    plot([0 length(temp_data(1,:))],[0.61 0.61],'r')
    plot([0 length(temp_data(1,:))],[-0.61 -0.61],'r')
    title('Heave Velocity Signal')
% Z (heave) acceleration
subplot(313)
    hold all;
    plot(data2(:,3))
    plot(temp_data(3,:),'b--')
    plot([0 length(temp_data(1,:))],[10.0 10.0],'r')
    plot([0 length(temp_data(1,:))],[-10.0 -10.0],'r')
    title('Heave Acceleration Signal')
%}