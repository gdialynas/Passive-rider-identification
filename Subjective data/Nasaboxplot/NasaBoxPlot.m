TLX1 = xlsread('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\General\Subjective data\Nasaboxplot\Nasa.xlsx','C2:H25');
TLX_Feedback1=TLX1(1:24,:);
figure('name','Boxplot of NASA TLX','numbertitle','off');hold on    
hlc=notBoxPlot(TLX_Feedback1,'style','patch','markMedian',true);
ylabel('Score(%)') 
set(gca,'XTick',[1:6],'XTickLabel',{'Mental demand','Physical demand','Temporal demand','Performance','Effort','Frustration'});
h=findobj('FontName','Helvetica'); set(h,'FontSize',18.5,'Fontname','Arial')
hold on
index = [2 12 19:24];
for ii = 1:6
xhl(:,ii) = hlc(ii).data.XData(index);
yhl(:,ii) = hlc(ii).data.YData(index);
end
plot(xhl,yhl,'k.','markersize',18.5);
%% Coorelation of performance and effort (linear fitting)
performance=TLX_Feedback1(:,4);
effort=TLX_Feedback1(:,5);
plot(effort,performance,'o');
p = polyfit(effort,performance,1);
f = polyval(p,performance);
hold on
plot(performance,f,'--r');
ylabel('Performance(%)');
xlabel('Effort(%)');
h=findobj('FontName','Helvetica'); set(h,'FontSize',18.5,'Fontname','Arial')
%% Correletion betwwen performance and effort scales of NASA TLX
%first cluster
x1=effort([1 3:11 19:24]);
y1=performance([1 3:11 19:24]);
%second cluster
x2=effort([2 12 19:24]);
y2=performance([2 12 19:24]);
%Correletion coefficients
R1 = corrcoef(x1,y1);
R2 = corrcoef(x2,y2);
coef1=(R1(2,1));
coef2=(R2(2,1));





