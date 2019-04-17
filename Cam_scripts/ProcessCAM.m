ID=load('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/subject_ID.mat');
[Caminfo,Camtext]=xlsread('/data/stalxy/Pipeline4JIN/CAMCAN_fMRI/Camfmri_information.xlsx');

FCS_Rpath=g_ls('/data/stalxy/ArticleJResults/CAMCAN_Gretna/FCSmat/*.mat');
atlas_flag={'AIC','AIC','BNA','BNA'};

% for k=1:4
k=2;
af=atlas_flag{k};

%% Part1 baseline by age groups
FCS_R=load(FCS_Rpath{k});
FCS_Rstate=FCS_R.finalFCS;
[~,nm,~]=fileparts(FCS_Rpath{k});

if k==1 || k==3

    limrange=0.8;
    lisrange=0.5;
elseif k==2 || k==4

    limrange=0.2;
    lisrange=0.2;
end


system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Baseline_' nm '/Homo']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Baseline_' nm '/IntraLIabs']);

filepath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Baseline_' nm '/*/']);

shp='/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/plot.sh';

%
for i=1:652
    CCID=Camtext{i+1,1};
    CamID(i,1)=str2double(CCID(3:end));
end
% 
finalid=ID.subject_ID;
[~,~,ACam]=intersect(finalid,CamID);
YCam=ACam(Caminfo(ACam,6)==1);
MCam=ACam(Caminfo(ACam,6)==2);
OCam=ACam(Caminfo(ACam,6)==3);
[Yid,~,~]=intersect(finalid,CamID(YCam));
[Mid,~,~]=intersect(finalid,CamID(MCam));
[Oid,~,~]=intersect(finalid,CamID(OCam));


genbaselinemapCAM(FCS_Rstate,af,Yid,filepath,['Youth_' nm],limrange,lisrange,shp)
genbaselinemapCAM(FCS_Rstate,af,Mid,filepath,['Middle_' nm],limrange,lisrange,shp)
genbaselinemapCAM(FCS_Rstate,af,Oid,filepath,['Old_' nm],limrange,lisrange,shp)


%% Part2 compare between STATES

%% Part3 relation of HomoxIntra by groups
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/RelatedinState_' nm '/Youth/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/RelatedinState_' nm '/Middle/']);
system(['mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/RelatedinState_' nm '/Old/']);
filecorrpath=g_ls(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/RelatedinState_' nm '/*']);

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


[Y_HxI_Rmap,Y_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Yid,term(Yage)+term(Ygender),filecorrpath{3},['Youth_' nm],[Yage,Ygen],[-0.5,-0.001],shp)
[M_HxI_Rmap,M_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Mid,term(Mage)+term(Mgender),filecorrpath{1},['Middle_' nm],[Mage,Mgen],[-0.5,-0.001],shp)
[O_HxI_Rmap,O_HxI_Rsub]=gencorrmapCAM(FCS_Rstate,af,Oid,term(Oage)+term(Ogender),filecorrpath{2},['Old_' nm],[Oage,Ogen],[-0.5,-0.001],shp)


%% Part4 compare relations of HomoxIntra across STATES


%% Part5 age effect
if strcmp(af,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(af,'BNA')
    nid=[1:123];
end

surftype = 'inf';
projtype = 'tri';

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

statspath=['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/COM_' nm '/'];
system(['mkdir -p ' statspath]);
% SaveAsAtlasNii(slmH_FAG.t,[af '3'],statspath,['AgexGenderONhomo' '_F' '_map'],1)
% NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map'],'.nii'],'inf',projtype,'hemi',[0,10]);
% SaveAsAtlasNii(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGenderONhomo' '_F' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgexGenderONhomo' '_F' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[0,10]);
SaveAsAtlasMZ3_Plot(slmH_FAG.t,statspath,['AgexGenderONhomo' '_F' '_map','_SFICE'],[0.001,10],shp);
SaveAsAtlasMZ3_Plot(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),statspath,['AgexGenderONhomo' '_F' '_map_thresh','_SFICE'],[0.001,10],shp);

% SaveAsAtlasNii(slmH_TA.t,[af '3'],statspath,['AgeONhomo' '_T' '_map'],1)
% NiiProj2Surf([statspath,'/',['AgeONhomo' '_T' '_map'],'.nii'],'inf',projtype,'hemi',[-5,5]);
% SaveAsAtlasNii(slmH_TA.t.*(slmH_TA.t>0).*(p_HTA<0.05/length(nid)),[af '3'],statspath,['AgeONhomo' '_Tpos' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgeONhomo' '_Tpos' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[-8,8]);
% SaveAsAtlasNii(slmH_TA.t.*(slmH_TA.t<0).*(p_HTA<0.05/length(nid)),[af '3'],statspath,['AgeONhomo' '_Tneg' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgeONhomo' '_Tneg' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[-8,8]);
% SaveAsAtlasMZ3_Plot(slmH_TA.t,statspath,['AgeONhomo' '_T' '_map','_SFICE'],[-5,5],shp);
SaveAsAtlasMZ3_Plot(slmH_TA.t.*(slmH_TA.t>0).*(p_HTA<0.05/length(nid)),statspath,['AgeONhomo' '_Tpos' '_map_thresh','_SFICE'],[0.001,8],shp);
SaveAsAtlasMZ3_Plot(slmH_TA.t.*(slmH_TA.t<0).*(p_HTA<0.05/length(nid)),statspath,['AgeONhomo' '_Tneg' '_map_thresh','_SFICE'],[-8,-0.001],shp);

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

% SaveAsAtlasNii(slmL_FAG.t,[af '3'],statspath,['AgexGenderONLIabs' '_F' '_map'],1)
% NiiProj2Surf([statspath,'/',['AgexGenderONLIabs' '_F' '_map'],'.nii'],'inf',projtype,'hemi',[0,10]);
% SaveAsAtlasNii(slmL_FAG.t.*(p_LFTAG<0.05/length(nid)),[af '3'],statspath,['AgexGenderONLIabs' '_F' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgexGenderONLIabs' '_F' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[0,10]);
SaveAsAtlasMZ3_Plot(slmL_FAG.t,statspath,['AgexGenderONLIabs' '_F' '_map','_SFICE'],[0.001,10],shp);
SaveAsAtlasMZ3_Plot(slmL_FAG.t.*(p_LFTAG<0.05/length(nid)),statspath,['AgexGenderONLIabs' '_F' '_map_thresh','_SFICE'],[0.001,10],shp);


% SaveAsAtlasNii(slmL_TA.t,[af '3'],statspath,['AgeONLIabs' '_T' '_map'],1)
% NiiProj2Surf([statspath,'/',['AgeONLIabs' '_T' '_map'],'.nii'],'inf',projtype,'hemi',[-5,5]);
% SaveAsAtlasNii(slmL_TA.t.*(slmL_TA.t>0).*(p_LTA<0.05/length(nid)),[af '3'],statspath,['AgeONLIabs' '_Tpos' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgeONLIabs' '_Tpos' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[-8,8]);
% SaveAsAtlasNii(slmL_TA.t.*(slmL_TA.t<0).*(p_LTA<0.05/length(nid)),[af '3'],statspath,['AgeONLIabs' '_Tneg' '_map_thresh'],1)
% NiiProj2Surf([statspath,'/',['AgeONLIabs' '_Tneg' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[-8,8]);
% SaveAsAtlasMZ3_Plot(slmL_TA.t,statspath,['AgeONLIabs' '_T' '_map','_SFICE'],[-5,5],shp);
SaveAsAtlasMZ3_Plot(slmL_TA.t.*(slmL_TA.t>0).*(p_LTA<0.05/length(nid)),statspath,['AgeONLIabs' '_Tpos' '_map_thresh','_SFICE'],[0.001,8],shp);
SaveAsAtlasMZ3_Plot(slmL_TA.t.*(slmL_TA.t<0).*(p_LTA<0.05/length(nid)),statspath,['AgeONLIabs' '_Tneg' '_map_thresh','_SFICE'],[-8,-0.001],shp);


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
% SaveAsAtlasNii(homoxage_R,[af '3'],statspath,['AgexHomo' '_R' '_map'],1);
% NiiProj2Surf([statspath,'/','AgexHomo' '_R' '_map','.nii'],'inf',projtype,'hemi',[-0.3 0.3]);
SaveAsAtlasMZ3_Plot(homoxage_R,statspath,['AgexHomo' '_R' '_map','_SFICE'],[-0.3 0.3],shp);

% SaveAsAtlasNii(homoxage_R_thrd,[af '3'],statspath,['AgexHomo' '_R' '_THRD_map'],1);
% NiiProj2Surf([statspath,'/','AgexHomo' '_R' '_THRD_map','.nii'],'inf',projtype,'hemi',[-0.3 0.3]);
SaveAsAtlasMZ3_Plot(homoxage_R_thrd,statspath,['AgexHomo' '_R' '_THRD_map','_SFICE'],[-0.3 0.3],shp);

% SaveAsAtlasNii(liabsxage_R,[af '3'],statspath,['AgexLIabs' '_R' '_map'],1);
% NiiProj2Surf([statspath,'/','AgexLIabs' '_R' '_map','.nii'],'inf',projtype,'hemi',[-0.3 0.3]);
SaveAsAtlasMZ3_Plot(liabsxage_R,statspath,['AgexLIabs' '_R' '_map','_SFICE'],[-0.3 0.3],shp);

% SaveAsAtlasNii(liabsxage_R_thrd,[af '3'],statspath,['AgexLIabs' '_R' '_THRD_map'],1);
% NiiProj2Surf([statspath,'/','AgexLIabs' '_R' '_THRD_map','.nii'],'inf',projtype,'hemi',[-0.3 0.3]);
SaveAsAtlasMZ3_Plot(liabsxage_R_thrd,statspath,['AgexLIabs' '_R' '_THRD_map','_SFICE'],[-0.3 0.3],shp);

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
    system('mkdir -p /data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Mediation/');
    AgeOutput=age;
    GenOutput=gen;
    HomOutput=Homo(:,age_mediation==1);
    LIaOutput=LIabs(:,age_mediation==1);
    HomAvg=mean(HomOutput,2);
    LIaAvg=mean(LIaOutput,2);
    MediationAge=table(AgeOutput,GenOutput,HomOutput,LIaOutput,HomAvg,LIaAvg);
    filename = ['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Mediation/MediationAge_' nm '.xlsx'];
    writetable(MediationAge,filename,'Sheet',1,'Range','A1');
%     SaveAsAtlasNii(age_mediation,[af '3'],'/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Mediation/',['AgeMediation_' nm '_map'],1)
%     NiiProj2Surf(['/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Mediation/','/',['AgeMediation_' nm '_map'],'.nii'],'inf',projtype,'hemi',[0,1]);
    SaveAsAtlasMZ3_Plot(age_mediation,'/data/stalxy/ArticleJResults/CAMCAN_Gretna/Results/Mediation/',[['AgeMediation_' nm '_map'],'_SFICE'],[0.001,1],shp);

end

%HomoxLIabs Plot
% PlotCorr([statspath '/'],['HomoxLIabsRxAge_subR'],age,ALL_HxI_Rsub.homoxintraLIabs_R,term(gl)+term(GD));

%HomoxLIabs
% agetemp={Age,AgeGroup};
% agename={'AgeConti','AgeGroup'};
% for j=1:2
%     TmpAge=agetemp{j};
%     MHxLa_i=1+term(Homo)+TmpAge+term(Homo)*TmpAge+Gender+GL;
%     MHxLa=1+term(Homo)+TmpAge+Gender+GL;
%     
%     MLaxH_i=1+term(LIabs)+TmpAge+term(LIabs)*TmpAge+Gender+GL;
%     MLaxH=1+term(LIabs)+TmpAge+Gender+GL;
%     
%     slmHxLa_I=SurfStatLinMod(LIabs,MHxLa_i);
%     slmHxLa=SurfStatLinMod(LIabs,MHxLa);
%     
%     slmLaxH_I=SurfStatLinMod(Homo,MLaxH_i);
%     slmLaxH=SurfStatLinMod(Homo,MLaxH);
%     
%     slmHxLa_FAG=SurfStatF(slmHxLa_I,slmHxLa);
%     slmLaxH_FAG=SurfStatF(slmLaxH_I,slmLaxH);
%     
%     p_HxLa_FTAG=1-fcdf(slmHxLa_FAG.t,slmHxLa_FAG.df(1),slmHxLa_FAG.df(2));
%     p_LaxH_FTAG=1-fcdf(slmLaxH_FAG.t,slmLaxH_FAG.df(1),slmLaxH_FAG.df(2));
%     
%     SaveAsAtlasNii(slmHxLa_FAG.t,[af '3'],statspath,[agename{j},'xHomoONLIabs' '_F' '_map'],1)
%     NiiProj2Surf([statspath,'/',[agename{j},'xHomoONLIabs' '_F' '_map'],'.nii'],'inf',projtype,'hemi',[0,3]);
%     SaveAsAtlasNii(slmHxLa_FAG.t.*(p_HxLa_FTAG<0.05/length(nid)),[af '3'],statspath,[agename{j},'xHomoONLIabs' '_F' '_map_thresh'],1)
%     NiiProj2Surf([statspath,'/',[agename{j},'xHomoONLIabs' '_F' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[0,3]);
%     SaveAsAtlasMZ3_Plot(slmHxLa_FAG.t,statspath,[[agename{j},'xHomoONLIabs' '_F' '_map'],'_SFICE'],[0,3],shp);
%     SaveAsAtlasMZ3_Plot(slmHxLa_FAG.t.*(p_HxLa_FTAG<0.05/length(nid)),statspath,[[agename{j},'xHomoONLIabs' '_F' '_map_thresh'],'_SFICE'],[0,3],shp);
% 
%     SaveAsAtlasNii(slmLaxH_FAG.t,[af '3'],statspath,[agename{j},'xLIabsONHomo' '_T' '_map'],1)
%     NiiProj2Surf([statspath,'/',[agename{j},'xLIabsONHomo' '_T' '_map'],'.nii'],'inf',projtype,'hemi',[0,3]);
%     SaveAsAtlasNii(slmLaxH_FAG.t.*(p_LaxH_FTAG<0.05/length(nid)),[af '3'],statspath,[agename{j},'xLIabsONHomo' '_T' '_map_thresh'],1)
%     NiiProj2Surf([statspath,'/',[agename{j},'xLIabsONHomo' '_T' '_map_thresh'],'.nii'],'inf',projtype,'hemi',[0,3]);
%     SaveAsAtlasMZ3_Plot(slmLaxH_FAG.t,statspath,[[agename{j},'xLIabsONHomo' '_F' '_map'],'_SFICE'],[0,3],shp);
%     SaveAsAtlasMZ3_Plot(slmLaxH_FAG.t.*(p_LaxH_FTAG<0.05/length(nid)),statspath,[[agename{j},'xLIabsONHomo' '_F' '_map_thresh'],'_SFICE'],[0,3],shp);
%     
%     if sum(p_HxLa_FTAG<0.05/length(nid))>0
%         PlotCorr([statspath '/'],[agename{j},'HomoxAgeOnLIabs'],mean(Homo(:,logical(p_HxLa_FTAG<0.05/length(nid))),2),mean(LIabs(:,logical(p_HxLa_FTAG<0.05/length(nid))),2),term(gl)+term(GD),AgeGroup);
%     end
% end

% end



