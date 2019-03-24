HCP_heri_path='/data/stalxy/ArticleJResults/HCP/heri/';

atlasflag='AIC';
surftype = 'inf';
projtype = 'ec';

Homo_r1=load([HCP_heri_path,'rest1_homo.mat']);
Homo_t=load([HCP_heri_path,'task_homo.mat']);
Homo_diff=load([HCP_heri_path,'task_rest_homo.mat']);

LIabs_r1=load([HCP_heri_path,'rest1_absLI.mat']);
LIabs_t=load([HCP_heri_path,'task_absLI.mat']);
LIabs_diff=load([HCP_heri_path,'task_rest_absLI.mat']);

SaveAsAtlasNii(Homo_r1.Data(:,1).*(Homo_r1.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_Rest1_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_Rest1_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);

SaveAsAtlasNii(Homo_t.Data(:,1).*(Homo_t.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_Task_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_Task_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);

SaveAsAtlasNii(Homo_diff.Data(:,1).*(Homo_diff.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_diff_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_diff_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);

SaveAsAtlasNii(LIabs_r1.Data(:,1).*(LIabs_r1.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_Rest1_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_Rest1_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);

SaveAsAtlasNii(LIabs_t.Data(:,1).*(LIabs_t.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_Task_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_Task_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);

SaveAsAtlasNii(LIabs_diff.Data(:,1).*(LIabs_diff.Data(:,2)<(0.05/190)),[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_diff_heritability',1)
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_diff_heritability','.nii'],surftype,projtype,'hemi',[0,0.5]);



H_homo_r=Homo_r1.Data(:,1);
H_homo_t=Homo_t.Data(:,1);
diff_homo=H_homo_t-H_homo_r;
diff_homo_std=abs(diff_homo)> (1.96 .* (Homo_r1.Data(:,3)+Homo_t.Data(:,3)));

diff_homo_thr=diff_homo.* diff_homo_std.*(Homo_r1.Data(:,2)<(0.05/190)).*(Homo_t.Data(:,2)<(0.05/190));

SaveAsAtlasNii(diff_homo_thr,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'Homo_StateDiff_Sig',1);
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','Homo_StateDiff_Sig','.nii'],surftype,projtype,'hemi',[-0.5 0.5]);

H_LIabs_r=LIabs_r1.Data(:,1);
H_LIabs_t=LIabs_t.Data(:,1);
diff_LIabs=H_LIabs_t-H_LIabs_r;
diff_LIabs_std=abs(diff_LIabs)> (1.96 .* (LIabs_r1.Data(:,3)+LIabs_t.Data(:,3)));

diff_LIabs_thr=diff_LIabs.* diff_LIabs_std.*(LIabs_r1.Data(:,2)<(0.05/190)).*(LIabs_t.Data(:,2)<(0.05/190));

SaveAsAtlasNii(diff_LIabs_thr,[atlasflag '2'],[HCP_heri_path,'/Figures/'],'LIabs_StateDiff_Sig',1);
NiiProj2Surf([[HCP_heri_path,'/Figures/'],'/','LIabs_StateDiff_Sig','.nii'],surftype,projtype,'hemi',[-0.5 0.5]);
