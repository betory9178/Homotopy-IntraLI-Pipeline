ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');

R1Types=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_1228/REST1/*/');
R2Types=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_1228/REST2/*/');
TTypes=g_ls('/data/stalxy/Pipeline4JIN/FCS_HCP_1228/Task/*/');
for i=1:4
    REST1=g_ls([R1Types{i,1} '/*.mat']);
    REST2=g_ls([R2Types{i,1} '/*.mat']);
    MULTTASK=g_ls([TTypes{i,1} '/*.mat']);
    [~,nr1,~]=fileparts(R1Types{i,1});
    [~,nr2,~]=fileparts(R2Types{i,1});
    [~,nt,~]=fileparts(TTypes{i,1});
    getFCS1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/REST1_',nr1],REST1,nr1(1:3));
    getFCS1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/REST2_',nr1],REST2,nr2(1:3));
    getFCS1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTASK_',nt],MULTTASK,nt(1:3));
    if strcmp(nr1,nt)
        getFCSTvsR1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTaskcpRest1_',nt],ID.StID,MULTTASK,REST1,nt(1:3));
    end
    if strcmp(nr2,nt)
        getFCSTvsR1228(['/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTaskcpRest2_',nt],ID.StID,MULTTASK,REST2,nt(1:3));
    end
end

%% Part1 baseline
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/Baseline/Homo']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/Baseline/IntraL']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/Baseline/IntraLI']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/Baseline/IntraLIabs']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/Baseline/IntraR']);

filepath=g_ls('/data/stalxy/Pipeline4JIN/Results1228/Baseline/*/');
FCS_R1=load('/data/stalxy/Pipeline4JIN/Results1228/FCSmat/REST1_AICHA_NGR.mat');
FCS_R2=load('/data/stalxy/Pipeline4JIN/Results1228/FCSmat/REST2_AICHA_NGR.mat');
FCS_MT=load('/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTASK_AICHA_NGR.mat');
FCS_MTvR1=load('/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTaskcpRest1_AICHA_NGR.mat');
FCS_MTvR2=load('/data/stalxy/Pipeline4JIN/Results1228/FCSmat/MTaskcpRest2_AICHA_NGR.mat');
FCS_Rstate1=FCS_R1.finalFCS;
FCS_Rstate2=FCS_R2.finalFCS;
FCS_TstateA=FCS_MT.finalFCS;
FCS_TvRs1=FCS_MTvR1.finalFCS;
FCS_TvRs2=FCS_MTvR2.finalFCS;

genbaselinemap1228(FCS_Rstate1,ID.StID,filepath,'Rstate1_',0)
genbaselinemap1228(FCS_Rstate2,ID.StID,filepath,'Rstate2_',0)
genbaselinemap1228(FCS_TstateA,ID.StID,filepath,'TstateA_',0)

genbaselinemap1228(FCS_TvRs1,ID.StID,filepath,'TvRstate1_',-1)
genbaselinemap1228(FCS_TvRs2,ID.StID,filepath,'TvRstate2_',-1)

% filesppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SpecialCheck/*/');
% genbaselinemap(FCS_Rstate1,ID.ID_rest_task,filesppath,'Rstate1_')
% genbaselinemap(FCS_Rstate2,ID.ID_rest_task,filesppath,'Rstate2_')
% genbaselinemap(FCS_TstateALL,ID.ID_rest_task,filesppath,'Tstateall_')

%% Part2 compare between STATES
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/Rstat1vsRstat2']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/Rstat1vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/Rstat2vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/TsvRs1vsTsvRs2']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/TsvRs1vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateCP/TsvRs2vsTstate']);
filecppath=g_ls('/data/stalxy/Pipeline4JIN/Results1228/StateCP/*/');

gencpmap1228(FCS_Rstate1,FCS_Rstate2,ID.StID,filecppath{1},'R1vR2',[-5,5],[-5,5],[-1,1],[0,0.9])
gencpmap1228(FCS_Rstate1,FCS_TstateA,ID.StID,filecppath{2},'R1vTA',[-10,120],[-25,25],[-1,1],[0,0.6])
gencpmap1228(FCS_Rstate2,FCS_TstateA,ID.StID,filecppath{3},'R2vTA',[-10,120],[-25,25],[-1,1],[0,0.6])

gencpmap1228(FCS_TvRs1,FCS_TvRs2,ID.StID,filecppath{4},'TsR1vTsR2',[-5,5],[-5,5],[-1,1],[0,0.9])
gencpmap1228(FCS_TvRs1,FCS_TstateA,ID.StID,filecppath{5},'TsR1vTA',[-120,10],[-100,0],[0,0.5],[-30,30])
gencpmap1228(FCS_TvRs2,FCS_TstateA,ID.StID,filecppath{6},'TsR2vTA',[-120,10],[-100,0],[0,0.5],[-30,30])


%% Part3 relation of HomoxIntra within each STATE
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/RelatedinState/Rstat1']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/RelatedinState/Rstat2']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/RelatedinState/Tstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/RelatedinState/TsvRs1']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/RelatedinState/TsvRs2']);
filecorrpath=g_ls('/data/stalxy/Pipeline4JIN/Results1228/RelatedinState/*/');
[R1_HxI_Rmap,R1_HxI_Rsub]=gencorrmap1228(FCS_Rstate1,ID.StID,filecorrpath{1},'Rstate1',[-20,20],[-0.6,0.6])
[R2_HxI_Rmap,R2_HxI_Rsub]=gencorrmap1228(FCS_Rstate2,ID.StID,filecorrpath{2},'Rstate2',[-20,20],[-0.6,0.6])
[Tk_HxI_Rmap,Tk_HxI_Rsub]=gencorrmap1228(FCS_TstateA,ID.StID,filecorrpath{3},'Tstate',[-20,20],[-0.6,0.6])

[TsR1_HxI_Rmap,TsR1_HxI_Rsub]=gencorrmap1228(FCS_TvRs1,ID.StID,filecorrpath{4},'TsR1',[-20,20],[-0.6,0.6])
[TsR2_HxI_Rmap,TsR2_HxI_Rsub]=gencorrmap1228(FCS_TvRs2,ID.StID,filecorrpath{5},'TsR2',[-20,20],[-0.6,0.6])

%% Part4 compare relations of HomoxIntra across STATES
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/Rstat1vsRstat2']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/Rstat1vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/Rstat2vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/TsvRs1vsTsvRs2']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/TsvRs1vsTstate']);
system(['mkdir /data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/TsvRs2vsTstate']);
filecorrcppath=g_ls('/data/stalxy/Pipeline4JIN/Results1228/StateRelatedCP/*/');
gencocpmap1228(R1_HxI_Rmap,R1_HxI_Rsub,R2_HxI_Rmap,R2_HxI_Rsub,filecorrcppath{1},'R1vR2',[-5,5])
gencocpmap1228(R1_HxI_Rmap,R1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,filecorrcppath{2},'R1vTA',[-5,5])
gencocpmap1228(R2_HxI_Rmap,R2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,filecorrcppath{3},'R2vTA',[-5,5])

gencocpmap1228(TsR1_HxI_Rmap,TsR1_HxI_Rsub,TsR2_HxI_Rmap,TsR2_HxI_Rsub,filecorrcppath{4},'TsR1vTsR2',[-5,5])
gencocpmap1228(TsR1_HxI_Rmap,TsR1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,filecorrcppath{5},'TsR-1vTA',[-10,10])
gencocpmap1228(TsR2_HxI_Rmap,TsR2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,filecorrcppath{6},'TsR2vTA',[-10,10])

%% Part5 heritability and its relation 
% hefp_R1=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/rest1*');
% hefp_R2=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/rest2*');
% hefp_Task=g_ls('/data/stalxy/Pipeline4JIN/HCP_FCS_heri/All_task*');
% filehepath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/Heritability/*/');
% 
% genbasexhe1228(FCS_Rstate1,ID.ID_rest_task,filehepath{1},'Rstate1',hefp_R1)
% genbasexhe1228(FCS_Rstate2,ID.ID_rest_task,filehepath{2},'Rstate2',hefp_R2)
% genbasexhe1228(FCS_TstateALL,ID.ID_rest_task,filehepath{3},'Tstate',hefp_Task)


% Part6 task-general v.s. task
% sufilepath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBaseline/*/');
% genbaselinemap1228(TsR1,ID.ID_rest_task,sufilepath,'Taskall-Rstate1_',-1)
% genbaselinemap1228(TsR2,ID.ID_rest_task,sufilepath,'Taskall-Rstate2_',-1)
% 
% sufilecppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBcpTask/*/');
% gencpmap1228(TsR1,TsR2,ID.ID_rest_task,sufilecppath{1},'TsR1vTsR2',[-5,5],[-5,5],[0,0.9])
% gencpmap1228(TsR1,FCS_TstateALL,ID.ID_rest_task,sufilecppath{2},'TsR1vTall',[-120,10],[-100,0],[0,0.5],[-30,30])
% gencpmap1228(TsR2,FCS_TstateALL,ID.ID_rest_task,sufilecppath{3},'TsR2vTall',[-120,10],[-100,0],[0,0.5],[-30,30])
% 
% sufilecorrpath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBCorrinS/*/');
% [TsR1_HxI_Rmap,TsR1_HxI_Rsub]=gencorrmap1228(TsR1,ID.ID_rest_task,sufilecorrpath{1},'TsR1',[-20,20],[-0.6,0.6])
% [TsR2_HxI_Rmap,TsR2_HxI_Rsub]=gencorrmap1228(TsR2,ID.ID_rest_task,sufilecorrpath{2},'TsR2',[-20,20],[-0.6,0.6])
% 
% sufilecrppath=g_ls('/data/stalxy/Pipeline4JIN/ResultsRe/SUB_taskG/SUBCorrCp/*/');
% gencocpmap1228(TsR1_HxI_Rmap,TsR1_HxI_Rsub,TsR2_HxI_Rmap,TsR2_HxI_Rsub,sufilecrppath{1},'R1vR2',[-5,5])
% gencocpmap1228(TsR1_HxI_Rmap,TsR1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,sufilecrppath{2},'R1vTall',[-10,10])
% gencocpmap1228(TsR2_HxI_Rmap,TsR2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,sufilecrppath{3},'R2vTall',[-10,10])

