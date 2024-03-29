function [r,p] = PlotCorr(savepath,tname,VarA,VarB,Cov,Group)
% range

if isempty(dir(savepath))
    system(['mkdir -p ' savepath])
end

if nargin<4
    fig = figure,
    [no,xo] = hist(VarA),
    title(tname,'Interpreter','none'),
    saveas(fig,[savepath tname '.tif'],'tif'),
    close(fig);
    
    Data2xls1=table(VarA);
    Data2xls2=table(no,xo);
    filename = [savepath '/' tname '.xlsx'];
    writetable(Data2xls1,filename,'Sheet',1,'Range','A1');
    writetable(Data2xls2,filename,'Sheet',2,'Range','A1');
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
    fig = figure;
    [ ~, ~, ~, SSS ] = SurfStatPlot(term(VarA),term(VarB),1+term(Cov),term(Group),'LineWidth',2, 'MarkerSize',10),
    title([tname ' r=' num2str(r) ' p=' num2str(p)],'Interpreter','none'),
%     axis(range),
    saveas(fig,[savepath tname '.tif'],'tif'),
    close(fig);
    if Group == 1
        Data2xls=table(VarA,VarB,SSS,Cov(:));
    else
        Data2xls=table(VarA,VarB,SSS,Cov(:),Group(:));
    end
    filename = [savepath '/' tname '.xlsx'];
    writetable(Data2xls,filename,'Sheet',1,'Range','A1');

else

    
end

end

