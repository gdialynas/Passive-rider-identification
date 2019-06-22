
function [mean_avg,std_avg]=averagePhase(wtf_SP)


x_angles=angle(wtf_SP);
x_c=zeros(size(x_angles,1),1);
y_c=zeros(size(x_angles,1),1);

for ii=1:size(x_angles,2)
  x_c  = x_c  + cos(x_angles(:,ii));
  y_c  = y_c  + sin(x_angles(:,ii));
end
x_c=x_c/size(x_angles,2);
y_c=y_c/size(x_angles,2);

stddev=sqrt(-log(abs(x_c.*x_c+y_c.*y_c)));
std_avg=stddev*180/pi;
std_avg=std_avg.';
x_m=mean(wtf_SP,2);
mean_angle=angle(x_m);

% std_angles=zeros(length(wtf_SP),2);
% for ii=1:length(x_m)
%   if std_imag(ii)==0
%     std_angles(ii,:)= [ mean_angle(ii) mean_angle(ii)];
%     continue
%   end
%   std_angles(ii,:) = findEllipseTangent(x_m(ii),std_real(ii),std_imag(ii));
% end


mean_avg = unwrap(mean_angle)*180/pi;
mean_avg = mean_avg.';
%std_avg = unwrap(std_angles)*180/pi;


end