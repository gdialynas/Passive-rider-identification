function [y] = extract_pert_part_IMU(u)

y = NaN(6000,24); 

for i = 1:24
    sub = u{i};
    pert_part = sub(502:6501);
    y(:,i) = pert_part; 
end
