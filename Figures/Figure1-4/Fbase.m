function Fbase(FCS,atlasflag,subid,statpath,statename,limrange,shp)
% baseline

%% Group mean - Across subject

[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
AI_intra_abs=FCS.intra_absAI(iS,:);

SysDiv2Plot('Hierarchy',atlasflag,[0,2],[statename,'Homo'],statpath,ho_FC);
SysDiv2Plot('Hierarchy',atlasflag,[0,1],[statename,'IntraLIabs'],statpath,AI_intra_abs);

HomoFC_mean=mean(ho_FC)';

SaveAsAtlasMZ3_Plot(HomoFC_mean,statpath,[statename,'HomoFC_mean','_SFICE'],[-1.8 1.8],shp);

AI_abs_mean=mean(AI_intra_abs)';

SaveAsAtlasMZ3_Plot(AI_abs_mean,statpath,[statename,'IntraFC_LIabs_mean','_SFICE'],[-limrange limrange],shp);

