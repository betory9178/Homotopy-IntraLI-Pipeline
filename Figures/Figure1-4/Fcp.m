function Fcp(FCS1,FCS2,atlasflag,subid,cov,statspath,statename,cba,COV,shp)
% compare between STATES
if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

%% Group mean - Across subject

[~,~,iS1]=intersect(subid,FCS1.subid);
[~,~,iS2]=intersect(subid,FCS2.subid);

FCS_global1=FCS1.global(iS1,:);
FCS_global2=FCS2.global(iS2,:);

ho_FC1=FCS1.homo(iS1,:);
LI_intra_abs1=FCS1.intra_absAI(iS1,:);

LI_abs_mean1=mean(LI_intra_abs1)';     

ho_FC2=FCS2.homo(iS2,:);
LI_intra_abs2=FCS2.intra_absAI(iS2,:);

LI_abs_mean2=mean(LI_intra_abs2)';


for j=1:size(ho_FC1,2)
    
    [~,p_homot(1,j),~,stats1]=ttest(ho_FC2(:,j),ho_FC1(:,j));
    t_homot(1,j)=stats1.tstat;     
    [~,p_intraLIabst(1,j),~,stats5]=ttest(LI_intra_abs2(:,j),LI_intra_abs1(:,j));
    t_intraLIabst(1,j)=stats5.tstat;  
%     [homoc_R(1,j),homoc_P(1,j)]=partialcorr(ho_FC1(:,j),ho_FC2(:,j),[FCS_global1,FCS_global2,COV]);     
%     [intraLIabsc_R(1,j),intraLIabsc_P(1,j)]=partialcorr(LI_intra_abs1(:,j),LI_intra_abs2(:,j),[FCS_global1,FCS_global2,COV]);
%     
    [sub_R(1,j),sub_P(1,j)]=corr(ho_FC2(:,j)-ho_FC1(:,j),LI_intra_abs2(:,j)-LI_intra_abs1(:,j));
    
end

pbon=0.05/(length(nid));
t_homot_thrd=t_homot .* (p_homot<pbon);

t_intraLIabst_thrd=t_intraLIabst .* (p_intraLIabst<pbon);
% homoc_R_thrd=homoc_R .* (homoc_P<pbon);
% 
% intraLIabsc_R_thrd=intraLIabsc_R .* (intraLIabsc_P<pbon);

sub_R_thrd=sub_R .* (sub_P<pbon);

SaveAsAtlasMZ3_Plot(t_homot,statspath,[statename,'_HomoFC','_T','_map','_SFICE'],cba,shp);
SaveAsAtlasMZ3_Plot(t_intraLIabst,statspath,[statename,'_IntraLIabs','_T','_map','_SFICE'],[-20,20],shp);
% SaveAsAtlasMZ3_Plot(homoc_R,statspath,[statename,'_HomoFC','_R','_map','_SFICE'],[0.001,1],shp);
% SaveAsAtlasMZ3_Plot(intraLIabsc_R,statspath,[statename,'_IntraLIabs','_R','_map','_SFICE'],[0.001,0.5],shp);
SaveAsAtlasMZ3_Plot(t_homot_thrd,statspath,[statename,'_HomoFC','_T','_map','_THRD','_SFICE'],cba,shp);
SaveAsAtlasMZ3_Plot(t_intraLIabst_thrd,statspath,[statename,'_IntraLIabs','_T','_map','_THRD','_SFICE'],[-20,20],shp);
% SaveAsAtlasMZ3_Plot(homoc_R_thrd,statspath,[statename,'_HomoFC','_R','_map','_THRD','_SFICE'],[0.001,1],shp);
% SaveAsAtlasMZ3_Plot(intraLIabsc_R_thrd,statspath,[statename,'_IntraLIabs','_R','_map','_THRD','_SFICE'],[0.001,0.5],shp);

SaveAsAtlasMZ3_Plot(sub_R,statspath,[statename,'_2sub1','_R','_map','_SFICE'],[-0.4,0.4],shp);
SaveAsAtlasMZ3_Plot(sub_R_thrd,statspath,[statename,'_2sub1','_R','_THRD','_map','_SFICE'],[-0.4,0.4],shp);
% SaveAsAtlasMZ3_Plot(LI_abs_mean2-LI_abs_mean1,statspath,[statename,'_IntraLIabs_2sub1','_map','_SFICE'],[-0.1,0.1],shp);
% 
% PlotCorr([statspath '/'],[statename '_homo_avgsubR'],mean(ho_FC1,2),mean(ho_FC2,2),term(FCS_global1)+term(FCS_global2)+cov);
% PlotCorr([statspath '/'],[statename '_intraLIabs_avgsubR'],mean(LI_intra_abs1,2),mean(LI_intra_abs2,2),term(FCS_global1)+term(FCS_global2)+cov);
% 
% SysDiv2Plot('Hierarchy',atlasflag,[0,2],[statename,'LI_abs_SUB'],statspath,LI_intra_abs2-LI_intra_abs1);


end