function [y] = my_resample_function(u,p,q)

y = cell(1,24);

for i = 1:24
    sub = u{i};
    resample_sub = resample(sub,p,q);
    y{i} = resample_sub;
end