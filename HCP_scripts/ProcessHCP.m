ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
[numData1, textData1, rawData1]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet1');
[numData2, textData2, rawData2]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet2');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_R2path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST2_*.mat');
FCS_MTpath=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTASK_*.mat');

atlas_flag={'AIC','AIC','BNA','BNA'};
% for k=1:4
k=2;

[~,nm,~]=fileparts(FCS_R1path{k});
af=atlas_flag{k};

[~,~,iSg]=intersect(ID.StID,numData1(:,1));
[~,~,iSa]=intersect(ID.StID,numData2(:,1));
gen=textData1(iSg+1,2);
age=numData2(iSg,2);
gennum=strcmp(gen,'F')+1;

%% Part1 baseline
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/Homo']);
system(['mkdir /data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/IntraLIabs']);

filepath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/Baseline_' nm '/*/']);
FCS_R1=load(FCS_R1path{k});
FCS_R2=load(FCS_R2path{k});
FCS_MT=load(FCS_MTpath{k});

FCS_Rstate1=FCS_R1.finalFCS;
FCS_Rstate2=FCS_R2.finalFCS;
FCS_TstateA=FCS_MT.finalFCS;

if k==1 || k==3
    limrange=0.8;
    lisrange=0.5;
elseif k==2 || k==4
    limrange=0.3;
    lisrange=0.2;
end

genbaselinemapHCP(FCS_Rstate1,af,ID.StID,filepath,'Rstate1_',limrange,lisrange)
genbaselinemapHCP(FCS_Rstate2,af,ID.StID,filepath,'Rstate2_',limrange,lisrange)
genbaselinemapHCP(FCS_TstateA,af,ID.StID,filepath,'TstateA_',limrange,lisrange)

%% Part2 compare between STATES
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat1vsRstat2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/Rstat2vsTstate']);

filecppath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/StateCP_' nm '/*/']);

gencpmapHCP(FCS_Rstate1,FCS_Rstate2,af,ID.StID,term(age)+term(gen),filecppath{1},'R1vR2',[-5,5],[age,gennum],[-1,1],[0,0.9])
gencpmapHCP(FCS_Rstate1,FCS_TstateA,af,ID.StID,term(age)+term(gen),filecppath{2},'R1vTA',[-120,10],[age,gennum],[-1,1],[0,0.6])
gencpmapHCP(FCS_Rstate2,FCS_TstateA,af,ID.StID,term(age)+term(gen),filecppath{3},'R2vTA',[-10,120],[age,gennum],[-1,1],[0,0.6])


%% Part3 relation of HomoxIntra within each STATE
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/Rstat1']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/Rstat2']);

filecorrpath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/RelatedinState_' nm '/*/']);
[R1_HxI_Rmap,R1_HxI_Rsub]=gencorrmapHCP(FCS_Rstate1,af,ID.StID,term(age)+term(gen),filecorrpath{1},'Rstate1',[age,gennum],[-0.5,0.5])
[R2_HxI_Rmap,R2_HxI_Rsub]=gencorrmapHCP(FCS_Rstate2,af,ID.StID,term(age)+term(gen),filecorrpath{2},'Rstate2',[age,gennum],[-0.5,0.5])
[Tk_HxI_Rmap,Tk_HxI_Rsub]=gencorrmapHCP(FCS_TstateA,af,ID.StID,term(age)+term(gen),filecorrpath{3},'Tstate',[age,gennum],[-0.5,0.5])

%% Part4 compare relations of HomoxIntra across STATES
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat1vsRstat2']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat1vsTstate']);
system(['mkdir -p /data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/Rstat2vsTstate']);

filecorrcppath=g_ls(['/data/stalxy/ArticleJResults/HCP/Results/StateRelatedCP_' nm '/*/']);
gencocpmapHCP(R1_HxI_Rmap,R1_HxI_Rsub,R2_HxI_Rmap,R2_HxI_Rsub,af,filecorrcppath{1},'R1vR2',[-5,5],term(age)+term(gen))
[Mpos,Mneg]=gencocpmapHCP(R1_HxI_Rmap,R1_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{2},'R1vTA',[-5,5],term(age)+term(gen))
gencocpmapHCP(R2_HxI_Rmap,R2_HxI_Rsub,Tk_HxI_Rmap,Tk_HxI_Rsub,af,filecorrcppath{3},'R2vTA',[-5,5],term(age)+term(gen))


[~,~,iS1]=intersect(ID.StID,FCS_Rstate1.subid);
[~,~,iS2]=intersect(ID.StID,FCS_TstateA.subid);
StateGroup=var2fac([zeros(887,1);ones(887,1)],{'Rest','Task'});
Pr1h=FCS_Rstate1.homo(iS1,Mpos);
Pth=FCS_TstateA.homo(iS2,Mpos);
Pr1la=FCS_Rstate1.intra_absAI(iS1,Mpos);
Ptla=FCS_TstateA.intra_absAI(iS2,Mpos);
Nr1h=FCS_Rstate1.homo(iS1,Mneg);
Nth=FCS_TstateA.homo(iS2,Mneg);
Nr1la=FCS_Rstate1.intra_absAI(iS1,Mneg);
Ntla=FCS_TstateA.intra_absAI(iS2,Mneg);

PlotCorr([filecorrcppath{2} '/'],['HomoxLIabs_TAvsR1StateDiff_MostPos'],[Pr1h;Pth],[Pr1la;Ptla],term([age;age])+term([gen;gen])+term([FCS_Rstate1.global(iS1);FCS_TstateA.global(iS2)]),StateGroup);
PlotCorr([filecorrcppath{2} '/'],['HomoxLIabs_TAvsR1StateDiff_MostNeg'],[Nr1h;Nth],[Nr1la;Ntla],term([age;age])+term([gen;gen])+term([FCS_Rstate1.global(iS1);FCS_TstateA.global(iS2)]),StateGroup);


%% Part 4 add  Homo&Intra interaction between state 
geninteractionHCP(FCS_Rstate1,FCS_Rstate2,af,ID.StID,filecorrcppath{1},'R1vR2');
geninteractionHCP(FCS_Rstate1,FCS_TstateA,af,ID.StID,filecorrcppath{2},'R1vTS');
geninteractionHCP(FCS_Rstate2,FCS_TstateA,af,ID.StID,filecorrcppath{3},'R2vTS');

%% Part5 heritability and its relation 
run('genheriHCP.m')


%% Mediation
[~,~,iS1]=intersect(ID.StID,FCS_Rstate1.subid);
[~,~,iS2]=intersect(ID.StID,FCS_TstateA.subid);

Sr1h=FCS_Rstate1.homo(iS1,:);
Sth=FCS_TstateA.homo(iS2,:);
Sr1la=FCS_Rstate1.intra_absAI(iS1,:);
Stla=FCS_TstateA.intra_absAI(iS2,:);
if strcmp(af,'AIC')
    nsize=192;
    nid=[1:174,176:190,192];
elseif strcmp(af,'BNA')
    nsize=123;
    nid=[1:123];
end

TsHomo=zeros(1,nsize);
TsLIab=zeros(1,nsize);
PsHomo=zeros(1,nsize);
PsLIab=zeros(1,nsize);
PHoxLI=zeros(1,nsize);
RHoxLI=zeros(1,nsize);

for i=1:nsize
    [~,PsHomo(1,i),~,STHomo]=ttest(Sr1h(:,i),Sth(:,i));
    TsHomo(1,i)=STHomo.tstat;
    [~,PsLIab(1,i),~,STLIab]=ttest(Sr1la(:,i),Stla(:,i));
    TsLIab(1,i)=STLIab.tstat;
    [RHoxLI(1,i),PHoxLI(1,i)]=partialcorr(Sr1h(:,i)-Sth(:,i),Sr1la(:,i)-Stla(:,i),[age,gennum]);
end
state_mediation=(PsHomo<0.05/length(nid)).*(PsLIab<0.05/length(nid)).*(PHoxLI<0.05/length(nid));
Ho_flag=TsHomo.*(PsHomo<0.05/length(nid));
LI_flag=TsLIab.*(PsLIab<0.05/length(nid));
Re_flag=RHoxLI.*(PHoxLI<0.05/length(nid));

if sum(state_mediation)>0
    AgeOutput=age;
    GenOutput=gennum;
    filename = ['/data/stalxy/ArticleJResults/HCP/Results/MediationAge_' nm '.xlsx'];
    type1=(Ho_flag>0).*(LI_flag>0).*(Re_flag>0);
    type2=(Ho_flag>0).*(LI_flag>0).*(Re_flag<0);
    type3=(Ho_flag>0).*(LI_flag<0).*(Re_flag>0);
    type4=(Ho_flag>0).*(LI_flag<0).*(Re_flag<0);
    type5=(Ho_flag<0).*(LI_flag>0).*(Re_flag>0);
    type6=(Ho_flag<0).*(LI_flag>0).*(Re_flag<0);
    type7=(Ho_flag<0).*(LI_flag<0).*(Re_flag>0);
    type8=(Ho_flag<0).*(LI_flag<0).*(Re_flag<0);
    
    if sum(type1)>0
        
        %type1
        R1HomAvg=mean(Sr1h(:,logical(type1)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type1)),2);
        TaHomAvg=mean(Sth(:,logical(type1)),2);
        TaLIaAvg=mean(Stla(:,logical(type1)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',1,'Range','A1');
        SaveAsAtlasNii(type1,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation1_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation1_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type2)>0
        
        %type2
        R1HomAvg=mean(Sr1h(:,logical(type2)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type2)),2);
        TaHomAvg=mean(Sth(:,logical(type2)),2);
        TaLIaAvg=mean(Stla(:,logical(type2)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',2,'Range','A1');
        SaveAsAtlasNii(type2,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation2_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation2_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type3)>0
        
        %type3
        R1HomAvg=mean(Sr1h(:,logical(type3)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type3)),2);
        TaHomAvg=mean(Sth(:,logical(type3)),2);
        TaLIaAvg=mean(Stla(:,logical(type3)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',3,'Range','A1');
        SaveAsAtlasNii(type3,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation3_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation3_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type4)>0
        
        %type4
        R1HomAvg=mean(Sr1h(:,logical(type4)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type4)),2);
        TaHomAvg=mean(Sth(:,logical(type4)),2);
        TaLIaAvg=mean(Stla(:,logical(type4)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',4,'Range','A1');
        SaveAsAtlasNii(type4,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation4_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation4_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type5)>0
        
        %type5
        R1HomAvg=mean(Sr1h(:,logical(type5)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type5)),2);
        TaHomAvg=mean(Sth(:,logical(type5)),2);
        TaLIaAvg=mean(Stla(:,logical(type5)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',5,'Range','A1');
        SaveAsAtlasNii(type5,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation5_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation5_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type6)>0
        
        %type6
        R1HomAvg=mean(Sr1h(:,logical(type6)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type6)),2);
        TaHomAvg=mean(Sth(:,logical(type6)),2);
        TaLIaAvg=mean(Stla(:,logical(type6)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',6,'Range','A1');
        SaveAsAtlasNii(type6,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation6_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation6_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type7)>0
        
        %type7
        R1HomAvg=mean(Sr1h(:,logical(type7)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type7)),2);
        TaHomAvg=mean(Sth(:,logical(type7)),2);
        TaLIaAvg=mean(Stla(:,logical(type7)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',7,'Range','A1');
        SaveAsAtlasNii(type7,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation7_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation7_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
        
    end
    if sum(type8)>0
        
        %type8
        R1HomAvg=mean(Sr1h(:,logical(type8)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type8)),2);
        TaHomAvg=mean(Sth(:,logical(type8)),2);
        TaLIaAvg=mean(Stla(:,logical(type8)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',8,'Range','A1');
        SaveAsAtlasNii(type8,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation8_' nm '_map'],1)
        NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation8_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
    end
    
end

if sum(state_mediation)>0
    AgeOutput=age;
    GenOutput=gennum;
    R1HomOutput=Sr1h(:,state_mediation==1);
    R1LIaOutput=Sr1la(:,state_mediation==1);
    TaHomOutput=Sth(:,state_mediation==1);
    TaLIaOutput=Stla(:,state_mediation==1);
    R1HomAvg=mean(R1HomOutput,2);
    R1LIaAvg=mean(R1LIaOutput,2);
    TaHomAvg=mean(TaHomOutput,2);
    TaLIaAvg=mean(TaLIaOutput,2);
    MediationState1=table(AgeOutput,GenOutput,R1HomOutput,R1LIaOutput,TaHomOutput,TaLIaOutput);
    MediationState2=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
    filename = ['/data/stalxy/ArticleJResults/HCP/Results/MediationAge_' nm '.xlsx'];
    writetable(MediationState1,filename,'Sheet',1,'Range','A1');
    writetable(MediationState2,filename,'Sheet',2,'Range','A1');
    SaveAsAtlasNii(state_mediation,[af '2'],'/data/stalxy/ArticleJResults/HCP/Results/',['StateMediation_' nm '_map'],1)
    NiiProj2Surf(['/data/stalxy/ArticleJResults/HCP/Results/','/',['StateMediation_' nm '_map'],'.nii'],'inf','tri','hemi',[-1,1]);
end



% end