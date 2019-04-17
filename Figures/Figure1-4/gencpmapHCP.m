function gencpmapHCP(FCS1,FCS2,atlasflag,subid,cov,statspath,statename,cba,COV,shp)
% compare between STATES
figflag=1;
if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

surftype = 'inf';
projtype = 'tri';
%% Group mean - Across subject

[~,~,iS1]=intersect(subid,FCS1.subid);
[~,~,iS2]=intersect(subid,FCS2.subid);

FCS_global1=FCS1.global(iS1,:);
FCS_global2=FCS2.global(iS2,:);

ho_FC1=FCS1.homo(iS1,:);
LI_intra_abs1=FCS1.intra_absAI(iS1,:);

HomoFC_mean1=mean(ho_FC1)';
LI_abs_mean1=mean(LI_intra_abs1)';     

ho_FC2=FCS2.homo(iS2,:);
LI_intra_abs2=FCS2.intra_absAI(iS2,:);

HomoFC_mean2=mean(ho_FC2)';
LI_abs_mean2=mean(LI_intra_abs2)';

if figflag==1
    [gr_homo,~] =PlotCorr([statspath '/'],[statename '_homo_avgmapR'],HomoFC_mean1,HomoFC_mean2);
    [gr_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_avgmapR'],LI_abs_mean1,LI_abs_mean2);
end

[~,~,~,tst1]=ttest(HomoFC_mean1,HomoFC_mean2);
[~,~,~,tst5]=ttest(LI_abs_mean1,LI_abs_mean2);
gt_homo=tst1.tstat;
gt_intraLIabs=tst5.tstat;


for j=1:size(ho_FC1,2)
    
    [~,p_homot(1,j),~,stats1]=ttest(ho_FC2(:,j),ho_FC1(:,j));
    t_homot(1,j)=stats1.tstat;     
    [~,p_intraLIabst(1,j),~,stats5]=ttest(LI_intra_abs2(:,j),LI_intra_abs1(:,j));
    t_intraLIabst(1,j)=stats5.tstat;  
    [homoc_R(1,j),homoc_P(1,j)]=partialcorr(ho_FC1(:,j),ho_FC2(:,j),[FCS_global1,FCS_global2,COV]);     
    [intraLIabsc_R(1,j),intraLIabsc_P(1,j)]=partialcorr(LI_intra_abs1(:,j),LI_intra_abs2(:,j),[FCS_global1,FCS_global2,COV]);
    
    [sub_R(1,j),sub_P(1,j)]=corr(ho_FC2(:,j)-ho_FC1(:,j),LI_intra_abs2(:,j)-LI_intra_abs1(:,j));
    
    ICC_homo(1,j)=IPN_icc([ho_FC1(:,j),ho_FC2(:,j)],1,'single');
    ICC_LIabs(1,j)=IPN_icc([LI_intra_abs1(:,j),LI_intra_abs2(:,j)],1,'single');
end
ICC_homo(isnan(ICC_homo))=0;
ICC_LIabs(isnan(ICC_LIabs))=0;

pbon=0.05/(length(nid));
t_homot_thrd=t_homot .* (p_homot<pbon);

t_intraLIabst_thrd=t_intraLIabst .* (p_intraLIabst<pbon);
homoc_R_thrd=homoc_R .* (homoc_P<pbon);

intraLIabsc_R_thrd=intraLIabsc_R .* (intraLIabsc_P<pbon);

sub_R_thrd=sub_R .* (sub_P<pbon);

if figflag==1
    SaveAsAtlasNii(t_homot,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_T' '_map'],1)
    SaveAsAtlasNii(t_intraLIabst,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_T' '_map'],1)
    SaveAsAtlasNii(homoc_R,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_R' '_map'],1)
    SaveAsAtlasNii(intraLIabsc_R,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_R' '_map'],1)
    
    SaveAsAtlasNii(t_homot_thrd,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_T' '_THRD'],1)
    SaveAsAtlasNii(t_intraLIabst_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_T' '_THRD'],1)
    SaveAsAtlasNii(homoc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_R' '_THRD'],1)
    SaveAsAtlasNii(intraLIabsc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_R' '_THRD'],1)
    
    SaveAsAtlasNii(sub_R,[atlasflag '2'],[statspath,'/',statename],['_SUB' '_R' '_map'],1)
    SaveAsAtlasNii(sub_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_SUB' '_R' '_THRD'],1)

    SaveAsAtlasNii(ICC_homo,[atlasflag '2'],[statspath,'/',statename],'_ICC_Homo',1)
    SaveAsAtlasNii(ICC_LIabs,[atlasflag '2'],[statspath,'/',statename],'_ICC_IntraLIabs',1)
    SaveAsAtlasNii(LI_abs_mean2-LI_abs_mean1,[atlasflag '2'],[statspath,'/',statename],'_IntraLIabs_2sub1',1)

    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_T' '_map','.nii'],surftype,projtype,'hemi',cba);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_T' '_map','.nii'],surftype,projtype,'hemi',[-25,25]);
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_R' '_map','.nii'],surftype,projtype,'hemi',[0,1]);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_R' '_map','.nii'],surftype,projtype,'hemi',[0,0.5]);
    
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_T' '_THRD','.nii'],surftype,projtype,'hemi',cba);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_T' '_THRD','.nii'],surftype,projtype,'hemi',[-25,25]);
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_R' '_THRD','.nii'],surftype,projtype,'hemi',[0,1]);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_R' '_THRD','.nii'],surftype,projtype,'hemi',[0,0.5]);
    
    SaveAsAtlasMZ3_Plot(t_homot,statspath,[statename,'_HomoFC','_T','_map','_SFICE'],cba,shp);
    SaveAsAtlasMZ3_Plot(t_intraLIabst,statspath,[statename,'_IntraLIabs','_T','_map','_SFICE'],[-25,25],shp);
    SaveAsAtlasMZ3_Plot(homoc_R,statspath,[statename,'_HomoFC','_R','_map','_SFICE'],[0.001,1],shp);
    SaveAsAtlasMZ3_Plot(intraLIabsc_R,statspath,[statename,'_IntraLIabs','_R','_map','_SFICE'],[0.001,0.5],shp);
    SaveAsAtlasMZ3_Plot(t_homot_thrd,statspath,[statename,'_HomoFC','_T','_map','_THRD','_SFICE'],cba,shp);
    SaveAsAtlasMZ3_Plot(t_intraLIabst_thrd,statspath,[statename,'_IntraLIabs','_T','_map','_THRD','_SFICE'],[-25,25],shp);
    SaveAsAtlasMZ3_Plot(homoc_R_thrd,statspath,[statename,'_HomoFC','_R','_map','_THRD','_SFICE'],[0.001,1],shp);
    SaveAsAtlasMZ3_Plot(intraLIabsc_R_thrd,statspath,[statename,'_IntraLIabs','_R','_map','_THRD','_SFICE'],[0.001,0.5],shp);
    
    NiiProj2Surf([statspath,'/',statename,'_SUB' '_R' '_map','.nii'],surftype,projtype,'hemi',[-0.5,0.5]);
    NiiProj2Surf([statspath,'/',statename,'_SUB' '_R' '_THRD','.nii'],surftype,projtype,'hemi',[-0.5,0.5]);

    NiiProj2Surf([statspath,'/',statename,'_ICC_Homo','.nii'],surftype,projtype,'hemi',[0,1]);
    NiiProj2Surf([statspath,'/',statename,'_ICC_IntraLIabs','.nii'],surftype,projtype,'hemi',[0,0.5]);
    
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs_2sub1','.nii'],surftype,projtype,'hemi',[-0.1,0.1]);
    
    SaveAsAtlasMZ3_Plot(sub_R,statspath,[statename,'_SUB','_R','_map','_SFICE'],[-0.5,0.5],shp);
    SaveAsAtlasMZ3_Plot(sub_R_thrd,statspath,[statename,'_SUB','_R','_THRD','_map','_SFICE'],[-0.5,0.5],shp);
    SaveAsAtlasMZ3_Plot(ICC_homo,statspath,[statename,'_ICC_Homo','_map','_SFICE'],[0.001,1],shp);
    SaveAsAtlasMZ3_Plot(ICC_LIabs,statspath,[statename,'_ICC_IntraLIabs','_map','_SFICE'],[0.001,0.5],shp);
    SaveAsAtlasMZ3_Plot(LI_abs_mean2-LI_abs_mean1,statspath,[statename,'_IntraLIabs_2sub1','_map','_SFICE'],[-0.1,0.1],shp);  
    
    PlotCorr([statspath '/'],[statename '_homo_avgsubR'],mean(ho_FC1,2),mean(ho_FC2,2),term(FCS_global1)+term(FCS_global2)+cov);
    PlotCorr([statspath '/'],[statename '_intraLIabs_avgsubR'],mean(LI_intra_abs1,2),mean(LI_intra_abs2,2),term(FCS_global1)+term(FCS_global2)+cov);
    
    SysDiv2Plot('Hierarchy',atlasflag,[0,2],[statename,'LI_abs_SUB'],statspath,LI_intra_abs2-LI_intra_abs1);

end

%% single sub
for i=1:length(subid)

    HomoFC_sub1=ho_FC1(i,:)';
    LI_abs_sub1=LI_intra_abs1(i,:)';
    
    HomoFC_sub2=ho_FC2(i,:)';
    LI_abs_sub2=LI_intra_abs2(i,:)';
    
    [~,p_homot_sub(i,1),~,stats1]=ttest(HomoFC_sub1,HomoFC_sub2);
    t_homot_sub(i,1)=stats1.tstat;     

    [~,p_intraLIabst_sub(i,1),~,stats5]=ttest(LI_abs_sub1,LI_abs_sub2);
    t_intraLIabst_sub(i,1)=stats5.tstat;  

    [homoc_R_sub(i,1),homoc_P_sub(i,1)]=corr(HomoFC_sub1,HomoFC_sub2);       
    [intraLIabsc_R_sub(i,1),intraLIabsc_P_sub(i,1)]=corr(LI_abs_sub1,LI_abs_sub2);
end

if figflag==1
    hist_lxy(t_homot_sub,gt_homo,statspath,[statename '_homo_mapT_hist']);
    hist_lxy(t_intraLIabst_sub,gt_intraLIabs,statspath,[statename '_intraLIabs_mapT_hist']);
    
    hist_lxy(homoc_R_sub,gr_homo,statspath,[statename '_homo_mapR_hist']);

    hist_lxy(intraLIabsc_R_sub,gr_intraLIabs,statspath,[statename '_intraLIabs_mapR_hist']);
end

end