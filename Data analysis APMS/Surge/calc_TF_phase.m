function [wtf_phase_SP_Z] = calc_TF_phase(wtf)

[~,col]         = size(wtf);
wtf_phase_SP_Z  = NaN(size(wtf));

for i = 1:col
    wtf_phase_SP_Z_sub = angle(wtf(:,i))/(pi/180);
    wtf_phase_SP_Z(:,i) = wtf_phase_SP_Z_sub;
end

