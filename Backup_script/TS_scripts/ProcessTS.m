ID=load('/data/stalxy/TSFC/SubInfo_45XOandNC.mat');

% RTypes1=g_ls('/data/stalxy/TSFC/REST_Gretna/GR/AICHA/FC_Z/z*.txt');
% RTypes2=g_ls('/data/stalxy/TSFC/REST_Gretna/NGR/AICHA/FC_Z/z*.txt');
% RTypes3=g_ls('/data/stalxy/TSFC/REST_Gretna/GR/BNA/FC_Z/z*.txt');
% RTypes4=g_ls('/data/stalxy/TSFC/REST_Gretna/NGR/BNA/FC_Z/z*.txt');
% 
% getFCSTS('/data/stalxy/ArticleJResults/TSFC/FCSmat/TSR_AICHA_GR',RTypes1,'AIC');
% getFCSTS('/data/stalxy/ArticleJResults/TSFC/FCSmat/TSR_AICHA_NGR',RTypes2,'AIC');
% getFCSTS('/data/stalxy/ArticleJResults/TSFC/FCSmat/TSR_BNA_GR',RTypes3,'BNA');
% getFCSTS('/data/stalxy/ArticleJResults/TSFC/FCSmat/TSR_BNA_NGR',RTypes4,'BNA');
FCS_Rpath=g_ls('/data/stalxy/ArticleJResults/TSFC/FCSmat/*.mat');
atlas_flag={'AIC','AIC','BNA','BNA'};

for k=1:4

af=atlas_flag{k};

%% Part1 baseline
FCS_R=load(FCS_Rpath{k});
FCS_Rstate=FCS_R.finalFCS;
[~,nm,~]=fileparts(FCS_Rpath{k});

system(['mkdir -p /data/stalxy/ArticleJResults/TSFC/Results/Baseline_' nm '/Homo']);
system(['mkdir -p /data/stalxy/ArticleJResults/TSFC/Results/Baseline_' nm '/IntraLIabs']);
filepath=g_ls(['/data/stalxy/ArticleJResults/TSFC/Results/Baseline_' nm '/*/']);

exclude=[22;28;34];
finalid=setdiff(ID.ID,exclude);
TSID=intersect(ID.ID(strcmp(ID.Group,'Nonmosaic')),finalid);
NCID=intersect(ID.ID(strcmp(ID.Group,'NC_female1')),finalid);
genbaselinemapTS(FCS_Rstate,af,TSID,filepath,['TS_' nm],0)
genbaselinemapTS(FCS_Rstate,af,NCID,filepath,['NC_' nm],0)


%% Part2 compare between STATES

%% Part3 relation of HomoxIntra within each STATE
system(['mkdir -p /data/stalxy/ArticleJResults/TSFC/Results/RelatedinState_' nm '/TS/']);
system(['mkdir -p /data/stalxy/ArticleJResults/TSFC/Results/RelatedinState_' nm '/NC/']);
filecorrpath=g_ls(['/data/stalxy/ArticleJResults/TSFC/Results/RelatedinState_' nm '/*']);
[~,TSod,~]=intersect(ID.ID,TSID);
[~,NCod,~]=intersect(ID.ID,NCID);

TSage=ID.Age(TSod);
NCage=ID.Age(NCod);
[TS_HxI_Rmap,TS_HxI_Rsub]=gencorrmapTS(FCS_Rstate,af,TSID,TSage,filecorrpath{2},['TS_' nm],[-20,20],[-0.6,0.6])
[NC_HxI_Rmap,NC_HxI_Rsub]=gencorrmapTS(FCS_Rstate,af,NCID,NCage,filecorrpath{1},['NC_' nm],[-20,20],[-0.6,0.6])


%% Part4 compare relations of HomoxIntra across STATES


%% Part5 heritability and its relation 
if strcmp(af,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(af,'BNA')
    nid=[1:123];
end

[~,IDod,~]=intersect(ID.ID,finalid);
Homo=FCS_Rstate.homo(IDod,:);
LIabs=FCS_Rstate.intra_absAI(IDod,:);
gl=FCS_Rstate.global(IDod);
GL=term(gl);
age=ID.Age(IDod);
Age=term(age);
group=ID.Group(IDod);
Group=term(group);

M=1+Age+Group+GL;
Mi=1+Age+Group+Age*Group+GL;
slmH=SurfStatLinMod(Homo,M);
slmHi=SurfStatLinMod(Homo,Mi);

slmH_FAG=SurfStatF(slmHi,slmH);
slmH_TA=SurfStatT(slmH,age);
slmH_TG=SurfStatT(slmH,Group.NC_female1-Group.Nonmosaic);

p_HFTAG=1-fcdf(slmH_FAG.t,slmH_FAG.df(1),slmH_FAG.df(2));
p_HTA=2*tcdf(-1*abs(slmH_TA.t),slmH_TA.df);
p_HTG=2*tcdf(-1*abs(slmH_TG.t),slmH_TG.df);

statspath=['/data/stalxy/ArticleJResults/TSFC/Results/COM_' nm '/'];
system(['mkdir -p ' statspath]);
SaveAsAtlasNii(slmH_FAG.t,[af '3'],statspath,['AgexGroupONhomo' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONhomo' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGroupONhomo' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONhomo' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmH_TA.t,[af '3'],statspath,['AgeONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TA.t.*(p_HTA<0.05/length(nid)),[af '3'],statspath,['AgeONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

SaveAsAtlasNii(slmH_TG.t,[af '3'],statspath,['NCvTS_GroupONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TG.t.*(p_HTG<0.05/length(nid)),[af '3'],statspath,['NCvTS_GroupONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

slmL=SurfStatLinMod(LIabs,M);
slmLi=SurfStatLinMod(LIabs,Mi);

slmL_FAG=SurfStatF(slmLi,slmL);
slmL_TA=SurfStatT(slmL,age);
slmL_TG=SurfStatT(slmL,Group.NC_female1-Group.Nonmosaic);

p_LFTAG=1-fcdf(slmL_FAG.t,slmL_FAG.df(1),slmL_FAG.df(2));
p_LTA=2*tcdf(-1*abs(slmL_TA.t),slmL_TA.df);
p_LTG=2*tcdf(-1*abs(slmL_TG.t),slmL_TG.df);

SaveAsAtlasNii(slmL_FAG.t,[af '3'],statspath,['AgexGroupONLIabs' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONLIabs' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmL_FAG.t.*(p_LFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGroupONLIabs' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONLIabs' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmL_TA.t,[af '3'],statspath,['AgeONLIabs' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmL_TA.t.*(p_LTA<0.05/length(nid)),[af '3'],statspath,['AgeONLIabs' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

SaveAsAtlasNii(slmL_TG.t,[af '3'],statspath,['NCvTS_GroupONLIabs' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONLIabs' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmL_TG.t.*(p_LTG<0.05/length(nid)),[af '3'],statspath,['NCvTS_GroupONLIabs' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONLIabs' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);
PlotCorr([statspath '/'],'NCvTS_GroupONLIabs_clus1',group,LIabs(:,p_LTG<0.05/length(nid)),[age,gl],[]);

for i=1:max(nid)
    MGIh=1+Age+term(Homo(:,i))+Group+GL;
    MGIhi=1+Age+term(Homo(:,i))+Group+term(Homo(:,i))*Group+GL;
    MGIl=1+Age+term(LIabs(:,i))+Group+GL;
    MGIli=1+Age+term(LIabs(:,i))+Group+term(LIabs(:,i))*Group+GL;
    slmHxLh=SurfStatLinMod(LIabs(:,i),MGIh);
    slmHxLhi=SurfStatLinMod(LIabs(:,i),MGIhi);
    slmHxLl=SurfStatLinMod(Homo(:,i),MGIl);
    slmHxLli=SurfStatLinMod(Homo(:,i),MGIli);
    
    slmHxLh_F=SurfStatF(slmHxLhi,slmHxLh);
    slmHxLl_F=SurfStatF(slmHxLli,slmHxLl);
    F_HxLh(1,i)=slmHxLh_F.t;
    F_HxLl(1,i)=slmHxLl_F.t;
    p_HxLh_F(1,i)=1-fcdf(slmHxLh_F.t,slmHxLh_F.df(1),slmHxLh_F.df(2));
    p_HxLl_F(1,i)=1-fcdf(slmHxLl_F.t,slmHxLl_F.df(1),slmHxLl_F.df(2));
end

SaveAsAtlasNii(F_HxLh,[af '3'],statspath,['HomoxGroupONLIabs' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['HomoxGroupONLIabs' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(F_HxLh.*(p_HxLh_F<0.05/length(nid)),[af '3'],statspath,['HomoxGroupONLIabs' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['HomoxGroupONLIabs' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);
 
SaveAsAtlasNii(F_HxLl,[af '3'],statspath,['LIabsxGroupONHomo' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['LIabsxGroupONHomo' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(F_HxLl.*(p_HxLl_F<0.05/length(nid)),[af '3'],statspath,['LIabsxGroupONHomo' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['LIabsxGroupONHomo' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

PlotCorr([statspath '/'],'GroupEffect_HomoxLIabs_similarityacrossregions',[ID.Group(TSod);ID.Group(NCod)],fisherR2Z([TS_HxI_Rsub.homoxintraLIabs_R;NC_HxI_Rsub.homoxintraLIabs_R]),[ID.Age(TSod);ID.Age(NCod)]);
PlotCorr([statspath '/'],'Similaritybetweengroups_HomoxLIabs_similarityacrosssubjects',fisherR2Z(TS_HxI_Rmap.homoxintraLIabs_R(nid)'),fisherR2Z(NC_HxI_Rmap.homoxintraLIabs_R(nid)'),[]);

end