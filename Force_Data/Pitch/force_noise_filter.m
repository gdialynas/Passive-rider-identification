function [y] = force_noise_filter(u)

u       = cell2mat(u);
[~,col] = size(u);
u_filt  = NaN(size(u));

% filter characteristics
fs    = 100;
Fnorm = 13/(fs/2);           % Normalized frequency
df    = designfilt('lowpassfir','FilterOrder',70,'CutoffFrequency',Fnorm);

% calculate delay as result of filtering
D = mean(grpdelay(df)) ; % filter delay in samples

% filtering
for i = 1:col
    sub_filt    = filter(df,[u(:,i); zeros(D,1)]); % Append D zeros to the input data
    u_filt(:,i) = sub_filt(D+1:end);
end

SP_X          = u_filt(:,[1:24]);
SP_Y          = u_filt(:,[25:48]);
SP_Z          = u_filt(:,[49:72]);

FPL_X         = u_filt(:,[73:96]);
FPL_Z         = u_filt(:,[97:120]);

FPR_X         = u_filt(:,[121:144]);
FPR_Z         = u_filt(:,[145:168]);

HBL_X         = u_filt(:,[169:192]);
HBL_Y         = u_filt(:,[193:216]);
HBL_Z         = u_filt(:,[217:240]);

HBR_X         = u_filt(:,[241:264]);
HBR_Y         = u_filt(:,[265:288]);
HBR_Z         = u_filt(:,[289:312]);

y =     {   SP_X, SP_Y, SP_Z,...
            FPL_X, FPL_Z,... 
            FPR_X, FPR_Z,...
            HBL_X, HBL_Y, HBL_Z,... 
            HBR_X, HBR_Y, HBR_Z};
        