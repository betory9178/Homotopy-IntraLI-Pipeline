function [r,p] = PlotCorr(savepath,tname,VarA,VarB,Cov,Group)
% ,range

if isempty(dir(savepath))
    system(['mkdir -p ' savepath])
end

if nargin<4
    fig = figure,hist(VarA),
    title(tname,'Interpreter','none'),
    saveas(fig,[savepath tname '.tif'],'tif'),
    close(fig);
    return
    
elseif nargin<5 || isempty(Cov)
    Group=1;
    subs=length(VarA);
    Cov=zeros(subs,1);
    
elseif nargin<6 || isempty(Group)
    Group=1;
end


if iscolumn(VarA) && iscolumn(VarB)
    if isnumeric(VarA) && isnumeric(Cov)
        [r,p]=partialcorr(VarA,VarB,Cov);
    elseif iscell(VarA)
        r=NaN;
        p=NaN;
    else
        [r,p]=partialcorr(VarA,VarB,double(Cov));
    end
    fig = figure,SurfStatPlot(term(VarA),term(VarB),1+term(Cov),term(Group),'LineWidth',2, 'MarkerSize',10),
    title([tname ' r=' num2str(r) ' p=' num2str(p)],'Interpreter','none'),
%     axis(range),
    saveas(fig,[savepath tname '.tif'],'tif'),
    close(fig);
    
else

    
end

end

