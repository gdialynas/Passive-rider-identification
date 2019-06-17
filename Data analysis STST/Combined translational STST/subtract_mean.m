function [y] = subtract_mean(u)

[~,col] = size(u);
y = NaN(size(u));

for i = 1:col
   mean_sub = mean(u(:,i));
   scaled_sub = u(:,i)-mean_sub;
   y(:,i) = scaled_sub;
end
