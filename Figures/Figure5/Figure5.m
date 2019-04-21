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
elseif k==2 || k==4
    limrange=0.2;
end

filepath='/data/stalxy/ArticleJResults/Figures/Figure5/';
shp='/data/stalxy/ArticleJResults/Figures/Figure5_plot.sh';
system(['rm ' shp]);

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


F5basemap(FCS_Rstate,af,Yid,filepath,['Youth_' nm],limrange,shp);
F5basemap(FCS_Rstate,af,Mid,filepath,['Middle_' nm],limrange,shp);
F5basemap(FCS_Rstate,af,Oid,filepath,['Old_' nm],limrange,shp);

%% Part3 relation of HomoxIntra by groups

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


F5corrmap(FCS_Rstate,af,Yid,term(Yage)+term(Ygender),filepath,['Youth_' nm],[Yage,Ygen],[-0.5,0.5],shp);
F5corrmap(FCS_Rstate,af,Mid,term(Mage)+term(Mgender),filepath,['Middle_' nm],[Mage,Mgen],[-0.5,0.5],shp);
F5corrmap(FCS_Rstate,af,Oid,term(Oage)+term(Ogender),filepath,['Old_' nm],[Oage,Ogen],[-0.5,0.5],shp);

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

statspath=filepath;

%Homo
M=1+Age+Gender+GL;
Mi=1+Age+Gender+Age*Gender+GL;
slmH=SurfStatLinMod(Homo,M);
slmHi=SurfStatLinMod(Homo,Mi);

slmH_FAG=SurfStatF(slmHi,slmH);
slmH_TA=SurfStatT(slmH,age);

p_HFTAG=1-fcdf(slmH_FAG.t,slmH_FAG.df(1),slmH_FAG.df(2));
p_HTA=2*tcdf(-1*abs(slmH_TA.t),slmH_TA.df);

% SaveAsAtlasMZ3_Plot(slmH_FAG.t,statspath,['AgexGenderONhomo' '_F' '_map','_SFICE'],[0.001,10],shp);
% SaveAsAtlasMZ3_Plot(slmH_FAG.t.*(p_HFTAG<0.05/length(nid)),statspath,['AgexGenderONhomo' '_F' '_map_thresh','_SFICE'],[0.001,10],shp);

SaveAsAtlasMZ3_Plot(slmH_TA.t.*(slmH_TA.t>0).*(p_HTA<0.05/length(nid)),statspath,['AgeONhomo' '_Tpos' '_map_thresh','_SFICE'],[-8,8],shp);
SaveAsAtlasMZ3_Plot(slmH_TA.t.*(slmH_TA.t<0).*(p_HTA<0.05/length(nid)),statspath,['AgeONhomo' '_Tneg' '_map_thresh','_SFICE'],[-8,8],shp);

PlotCorr([statspath '/'],['HomoSigPosxAge_subR'],age,mean(Homo(:,logical(slmH_TA.t.*(p_HTA<0.05/length(nid))>0)),2),term(gl)+term(GD));
PlotCorr([statspath '/'],['HomoSigNegxAge_subR'],age,mean(Homo(:,logical(slmH_TA.t.*(p_HTA<0.05/length(nid))<0)),2),term(gl)+term(GD));

%LIabs

slmL=SurfStatLinMod(LIabs,M);
slmLi=SurfStatLinMod(LIabs,Mi);

slmL_FAG=SurfStatF(slmLi,slmL);
slmL_TA=SurfStatT(slmL,age);

p_LFTAG=1-fcdf(slmL_FAG.t,slmL_FAG.df(1),slmL_FAG.df(2));
p_LTA=2*tcdf(-1*abs(slmL_TA.t),slmL_TA.df);

% SaveAsAtlasMZ3_Plot(slmL_FAG.t,statspath,['AgexGenderONLIabs' '_F' '_map','_SFICE'],[0.001,10],shp);
% SaveAsAtlasMZ3_Plot(slmL_FAG.t.*(p_LFTAG<0.05/length(nid)),statspath,['AgexGenderONLIabs' '_F' '_map_thresh','_SFICE'],[0.001,10],shp);

SaveAsAtlasMZ3_Plot(slmL_TA.t.*(slmL_TA.t>0).*(p_LTA<0.05/length(nid)),statspath,['AgeONLIabs' '_Tpos' '_map_thresh','_SFICE'],[-8,8],shp);
SaveAsAtlasMZ3_Plot(slmL_TA.t.*(slmL_TA.t<0).*(p_LTA<0.05/length(nid)),statspath,['AgeONLIabs' '_Tneg' '_map_thresh','_SFICE'],[-8,8],shp);

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

SaveAsAtlasMZ3_Plot(homoxage_R,statspath,['AgexHomo' '_R' '_map','_SFICE'],[-0.3 0.3],shp);
SaveAsAtlasMZ3_Plot(homoxage_R_thrd,statspath,['AgexHomo' '_R' '_THRD_map','_SFICE'],[-0.3 0.3],shp);
SaveAsAtlasMZ3_Plot(liabsxage_R,statspath,['AgexLIabs' '_R' '_map','_SFICE'],[-0.3 0.3],shp);
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
    system(['mkdir -p ' filepath '/Mediation/']);
    AgeOutput=age;
    GenOutput=gen;
    HomOutput=Homo(:,age_mediation==1);
    LIaOutput=LIabs(:,age_mediation==1);
    HomAvg=mean(HomOutput,2);
    LIaAvg=mean(LIaOutput,2);
    MediationAge=table(AgeOutput,GenOutput,HomOutput,LIaOutput,HomAvg,LIaAvg);
    filename = [filepath '/Mediation/MediationAge_' nm '.xlsx'];
    writetable(MediationAge,filename,'Sheet',1,'Range','A1');
    SaveAsAtlasMZ3_Plot(age_mediation,[filepath '/Mediation/'],[['AgeMediation_' nm '_map'],'_SFICE'],[-1,1],shp);

end




