function hist_lxy(subv,meanv,figpath,figtitle)

hfig=figure;
tmp=get(gcf,'Position');
set(gcf,'Position', [50, tmp(2) ,tmp(4)*2, tmp(4)*0.9]);
if size(subv,2)==1
    histdata = histogram(subv,10);
    hold on;
    y=1:1:max(histdata.Values);
    x=repmat(meanv,length(y),1);
    plot(x,y,'LineWidth',3,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10)
else
    histdata1 = histogram(subv(:,1),10,'Normalization','pdf','FaceColor','r','FaceAlpha',0.5);
    fitdata1 = fitdist(subv(:,1),'Normal');
    hold on;
    histdata2 = histogram(subv(:,2),10,'Normalization','pdf','FaceColor','b','FaceAlpha',0.5);
    fitdata2 = fitdist(subv(:,2),'Normal');
    
    x_values=min([histdata1.BinLimits,histdata2.BinLimits]):0.01:max([histdata1.BinLimits,histdata2.BinLimits]);
    dpdf1 = pdf(fitdata1,x_values);
    dpdf2 = pdf(fitdata2,x_values);
    plot(x_values,dpdf1,'LineWidth',2)
    plot(x_values,dpdf2,'Color','r','LineStyle',':','LineWidth',2)
    legend(gn,'Location','NorthEast')
    
    hold off

    y=1:1:max(histdata1.Values);
    x=repmat(meanv(i),length(y),1);
    plot(x,y,'LineWidth',3,...
        'MarkerEdgeColor','k',...
        'MarkerFaceColor','g',...
        'MarkerSize',10)
end
% title set
til=title(figtitle,'Interpreter','none'),
set(til,'FontSize',15);
set(til,'FontWeight','Bold');
set(til,'FontName','Ubuntu Light');

background='white';
whitebg(gcf,background);
set(gcf,'Color',background,'InvertHardcopy','off');

saveas(hfig,[figpath '/' figtitle '.tif'],'tif');
close(hfig);

end