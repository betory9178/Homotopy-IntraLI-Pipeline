ID=load('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/subject_ID.mat');
[Caminfo,Camtext]=xlsread('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/Camfmri_information.xlsx');

% RTypes=g_ls('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/REST/*/*/FC_Z/');
% for i=1:4
%     REST=g_ls([RTypes{i,1} '/*.txt']);
%     [nr,~,~]=fileparts(RTypes{i,1});
%     [nr1,nr2,~]=fileparts(nr);
%     [~,nr3,~]=fileparts(nr1);
%     getFCSCAM(['/data/stalxy/ArticleJResults/CAMCAN_fMRI/FCSmat/CAM_',nr2,'_',nr3],REST,nr2(1:3));
% end

% RTypes=g_ls('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/REST/NGR/AICHA/FC_Z/z*.txt');
% getFCSCAM('/data/stalxy/ArticleJResults/CAMCAN_fMRI/FCSmat/CAM_AICHA_NGR',RTypes,'AIC');
FCS_Rpath=g_ls('/data/stalxy/ArticleJResults/CAMCAN_fMRI/FCSmat/*.mat');
atlas_flag={'AIC','AIC','BNA','BNA'};

for k=1:4
    
af=atlas_flag{k};

%% Part1 baseline by age groups
FCS_R=load(FCS_Rpath{k});
FCS_Rstate=FCS_R.finalFCS;
[~,nm,~]=fileparts(FCS_Rpath{k});

system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/Baseline_' nm '/Homo']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/Baseline_' nm '/IntraLIabs']);

filepath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/Baseline_' nm '/*/']);


for i=1:652
    CCID=Camtext{i+1,1};
    CamID(i,1)=str2double(CCID(3:end));
end

finalid=ID.subject_ID;
[Yid,Yfinal,YCam]=intersect(finalid,CamID((Caminfo(:,6)==1)));
[Mid,Mfinal,MCam]=intersect(finalid,CamID((Caminfo(:,6)==2)));
[Oid,Ofinal,OCam]=intersect(finalid,CamID((Caminfo(:,6)==3)));
[~,~,ACam]=intersect(finalid,CamID);

genbaselinemapCAM(FCS_Rstate,af,finalid,filepath,['All_' nm],0)
genbaselinemapCAM(FCS_Rstate,af,Yid,filepath,['Youth_' nm],0)
genbaselinemapCAM(FCS_Rstate,af,Mid,filepath,['Middle_' nm],0)
genbaselinemapCAM(FCS_Rstate,af,Oid,filepath,['Old_' nm],0)


%% Part2 compare between STATES

%% Part3 relation of HomoxIntra by groups
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/RelatedinState_' nm '/All/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/RelatedinState_' nm '/Youth/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/RelatedinState_' nm '/Middle/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/RelatedinState_' nm '/Old/']);
filecorrpath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/RelatedinState_' nm '/*']);

Yage=Caminfo(YCam,1);
Mage=Caminfo(MCam,1);
Oage=Caminfo(OCam,1);
Ygender=Camtext(YCam+1,4);
Mgender=Camtext(MCam+1,4);
Ogender=Camtext(OCam+1,4);
Ygen=Caminfo(YCam,4);
Mgen=Caminfo(MCam,4);
Ogen=Caminfo(OCam,4);

Aage=Caminfo(ACam,1);
Agen=Caminfo(ACam,4);
Agender=Camtext(ACam+1,4);


[ALL_HxI_Rmap,ALL_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,finalid,term(Aage)+term(Agender),filecorrpath{1},['All_' nm],[Aage,Agen],[-0.6,0.6])
[Y_HxI_Rmap,Y_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Yid,term(Yage)+term(Ygender),filecorrpath{4},['Youth_' nm],[Yage,Ygen],[-0.6,0.6])
[M_HxI_Rmap,M_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Mid,term(Mage)+term(Mgender),filecorrpath{2},['Middle_' nm],[Mage,Mgen],[-0.6,0.6])
[O_HxI_Rmap,O_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Oid,term(Oage)+term(Ogender),filecorrpath{3},['Old_' nm],[Oage,Ogen],[-0.6,0.6])


%% Part4 compare relations of HomoxIntra across STATES


%% Part5 age effect
if strcmp(af,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(af,'BNA')
    nid=[1:123];
end

[~,IDod,~]=intersect(CamID,finalid);
[~,IDodata,~]=intersect(FCS_Rstate.subid,finalid);

Homo=FCS_Rstate.homo(IDodata,:);
LIabs=FCS_Rstate.intra_absAI(IDodata,:);
gl=FCS_Rstate.global(IDodata);
GL=term(gl);
age=Caminfo(IDod,1);
Age=term(age);
agegroup=Caminfo(IDod,6);
AgeGroup=term(var2fac(agegroup));
gen=Caminfo(IDod,4);
Gender=term(var2fac(gen));
GD=Camtext(IDod+1,4);

%Homo
M=1+Age+Gender+GL;
Mi=1+Age+Gender+Age*Gender+GL;
slmH=SurfStatLinMod(Homo,M);
slmHi=SurfStatLinMod(Homo,Mi);

slmH_FAG=SurfStatF(slmHi,slmH);
slmH_TA=SurfStatT(slmH,age);

p_HFTAG=1-fcdf(slmH_FAG.t,slmH_FAG.df(1),slmH_FAG.df(2));
p_HTA=2*tcdf(-1*abs(slmH_TA.t),slmH_TA.df);

statspath=['/data/stalxy/ArticleJResults/CAMCAN_fMRI/Results/COM_' nm '/'];
system(['mkdir -p ' statspath]);
SaveAsAtlasNii(slmH_FAG.t,[af '3'],statspath,['AgexGenderONhomo' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGenderONhomo' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmH_TA.t,[af '3'],statspath,['AgeONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TA.t.*(p_HTA<0.05/length(nid)),[af '3'],statspath,['AgeONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

PlotCorr([statspath '/'],['HomoavgxAge_subR'],age,mean(Homo(:,nid),2),term(gl)+term(age)+term(GD));

%LIabs

slmL=SurfStatLinMod(LIabs,M);
slmLi=SurfStatLinMod(LIabs,Mi);

slmL_FAG=SurfStatF(slmLi,slmL);
slmL_TA=SurfStatT(slmL,age);

p_LFTAG=1-fcdf(slmL_FAG.t,slmL_FAG.df(1),slmL_FAG.df(2));
p_LTA=2*tcdf(-1*abs(slmL_TA.t),slmL_TA.df);

SaveAsAtlasNii(slmL_FAG.t,[af '3'],statspath,['AgexGenderONLIabs' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONLIabs' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmL_FAG.t.*(p_LFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGenderONLIabs' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONLIabs' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmL_TA.t,[af '3'],statspath,['AgeONLIabs' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmL_TA.t.*(p_LTA<0.05/length(nid)),[af '3'],statspath,['AgeONLIabs' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);
PlotCorr([statspath '/'],['LIabsavgxAge_subR'],age,mean(LIabs(:,nid),2),term(gl)+term(age)+term(GD));

%HomoxLIabs Plot
PlotCorr([statspath '/'],['HomoxLIabsRxAge_subR'],age,ALL_HxI_Rsub.homoxintraLIabs_R,term(gl)+term(GD));

%HomoxLIabs
agetemp={Age,AgeGroup};
agename={'AgeConti','AgeGroup'};
for j=1:2
    TmpAge=agetemp{j};
    MHxLa_i=1+term(Homo)+TmpAge+term(Homo)*TmpAge+Gender+GL;
    MHxLa=1+term(Homo)+TmpAge+Gender+GL;
    
    MLaxH_i=1+term(LIabs)+TmpAge+term(LIabs)*TmpAge+Gender+GL;
    MLaxH=1+term(LIabs)+TmpAge+Gender+GL;
    
    slmHxLa_I=SurfStatLinMod(LIabs,MHxLa_i);
    slmHxLa=SurfStatLinMod(LIabs,MHxLa);
    
    slmLaxH_I=SurfStatLinMod(Homo,MLaxH_i);
    slmLaxH=SurfStatLinMod(Homo,MLaxH);
    
    slmHxLa_FAG=SurfStatF(slmHxLa_I,slmHxLa);
    slmLaxH_FAG=SurfStatF(slmLaxH_I,slmLaxH);
    
    p_HxLa_FTAG=1-fcdf(slmHxLa_FAG.t,slmHxLa_FAG.df(1),slmHxLa_FAG.df(2));
    p_LaxH_FTAG=1-fcdf(slmLaxH_FAG.t,slmLaxH_FAG.df(1),slmLaxH_FAG.df(2));
    
    SaveAsAtlasNii(slmHxLa_FAG.t,[af '3'],statspath,[agename{j},'xHomoONLIabs' '_F' '_map'],1)
    NiiProj2Surf([statspath,'/',[agename{j},'xHomoONLIabs' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,3]);
    SaveAsAtlasNii(slmHxLa_FAG.t.*(p_HxLa_FTAG<0.05/length(nid)),[af '3'],statspath,[agename{j},'xHomoONLIabs' '_F' '_map_thresh'],1)
    NiiProj2Surf([statspath,'/',[agename{j},'xHomoONLIabs' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,3]);
    
    SaveAsAtlasNii(slmLaxH_FAG.t,[af '3'],statspath,[agename{j},'xLIabsONHomo' '_T' '_map'],1)
    NiiProj2Surf([statspath,'/',[agename{j},'xLIabsONHomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[0,3]);
    SaveAsAtlasNii(slmLaxH_FAG.t.*(p_LaxH_FTAG<0.05/length(nid)),[af '3'],statspath,[agename{j},'xLIabsONHomo' '_T' '_map_thresh'],1)
    NiiProj2Surf([statspath,'/',[agename{j},'xLIabsONHomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,3]);
end

end
% polyfit(age,y_res,1)
% polyfit(age,y_res,2)

