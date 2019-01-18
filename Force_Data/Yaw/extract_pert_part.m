function [y] = extract_pert_part(u)

[~, col]    = size(u);
pert_part_24subs = NaN(6000,312); 

for i = 1:col
    sub = u{i};
    pert_part = sub(502:6501);
    pert_part_24subs(:,i) = pert_part; 
end

y = pert_part_24subs;