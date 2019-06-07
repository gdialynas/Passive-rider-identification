function [y] = my_phase_unwrap(u)

[~,col] = size(u);
phase_scaled = NaN(size(u));

for i = 1:col
    phase_sub = u(:,i);
    third_element_sub  = phase_sub(3);
    if third_element_sub > 0 
        phase_sub_scaled = phase_sub - 360;
    else
        phase_sub_scaled = phase_sub;
    end
        phase_scaled(:,i) = phase_sub_scaled;
end

y = phase_scaled;
    


    