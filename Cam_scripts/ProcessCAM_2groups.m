ID=load('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/subject_ID.mat');
[Caminfo,Camtext]=xlsread('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/Camfmri_information.xlsx');

% RTypes=g_ls('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/Results0227/*/*/FC_Z/');
% for i=1:4
%     REST=g_ls([RTypes{i,1} '/*.txt']);
%     [nr,~,~]=fileparts(RTypes{i,1});
%     [nr1,nr2,~]=fileparts(nr);
%     [~,nr3,~]=fileparts(nr1);
%     getFCSCAM(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/FCSmat/CAM_',nr2,'_',nr3],REST,nr2(1:3));
% end

% RTypes=g_ls('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/REST/NGR/AICHA/FC_Z/z*.txt');
% getFCSCAM('/data/stalxy/ArticleJResults/CAMCAN_fMRI/FCSmat/CAM_AICHA_NGR',RTypes,'AIC');
FCS_Rpath=g_ls('/data/stalxy/ArticleJResults/CAMCAN_Gretna/FCSmat/*.mat');
atlas_flag={'AIC','AIC','BNA','BNA'};

for k=1:4
    
af=atlas_flag{k};

%% Part1 baseline by age groups
FCS_R=load(FCS_Rpath{k});
FCS_Rstate=FCS_R.finalFCS;
[~,nm,~]=fileparts(FCS_Rpath{k});

if k==1 || k==3
%     limrange=0.8;
%     lisrange=0.5;
    limrange=0.8;
    lisrange=0.5;
elseif k==2 || k==4
%     limrange=0.3;
%     lisrange=0.2;
    limrange=0.2;
    lisrange=0.2;
end

system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/Baseline_' nm '/Homo']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/Baseline_' nm '/IntraLIabs']);

filepath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/Baseline_' nm '/*/']);

%
for i=1:652
    CCID=Camtext{i+1,1};
    CamID(i,1)=str2double(CCID(3:end));
end
% 
finalid=ID.subject_ID;
[~,~,ACam]=intersect(finalid,CamID);
g1=ACam(1:295);
g2=ACam(296:end);
[Yid,~,YAO]=intersect(finalid,CamID(g1));
[Oid,~,OAO]=intersect(finalid,CamID(g2));
YCam=g1(YAO);
OCam=g2(OAO);
genbaselinemapCAM(FCS_Rstate,af,finalid,filepath,['All_' nm],0,limrange,lisrange)
genbaselinemapCAM(FCS_Rstate,af,Yid,filepath,['Youth_' nm],0,limrange,lisrange)
genbaselinemapCAM(FCS_Rstate,af,Oid,filepath,['Old_' nm],0,limrange,lisrange)


%% Part2 compare between STATES

%% Part3 relation of HomoxIntra by groups
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/RelatedinState_' nm '/All/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/RelatedinState_' nm '/Youth/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/RelatedinState_' nm '/Middle/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/RelatedinState_' nm '/Old/']);
filecorrpath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/RelatedinState_' nm '/*']);

Yage=Caminfo(YCam,1);
Oage=Caminfo(OCam,1);
Ygender=Camtext(YCam+1,4);
Ogender=Camtext(OCam+1,4);
Ygen=Caminfo(YCam,4);
Ogen=Caminfo(OCam,4);

Aage=Caminfo(ACam,1);
Agen=Caminfo(ACam,4);
Agender=Camtext(ACam+1,4);

% 
[ALL_HxI_Rmap,ALL_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,finalid,term(Aage)+term(Agender),filecorrpath{1},['All_' nm],[Aage,Agen],[-0.6,0.6])
[Y_HxI_Rmap,Y_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Yid,term(Yage)+term(Ygender),filecorrpath{4},['Youth_' nm],[Yage,Ygen],[-0.6,0.6])
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
agegroup=[ones(295,1);ones(295,1)+1];
AgeGroup=term(var2fac(agegroup,{'Young','Old'}));
gen=Caminfo(IDod,4);
Gender=term(var2fac(gen,{'Male','Female'}));
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

statspath=['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/COM_' nm '/'];
system(['mkdir -p ' statspath]);
SaveAsAtlasNii(slmH_FAG.t,[af '3'],statspath,['AgexGenderONhomo' '_F' '_map'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map'],'.nii'],'inf','tri','hemi',[0,10]);
SaveAsAtlasNii(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGenderONhomo' '_F' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map_thresh'],'.nii'],'inf','tri','hemi',[0,10]);

SaveAsAtlasNii(slmH_TA.t,[af '3'],statspath,['AgeONhomo' '_T' '_map'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map'],'.nii'],'inf','tri','hemi',[-5,5]);
SaveAsAtlasNii(slmH_TA.t.*(p_HTA<0.05/length(nid)),[af '3'],statspath,['AgeONhomo' '_T' '_map_thresh'],1)
NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map_thresh'],'.nii'],'inf','tri','hemi',[-5,5]);

% PlotCorr([statspath '/'],['HomoavgxAge_subR'],age,mean(Homo(:,nid),2),term(gl)+term(GD));
PlotCorr([statspath '/'],['HomoSigPosxAge_subR'],age,mean(Homo(:,logical(slmH_TA.t.*(p_HTA<0.05/length(nid))>0)),2),term(gl)+term(GD));
PlotCorr([statspath '/'],['HomoSigNegxAge_subR'],age,mean(Homo(:,logical(slmH_TA.t.*(p_HTA<0.05/length(nid))<0)),2),term(gl)+term(GD));

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
% PlotCorr([statspath '/'],['LIabsavgxAge_subR'],age,mean(LIabs(:,nid),2),term(gl)+term(GD));

PlotCorr([statspath '/'],['LIabsSigPosxAge_subR'],age,mean(LIabs(:,logical(slmL_TA.t.*(p_LTA<0.05/length(nid))>0)),2),term(gl)+term(GD));
PlotCorr([statspath '/'],['LIabsSigNegxAge_subR'],age,mean(LIabs(:,logical(slmL_TA.t.*(p_LTA<0.05/length(nid))<0)),2),term(gl)+term(GD));

%Age correlation
for hl=1:max(nid)
    [homoxage_R(1,hl),homoxage_P(1,hl)]=partialcorr(age,Homo(:,hl),[gl,gen]);   
    [liabsxage_R(1,hl),liabsxage_P(1,hl)]=partialcorr(age,LIabs(:,hl),[gl,gen]);   
end

pbon=0.05/length(nid);
homoxage_R_thrd=homoxage_R .* (homoxage_P<pbon);
liabsxage_R_thrd=liabsxage_R .* (liabsxage_P<pbon);
SaveAsAtlasNii(homoxage_R,[af '3'],statspath,['AgexHomo' '_R' '_map'],1);
NiiProj2Surf([statspath,'/','AgexHomo' '_R' '_map','.nii'],'inf','tri','hemi',[-0.3 0.3]);

SaveAsAtlasNii(homoxage_R_thrd,[af '3'],statspath,['AgexHomo' '_R' '_THRD_map'],1);
NiiProj2Surf([statspath,'/','AgexHomo' '_R' '_THRD_map','.nii'],'inf','tri','hemi',[-0.3 0.3]);

SaveAsAtlasNii(liabsxage_R,[af '3'],statspath,['AgexLIabs' '_R' '_map'],1);
NiiProj2Surf([statspath,'/','AgexLIabs' '_R' '_map','.nii'],'inf','tri','hemi',[-0.3 0.3]);

SaveAsAtlasNii(liabsxage_R_thrd,[af '3'],statspath,['AgexLIabs' '_R' '_THRD_map'],1);
NiiProj2Surf([statspath,'/','AgexLIabs' '_R' '_THRD_map','.nii'],'inf','tri','hemi',[-0.3 0.3]);

% Mediation
if ~isempty(p_HTA<0.05/length(nid)) && ~isempty(p_LTA<0.05/length(nid))
    age_ef_combined=(p_HTA<0.05/length(nid)) .* (p_LTA<0.05/length(nid));
else
    age_ef_combined=[];
end
HxLI_R=[];
HxLI_P=[];
for i=1:max(nid)
   [HxLI_R(1,i),HxLI_P(1,i)]=partialcorr(Homo(:,i),LIabs(:,i),[age,gen,gl]);
end
if ~isempty(HxLI_P<0.05/length(nid)) && ~isempty(age_ef_combined)
    age_mediation=age_ef_combined .* (HxLI_P<0.05/length(nid));
else
    age_mediation=1;
end
if sum(age_mediation)>0
    AgeOutput=age;
    GenOutput=gen;
    HomOutput=Homo(:,age_mediation==1);
    LIaOutput=LIabs(:,age_mediation==1);
    HomAvg=mean(HomOutput,2);
    LIaAvg=mean(LIaOutput,2);
    MediationAge=table(AgeOutput,GenOutput,HomOutput,LIaOutput,HomAvg,LIaAvg);
    filename = ['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/MediationAge_' nm '.xlsx'];
    writetable(MediationAge,filename,'Sheet',1,'Range','A1');
    SaveAsAtlasNii(age_mediation,[af '3'],'/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/',['AgeMediation_' nm '_map'],1)
    NiiProj2Surf(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results_2groups/','/',['AgeMediation_' nm '_map'],'.nii'],'inf','tri','hemi',[0,1]);
end

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
    if sum(p_HxLa_FTAG<0.05/length(nid))>0
        PlotCorr([statspath '/'],['HomoxAgeOnLIabs'],mean(Homo(:,logical(p_HxLa_FTAG<0.05/length(nid))),2),mean(LIabs(:,logical(p_HxLa_FTAG<0.05/length(nid))),2),term(gl)+term(GD),TmpAge);
    end

end

end
% polyfit(age,y_res,1)
% polyfit(age,y_res,2)


