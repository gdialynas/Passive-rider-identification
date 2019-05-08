function [y] = solve_seatpost_inclination(u)

inclination_SP = 28*(pi/180); % radians

SP_X = u{1};
y_SP_X   = NaN(size(SP_X));

for i = 1:24
    SP_X_sub = SP_X(:,i);
    SP_X_sub_scaled = SP_X_sub.*cos(inclination_SP);
    y_SP_X(:,i) = SP_X_sub_scaled;
end

SP_Z = u{3}; 
y_SP_Z   = NaN(size(SP_Z));

for i = 1:24
    SP_Z_sub = SP_Z(:,i);
    SP_Z_sub_scaled = SP_Z_sub.*cos(inclination_SP);
    y_SP_Z(:,i) = SP_Z_sub_scaled;
end

y = {   y_SP_X, u{2}, y_SP_Z,...
        u{4}, u{5},...
        u{6}, u{7},...
        u{8}, u{9}, u{10},...
        u{11}, u{12}, u{13}};
        
        