function hist_lxy(subv,pointv,figpath,figtitle)

hfig=figure;
tmp=get(gcf,'Position');
set(gcf,'Position', [50, tmp(2) ,tmp(4)*2, tmp(4)*0.9]);
if size(subv,2)==1
    histdata = histogram(subv,10);
    hold on;
    y=min(histdata.Values):(max(histdata.Values)/10):max(histdata.Values);
    x=repmat(pointv,length(y),1);
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
    plot(x_values,dpdf1,'Color','r','LineStyle',':','LineWidth',2)
    plot(x_values,dpdf2,'Color','b','LineStyle',':','LineWidth',2)

    y=min(histdata1.Values):(max(histdata1.Values)/10):max(histdata1.Values);
    x=repmat(mean(histdata1.Data),length(y),1);
    plot(x,y,'LineWidth',2,...
        'MarkerFaceColor','r',...
        'MarkerSize',10)
    
    y=min(histdata2.Values):(max(histdata2.Values)/10):max(histdata2.Values);
    x=repmat(mean(histdata2.Data),length(y),1);
    plot(x,y,'LineWidth',2,...
        'MarkerFaceColor','b',...
        'MarkerSize',10)
    
%     legend({'Rest','Task'},'Location','NorthEast')
    
end
% title set
til=title(figtitle,'Interpreter','none'),
set(til,'FontSize',15);
set(til,'FontWeight','Bold');
set(til,'FontName','Ubuntu Light');

background='white';
whitebg(gcf,background);
set(gcf,'Color',background,'InvertHardcopy','off');

hold off
    
saveas(hfig,[figpath '/' figtitle '.tif'],'tif');
close(hfig);

end