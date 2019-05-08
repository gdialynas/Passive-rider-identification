clear all 
close all
clc

%%

N = 6000;
Nsegment = 10;      % number of segment over which is averaged

%wSuu_Acc_Y          = welchspectrum(u_GR_sway_acc,u_GR_sway_acc,Nsegment);
nfft=round(N/Nsegment);

%% 

wvtool(hann(nfft))

figure()
plot(hann(nfft))
set(gca,'FontSize',20)
xlabel('Samples')
ylabel('Amplitude')
title('Hanning Window')

%%
T       = 60;           % observation time. 
fs      = 100;          % samplin frequency
dt      = 1/fs;         % sample duration
N       = T*fs;         % number of samples in signal
t       = (0:N-1).'*dt; % time vector
t1      = (0:nfft-1).'*dt; 
T1      = 60/Nsegment;

w = 0.5*(1-cos((2*pi*t1)/T1));

figure
plot(t1,w)