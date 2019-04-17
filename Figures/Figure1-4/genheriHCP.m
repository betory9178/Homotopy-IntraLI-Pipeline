HCP_heri_path='/data/stalxy/ArticleJResults/HCP/heri/';
shp=[HCP_heri_path,'plot_0408.sh'];
ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
subid=ID.StID;

coheri=load('/data/stalxy/sharefolder/HCP/CodeFromJIN/genetic_correlation.mat');

atlasflag='AIC';
surftype = 'inf';
projtype = 'tri';

Homo_r1=load([HCP_heri_path,'rest1_homo.mat']);
Homo_t=load([HCP_heri_path,'task_homo.mat']);
% Homo_diff=load([HCP_heri_path,'task_rest_homo.mat']);

LIabs_r1=load([HCP_heri_path,'rest1_absLI.mat']);
LIabs_t=load([HCP_heri_path,'task_absLI.mat']);
% LIabs_diff=load([HCP_heri_path,'task_rest_absLI.mat']);

SaveAsAtlasNii(Homo_r1.Data(:,1).*(Homo_r1.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_Rest1_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_Rest1_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(Homo_r1.Data(:,1).*(Homo_r1.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['Homo_Rest1_heritability','_SFICE'],[0.001,0.5],shp);

SaveAsAtlasNii(Homo_r1.Data(:,1),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_Rest1_heritability_unthresh',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_Rest1_heritability_unthresh','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(Homo_r1.Data(:,1),[HCP_heri_path,'/Figures/'],['Homo_Rest1_heritability_unthresh','_SFICE'],[0,0.5],shp);

SaveAsAtlasNii(Homo_t.Data(:,1).*(Homo_t.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_Task_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_Task_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(Homo_t.Data(:,1).*(Homo_t.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['Homo_Task_heritability','_SFICE'],[0.001,0.5],shp);

% SaveAsAtlasNii(Homo_diff.Data(:,1).*(Homo_diff.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_diff_heritability',1)
% NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_diff_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
% SaveAsAtlasMZ3_Plot(Homo_diff.Data(:,1).*(Homo_diff.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['Homo_diff_heritability','_SFICE'],[0.001,0.5],shp);

SaveAsAtlasNii(LIabs_r1.Data(:,1).*(LIabs_r1.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_Rest1_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_Rest1_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(LIabs_r1.Data(:,1).*(LIabs_r1.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['LIabs_Rest1_heritability','_SFICE'],[0.001,0.5],shp);

SaveAsAtlasNii(LIabs_r1.Data(:,1),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_Rest1_heritability_unthresh',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_Rest1_heritability_unthresh','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(LIabs_r1.Data(:,1),[HCP_heri_path,'/Figures/'],['LIabs_Rest1_heritability_unthresh','_SFICE'],[0,0.5],shp);

SaveAsAtlasNii(LIabs_t.Data(:,1).*(LIabs_t.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_Task_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_Task_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
SaveAsAtlasMZ3_Plot(LIabs_t.Data(:,1).*(LIabs_t.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['LIabs_Task_heritability','_SFICE'],[0.001,0.5],shp);

% SaveAsAtlasNii(LIabs_diff.Data(:,1).*(LIabs_diff.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_diff_heritability',1)
% NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_diff_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);
% SaveAsAtlasMZ3_Plot(LIabs_diff.Data(:,1).*(LIabs_diff.Data(:,2)<(0.05/190)),[HCP_heri_path,'/Figures/'],['LIabs_diff_heritability','_SFICE'],[0.001,0.5],shp);

herirelated=zeros(192,1);
herirelated([1:174,176:190,192])=coheri.RHOG;
SaveAsAtlasNii(herirelated,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Coheri_Rest1',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Coheri_Rest1','.nii'],surftype,projtype,'hemi',[-1,1]);
SaveAsAtlasMZ3_Plot(herirelated,[HCP_heri_path,'/Figures/'],['Coheri_Rest1','_SFICE'],[-1,1],shp);

herirBonf=zeros(192,1);
herirBonf([1:174,176:190,192])=coheri.rhog0bf;
SaveAsAtlasNii(herirBonf,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Coheri_Rest1_bonf',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Coheri_Rest1_bonf','.nii'],surftype,projtype,'hemi',[-1,0]);
SaveAsAtlasMZ3_Plot(herirBonf,[HCP_heri_path,'/Figures/'],['Coheri_Rest1_bonf','_SFICE'],[-1,1],shp);



H_homo_r=Homo_r1.Data(:,1);
H_homo_t=Homo_t.Data(:,1);
diff_homo=H_homo_t-H_homo_r;
diff_homo_std=abs(diff_homo)> (1.96 .* (Homo_r1.Data(:,3)+Homo_t.Data(:,3)));

diff_homo_thr=diff_homo.* diff_homo_std.*(Homo_r1.Data(:,2)<(0.05/190)).*(Homo_t.Data(:,2)<(0.05/190));

SaveAsAtlasNii(diff_homo_thr,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_StateDiff_Sig',1);
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_StateDiff_Sig','.nii'],surftype,projtype,'hemi',[-0.5 0.5]);
SaveAsAtlasMZ3_Plot(diff_homo_thr,[HCP_heri_path,'/Figures/'],['Homo_StateDiff_Sig','_SFICE'],[0.001,0.5],shp);

H_LIabs_r=LIabs_r1.Data(:,1);
H_LIabs_t=LIabs_t.Data(:,1);
diff_LIabs=H_LIabs_t-H_LIabs_r;
diff_LIabs_std=abs(diff_LIabs)> (1.96 .* (LIabs_r1.Data(:,3)+LIabs_t.Data(:,3)));

diff_LIabs_thr=diff_LIabs.* diff_LIabs_std.*(LIabs_r1.Data(:,2)<(0.05/190)).*(LIabs_t.Data(:,2)<(0.05/190));

SaveAsAtlasNii(diff_LIabs_thr,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_StateDiff_Sig',1);
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_StateDiff_Sig','.nii'],surftype,projtype,'hemi',[-0.5 0.5]);
SaveAsAtlasMZ3_Plot(diff_LIabs_thr,[HCP_heri_path,'/Figures/'],['LIabs_StateDiff_Sig','_SFICE'],[0.001,0.5],shp);

% relation between heritability and original value 
% [~,~,iS]=intersect(subid,FCS.subid);
% 
% ho_FC=FCS.homo(iS,:);
% LI_intra_abs=FCS.intra_absAI(iS,:);
% 
% 
% HomoFC_mean=mean(ho_FC)';
% LI_abs_mean=mean(LI_intra_abs)';
% 
% 
% PlotCorr([statspath '/'],[statename '_HexHomoM_avgmapR'],Homo_he_V(nid,:),HomoFC_mean(nid,:));
% PlotCorr([statspath '/'],[statename '_HexIntraLIabsM_avgmapR'],LIabs_he_V(nid,:),LI_abs_mean(nid,:));
