function genbaselinemapHCP(FCS,atlasflag,subid,statpath,statename,limrange,lisrange,shp)
% baseline

statspath3=statpath{1};
statspath5=statpath{2};

surftype = 'inf';
projtype = 'tri';

%% Group mean - Across subject

[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
AI_intra_abs=FCS.intra_absAI(iS,:);

% SysDiv2Plot('Yeo7',atlasflag,[0,2],[statename,'Homo'],statspath3,ho_FC);
% SysDiv2Plot('Yeo7',atlasflag,[0,1],[statename,'IntraLIabs'],statspath5,AI_intra_abs);

SysDiv2Plot('Hierarchy',atlasflag,[0,2],[statename,'Homo'],statspath3,ho_FC);
SysDiv2Plot('Hierarchy',atlasflag,[0,1],[statename,'IntraLIabs'],statspath5,AI_intra_abs);


HomoFC_mean=mean(ho_FC)';
HomoFC_std=std(ho_FC)';

SaveAsAtlasNii(HomoFC_mean,[atlasflag '2'],[statspath3,'/',statename],'HomoFC_mean',1)
SaveAsAtlasNii(HomoFC_std,[atlasflag '2'],[statspath3,'/',statename],'HomoFC_std',1)

    NiiProj2Surf([statspath3,'/',statename,'HomoFC_mean','.nii'],surftype,projtype,'hemi',[0 1.8]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_std','.nii'],surftype,projtype,'hemi',[0 0.3]);
    
SaveAsAtlasMZ3_Plot(HomoFC_mean,statspath3,[statename,'HomoFC_mean','_SFICE'],[0.001 1.8],shp);
SaveAsAtlasMZ3_Plot(HomoFC_std,statspath3,[statename,'HomoFC_std','_SFICE'],[0.001 0.3],shp);

AI_abs_mean=mean(AI_intra_abs)';
AI_abs_std=std(AI_intra_abs)';

SaveAsAtlasNii(AI_abs_mean,[atlasflag '2'],[statspath5,'/',statename],'IntraFC_LIabs_mean',1)
SaveAsAtlasNii(AI_abs_std,[atlasflag '2'],[statspath5,'/',statename],'IntraFC_LIabs_std',1)

    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_mean','.nii'],surftype,projtype,'hemi',[0 limrange]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_std','.nii'],surftype,projtype,'hemi',[0 lisrange]);

SaveAsAtlasMZ3_Plot(AI_abs_mean,statspath5,[statename,'IntraFC_LIabs_mean','_SFICE'],[0.001 limrange],shp);
SaveAsAtlasMZ3_Plot(AI_abs_std,statspath5,[statename,'IntraFC_LIabs_std','_SFICE'],[0.001 lisrange],shp);
% 
% HomoFC_CV=HomoFC_std ./ abs(HomoFC_mean);
% AI_abs_CV=AI_abs_std ./ abs(AI_abs_mean);
% SaveAsAtlasNii(HomoFC_CV,[atlasflag '2'],[statspath3,'/',statename],'HomoFC_CV',1)
% SaveAsAtlasNii(AI_abs_CV,[atlasflag '2'],[statspath5,'/',statename],'IntraFC_LIabs_CV',1)
% HomoFC_qcd= (quantile(ho_FC,.75)-quantile(ho_FC,.25))./ (quantile(ho_FC,.75)+quantile(ho_FC,.25));
% AI_abs_qcd= (quantile(AI_intra_abs,.75)-quantile(AI_intra_abs,.25))./ (quantile(AI_intra_abs,.75)+quantile(AI_intra_abs,.25));
% SaveAsAtlasNii(HomoFC_qcd,[atlasflag '2'],[statspath3,'/',statename],'HomoFC_qcd',1)
% SaveAsAtlasNii(AI_abs_qcd,[atlasflag '2'],[statspath5,'/',statename],'IntraFC_LIabs_qcd',1)
%    NiiProj2Surf([statspath3,'/',statename,'HomoFC_CV','.nii'],surftype,projtype,'hemi',[-1 1]);
%     NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_CV','.nii'],surftype,projtype,'hemi',[-2 2]);
%    NiiProj2Surf([statspath3,'/',statename,'HomoFC_qcd','.nii'],surftype,projtype,'hemi',[0 0.5]);
%     NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_qcd','.nii'],surftype,projtype,'hemi',[0 0.5]);

    
%% single sub
% load('/data/stalxy/Pipeline4JIN/ResultsRe/unirandsub.mat');
unirandsub=[180129;206727];
for i=1:2
    [~,~,Cid]=intersect(unirandsub(i),subid);
    HomoFC_sub=ho_FC(Cid,:)';
    
%     SaveAsAtlasNii(HomoFC_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath3,'/',statename],['HomoFC' '_sub' num2str(unirandsub(i))],1)
%     NiiProj2Surf([statspath3,'/',statename,'HomoFC','_sub' num2str(unirandsub(i)),'.nii'],surftype,projtype,'hemi',[0 1.8]);
    SaveAsAtlasMZ3_Plot(HomoFC_sub,statspath3,[statename,'HomoFC','_sub' num2str(unirandsub(i)),'_SFICE'],[0.001 1.8],shp);

    AI_abs_sub=AI_intra_abs(Cid,:)';
%     SaveAsAtlasNii(AI_abs_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath5,'/',statename],['IntraFC_LIabs' '_sub' num2str(unirandsub(i))],1)
%     NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs','_sub' num2str(unirandsub(i)),'.nii'],surftype,projtype,'hemi',[0 limrange]);
    SaveAsAtlasMZ3_Plot(AI_abs_sub,statspath5,[statename,'IntraFC_LIabs','_sub' num2str(unirandsub(i)),'_SFICE'],[0.001 limrange],shp);
    
end