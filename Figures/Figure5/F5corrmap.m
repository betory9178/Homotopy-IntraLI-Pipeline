function [HxI_Rmap]=F5corrmap(FCS,atlasflag,subid,cov,statspath,statename,COV,cbc,shp)
% relation of HomoxIntra within each STATE

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

%% Group mean - Across subject
[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
LI_intra_abs=FCS.intra_absAI(iS,:);


HomoFC_mean=mean(ho_FC)';
LI_abs_mean=mean(LI_intra_abs)';

FCS_global=FCS.global(iS,:);

[gr_homoxintraLIabs,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraLIabs_avgmapR'],HomoFC_mean(nid,:),LI_abs_mean(nid,:));

for j=1:length(HomoFC_mean)
    [homoxintraLIabsc_R(1,j),homoxintraLIabsc_P(1,j)]=partialcorr(ho_FC(:,j),LI_intra_abs(:,j),[FCS_global,COV]);
end


HxI_Rmap.homoxintraLIabs_R=homoxintraLIabsc_R;
HxI_Rmap.homoxintraLIabs_P=homoxintraLIabsc_P;

pbon=0.05/length(nid);
homoxintraLIabsc_R_thrd=homoxintraLIabsc_R .* (homoxintraLIabsc_P<pbon);

SaveAsAtlasMZ3_Plot(homoxintraLIabsc_R,statspath,[statename,'_HomoxIntraLIabs' '_R' '_map','_SFICE'],cbc,shp);
SaveAsAtlasMZ3_Plot(homoxintraLIabsc_R_thrd,statspath,[statename,'_HomoxIntraLIabs' '_R' '_THRD','_SFICE'],cbc,shp);

SysDiv2Plot('Yeo7',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
SysDiv2Plot('Hierarchy',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));



end