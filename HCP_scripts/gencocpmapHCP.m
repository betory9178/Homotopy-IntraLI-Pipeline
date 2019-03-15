function gencocpmapHCP(S1_Rmap,S1_Rsub,S2_Rmap,S2_Rsub,atlasflag,statspath,statename,cba,cov)
% compare relations of HomoxIntra across STATES

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

sbsz1=length(S1_Rsub.homoxintraLIabs_R);
sbsz2=length(S2_Rsub.homoxintraLIabs_R);

% [mapr_intraL,~] =PlotCorr([statspath '/'],[statename '_intraL_RmapR'],S1_Rmap.homoxintraL_R(1,nid)',S2_Rmap.homoxintraL_R(1,nid)');
% [mapr_intraR,~] =PlotCorr([statspath '/'],[statename '_intraR_RmapR'],S1_Rmap.homoxintraR_R(1,nid)',S2_Rmap.homoxintraR_R(1,nid)');
% [mapr_intraLI,~] =PlotCorr([statspath '/'],[statename '_intraLI_RmapR'],S1_Rmap.homoxintraLI_R(1,nid)',S2_Rmap.homoxintraLI_R(1,nid)');
[mapr_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_RmapR'],S1_Rmap.homoxintraLIabs_R(1,nid)',S2_Rmap.homoxintraLIabs_R(1,nid)');


% [Z_hiL_map,P_hiL_map] = FisherZtest(S1_Rmap.homoxintraL_R,S2_Rmap.homoxintraL_R,904,904);
% [Z_hiR_map,P_hiR_map] = FisherZtest(S1_Rmap.homoxintraR_R,S2_Rmap.homoxintraR_R,904,904);
% [Z_hiLI_map,P_hiLI_map] = FisherZtest(S1_Rmap.homoxintraLI_R,S2_Rmap.homoxintraLI_R,904,904);
[Z_hiLIabs_map,P_hiLIbas_map] = FisherZtest(S2_Rmap.homoxintraLIabs_R,S1_Rmap.homoxintraLIabs_R,sbsz2,sbsz1);

% Z_hiL_map_thr=Z_hiL_map .* (P_hiL_map<0.5/186);
% Z_hiR_map_thr=Z_hiR_map .* (P_hiR_map<0.5/186);
% Z_hiLI_map_thr=Z_hiLI_map .* (P_hiLI_map<0.5/186);
Z_hiLIabs_map_thr=Z_hiLIabs_map .* (P_hiLIbas_map<0.5/length(nid));

% SaveAsAtlasNii(Z_hiL_map,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraL' '_Z' '_map'],1)
% SaveAsAtlasNii(Z_hiR_map,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraR' '_Z' '_map'],1)
% SaveAsAtlasNii(Z_hiLI_map,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLI' '_Z' '_map'],1)
SaveAsAtlasNii(Z_hiLIabs_map,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Z' '_map'],1)

% SaveAsAtlasNii(Z_hiL_map_thr,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraL' '_Z' '_map_THRD'],1)
% SaveAsAtlasNii(Z_hiR_map_thr,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraR' '_Z' '_map_THRD'],1)
% SaveAsAtlasNii(Z_hiLI_map_thr,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLI' '_Z' '_map_THRD'],1)
SaveAsAtlasNii(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr>0),[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Zpos' '_map_THRD'],1)
SaveAsAtlasNii(Z_hiLIabs_map_thr.*(Z_hiLIabs_map_thr<0),[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_Zneg' '_map_THRD'],1)

% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraL' '_Z' '_map','.nii'],'inf','tri','hemi',cba);
% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraR' '_Z' '_map','.nii'],'inf','tri','hemi',cba);
% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLI' '_Z' '_map','.nii'],'inf','tri','hemi',cba);
NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Z' '_map','.nii'],'inf','tri','hemi',cba);

% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraL' '_Z' '_map_THRD','.nii'],'inf','tri','hemi',cba);
% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraR' '_Z' '_map_THRD','.nii'],'inf','tri','hemi',cba);
% NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLI' '_Z' '_map_THRD','.nii'],'inf','tri','hemi',cba);
NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Zpos' '_map_THRD','.nii'],'inf','tri','hemi',[0 5]);
NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_Zneg' '_map_THRD','.nii'],'inf','tri','hemi',[-5 0]);


% [sub_intraL,~] =PlotCorr([statspath '/'],[statename '_intraL_RsubR'],S1_Rsub.homoxintraL_R,S2_Rsub.homoxintraL_R);
% [sub_intraR,~] =PlotCorr([statspath '/'],[statename '_intraR_RsubR'],S1_Rsub.homoxintraR_R,S2_Rsub.homoxintraR_R);
% [sub_intraLI,~] =PlotCorr([statspath '/'],[statename '_intraLI_RsubR'],S1_Rsub.homoxintraLI_R,S2_Rsub.homoxintraLI_R);
[sub_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_RsubR'],S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,cov);

% [Z_hiL_sub,P_hiL_sub] = FisherZtest(S1_Rsub.homoxintraL_R,S2_Rsub.homoxintraL_R,904,904);
% [Z_hiR_sub,P_hiR_sub] = FisherZtest(S1_Rsub.homoxintraR_R,S2_Rsub.homoxintraR_R,904,904);
% [Z_hiLI_sub,P_hiLI_sub] = FisherZtest(S1_Rsub.homoxintraLI_R,S2_Rsub.homoxintraLI_R,904,904);
[Z_hiLIabs_sub,P_hiLIbas_sub] = FisherZtest(S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,sbsz1,sbsz2);

% [Z_hiL_sub,P_hiL_sub] = FisherZtest(S1_Rsub.homoxintraL_R,S2_Rsub.homoxintraL_R,904,904);
% [Z_hiR_sub,P_hiR_sub] = FisherZtest(S1_Rsub.homoxintraR_R,S2_Rsub.homoxintraR_R,904,904);
% [Z_hiLI_sub,P_hiLI_sub] = FisherZtest(S1_Rsub.homoxintraLI_R,S2_Rsub.homoxintraLI_R,904,904);
[Z_hiLIabs_sub,P_hiLIbas_sub] = FisherZtest(S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R,sbsz1,sbsz2);

% [Z_hiL,P_hiL] = FisherZtest(mean(S1_Rsub.homoxintraL_R),mean(S2_Rsub.homoxintraL_R),904,904);
% [Z_hiR,P_hiR] = FisherZtest(mean(S1_Rsub.homoxintraR_R),mean(S2_Rsub.homoxintraR_R),904,904);
% [Z_hiLI,P_hiLI] = FisherZtest(mean(S1_Rsub.homoxintraLI_R),mean(S2_Rsub.homoxintraLI_R),904,904);
[Z_hiLIabs,P_hiLIbas] = FisherZtest(mean(S1_Rsub.homoxintraLIabs_R),mean(S2_Rsub.homoxintraLIabs_R),sbsz1,sbsz2);

% hist_lxy(Z_hiL_sub,Z_hiL,statspath,[statename '_HomoxIntraL_subZtest_hist']);
% hist_lxy(Z_hiR_sub,Z_hiR,statspath,[statename '_HomoxIntraR_subZtest_hist']);
% hist_lxy(Z_hiLI_sub,Z_hiLI,statspath,[statename '_HomoxIntraLI_subZtest_hist']);
hist_lxy(Z_hiLIabs_sub,Z_hiLIabs,statspath,[statename '_HomoxIntraLIabs_subZtest_hist']);

hist_lxy(fisherR2Z([S1_Rsub.homoxintraLIabs_R,S2_Rsub.homoxintraLIabs_R]),[],statspath,[statename '_HomoxIntraLIabsR_sub_dist']);

end