function [MostPos,MostNeg]=Fcorrcp(S1_Rmap,S2_Rmap,atlasflag,statspath,statename,cba,cov,shp)
% compare relations of HomoxIntra across STATES

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

[mapr_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_RmapR'],S1_Rmap.homoxintraLIabs_R(1,nid)',S2_Rmap.homoxintraLIabs_R(1,nid)');
[Z_hiLIabs_map,P_hiLIbas_map] = FisherZtest(S2_Rmap.homoxintraLIabs_R,S1_Rmap.homoxintraLIabs_R,887,887);

Z_hiLIabs_map_thr=Z_hiLIabs_map .* (P_hiLIbas_map<0.5/length(nid));


MostPos=find(Z_hiLIabs_map_thr==max(Z_hiLIabs_map_thr));
MostNeg=find(Z_hiLIabs_map_thr==min(Z_hiLIabs_map_thr));

SaveAsAtlasMZ3_Plot(Z_hiLIabs_map,[statspath,'/'],[statename '_HomoxIntraLIabs' '_Z' '_map','_SFICE'],[-5 5],shp);
SaveAsAtlasMZ3_Plot(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr>0),[statspath,'/'],[statename '_HomoxIntraLIabs' '_Zpos' '_map_THRD','_SFICE'],[-5 5],shp);
SaveAsAtlasMZ3_Plot(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr<0),[statspath,'/'],[statename '_HomoxIntraLIabs' '_Zneg' '_map_THRD','_SFICE'],[-5 5],shp);


end