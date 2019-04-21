ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
[numData1, textData1, rawData1]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet1');
[numData2, textData2, rawData2]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet2');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_MTpath=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTASK_*.mat');

atlas_flag={'AIC','AIC','BNA','BNA'};
% for k=1:4
k=2;

[~,nm,~]=fileparts(FCS_R1path{k});
af=atlas_flag{k};

[~,~,iSg]=intersect(ID.StID,numData1(:,1));
[~,~,iSa]=intersect(ID.StID,numData2(:,1));
gen=textData1(iSg+1,2);
age=numData2(iSa,2);
gennum=strcmp(gen,'F')+1;

filepath='/data/stalxy/ArticleJResults/Figures/Figure4/';
shp='/data/stalxy/ArticleJResults/Figures/Figure4_plot.sh';
system(['rm ' shp]);

%% Part1 baseline

FCS_R1=load(FCS_R1path{k});
FCS_MT=load(FCS_MTpath{k});

FCS_Rstate1=FCS_R1.finalFCS;
FCS_TstateA=FCS_MT.finalFCS;

Fbase(FCS_TstateA,af,ID.StID,filepath,'TstateA_',0.3,shp)

%% Part2 compare between STATES

Fcp(FCS_Rstate1,FCS_TstateA,af,ID.StID,term(age)+term(gen),filepath,'R1vTA',[-60,60],[age,gennum],shp)


%% Part3 relation of HomoxIntra within each STATE

[R1_HxI_Rmap]=Fcorr(FCS_Rstate1,af,ID.StID,term(age)+term(gen),filepath,'Rstate1',[age,gennum],[-0.5,0.5],shp)
[Tk_HxI_Rmap]=Fcorr(FCS_TstateA,af,ID.StID,term(age)+term(gen),filepath,'Tstate',[age,gennum],[-0.5,0.5],shp)

%% Part4 compare relations of HomoxIntra across STATES

[Mpos,Mneg]=Fcorrcp(R1_HxI_Rmap,Tk_HxI_Rmap,af,filepath,'R1vTA',[-5,5],term(age)+term(gen),shp)


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

PlotCorr([filepath '/'],['HomoxLIabs_TAvsR1StateDiff_MostPos'],[Pr1h;Pth],[Pr1la;Ptla],term([age;age])+term([gen;gen])+term([FCS_Rstate1.global(iS1);FCS_TstateA.global(iS2)]),StateGroup);
PlotCorr([filepath '/'],['HomoxLIabs_TAvsR1StateDiff_MostNeg'],[Nr1h;Nth],[Nr1la;Ntla],term([age;age])+term([gen;gen])+term([FCS_Rstate1.global(iS1);FCS_TstateA.global(iS2)]),StateGroup);


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

medpath=[filepath '/Mediation/'];
if isempty(dir(medpath))
   system(['mkdir -p ' medpath]); 
end
if sum(state_mediation)>0
    AgeOutput=age;
    GenOutput=gennum;
    filename = [medpath '/Mediation_' nm '.xlsx'];
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
        SaveAsAtlasMZ3_Plot(type1,medpath,[['StateMediation1_' nm '_map'],'_SFICE'],[0.001 1],shp);

    end
    if sum(type2)>0
        
        %type2
        R1HomAvg=mean(Sr1h(:,logical(type2)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type2)),2);
        TaHomAvg=mean(Sth(:,logical(type2)),2);
        TaLIaAvg=mean(Stla(:,logical(type2)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',2,'Range','A1');
        SaveAsAtlasMZ3_Plot(type2,medpath,[['StateMediation2_' nm '_map'],'_SFICE'],[0.001 1],shp);
        
    end
    if sum(type3)>0
        
        %type3
        R1HomAvg=mean(Sr1h(:,logical(type3)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type3)),2);
        TaHomAvg=mean(Sth(:,logical(type3)),2);
        TaLIaAvg=mean(Stla(:,logical(type3)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',3,'Range','A1');
        SaveAsAtlasMZ3_Plot(type3,medpath,[['StateMediation3_' nm '_map'],'_SFICE'],[0.001 1],shp);
    end
    if sum(type4)>0
        
        %type4
        R1HomAvg=mean(Sr1h(:,logical(type4)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type4)),2);
        TaHomAvg=mean(Sth(:,logical(type4)),2);
        TaLIaAvg=mean(Stla(:,logical(type4)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',4,'Range','A1');
        SaveAsAtlasMZ3_Plot(type4,medpath,[['StateMediation4_' nm '_map'],'_SFICE'],[0.001 1],shp);
    end
    if sum(type5)>0
        
        %type5
        R1HomAvg=mean(Sr1h(:,logical(type5)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type5)),2);
        TaHomAvg=mean(Sth(:,logical(type5)),2);
        TaLIaAvg=mean(Stla(:,logical(type5)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',5,'Range','A1');
        SaveAsAtlasMZ3_Plot(type5,medpath,[['StateMediation5_' nm '_map'],'_SFICE'],[0.001 1],shp);
    end
    if sum(type6)>0
        
        %type6
        R1HomAvg=mean(Sr1h(:,logical(type6)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type6)),2);
        TaHomAvg=mean(Sth(:,logical(type6)),2);
        TaLIaAvg=mean(Stla(:,logical(type6)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',6,'Range','A1');
        SaveAsAtlasMZ3_Plot(type6,medpath,[['StateMediation6_' nm '_map'],'_SFICE'],[0.001 1],shp);
    end
    if sum(type7)>0
        
        %type7
        R1HomAvg=mean(Sr1h(:,logical(type7)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type7)),2);
        TaHomAvg=mean(Sth(:,logical(type7)),2);
        TaLIaAvg=mean(Stla(:,logical(type7)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',7,'Range','A1');
        SaveAsAtlasMZ3_Plot(type7,medpath,[['StateMediation7_' nm '_map'],'_SFICE'],[0.001 1],shp);
    end
    if sum(type8)>0
        
        %type8
        R1HomAvg=mean(Sr1h(:,logical(type8)),2);
        R1LIaAvg=mean(Sr1la(:,logical(type8)),2);
        TaHomAvg=mean(Sth(:,logical(type8)),2);
        TaLIaAvg=mean(Stla(:,logical(type8)),2);
        MediationState=table(AgeOutput,GenOutput,R1HomAvg,R1LIaAvg,TaHomAvg,TaLIaAvg);
        writetable(MediationState,filename,'Sheet',8,'Range','A1');
        SaveAsAtlasMZ3_Plot(type8,medpath,[['StateMediation8_' nm '_map'],'_SFICE'],[0.001 1],shp);
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
    filename = [medpath '/Mediation_' nm '.xlsx'];
    writetable(MediationState1,filename,'Sheet',1,'Range','A1');
    writetable(MediationState2,filename,'Sheet',2,'Range','A1');
    SaveAsAtlasMZ3_Plot(state_mediation,medpath,[['StateMediationALL_' nm '_map'],'_SFICE'],[0.001 1],shp);
end



