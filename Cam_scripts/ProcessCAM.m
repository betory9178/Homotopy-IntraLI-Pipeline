ID=load('/data/stalxy/TSFC/SubInfo_45XOandNC.mat');
AICHApath='/data/stalxy/Pipeline4JIN/atlas/Cam_Turner_3mm/AICHA.nii';
% RTypes=g_ls('/data/stalxy/TSFC/REST/NGR/FC_Z/z*_AICHA.txt');
% for i=1:4
%     REST1=g_ls([RTypes{i,1} '/*.mat']);
%     [~,nr,~]=fileparts(RTypes{i,1});
%     getFCS1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/REST1_',nr1],REST1,nr1(1:3));
% end

RTypes=g_ls('/data/stalxy/TSFC/REST/NGR/FC_Z/z*_AICHA.txt');

getFCSTS('/data/stalxy/TSFC/FCSmat/TSR_AICHA',RTypes,'AIC');

%% Part1 baseline
system(['mkdir /data/stalxy/TSFC/Results/Baseline/Homo']);
system(['mkdir /data/stalxy/TSFC/Results/Baseline/IntraLIabs']);

filepath=g_ls('/data/stalxy/TSFC/Results/Baseline/*/');
FCS_R=load('/data/stalxy/TSFC/FCSmat/TSR_AICHA.mat');
FCS_Rstate=FCS_R.finalFCS;

exclude=[22;28;34];
finalid=setdiff(ID.ID,exclude);
TSID=intersect(ID.ID(strcmp(ID.Group,'Nonmosaic')),finalid);
NCID=intersect(ID.ID(strcmp(ID.Group,'NC_female1')),finalid);
genbaselinemapTS(FCS_Rstate,TSID,filepath,'TS_AICHA_NG_',0)
genbaselinemapTS(FCS_Rstate,NCID,filepath,'NC_AICHA_NG_',0)


% filesppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SpecialCheck/*/');
% genbaselinemap(FCS_Rstate1,ID.ID_rest_task,filesppath,'Rstate1_')
% genbaselinemap(FCS_Rstate2,ID.ID_rest_task,filesppath,'Rstate2_')
% genbaselinemap(FCS_TstateALL,ID.ID_rest_task,filesppath,'Tstateall_')

%% Part2 compare between STATES

%% Part3 relation of HomoxIntra within each STATE
system(['mkdir /data/stalxy/TSFC/Results/RelatedinState/TS/']);
system(['mkdir /data/stalxy/TSFC/Results/RelatedinState/NC/']);
filecorrpath=g_ls('/data/stalxy/TSFC/Results/RelatedinState/*');
[~,TSod,~]=intersect(ID.ID,TSID);
[~,NCod,~]=intersect(ID.ID,NCID);

TSage=ID.Age(TSod);
NCage=ID.Age(NCod);
[TS_HxI_Rmap,TS_HxI_Rsub]=gencorrmapTS(FCS_Rstate,TSID,TSage,filecorrpath{2},'TS_AICHA_NG',[-20,20],[-0.6,0.6])
[NC_HxI_Rmap,NC_HxI_Rsub]=gencorrmapTS(FCS_Rstate,NCID,NCage,filecorrpath{1},'NC_AICHA_NG',[-20,20],[-0.6,0.6])


%% Part4 compare relations of HomoxIntra across STATES


%% Part5 heritability and its relation 

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

statspath='/data/stalxy/TSFC/Results/COM/';
SaveAsAtlasNii(slmH_FAG.t,AICHApath,statspath,['AgexGroupONhomo' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONhomo' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmH_FAG.t.*(p_HFTAG<0.05/190),AICHApath,statspath,['AgexGroupONhomo' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONhomo' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmH_TA.t,AICHApath,statspath,['AgeONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TA.t.*(p_HTA<0.05/190),AICHApath,statspath,['AgeONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

SaveAsAtlasNii(slmH_TG.t,AICHApath,statspath,['NCvTS_GroupONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TG.t.*(p_HTG<0.05/190),AICHApath,statspath,['NCvTS_GroupONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

slmL=SurfStatLinMod(LIabs,M);
slmLi=SurfStatLinMod(LIabs,Mi);

slmL_FAG=SurfStatF(slmLi,slmL);
slmL_TA=SurfStatT(slmL,age);
slmL_TG=SurfStatT(slmL,Group.NC_female1-Group.Nonmosaic);

p_LFTAG=1-fcdf(slmL_FAG.t,slmL_FAG.df(1),slmL_FAG.df(2));
p_LTA=2*tcdf(-1*abs(slmL_TA.t),slmL_TA.df);
p_LTG=2*tcdf(-1*abs(slmL_TG.t),slmL_TG.df);

SaveAsAtlasNii(slmL_FAG.t,AICHApath,statspath,['AgexGroupONLIabs' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONLIabs' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmL_FAG.t.*(p_LFTAG<0.05/190),AICHApath,statspath,['AgexGroupONLIabs' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGroupONLIabs' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmL_TA.t,AICHApath,statspath,['AgeONLIabs' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmL_TA.t.*(p_LTA<0.05/190),AICHApath,statspath,['AgeONLIabs' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

SaveAsAtlasNii(slmL_TG.t,AICHApath,statspath,['NCvTS_GroupONLIabs' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONLIabs' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmL_TG.t.*(p_LTG<0.05/190),AICHApath,statspath,['NCvTS_GroupONLIabs' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['NCvTS_GroupONLIabs' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);
PlotCorr([statspath '/'],'NCvTS_GroupONLIabs_clus1',group,LIabs(:,p_LTG<0.05/190),[age,gl],[]);



PlotCorr([statspath '/'],'GroupEffect_HomoxLIabs_similarityacrossregions',[ID.Group(TSod);ID.Group(NCod)],fisherR2Z([TS_HxI_Rsub.homoxintraLIabs_R;NC_HxI_Rsub.homoxintraLIabs_R]),[ID.Age(TSod);ID.Age(NCod)]);
nid=[1:174,176:190,192]
PlotCorr([statspath '/'],'Similaritybetweengroups_HomoxLIabs_similarityacrosssubjects',fisherR2Z(TS_HxI_Rmap.homoxintraLIabs_R(nid)'),fisherR2Z(NC_HxI_Rmap.homoxintraLIabs_R(nid)'),[]);

