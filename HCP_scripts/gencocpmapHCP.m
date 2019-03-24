function [MostPos,MostNeg]=gencocpmapHCP(S1_Rmap,S1_Rsub,S2_Rmap,S2_Rsub,atlasflag,statspath,statename,cba,cov)
% compare relations of HomoxIntra across STATES

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

surftype = 'inf';
projtype = 'tri';

sbsz1=length(S1_Rsub.homoxintraLIabs_R);
sbsz2=length(S2_Rsub.homoxintraLIabs_R);

[mapr_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_RmapR'],S1_Rmap.homoxintraLIabs_R(1,nid)',S2_Rmap.homoxintraLIabs_R(1,nid)');
[Z_hiLIabs_map,P_hiLIbas_map] = FisherZtest(S2_Rmap.homoxintraLIabs_R,S1_Rmap.homoxintraLIabs_R,sbsz2,sbsz1);

Z_hiLIabs_map_thr=Z_hiLIabs_map .* (P_hiLIbas_map<0.5/length(nid));

SaveAsAtlasNii(Z_hiLIabs_map,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Z' '_map'],1)
SaveAsAtlasNii(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr>0),[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Zpos' '_map_THRD'],1)
SaveAsAtlasNii(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr<0),[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Zneg' '_map_THRD'],1)

MostPos=find(Z_hiLIabs_map_thr==max(Z_hiLIabs_map_thr));
MostNeg=find(Z_hiLIabs_map_thr==min(Z_hiLIabs_map_thr));

NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Z' '_map','.nii'],surftype,projtype,'hemi',cba);
NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Zpos' '_map_THRD','.nii'],surftype,projtype,'hemi',cba);
NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Zneg' '_map_THRD','.nii'],surftype,projtype,'hemi',cba);


[sub_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_RsubR'],S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,cov);

[Z_hiLIabs_sub,P_hiLIbas_sub] = FisherZtest(S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,sbsz1,sbsz2);

[Z_hiLIabs_sub,P_hiLIbas_sub] = FisherZtest(S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,sbsz1,sbsz2);

[Z_hiLIabs,P_hiLIbas] = FisherZtest(mean(S1_Rsub.homoxintraLIabs_R),mean(S2_Rsub.homoxintraLIabs_R),sbsz1,sbsz2);

hist_lxy(Z_hiLIabs_sub,Z_hiLIabs,statspath,[statename '_HomoxIntraLIabs_subZtest_hist']);

hist_lxy(fisherR2Z([S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R]),[],statspath,[statename '_HomoxIntraLIabsR_sub_dist']);

end