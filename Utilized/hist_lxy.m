function hist_lxy(subv,meanv,figpath,figtitle)

hfig=figure;
tmp=get(gcf,'Position');
set(gcf,'Position', [50, tmp(2) ,tmp(4)*2, tmp(4)*0.9]);

histdata = histogram(subv,10);
hold on;
y=1:1:max(histdata.Values);
x=repmat(meanv,length(y),1);
plot(x,y,'LineWidth',3,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','g',...
    'MarkerSize',10)

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