HCP_heri_path='/data/stalxy/ArticleJResults/Figures/Figure3/';
shp='/data/stalxy/ArticleJResults/Figures/Figure3heri_plot.sh';
system(['rm ' shp]);

ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
subid=ID.StID;

coheri=load('/data/stalxy/sharefolder/HCP/CodeFromJIN/genetic_correlation.mat');

Homo_r1=load('/data/stalxy/ArticleJResults/HCP/heri/rest1_homo.mat');
Homo_t=load('/data/stalxy/ArticleJResults/HCP/heri/task_homo.mat');

LIabs_r1=load('/data/stalxy/ArticleJResults/HCP/heri/rest1_absLI.mat');
LIabs_t=load('/data/stalxy/ArticleJResults/HCP/heri/task_absLI.mat');

SaveAsAtlasMZ3_Plot(Homo_r1.Data(:,1),HCP_heri_path,['Homo_Rest1_heritability','_SFICE'],[-0.3,0.3],shp);
% SaveAsAtlasMZ3_Plot(Homo_t.Data(:,1).*(Homo_t.Data(:,2)<(0.05/190)),HCP_heri_path,['Homo_Task_heritability','_SFICE'],[-0.5,0.5],shp);
SaveAsAtlasMZ3_Plot(LIabs_r1.Data(:,1),HCP_heri_path,['LIabs_Rest1_heritability','_SFICE'],[-0.3,0.3],shp);
% SaveAsAtlasMZ3_Plot(LIabs_t.Data(:,1).*(LIabs_t.Data(:,2)<(0.05/190)),HCP_heri_path,['LIabs_Task_heritability','_SFICE'],[-0.5,0.5],shp);

SaveAsAtlasMZ3_Plot(Homo_r1.Data(:,1).*(Homo_r1.Data(:,2)<(0.05/190)),HCP_heri_path,['Homo_Rest1_heritability_thresh','_SFICE'],[-0.3,0.3],shp);
% SaveAsAtlasMZ3_Plot(Homo_t.Data(:,1).*(Homo_t.Data(:,2)<(0.05/190)),HCP_heri_path,['Homo_Task_heritability','_SFICE'],[-0.5,0.5],shp);
SaveAsAtlasMZ3_Plot(LIabs_r1.Data(:,1).*(LIabs_r1.Data(:,2)<(0.05/190)),HCP_heri_path,['LIabs_Rest1_heritability_thresh','_SFICE'],[-0.3,0.3],shp);
% SaveAsAtlasMZ3_Plot(LIabs_t.Data(:,1).*(LIabs_t.Data(:,2)<(0.05/190)),HCP_heri_path,['LIabs_Task_heritability','_SFICE'],[-0.5,0.5],shp);

herirelated=zeros(192,1);
herirelated([1:174,176:190,192])=coheri.RHOG;
SaveAsAtlasMZ3_Plot(herirelated,HCP_heri_path,['Coheri_Rest1','_SFICE'],[-1,1],shp);

herirBonf=zeros(192,1);
herirBonf([1:174,176:190,192])=coheri.rhog0bf;
SaveAsAtlasMZ3_Plot(herirBonf,HCP_heri_path,['Coheri_Rest1_bonf','_SFICE'],[-1,1],shp);


SysDiv2Plot('Hierarchy','AIC',[0,1],['Rest1_Homo'],HCP_heri_path,Homo_r1.Data(:,1)');
SysDiv2Plot('Hierarchy','AIC',[0,1],['Rest1_IntraLIabs'],HCP_heri_path,LIabs_r1.Data(:,1)');
SysDiv2Plot('Hierarchy','AIC',[-1,1],['Rest1_Coheri'],HCP_heri_path,herirelated');

% H_homo_r=Homo_r1.Data(:,1);
% H_homo_t=Homo_t.Data(:,1);
% diff_homo=H_homo_t-H_homo_r;
% diff_homo_std=abs(diff_homo)> (1.96 .* (Homo_r1.Data(:,3)+Homo_t.Data(:,3)));
% 
% diff_homo_thr=diff_homo.* diff_homo_std.*(Homo_r1.Data(:,2)<(0.05/190)).*(Homo_t.Data(:,2)<(0.05/190));
% 
% SaveAsAtlasMZ3_Plot(diff_homo_thr,[HCP_heri_path,'/Figures/'],['Homo_StateDiff_Sig','_SFICE'],[0.001,0.5],shp);
% 
% H_LIabs_r=LIabs_r1.Data(:,1);
% H_LIabs_t=LIabs_t.Data(:,1);
% diff_LIabs=H_LIabs_t-H_LIabs_r;
% diff_LIabs_std=abs(diff_LIabs)> (1.96 .* (LIabs_r1.Data(:,3)+LIabs_t.Data(:,3)));
% 
% diff_LIabs_thr=diff_LIabs.* diff_LIabs_std.*(LIabs_r1.Data(:,2)<(0.05/190)).*(LIabs_t.Data(:,2)<(0.05/190));
% 
% SaveAsAtlasMZ3_Plot(diff_LIabs_thr,[HCP_heri_path,'/Figures/'],['LIabs_StateDiff_Sig','_SFICE'],[0.001,0.5],shp);
