TLX1 = xlsread('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\General\Subjective data\Nasaboxplot\Nasa.xlsx','C2:H25');
figure('name','Boxplot of NASA TLX','numbertitle','off');hold on    
hlc=notBoxPlot(TLX1,'style','patch','markMedian',true);
ylabel('Score(%)') 
set(gca,'XTick',[1:6],'XTickLabel',{'Mental demand','Physical demand','Temporal demand','Performance','Effort','Frustration'});
h=findobj('FontName','Helvetica'); set(h,'FontSize',18.5,'Fontname','Arial')
hold on
index = [2 12 19:24];
for ii = 1:6
xhl(:,ii) = hlc(ii).data.XData(index);
yhl(:,ii) = hlc(ii).data.YData(index);
end
hold on
index = [2 12 19:24];
for ii = 1:6
xhl(:,ii) = hlc(ii).data.XData(index);
yhl(:,ii) = hlc(ii).data.YData(index);
end
plot(xhl,yhl,'k.','markersize',18.5);
%% Coorelation of performance and effort (linear fitting)
performance=TLX1(:,4);
effort=TLX1(:,5);
% First cluster
x1=effort([1 3:11 13:18]);
y1=performance([1 3:11 13:18]);
% Second cluster
x2=effort([2 12 19:24]);
y2=performance([2 12 19:24]);
% Correletion coefficients
R1 = corrcoef(x1,y1);
R2 = corrcoef(x2,y2);
coef1=(R1(2,1));
coef2=(R2(2,1));

% Correletion between performance and effort scales of NASA TLX

figure
subplot(3,1,1) 
plot(effort,performance,'o');
hold on
plot(effort(5:5),performance(5:5),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(effort(7:7),performance(7:7),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(effort(10:10),performance(10:10),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(effort(11:11),performance(11:11),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(effort(13:13),performance(13:13),'o','MarkerEdgeColor','g','MarkerSize',12);
P = polyfit(effort,performance,1);
yfit = P(1)*effort+P(2);
hold on;
plot(effort,yfit,'r');
ylabel('Performance (%)');
hold off

subplot(3,1,2);
plot(x1,y1,'o');
% x1=zscore(x1); % normalization to get the correletion coefficient
% y1=zscore(y1);
hold on
P1 = polyfit(x1,y1,1);
yfit1 = P(1)*x1+P(2);
coefficient1=polyfit(x1,y1,1);
a1=coefficient1(1);
b1=coefficient1(2);
yfit1=a1*x1+b1;
y= ['y = ' num2str(a1) 'x+ ' num2str(b1) ''];
plot(x1,yfit1,'r-');
plot(x1(4:4),y1(4:4),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(x1(5:5),y1(5:5),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(x1(10:10),y1(10:10),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(x1(11:11),y1(11:11),'o','MarkerEdgeColor','g','MarkerSize',12);
plot(x1(12:12),y1(12:12),'o','MarkerEdgeColor','g','MarkerSize',12);
legend('1st Data cluster',y);
xlim([0 40])
ylabel('Performance (%)');

subplot(3,1,3);
plot(x2,y2,'o');
% x2=zscore(x2); % normalization to get the correletion coefficient
% y2=zscore(y2);
xlim([35 90])
hold on
coefficient2=polyfit(x2,y2,1);
a2=coefficient2(1);
b2=coefficient2(2);
yfit2=a2*x2+b2;
y= ['y = ' num2str(a2) 'x+ ' num2str(b2) ''];
plot(x2,yfit2,'r-');
legend('2nd Data cluster',y);
ylabel('Performance (%)');
xlabel('Effort (%)');
h=findobj('FontName','Helvetica'); set(h,'FontSize',16.5,'Fontname','Arial')






