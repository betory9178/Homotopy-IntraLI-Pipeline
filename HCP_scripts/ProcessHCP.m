ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');

% R1Types=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_0212/REST1/*/');
% R2Types=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_0212/REST2/*/');
% TTypes=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_0212/TASK/*/');
% for i=1:4
%     REST1=g_ls([R1Types{i,1} '/*.mat']);
%     REST2=g_ls([R2Types{i,1} '/*.mat']);
%     MULTTASK=g_ls([TTypes{i,1} '/*.mat']);
%     [~,nr1,~]=fileparts(R1Types{i,1});
%     [~,nr2,~]=fileparts(R2Types{i,1});
%     [~,nt,~]=fileparts(TTypes{i,1});
%     getFCSHCP(['/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_',nr1],REST1,nr1(1:3));
%     getFCSHCP(['/data/stalxy/ArticleJResults/HCP/FCSmat/REST2_',nr1],REST2,nr2(1:3));
%     getFCSHCP(['/data/stalxy/ArticleJResults/HCP/FCSmat/MTASK_',nt],MULTTASK,nt(1:3));
%     if strcmp(nr1,nt)
%         getFCSTvsRHCP(['/data/stalxy/ArticleJResults/HCP/FCSmat/MTaskcpRest1_',nt],ID.StID,MULTTASK,REST1,nt(1:3));
%     end
%     if strcmp(nr2,nt)
%         getFCSTvsRHCP(['/data/stalxy/ArticleJResults/HCP/FCSmat/MTaskcpRest2_',nt],ID.StID,MULTTASK,REST2,nt(1:3));
%     end
% end

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_R2path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST2_*.mat');
FCS_MTpath=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTASK_*.mat');
FCS_MTvR1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTaskcpRest1_*.mat');
FCS_MTvR2path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTaskcpRest2_*.mat');

atlas_flag={'AIC','AIC','BNA','BNA'};
for k=1:4
[~,nm,~]=fileparts(FCS_R1path{k});
af=atlas_flag{k};
%% Part1 baseline
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/Homo']);
system(['mkdir /data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/IntraLIabs']);

filepath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/*/']);
FCS_R1=load(FCS_R1path{k});
FCS_R2=load(FCS_R2path{k});
FCS_MT=load(FCS_MTpath{k});
FCS_MTvR1=load(FCS_MTvR1path{k});
FCS_MTvR2=load(FCS_MTvR2path{k});
FCS_Rstate1=FCS_R1.finalFCS;
FCS_Rstate2=FCS_R2.finalFCS;
FCS_TstateA=FCS_MT.finalFCS;
FCS_TvRs1=FCS_MTvR1.finalFCS;
FCS_TvRs2=FCS_MTvR2.finalFCS;

genbaselinemapHCP(FCS_Rstate1,af,ID.StID,filepath,'Rstate1_',0)
genbaselinemapHCP(FCS_Rstate2,af,ID.StID,filepath,'Rstate2_',0)
genbaselinemapHCP(FCS_TstateA,af,ID.StID,filepath,'TstateA_',0)

genbaselinemapHCP(FCS_TvRs1,af,ID.StID,filepath,'TvRstate1_',-1)
genbaselinemapHCP(FCS_TvRs2,af,ID.StID,filepath,'TvRstate2_',-1)

% filesppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SpecialCheck/*/');
% genbaselinemap(FCS_Rstate1,ID.ID_rest_task,filesppath,'Rstate1_')
% genbaselinemap(FCS_Rstate2,ID.ID_rest_task,filesppath,'Rstate2_')
% genbaselinemap(FCS_TstateALL,ID.ID_rest_task,filesppath,'Tstateall_')

%% Part2 compare between STATES
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat1vsRstat2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat2vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/TsvRs1vsTsvRs2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/TsvRs1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/TsvRs2vsTstate']);
filecppath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/*/']);

gencpmapHCP(FCS_Rstate1,FCS_Rstate2,af,ID.StID,filecppath{1},'R1vR2',[-5,5],[-5,5],[-1,1],[0,0.9])
gencpmapHCP(FCS_Rstate1,FCS_TstateA,af,ID.StID,filecppath{2},'R1vTA',[-10,120],[-25,25],[-1,1],[0,0.6])
gencpmapHCP(FCS_Rstate2,FCS_TstateA,af,ID.StID,filecppath{3},'R2vTA',[-10,120],[-25,25],[-1,1],[0,0.6])

gencpmapHCP(FCS_TvRs1,FCS_TvRs2,af,ID.StID,filecppath{4},'TsR1vTsR2',[-5,5],[-5,5],[-1,1],[0,0.9])
gencpmapHCP(FCS_TvRs1,FCS_TstateA,af,ID.StID,filecppath{5},'TsR1vTA',[-120,10],[-100,0],[0,0.5],[-30,30])
gencpmapHCP(FCS_TvRs2,FCS_TstateA,af,ID.StID,filecppath{6},'TsR2vTA',[-120,10],[-100,0],[0,0.5],[-30,30])


%% Part3 relation of HomoxIntra within each STATE
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/Rstat1']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/Rstat2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/Tstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/TsvRs1']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/TsvRs2']);
filecorrpath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/*/']);
[R1_HxI_Rmap,R1_HxI_Rsub]=gencorrmapHCP(FCS_Rstate1,af,ID.StID,filecorrpath{1},'Rstate1',[-20,20],[-0.6,0.6])
[R2_HxI_Rmap,R2_HxI_Rsub]=gencorrmapHCP(FCS_Rstate2,af,ID.StID,filecorrpath{2},'Rstate2',[-20,20],[-0.6,0.6])
[Tk_HxI_Rmap,Tk_HxI_Rsub]=gencorrmapHCP(FCS_TstateA,af,ID.StID,filecorrpath{3},'Tstate',[-20,20],[-0.6,0.6])

[TsR1_HxI_Rmap,TsR1_HxI_Rsub]=gencorrmapHCP(FCS_TvRs1,af,ID.StID,filecorrpath{4},'TsR1',[-20,20],[-0.6,0.6])
[TsR2_HxI_Rmap,TsR2_HxI_Rsub]=gencorrmapHCP(FCS_TvRs2,af,ID.StID,filecorrpath{5},'TsR2',[-20,20],[-0.6,0.6])

%% Part4 compare relations of HomoxIntra across STATES
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat1vsRstat2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat2vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/TsvRs1vsTsvRs2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/TsvRs1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/TsvRs2vsTstate']);
filecorrcppath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/*/']);
gencocpmapHCP(R1_HxI_Rmap,R1_HxI_Rsub,R2_HxI_Rmap,R2_HxI_Rsub,af,filecorrcppath{1},'R1vR2',[-5,5])
gencocpmapHCP(R1_HxI_Rmap,R1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{2},'R1vTA',[-5,5])
gencocpmapHCP(R2_HxI_Rmap,R2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{3},'R2vTA',[-5,5])

gencocpmapHCP(TsR1_HxI_Rmap,TsR1_HxI_Rsub,TsR2_HxI_Rmap,TsR2_HxI_Rsub,af,filecorrcppath{4},'TsR1vTsR2',[-5,5])
gencocpmapHCP(TsR1_HxI_Rmap,TsR1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{5},'TsR-1vTA',[-10,10])
gencocpmapHCP(TsR2_HxI_Rmap,TsR2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{6},'TsR2vTA',[-10,10])

%% Part5 heritability and its relation 
% hefp_R1=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/rest1*');
% hefp_R2=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/rest2*');
% hefp_Task=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/All_task*');
% filehepath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/Heritability/*/');
% 
% genbasexheHCP(FCS_Rstate1,ID.ID_rest_task,filehepath{1},'Rstate1',hefp_R1)
% genbasexheHCP(FCS_Rstate2,ID.ID_rest_task,filehepath{2},'Rstate2',hefp_R2)
% genbasexheHCP(FCS_TstateALL,ID.ID_rest_task,filehepath{3},'Tstate',hefp_Task)


% Part6 task-general v.s. task
% sufilepath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBaseline/*/');
% genbaselinemapHCP(TsR1,ID.ID_rest_task,sufilepath,'Taskall-Rstate1_',-1)
% genbaselinemapHCP(TsR2,ID.ID_rest_task,sufilepath,'Taskall-Rstate2_',-1)
% 
% sufilecppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBcpTask/*/');
% gencpmapHCP(TsR1,TsR2,ID.ID_rest_task,sufilecppath{1},'TsR1vTsR2',[-5,5],[-5,5],[0,0.9])
% gencpmapHCP(TsR1,FCS_TstateALL,ID.ID_rest_task,sufilecppath{2},'TsR1vTall',[-120,10],[-100,0],[0,0.5],[-30,30])
% gencpmapHCP(TsR2,FCS_TstateALL,ID.ID_rest_task,sufilecppath{3},'TsR2vTall',[-120,10],[-100,0],[0,0.5],[-30,30])
% 
% sufilecorrpath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBCorrinS/*/');
% [TsR1_HxI_Rmap,TsR1_HxI_Rsub]=gencorrmapHCP(TsR1,ID.ID_rest_task,sufilecorrpath{1},'TsR1',[-20,20],[-0.6,0.6])
% [TsR2_HxI_Rmap,TsR2_HxI_Rsub]=gencorrmapHCP(TsR2,ID.ID_rest_task,sufilecorrpath{2},'TsR2',[-20,20],[-0.6,0.6])
% 
% sufilecrppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBCorrCp/*/');
% gencocpmapHCP(TsR1_HxI_Rmap,TsR1_HxI_Rsub,TsR2_HxI_Rmap,TsR2_HxI_Rsub,sufilecrppath{1},'R1vR2',[-5,5])
% gencocpmapHCP(TsR1_HxI_Rmap,TsR1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,sufilecrppath{2},'R1vTall',[-10,10])
% gencocpmapHCP(TsR2_HxI_Rmap,TsR2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,sufilecrppath{3},'R2vTall',[-10,10])

% Mediation


end
