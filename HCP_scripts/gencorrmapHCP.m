function [HxI_Rmap,HxI_Rsub]=gencorrmapHCP(FCS,atlasflag,subid,cov,statspath,statename,COV,cbc)
% relation of HomoxIntra within each STATE

figflag=1;

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

surftype = 'inf';
projtype = 'tri';

%% Group mean - Across subject
[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
LI_intra_abs=FCS.intra_absAI(iS,:);

HomoFC_mean=mean(ho_FC)';
LI_abs_mean=mean(LI_intra_abs)';

FCS_global=FCS.global(iS,:);

if figflag==1
   [gr_homoxintraLIabs,~] =PlotCorr([statspath '/'],[statename '_HomoxIntraLIabs_avgmapR'],HomoFC_mean(nid,:),LI_abs_mean(nid,:));
end


for j=1:size(ho_FC,2)
   [homoxintraLIabsc_R(1,j),homoxintraLIabsc_P(1,j)]=partialcorr(ho_FC(:,j),LI_intra_abs(:,j),[FCS_global,COV]);   
end

HxI_Rmap.homoxintraLIabs_R=homoxintraLIabsc_R;
HxI_Rmap.homoxintraLIabs_P=homoxintraLIabsc_P;

pbon=0.05/length(nid);
homoxintraLIabsc_R_thrd=homoxintraLIabsc_R .* (homoxintraLIabsc_P<pbon);

if figflag==1
    SaveAsAtlasNii(homoxintraLIabsc_R,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_R' '_map'],1)
    SaveAsAtlasNii(homoxintraLIabsc_R_thrd,[atlasflag '2'],[statspath,'/',statename],['_HomoxIntraLIabs' '_R' '_THRD'],1)
    NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_R' '_map','.nii'],surftype,projtype,'hemi',cbc);
    NiiProj2Surf([statspath,'/',statename,'_HomoxIntraLIabs' '_R' '_THRD','.nii'],surftype,projtype,'hemi',cbc);
    PlotCorr([statspath '/'],[statename '_HomoxIntraLIabs_avgsubR'],mean(ho_FC(:,nid),2),mean(LI_intra_abs(:,nid),2),term(FCS_global)+cov);
%     SysDiv2Plot('Yeo7',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
    SysDiv2Plot('Hierarchy',atlasflag,[-1,1],[statename,'_HomoxIntraLIabs_avgsubR'],[statspath '/'],fisherR2Z(homoxintraLIabsc_R));
    
end


%% Each subject -- across regions 
for i=1:length(subid)

    HomoFC_sub=ho_FC(i,nid)';
    LI_abs_sub=LI_intra_abs(i,nid)';
    
    [homoxintraLIabsc_R_sub(i,1),homoxintraLIabsc_P_sub(i,1)]=corr(HomoFC_sub,LI_abs_sub);   
end

HxI_Rsub.homoxintraLIabs_R=homoxintraLIabsc_R_sub;
HxI_Rsub.homoxintraLIabs_P=homoxintraLIabsc_P_sub;
% 

if figflag==1
    hist_lxy(homoxintraLIabsc_R_sub,gr_homoxintraLIabs,statspath,[statename '_HomoxIntraLIabs_mapR_hist']);
end

end