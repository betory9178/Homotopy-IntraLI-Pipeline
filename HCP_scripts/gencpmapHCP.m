function gencpmapHCP(FCS1,FCS2,atlasflag,subid,statspath,statename,cba,cbb,cbc,cbd)
% compare between STATES
figflag=1;
if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

%% Group mean - Across subject

[~,~,iS1]=intersect(subid,FCS1.subid);
[~,~,iS2]=intersect(subid,FCS2.subid);

ho_FC1=FCS1.homo(iS1,:);
% intra_LL1=FCS1.intra_L(iS1,:);
% intra_RR1=FCS1.intra_R(iS1,:);
% LI_intra1=FCS1.intra_AI(iS1,:);
LI_intra_abs1=FCS1.intra_absAI(iS1,:);

% IntraL_mean1=mean(intra_LL1)';
% IntraR_mean1=mean(intra_RR1)';
HomoFC_mean1=mean(ho_FC1)';
% LI_mean1=mean(LI_intra1)';
LI_abs_mean1=mean(LI_intra_abs1)';
     

ho_FC2=FCS2.homo(iS2,:);
% intra_LL2=FCS2.intra_L(iS2,:);
% intra_RR2=FCS2.intra_R(iS2,:);
% LI_intra2=FCS2.intra_AI(iS2,:);
LI_intra_abs2=FCS2.intra_absAI(iS2,:);

% IntraL_mean2=mean(intra_LL2)';
% IntraR_mean2=mean(intra_RR2)';
HomoFC_mean2=mean(ho_FC2)';
% LI_mean2=mean(LI_intra2)';
LI_abs_mean2=mean(LI_intra_abs2)';

if figflag==1
    [gr_homo,~] =PlotCorr([statspath '/'],[statename '_homo_avgmapR'],HomoFC_mean1,HomoFC_mean2);
%     [gr_intraL,~] =PlotCorr([statspath '/'],[statename '_intraL_avgmapR'],IntraL_mean1,IntraL_mean2);
%     [gr_intraR,~] =PlotCorr([statspath '/'],[statename '_intraR_avgmapR'],IntraR_mean1,IntraR_mean2);
%     [gr_intraLI,~] =PlotCorr([statspath '/'],[statename '_intraLI_avgmapR'],LI_mean1,LI_mean2);
    [gr_intraLIabs,~] =PlotCorr([statspath '/'],[statename '_intraLIabs_avgmapR'],LI_abs_mean1,LI_abs_mean2);
end

[~,~,~,tst1]=ttest(HomoFC_mean1,HomoFC_mean2);
% [~,~,~,tst2]=ttest(IntraL_mean1,IntraL_mean2);
% [~,~,~,tst3]=ttest(IntraR_mean1,IntraR_mean2);
% [~,~,~,tst4]=ttest(LI_mean1,LI_mean2);
[~,~,~,tst5]=ttest(LI_abs_mean1,LI_abs_mean2);
gt_homo=tst1.tstat;
% gt_intraL=tst2.tstat;
% gt_intraR=tst3.tstat;
% gt_intraLI=tst4.tstat;
gt_intraLIabs=tst5.tstat;


for j=1:size(ho_FC1,2)
    
    [~,p_homot(1,j),~,stats1]=ttest(ho_FC1(:,j),ho_FC2(:,j));
    t_homot(1,j)=stats1.tstat;     
%     [~,p_intraLt(1,j),~,stats2]=ttest(intra_LL1(:,j),intra_LL2(:,j));
%     t_intraLt(1,j)=stats2.tstat;      
%     [~,p_intraRt(1,j),~,stats3]=ttest(intra_RR1(:,j),intra_RR2(:,j));
%     t_intraRt(1,j)=stats3.tstat;      
%     [~,p_intraLIt(1,j),~,stats4]=ttest(LI_intra1(:,j),LI_intra2(:,j));
%     t_intraLIt(1,j)=stats4.tstat;  
    [~,p_intraLIabst(1,j),~,stats5]=ttest(LI_intra_abs1(:,j),LI_intra_abs2(:,j));
    t_intraLIabst(1,j)=stats5.tstat;  
    [homoc_R(1,j),homoc_P(1,j)]=corr(ho_FC1(:,j),ho_FC2(:,j));     
%     [intraLc_R(1,j),intraLc_P(1,j)]=corr(intra_LL1(:,j),intra_LL2(:,j));    
%     [intraRc_R(1,j),intraRc_P(1,j)]=corr(intra_RR1(:,j),intra_RR2(:,j));
%     [intraLIc_R(1,j),intraLIc_P(1,j)]=corr(LI_intra1(:,j),LI_intra2(:,j));   
    [intraLIabsc_R(1,j),intraLIabsc_P(1,j)]=corr(LI_intra_abs1(:,j),LI_intra_abs2(:,j));

end

pbon=0.05/(length(nid));
t_homot_thrd=t_homot .* (p_homot<pbon);
% t_intraLt_thrd=t_intraLt .* (p_intraLt<pbon);
% t_intraRt_thrd=t_intraRt .* (p_intraRt<pbon);
% t_intraLIt_thrd=t_intraLIt .* (p_intraLIt<pbon);
t_intraLIabst_thrd=t_intraLIabst .* (p_intraLIabst<pbon);
homoc_R_thrd=homoc_R .* (homoc_P<pbon);
% intraLc_R_thrd=intraLc_R .* (intraLc_P<pbon);
% intraRc_R_thrd=intraRc_R .* (intraRc_P<pbon);
% intraLIc_R_thrd=intraLIc_R .* (intraLIc_P<pbon);
intraLIabsc_R_thrd=intraLIabsc_R .* (intraLIabsc_P<pbon);

if figflag==1
    SaveAsAtlasNii(t_homot,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_T' '_map'],1)
%     SaveAsAtlasNii(t_intraLt,[atlasflag '2'],[statspath,'/',statename],['_IntraL' '_T' '_map'],1)
%     SaveAsAtlasNii(t_intraRt,[atlasflag '2'],[statspath,'/',statename],['_IntraR' '_T' '_map'],1)
%     SaveAsAtlasNii(t_intraLIt,[atlasflag '2'],[statspath,'/',statename],['_IntraLI' '_T' '_map'],1)
    SaveAsAtlasNii(t_intraLIabst,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_T' '_map'],1)
    SaveAsAtlasNii(homoc_R,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_R' '_map'],1)
%     SaveAsAtlasNii(intraLc_R,[atlasflag '2'],[statspath,'/',statename],['_IntraL' '_R' '_map'],1)
%     SaveAsAtlasNii(intraRc_R,[atlasflag '2'],[statspath,'/',statename],['_IntraR' '_R' '_map'],1)
%     SaveAsAtlasNii(intraLIc_R,[atlasflag '2'],[statspath,'/',statename],['_IntraLI' '_R' '_map'],1)
    SaveAsAtlasNii(intraLIabsc_R,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_R' '_map'],1)
    
    SaveAsAtlasNii(t_homot_thrd,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_T' '_THRD'],1)
%     SaveAsAtlasNii(t_intraLt_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraL' '_T' '_THRD'],1)
%     SaveAsAtlasNii(t_intraRt_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraR' '_T' '_THRD'],1)
%     SaveAsAtlasNii(t_intraLIt_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLI' '_T' '_THRD'],1)
    SaveAsAtlasNii(t_intraLIabst_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_T' '_THRD'],1)
    SaveAsAtlasNii(homoc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_HomoFC' '_R' '_THRD'],1)
%     SaveAsAtlasNii(intraLc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraL' '_R' '_THRD'],1)
%     SaveAsAtlasNii(intraRc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraR' '_R' '_THRD'],1)
%     SaveAsAtlasNii(intraLIc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLI' '_R' '_THRD'],1)
    SaveAsAtlasNii(intraLIabsc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_IntraLIabs' '_R' '_THRD'],1)
    
    
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_T' '_map','.nii'],'inf','cubic','hemi',cba);
%     NiiProj2Surf([statspath,'/',statename,'_IntraL' '_T' '_map','.nii'],'inf','cubic','hemi',cbb);
%     NiiProj2Surf([statspath,'/',statename,'_IntraR' '_T' '_map','.nii'],'inf','cubic','hemi',cbb);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLI' '_T' '_map','.nii'],'inf','cubic','hemi',cbd);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_T' '_map','.nii'],'inf','cubic','hemi',cbd);
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraL' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraR' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLI' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_R' '_map','.nii'],'inf','cubic','hemi',cbc);
    
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_T' '_THRD','.nii'],'inf','cubic','hemi',cba);
%     NiiProj2Surf([statspath,'/',statename,'_IntraL' '_T' '_THRD','.nii'],'inf','cubic','hemi',cbb);
%     NiiProj2Surf([statspath,'/',statename,'_IntraR' '_T' '_THRD','.nii'],'inf','cubic','hemi',cbb);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLI' '_T' '_THRD','.nii'],'inf','cubic','hemi',cbd);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_T' '_THRD','.nii'],'inf','cubic','hemi',cbd);
    NiiProj2Surf([statspath,'/',statename,'_HomoFC' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraL' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraR' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
%     NiiProj2Surf([statspath,'/',statename,'_IntraLI' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
    NiiProj2Surf([statspath,'/',statename,'_IntraLIabs' '_R' '_THRD','.nii'],'inf','cubic','hemi',cbc);
    
    
    PlotCorr([statspath '/'],[statename '_homo_avgsubR'],mean(ho_FC1,2),mean(ho_FC2,2));
%     PlotCorr([statspath '/'],[statename '_intraL_avgsubR'],mean(intra_LL1,2),mean(intra_LL2,2));
%     PlotCorr([statspath '/'],[statename '_intraR_avgsubR'],mean(intra_RR1,2),mean(intra_RR2,2));
%     PlotCorr([statspath '/'],[statename '_intraLI_avgsubR'],mean(LI_intra1,2),mean(LI_intra2,2));
    PlotCorr([statspath '/'],[statename '_intraLIabs_avgsubR'],mean(LI_intra_abs1,2),mean(LI_intra_abs2,2));
end

% single sub
for i=1:length(subid)
%     IntraL_sub1=intra_LL1(i,:)';
%     IntraR_sub1=intra_RR1(i,:)';
    HomoFC_sub1=ho_FC1(i,:)';
%     LI_sub1=LI_intra1(i,:)';
    LI_abs_sub1=LI_intra_abs1(i,:)';
    
%     IntraL_sub2=intra_LL2(i,:)';
%     IntraR_sub2=intra_RR2(i,:)';
    HomoFC_sub2=ho_FC2(i,:)';
%     LI_sub2=LI_intra2(i,:)';
    LI_abs_sub2=LI_intra_abs2(i,:)';
    
    [~,p_homot_sub(i,1),~,stats1]=ttest(HomoFC_sub1,HomoFC_sub2);
    t_homot_sub(i,1)=stats1.tstat;     
%     [~,p_intraLt_sub(i,1),~,stats2]=ttest(IntraL_sub1,IntraL_sub2);
%     t_intraLt_sub(i,1)=stats2.tstat;      
%     [~,p_intraRt_sub(i,1),~,stats3]=ttest(IntraR_sub1,IntraR_sub2);
%     t_intraRt_sub(i,1)=stats3.tstat;      
%     [~,p_intraLIt_sub(i,1),~,stats4]=ttest(LI_sub1,LI_sub2);
%     t_intraLIt_sub(i,1)=stats4.tstat;  
    [~,p_intraLIabst_sub(i,1),~,stats5]=ttest(LI_abs_sub1,LI_abs_sub2);
    t_intraLIabst_sub(i,1)=stats5.tstat;  

    [homoc_R_sub(i,1),homoc_P_sub(i,1)]=corr(HomoFC_sub1,HomoFC_sub2);     
%     [intraLc_R_sub(i,1),intraLc_P_sub(i,1)]=corr(IntraL_sub1,IntraL_sub2);    
%     [intraRc_R_sub(i,1),intraRc_P_sub(i,1)]=corr(IntraR_sub1,IntraR_sub2);
%     [intraLIc_R_sub(i,1),intraLIc_P_sub(i,1)]=corr(LI_sub1,LI_sub2);   
    [intraLIabsc_R_sub(i,1),intraLIabsc_P_sub(i,1)]=corr(LI_abs_sub1,LI_abs_sub2);
end

if figflag==1
    hist_lxy(t_homot_sub,gt_homo,statspath,[statename '_homo_mapT_hist']);
%     hist_lxy(t_intraLt_sub,gt_intraL,statspath,[statename '_intraL_mapT_hist']);
%     hist_lxy(t_intraRt_sub,gt_intraR,statspath,[statename '_intraR_mapT_hist']);
%     hist_lxy(t_intraLIt_sub,gt_intraLI,statspath,[statename '_intraLI_mapT_hist']);
    hist_lxy(t_intraLIabst_sub,gt_intraLIabs,statspath,[statename '_intraLIabs_mapT_hist']);
    
    hist_lxy(homoc_R_sub,gr_homo,statspath,[statename '_homo_mapR_hist']);
%     hist_lxy(intraLc_R_sub,gr_intraL,statspath,[statename '_intraL_mapR_hist']);
%     hist_lxy(intraRc_R_sub,gr_intraR,statspath,[statename '_intraR_mapR_hist']);
%     hist_lxy(intraLIc_R_sub,gr_intraLI,statspath,[statename '_intraLI_mapR_hist']);
    hist_lxy(intraLIabsc_R_sub,gr_intraLIabs,statspath,[statename '_intraLIabs_mapR_hist']);
end
% insectid=subid(logical((t_intraLt_sub<-23) .* (t_intraRt_sub<-23)))


end