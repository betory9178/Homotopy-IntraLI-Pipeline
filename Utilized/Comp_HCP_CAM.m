IDHCP=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
IDCAM=load('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/subject_ID.mat');
[Caminfo,Camtext]=xlsread('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/Camfmri_information.xlsx');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_R2path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST2_*.mat');

FCS_R_CAMpath=g_ls('/data/stalxy/ArticleJResults/CAMCAN_Gretna/FCSmat/*.mat');

atlas_flag={'AICHA_GR','AICHA_NGR','BNA_GR','BNA_NGR'};

for k=1:4
af=atlas_flag{k};

if strcmp(af(1:3),'AIC')
    nsize=192;
    nid=[1:174,176:190,192];
elseif strcmp(af(1:3),'BNA')
    nsize=123;
    nid=[1:123];
end

%% HCP

FCS_R1=load(FCS_R1path{k});
FCS_R2=load(FCS_R2path{k});

FCS_HRstate1=FCS_R1.finalFCS;
FCS_HRstate2=FCS_R2.finalFCS;

[~,~,HiS1]=intersect(IDHCP.StID,FCS_HRstate1.subid);

Hho_FC1=FCS_HRstate1.homo(HiS1,:);
HLI_intra_abs1=FCS_HRstate1.intra_absAI(HiS1,:);
HHomo_mean1=mean(Hho_FC1)';
HLI_mean1=mean(HLI_intra_abs1)';

[~,~,HiS2]=intersect(IDHCP.StID,FCS_HRstate2.subid);

Hho_FC2=FCS_HRstate2.homo(HiS2,:);
HLI_intra_abs2=FCS_HRstate2.intra_absAI(HiS2,:);
HHomo_mean2=mean(Hho_FC2)';
HLI_mean2=mean(HLI_intra_abs2)';


%% CAM_CAN
FCS_R=load(FCS_R_CAMpath{k});
FCS_CRstate=FCS_R.finalFCS;

for i=1:652
    CCID=Camtext{i+1,1};
    CamID(i,1)=str2double(CCID(3:end));
end

finalid=IDCAM.subject_ID;
[Yid,Yfinal,YCam]=intersect(finalid,CamID((Caminfo(:,6)==1)));
% [Mid,Mfinal,MCam]=intersect(finalid,CamID((Caminfo(:,6)==2)));
% [Oid,Ofinal,OCam]=intersect(finalid,CamID((Caminfo(:,6)==3)));

[~,~,CiS]=intersect(Yid,FCS_CRstate.subid);

Cho_FC=FCS_CRstate.homo(CiS,:);
CLI_intra_abs=FCS_CRstate.intra_absAI(CiS,:);
CHomo_mean=mean(Cho_FC)';
CLI_mean=mean(CLI_intra_abs)';

%% Plot

PlotCorr('/data/stalxy/ArticleJResults/Similarity_HCPxCAM/',['HCP1xCAMy_Homo_' af '_RofMeanMap'],HHomo_mean1(nid),CHomo_mean(nid))
PlotCorr('/data/stalxy/ArticleJResults/Similarity_HCPxCAM/',['HCP2xCAMy_Homo_' af '_RofMeanMap'],HLI_mean1(nid),CLI_mean(nid))
PlotCorr('/data/stalxy/ArticleJResults/Similarity_HCPxCAM/',['HCP1xCAMy_LIabs_' af '_RofMeanMap'],HHomo_mean2(nid),CHomo_mean(nid))
PlotCorr('/data/stalxy/ArticleJResults/Similarity_HCPxCAM/',['HCP2xCAMy_LIabs_' af '_RofMeanMap'],HLI_mean2(nid),CLI_mean(nid))

end