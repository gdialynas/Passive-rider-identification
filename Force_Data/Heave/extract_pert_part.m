function [y] = extract_pert_part(u)

[~, col]    = size(u);
pert_part_24subs = NaN(6000,312); 

for i = 1:col
    sub = u{i};
    pert_part = sub(502:6501);
    pert_part_24subs(:,i) = pert_part; 
end

SP_X          = pert_part_24subs(:,[1:24]);
SP_Y          = pert_part_24subs(:,[25:48]);
SP_Z          = pert_part_24subs(:,[49:72]);

FPL_X         = pert_part_24subs(:,[73:96]);
FPL_Z         = pert_part_24subs(:,[97:120]);

FPR_X         = pert_part_24subs(:,[121:144]);
FPR_Z         = pert_part_24subs(:,[145:168]);

HBL_X         = pert_part_24subs(:,[169:192]);
HBL_Y         = pert_part_24subs(:,[193:216]);
HBL_Z         = pert_part_24subs(:,[217:240]);

HBR_X         = pert_part_24subs(:,[241:264]);
HBR_Y         = pert_part_24subs(:,[265:288]);
HBR_Z         = pert_part_24subs(:,[289:312]);

y =     {   SP_X, SP_Y, SP_Z,...
            FPL_X, FPL_Z,... 
            FPR_X, FPR_Z,...
            HBL_X, HBL_Y, HBL_Z,... 
            HBR_X, HBR_Y, HBR_Z};