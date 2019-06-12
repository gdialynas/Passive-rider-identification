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
xhl(:,ii) = hlc(ii).data.XData(index)
yhl(:,ii) = hlc(ii).data.YData(index)
end
plot(xhl,yhl,'k.','markersize',18.5)
%% Cross-correletion betwwen performance and effort scales of NASA TLX
a=zeros(1, 24);
b=zeros(1, 24);
for i=1:24
y=TLX_Feedback1(i:i,4);
x=TLX_Feedback1(i:i,5);
[cor_seq1, lags]=xcorr(x,y);
acor_norm = x/sqrt(sum(abs(x).^2)*sum(abs(y).^2));%normalized cross correlation
[a(i), b(i)] = max_one(lags, acor_norm.');
hold on
bar(b)
ylabel('Normalized Correletion |r|');
end

%% Coorelation of performance and effort (linear fitting)
performance=TLX_Feedback1(:,4);
effort=TLX_Feedback1(:,5);
plot(performance,effort,'o');
p = polyfit(performance,effort,1);
f = polyval(p,performance);
hold on
plot(performance,f,'--r');
ylabel('Performance(%)');
xlabel('Effort(%)');
