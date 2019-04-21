function [HxI_Rmap]=Fcorr(FCS,atlasflag,subid,cov,statspath,statename,COV,cbc,shp)
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

FCS_global=FCS.global(iS,:);

for j=1:size(ho_FC,2)
   [homoxintraLIabsc_R(1,j),homoxintraLIabsc_P(1,j)]=partialcorr(ho_FC(:,j),LI_intra_abs(:,j),[FCS_global,COV]);   
end

HxI_Rmap.homoxintraLIabs_R=homoxintraLIabsc_R;
HxI_Rmap.homoxintraLIabs_P=homoxintraLIabsc_P;

pbon=0.05/length(nid);
homoxintraLIabsc_R_thrd=homoxintraLIabsc_R .* (homoxintraLIabsc_P<pbon);

    SaveAsAtlasMZ3_Plot(homoxintraLIabsc_R,statspath,[statename,'_HomoxIntraLIabs' '_R' '_map','_SFICE'],[-0.5,0.5],shp);
    SaveAsAtlasMZ3_Plot(homoxintraLIabsc_R_thrd,statspath,[statename,'_HomoxIntraLIabs' '_R' '_THRD','_SFICE'],[-0.5,0.5],shp);
    
    SysDiv2Plot('Hierarchy',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
    
