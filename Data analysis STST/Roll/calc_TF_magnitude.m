function [wtf_mag] = calc_TF_magnitude(wtf)

[~,col] = size(wtf);
wtf_mag = NaN(size(wtf));

for i = 1:col
    wtf_mag_sub  = abs(wtf(:,i));
    wtf_mag(:,i) = wtf_mag_sub;
end