function [HxI_Rmap,HxI_Rsub]=gencorrmapCAM(FCS,atlasflag,subid,cov,statspath,statename,COV,cbc)
% relation of HomoxIntra within each STATE

figflag=1;
if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end


%% Group mean - Across subject
[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
% intra_LL=FCS.intra_L(iS,:);
% intra_RR=FCS.intra_R(iS,:);
% LI_intra=FCS.intra_AI(iS,:);
LI_intra_abs=FCS.intra_absAI(iS,:);

% IntraL_mean=mean(intra_LL)';
% IntraR_mean=mean(intra_RR)';
HomoFC_mean=mean(ho_FC)';
% LI_mean=mean(LI_intra)';
LI_abs_mean=mean(LI_intra_abs)';

FCS_global=FCS.global(iS,:);

if figflag==1
%     [gr_homoxintraL,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraL_avgmapR'],HomoFC_mean(nid,:),IntraL_mean(nid,:));
%     [gr_homoxintraR,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraR_avgmapR'],HomoFC_mean(nid,:),IntraR_mean(nid,:));
%     [gr_homoxintraLI,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraLI_avgmapR'],HomoFC_mean(nid,:),LI_mean(nid,:));
    [gr_homoxintraLIabs,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraLIabs_avgmapR'],HomoFC_mean(nid,:),LI_abs_mean(nid,:));
%     [gr_intraLxintraR,~] =PlotCorr([statspath '/'],[statename '_IntraLxIntraR_avgmapR'],IntraL_mean(nid,:),IntraR_mean(nid,:));
end

% [~,~,~,tst1]=ttest(IntraL_mean(nid,:),IntraR_mean(nid,:));
% gt_intraLxintraR=tst1.tstat;


for j=1:length(HomoFC_mean)
    
%     [~,p_intraLxintraRt(1,j),~,stats1]=ttest(intra_LL(:,j),intra_RR(:,j));
%     t_intraLxintraRt(1,j)=stats1.tstat;     

%     [homoxintraLc_R(1,j),homoxintraLc_P(1,j)]=partialcorr(ho_FC(:,j),intra_LL(:,j),FCS_global);     
%     [homoxintraRc_R(1,j),homoxintraRc_P(1,j)]=partialcorr(ho_FC(:,j),intra_RR(:,j),FCS_global);    
%     [homoxintraLIc_R(1,j),homoxintraLIc_P(1,j)]=partialcorr(ho_FC(:,j),LI_intra(:,j),FCS_global);
    [homoxintraLIabsc_R(1,j),homoxintraLIabsc_P(1,j)]=partialcorr(ho_FC(:,j),LI_intra_abs(:,j),[FCS_global,COV]);   
%     [intraLxintraRc_R(1,j),intraLxintraRc_P(1,j)]=partialcorr(intra_LL(:,j),intra_RR(:,j),FCS_global);

end

% HxI_Rmap.homoxintraL_R=homoxintraLc_R;
% HxI_Rmap.homoxintraR_R=homoxintraRc_R;
% HxI_Rmap.homoxintraLI_R=homoxintraLIc_R;
HxI_Rmap.homoxintraLIabs_R=homoxintraLIabsc_R;
% HxI_Rmap.homoxintraL_P=homoxintraLc_P;
% HxI_Rmap.homoxintraR_P=homoxintraRc_P;
% HxI_Rmap.homoxintraLI_P=homoxintraLIc_P;
HxI_Rmap.homoxintraLIabs_P=homoxintraLIabsc_P;

pbon=0.05/length(nid);
% [pbon,~] =FDR(homoxintraLIabsc_P,0.05)
% t_intraLxintraRt_thrd=t_intraLxintraRt .* (p_intraLxintraRt<pbon);
% 
% homoxintraLc_R_thrd=homoxintraLc_R .* (homoxintraLc_P<pbon);
% homoxintraRc_R_thrd=homoxintraRc_R .* (homoxintraRc_P<pbon);
% homoxintraLIc_R_thrd=homoxintraLIc_R .* (homoxintraLIc_P<pbon);
homoxintraLIabsc_R_thrd=homoxintraLIabsc_R .* (homoxintraLIabsc_P<pbon);
% intraLxintraRc_R_thrd=intraLxintraRc_R .* (intraLxintraRc_P<pbon);

if figflag==1
%     SaveAsAtlasNii(t_intraLxintraRt,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_IntraLxIntraR' '_T' '_map'],1)
%     
%     SaveAsAtlasNii(homoxintraLc_R,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraL' '_R' '_map'],1)
%     SaveAsAtlasNii(homoxintraRc_R,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraR' '_R' '_map'],1)
%     SaveAsAtlasNii(homoxintraLIc_R,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraLI' '_R' '_map'],1)
    SaveAsAtlasNii(homoxintraLIabsc_R,[atlasflag '3'],[statspath,'/',statename],['_HomoxIntraLIabs' '_R' '_map'],1)
%     SaveAsAtlasNii(intraLxintraRc_R,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_IntraLxIntraR' '_R' '_map'],1)
%     
%     SaveAsAtlasNii(t_intraLxintraRt_thrd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_IntraLxIntraR' '_T' '_THRD'],1)
%     
%     SaveAsAtlasNii(homoxintraLc_R_thrd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraL' '_R' '_THRD'],1)
%     SaveAsAtlasNii(homoxintraRc_R_thrd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraR' '_R' '_THRD'],1)
%     SaveAsAtlasNii(homoxintraLIc_R_thrd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_HomoxIntraLI' '_R' '_THRD'],1)
    SaveAsAtlasNii(homoxintraLIabsc_R_thrd,[atlasflag '3'],[statspath,'/',statename],['_HomoxIntraLIabs' '_R' '_THRD'],1)
%     SaveAsAtlasNii(intraLxintraRc_R_thrd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],['_IntraLxIntraR' '_R' '_THRD'],1)
    
    
%     NiiProj2Surf([statspath,'/',statename,'_IntraLxIntraR' '_T' '_map','.nii'],'inf','cubic','hemi',cba);
%     
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraL' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraR' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLI' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
    NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLxIntraR' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     
%     NiiProj2Surf([statspath,'/',statename,'_IntraLxIntraR' '_T' '_THRD','.nii'],'inf','cubic','hemi',cba);
%     
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraL' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraR' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLI' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
    NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLxIntraR' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     
%     PlotCorr([statspath '/'],[statename '_HomoxIntraL_avgsubR'],mean(ho_FC(:,nid),2),mean(intra_LL(:,nid),2),FCS_global);
%     PlotCorr([statspath '/'],[statename '_HomoxIntraR_avgsubR'],mean(ho_FC(:,nid),2),mean(intra_RR(:,nid),2),FCS_global);
%     PlotCorr([statspath '/'],[statename '_HomoxIntraLI_avgsubR'],mean(ho_FC(:,nid),2),mean(LI_intra(:,nid),2),FCS_global);
    PlotCorr([statspath '/'],[statename '_HomoxIntraLIabs_avgsubR'],mean(ho_FC(:,nid),2),mean(LI_intra_abs(:,nid),2),term(FCS_global)+cov);
%     PlotCorr([statspath '/'],[statename '_IntraLxIntraR_avgsubR'],mean(intra_LL(:,nid),2),mean(intra_RR(:,nid),2),FCS_global);
%     
%     SysDiv2Plot('Yeo7',[statename,'_HomoxIntraL_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLc_R));
%     SysDiv2Plot('Yeo7',[statename,'_HomoxIntraR_avgsubR'],[statspath '/'],fisherR2Z(homoxintraRc_R));
%     SysDiv2Plot('Yeo7',[statename,'_HomoxIntraLI_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIc_R));
    SysDiv2Plot('Yeo7',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
%     SysDiv2Plot('Yeo7',[statename,'_IntraLxIntraR_avgsubR'],[statspath '/'],fisherR2Z(intraLxintraRc_R));
%     
%     SysDiv2Plot('Hierarchy',[statename,'_HomoxIntraL_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLc_R));
%     SysDiv2Plot('Hierarchy',[statename,'_HomoxIntraR_avgsubR'],[statspath '/'],fisherR2Z(homoxintraRc_R));
%     SysDiv2Plot('Hierarchy',[statename,'_HomoxIntraLI_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIc_R));
    SysDiv2Plot('Hierarchy',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
%     SysDiv2Plot('Hierarchy',[statename,'_IntraLxIntraR_avgsubR'],[statspath '/'],fisherR2Z(intraLxintraRc_R));
    
end


%% Each subject -- across regions 
for i=1:length(subid)
%     IntraL_sub=intra_LL(i,nid)';
%     IntraR_sub=intra_RR(i,nid)';
    HomoFC_sub=ho_FC(i,nid)';
%     LI_sub=LI_intra(i,nid)';
    LI_abs_sub=LI_intra_abs(i,nid)';
    
%     [~,p_intraLxintraRt_sub(i,1),~,stats1]=ttest(IntraL_sub,IntraR_sub);
%     t_intraLxintraRt_sub(i,1)=stats1.tstat;     

%     [homoxintraLc_R_sub(i,1),homoxintraLc_P_sub(i,1)]=corr(HomoFC_sub,IntraL_sub);     
%     [homoxintraRc_R_sub(i,1),homoxintraRc_P_sub(i,1)]=corr(HomoFC_sub,IntraR_sub);    
%     [homoxintraLIc_R_sub(i,1),homoxintraLIc_P_sub(i,1)]=corr(HomoFC_sub,LI_sub);
    [homoxintraLIabsc_R_sub(i,1),homoxintraLIabsc_P_sub(i,1)]=corr(HomoFC_sub,LI_abs_sub);   
%     [intraLxintraRc_R_sub(i,1),intraLxintraRc_P_sub(i,1)]=corr(IntraL_sub,IntraR_sub);
end

% HxI_Rsub.homoxintraL_R=homoxintraLc_R_sub;
% HxI_Rsub.homoxintraR_R=homoxintraRc_R_sub;
% HxI_Rsub.homoxintraLI_R=homoxintraLIc_R_sub;
HxI_Rsub.homoxintraLIabs_R=homoxintraLIabsc_R_sub;
% HxI_Rsub.homoxintraL_P=homoxintraLc_P_sub;
% HxI_Rsub.homoxintraR_P=homoxintraRc_P_sub;
% HxI_Rsub.homoxintraLI_P=homoxintraLIc_P_sub;
HxI_Rsub.homoxintraLIabs_P=homoxintraLIabsc_P_sub;
% 

if figflag==1
    
%     hist_lxy(t_intraLxintraRt_sub,gt_intraLxintraR,statspath,[statename '_IntraLxIntraR_mapT_hist']);
%     
%     hist_lxy(homoxintraLc_R_sub,gr_homoxintraL,statspath,[statename '_HomoxIntraL_mapR_hist']);
%     hist_lxy(homoxintraRc_R_sub,gr_homoxintraR,statspath,[statename '_HomoxIntraR_mapR_hist']);
%     hist_lxy(homoxintraLIc_R_sub,gr_homoxintraLI,statspath,[statename '_HomoxIntraLI_mapR_hist']);
    hist_lxy(homoxintraLIabsc_R_sub,gr_homoxintraLIabs,statspath,[statename '_HomoxIntraLIabs_mapR_hist']);
%     hist_lxy(intraLxintraRc_R_sub,gr_intraLxintraR,statspath,[statename '_IntraLxIntraR_mapR_hist']);
end

end