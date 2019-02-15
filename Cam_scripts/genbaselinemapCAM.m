function genbaselinemapCAM(FCS,atlasflag,subid,statpath,statename,colorflag)
% baseline

% statspath1=statpath{1};
% statspath2=statpath{5};
statspath3=statpath{1};
% statspath4=statpath{3};
statspath5=statpath{2};

%% Group mean - Across subject

[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
% intra_LL=FCS.intra_L(iS,:);
% intra_RR=FCS.intra_R(iS,:);
% AI_intra=FCS.intra_AI(iS,:);
AI_intra_abs=FCS.intra_absAI(iS,:);

SysDiv2Plot('Yeo7',atlasflag,[0,2],[statename,'Homo'],statspath3,ho_FC);
% SysDiv2Plot('Yeo7',[statename,'IntraL'],statspath1,intra_LL);
% SysDiv2Plot('Yeo7',[statename,'IntraR'],statspath2,intra_RR);
% SysDiv2Plot('Yeo7',[statename,'IntraLI'],statspath4,AI_intra);
SysDiv2Plot('Yeo7',atlasflag,[0,1],[statename,'IntraLIabs'],statspath5,AI_intra_abs);

SysDiv2Plot('Hierarchy',atlasflag,[0,2],[statename,'Homo'],statspath3,ho_FC);
% SysDiv2Plot('Hierarchy',[statename,'IntraL'],statspath1,intra_LL);
% SysDiv2Plot('Hierarchy',[statename,'IntraR'],statspath2,intra_RR);
% SysDiv2Plot('Hierarchy',[statename,'IntraLI'],statspath4,AI_intra);
SysDiv2Plot('Hierarchy',atlasflag,[0,1],[statename,'IntraLIabs'],statspath5,AI_intra_abs);

% IntraL_mean=mean(intra_LL)';
% IntraR_mean=mean(intra_RR)';
HomoFC_mean=mean(ho_FC)';
% 
% IntraL_std=std(intra_LL)';
% IntraR_std=std(intra_RR)';
HomoFC_std=std(ho_FC)';

% SaveAsAtlasNii(IntraL_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath1,'/',statename],'IntraL_mean',1)
% SaveAsAtlasNii(IntraR_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath2,'/',statename],'IntraR_mean',1)
SaveAsAtlasNii(HomoFC_mean,[atlasflag '3'],[statspath3,'/',statename],'HomoFC_mean',1)
% SaveAsAtlasNii(IntraL_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath1,'/',statename],'IntraL_std',1)
% SaveAsAtlasNii(IntraR_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath2,'/',statename],'IntraR_std',1)
SaveAsAtlasNii(HomoFC_std,[atlasflag '3'],[statspath3,'/',statename],'HomoFC_std',1)

if colorflag==-1
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_mean','.nii'],'inf','cubic','hemi',[-40 0]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_mean','.nii'],'inf','cubic','hemi',[-40 0]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_mean','.nii'],'inf','cubic','hemi',[-1 0]);
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_std','.nii'],'inf','cubic','hemi',[0 30]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_std','.nii'],'inf','cubic','hemi',[0 30]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_std','.nii'],'inf','cubic','hemi',[0 0.5]);
else
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_mean','.nii'],'inf','cubic','hemi',[0 80]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_mean','.nii'],'inf','cubic','hemi',[0 80]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_mean','.nii'],'inf','cubic','hemi',[0 1.8]);
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_std','.nii'],'inf','cubic','hemi',[0 20]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_std','.nii'],'inf','cubic','hemi',[0 20]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_std','.nii'],'inf','cubic','hemi',[0 0.4]);
end

% AI_mean=mean(AI_intra)';
AI_abs_mean=mean(AI_intra_abs)';

% AI_std=std(AI_intra)';
AI_abs_std=std(AI_intra_abs)';

% SaveAsAtlasNii(AI_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath4,'/',statename],'IntraFC_LI_mean',1)
SaveAsAtlasNii(AI_abs_mean,[atlasflag '3'],[statspath5,'/',statename],'IntraFC_LIabs_mean',1)
% SaveAsAtlasNii(AI_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath4,'/',statename],'IntraFC_LI_std',1)
SaveAsAtlasNii(AI_abs_std,[atlasflag '3'],[statspath5,'/',statename],'IntraFC_LIabs_std',1)

if colorflag==-1
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_mean','.nii'],'inf','cubic','hemi',[-0.3 0.3]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_mean','.nii'],'inf','cubic','hemi',[0 0.6]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_std','.nii'],'inf','cubic','hemi',[0 0.6]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_std','.nii'],'inf','cubic','hemi',[0 0.6]);
else
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_mean','.nii'],'inf','cubic','hemi',[-0.3 0.3]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_mean','.nii'],'inf','cubic','hemi',[0 0.3]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_std','.nii'],'inf','cubic','hemi',[0 0.2]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_std','.nii'],'inf','cubic','hemi',[0 0.2]);
end

% IntraL_CV=IntraL_std ./ abs(IntraL_mean);
% IntraR_CV=IntraR_std ./ abs(IntraR_mean);
HomoFC_CV=HomoFC_std ./ abs(HomoFC_mean);
% AI_CV=AI_std ./ abs(AI_mean);
AI_abs_CV=AI_abs_std ./ abs(AI_abs_mean);

% SaveAsAtlasNii(IntraL_CV,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath1,'/',statename],'IntraL_CV',1)
% SaveAsAtlasNii(IntraR_CV,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath2,'/',statename],'IntraR_CV',1)
SaveAsAtlasNii(HomoFC_CV,[atlasflag '3'],[statspath3,'/',statename],'HomoFC_CV',1)
% SaveAsAtlasNii(AI_CV,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath4,'/',statename],'IntraFC_LI_CV',1)
SaveAsAtlasNii(AI_abs_CV,[atlasflag '3'],[statspath5,'/',statename],'IntraFC_LIabs_CV',1)

% IntraL_qcd= (quantile(intra_LL,.75)-quantile(intra_LL,.25))./ (quantile(intra_LL,.75)+quantile(intra_LL,.25));
% IntraR_qcd= (quantile(intra_RR,.75)-quantile(intra_RR,.25))./ (quantile(intra_RR,.75)+quantile(intra_RR,.25));
HomoFC_qcd= (quantile(ho_FC,.75)-quantile(ho_FC,.25))./ (quantile(ho_FC,.75)+quantile(ho_FC,.25));
% AI_qcd= (quantile(AI_intra,.75)-quantile(AI_intra,.25))./ (quantile(AI_intra,.75)+quantile(AI_intra,.25));
AI_abs_qcd= (quantile(AI_intra_abs,.75)-quantile(AI_intra_abs,.25))./ (quantile(AI_intra_abs,.75)+quantile(AI_intra_abs,.25));

% SaveAsAtlasNii(IntraL_qcd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath1,'/',statename],'IntraL_qcd',1)
% SaveAsAtlasNii(IntraR_qcd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath2,'/',statename],'IntraR_qcd',1)
SaveAsAtlasNii(HomoFC_qcd,[atlasflag '3'],[statspath3,'/',statename],'HomoFC_qcd',1)
% SaveAsAtlasNii(AI_qcd,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath4,'/',statename],'IntraFC_LI_qcd',1)
SaveAsAtlasNii(AI_abs_qcd,[atlasflag '3'],[statspath5,'/',statename],'IntraFC_LIabs_qcd',1)

if colorflag==-1
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_CV','.nii'],'inf','cubic','hemi',[-3 3]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_CV','.nii'],'inf','cubic','hemi',[-3 3]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_CV','.nii'],'inf','cubic','hemi',[-3 3]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_CV','.nii'],'inf','cubic','hemi',[-35 35]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_CV','.nii'],'inf','cubic','hemi',[0 1]);

%     NiiProj2Surf([statspath1,'/',statename,'IntraL_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_qcd','.nii'],'inf','cubic','hemi',[-1.5 1.5]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
    
else
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_CV','.nii'],'inf','cubic','hemi',[-1 1]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_CV','.nii'],'inf','cubic','hemi',[-1 1]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_CV','.nii'],'inf','cubic','hemi',[-1 1]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_CV','.nii'],'inf','cubic','hemi',[-15 15]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_CV','.nii'],'inf','cubic','hemi',[-2 2]);
    
%     NiiProj2Surf([statspath1,'/',statename,'IntraL_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
    NiiProj2Surf([statspath3,'/',statename,'HomoFC_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI_qcd','.nii'],'inf','cubic','hemi',[-1.5 1.5]);
    NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs_qcd','.nii'],'inf','cubic','hemi',[0 0.5]);
end
%% single sub
% load('/data/stalxy/Pipeline4JIN/ResultsRe/unirandsub.mat');
% unirandsub=[180129;206727];
% for i=1:2
%     [~,~,Cid]=intersect(unirandsub(i),subid);
%     IntraL_sub=intra_LL(Cid,:)';
%     IntraR_sub=intra_RR(Cid,:)';
%     HomoFC_sub=ho_FC(Cid,:)';
%     
%     SaveAsAtlasNii(IntraL_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath1,'/',statename],['IntraL' '_sub' num2str(unirandsub(i))],1)
%     SaveAsAtlasNii(IntraR_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath2,'/',statename],['IntraR' '_sub' num2str(unirandsub(i))],1)
%     SaveAsAtlasNii(HomoFC_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath3,'/',statename],['HomoFC' '_sub' num2str(unirandsub(i))],1)
%     
%     NiiProj2Surf([statspath1,'/',statename,'IntraL','_sub' num2str(unirandsub(i)),'.nii'],'inf','cubic','hemi',[0 80]);
%     NiiProj2Surf([statspath2,'/',statename,'IntraR','_sub' num2str(unirandsub(i)),'.nii'],'inf','cubic','hemi',[0 80]);
%     NiiProj2Surf([statspath3,'/',statename,'HomoFC','_sub' num2str(unirandsub(i)),'.nii'],'inf','cubic','hemi',[0 1.8]);
%     
%     
%     AI_sub=AI_intra(Cid,:)';
%     AI_abs_sub=AI_intra_abs(Cid,:)';
%     
%     SaveAsAtlasNii(AI_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath4,'/',statename],['IntraFC_LI' '_sub' num2str(unirandsub(i))],1)
%     SaveAsAtlasNii(AI_abs_sub,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath5,'/',statename],['IntraFC_LIabs' '_sub' num2str(unirandsub(i))],1)
%     
%     NiiProj2Surf([statspath4,'/',statename,'IntraFC_LI','_sub' num2str(unirandsub(i)),'.nii'],'inf','cubic','hemi',[-0.3 0.3]);
%     NiiProj2Surf([statspath5,'/',statename,'IntraFC_LIabs','_sub' num2str(unirandsub(i)),'.nii'],'inf','cubic','hemi',[0 0.3]);
%     
% end