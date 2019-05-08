function [y] = phase_scaling(u)

u_scaled = NaN(size(u));

for i = 1:24
    u_sub = u(:,i);
    first_element = u_sub(1,1);
    if first_element == 180
        first_element_scaled = first_element - 180;
        u_sub_scaled = [first_element_scaled;u_sub(2:end)]; 
    else
        u_sub_scaled = u_sub;
    end 
        u_scaled(:,i) = u_sub_scaled;
end

y = u_scaled;