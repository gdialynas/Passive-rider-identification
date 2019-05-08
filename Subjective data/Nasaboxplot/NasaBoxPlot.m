TLX = xlsread('D:\gdialynas\Desktop\My files\Passive rider project\Jelle_de_hann_final\General\Subjective data\Nasaboxplot\Nasa TLX.xlsx','C2:H25');
TLX_Feedback=TLX(1:24,:);
figure('name','Boxplot of NASA TLX','numbertitle','off');hold on    
hlc=notBoxPlot(TLX_Feedback,'style','patch','markMedian',true);
ylabel('Score(%)') 
set(gca,'XTick',[1:6],'XTickLabel',{'Mental demand','Physical demand','Temporal demand','Performance','Effort','Frustration'});
h=findobj('FontName','Helvetica'); set(h,'FontSize',18.5,'Fontname','Arial')
