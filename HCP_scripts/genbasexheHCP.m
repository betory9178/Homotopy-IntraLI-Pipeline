function genbasexhe1228(FCS,subid,statspath,statename,hepath)
% heritability and its relation 

nid=[1:101,103:127,129:173,176:179,181:190,192];

hepath1=hepath{3};
hepath2=hepath{4};
hepath3=hepath{5};
hepath4=hepath{1};
hepath5=hepath{2};

he_homo=load(hepath1);
he_intraL=load(hepath2);
he_intraR=load(hepath3);
he_intraLI=load(hepath4);
he_intraLIabs=load(hepath5);

Homo_he_V=he_homo.Data(:,1);
IntraL_he_V=he_intraL.Data(:,1);
IntraR_he_V=he_intraR.Data(:,1);
LI_he_V=he_intraLI.Data(:,1);
LIabs_he_V=he_intraLIabs.Data(:,1);

Homo_he_P=he_homo.Data(:,2);
IntraL_he_P=he_intraL.Data(:,2);
IntraR_he_P=he_intraR.Data(:,2);
LI_he_P=he_intraLI.Data(:,2);
LIabs_he_P=he_intraLIabs.Data(:,2);

SaveAsAtlasNii(Homo_he_V,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraL_he',1)
SaveAsAtlasNii(IntraL_he_V,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraR_he',1)
SaveAsAtlasNii(IntraR_he_V,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'HomoFC_he',1)
SaveAsAtlasNii(LI_he_V,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraFC_LI_he',1)
SaveAsAtlasNii(LIabs_he_V,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraFC_LIabs_he',1)

NiiProj2Surf([statspath,'/',statename,'IntraL_he','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraR_he','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'HomoFC_he','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraFC_LI_he','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraFC_LIabs_he','.nii'],'inf','tri','hemi',[0 0.4]);

SaveAsAtlasNii(Homo_he_V .*(Homo_he_P<(0.05/186)),'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraL_he_thrd',1)
SaveAsAtlasNii(IntraL_he_V .*(IntraL_he_P<(0.05/186)),'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraR_he_thrd',1)
SaveAsAtlasNii(IntraR_he_V .*(IntraR_he_P<(0.05/186)),'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'HomoFC_he_thrd',1)
SaveAsAtlasNii(LI_he_V .*(LI_he_P<(0.05/186)),'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraFC_LI_he_thrd',1)
SaveAsAtlasNii(LIabs_he_V .*(LIabs_he_P<(0.05/186)),'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',[statspath,'/',statename],'IntraFC_LIabs_he_thrd',1)

NiiProj2Surf([statspath,'/',statename,'IntraL_he_thrd','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraR_he_thrd','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'HomoFC_he_thrd','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraFC_LI_he_thrd','.nii'],'inf','tri','hemi',[0 0.4]);
NiiProj2Surf([statspath,'/',statename,'IntraFC_LIabs_he_thrd','.nii'],'inf','tri','hemi',[0 0.4]);


%% Group mean - Across subject

[~,~,iS]=intersect(subid,FCS.subid);

ho_FC=FCS.homo(iS,:);
intra_LL=FCS.intra_L(iS,:);
intra_RR=FCS.intra_R(iS,:);
LI_intra=FCS.intra_AI(iS,:);
LI_intra_abs=FCS.intra_absAI(iS,:);

IntraL_mean=mean(intra_LL)';
IntraR_mean=mean(intra_RR)';
HomoFC_mean=mean(ho_FC)';
LI_mean=mean(LI_intra)';
LI_abs_mean=mean(LI_intra_abs)';


IntraL_std=std(intra_LL)';
IntraR_std=std(intra_RR)';
HomoFC_std=std(ho_FC)';
LI_std=std(LI_intra)';
LI_abs_std=std(LI_intra_abs)';

IntraL_CV=IntraL_std ./ IntraL_mean;
IntraR_CV=IntraR_std ./ IntraR_mean;
HomoFC_CV=HomoFC_std ./ HomoFC_mean;
LI_CV=LI_std ./ LI_mean;
LI_abs_CV=LI_abs_std ./ LI_abs_mean;

PlotCorr([statspath '/'],[statename '_HexHomoM_avgmapR'],Homo_he_V(nid,:),HomoFC_mean(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLM_avgmapR'],IntraL_he_V(nid,:),IntraL_mean(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraRM_avgmapR'],IntraR_he_V(nid,:),IntraR_mean(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLIM_avgmapR'],LI_he_V(nid,:),LI_mean(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLIabsM_avgmapR'],LIabs_he_V(nid,:),LI_abs_mean(nid,:));

PlotCorr([statspath '/'],[statename '_HexHomoSTD_avgmapR'],Homo_he_V(nid,:),HomoFC_std(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLSTD_avgmapR'],IntraL_he_V(nid,:),IntraL_std(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraRSTD_avgmapR'],IntraR_he_V(nid,:),IntraR_std(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLISTD_avgmapR'],LI_he_V(nid,:),LI_std(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLIabsSTD_avgmapR'],LIabs_he_V(nid,:),LI_abs_std(nid,:));

PlotCorr([statspath '/'],[statename '_HexHomoCV_avgmapR'],Homo_he_V(nid,:),HomoFC_CV(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLCV_avgmapR'],IntraL_he_V(nid,:),IntraL_CV(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraRCV_avgmapR'],IntraR_he_V(nid,:),IntraR_CV(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLICV_avgmapR'],LI_he_V(nid,:),LI_CV(nid,:));
PlotCorr([statspath '/'],[statename '_HexIntraLIabsCV_avgmapR'],LIabs_he_V(nid,:),LI_abs_CV(nid,:));
