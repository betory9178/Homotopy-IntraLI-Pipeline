
ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_MTpath=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/MTASK_*.mat');
FCS_R1=load(FCS_R1path{2});
FCS_MT=load(FCS_MTpath{2});
FCS_Rstate1=FCS_R1.finalFCS;
FCS_TstateA=FCS_MT.finalFCS;

FCS1=FCS_Rstate1;
FCS2=FCS_TstateA;

atlasflag='AIC';
subid=ID.StID;
statspath='/data/stalxy/ArticleJResults/Figures/Figure2/';
shp='/data/stalxy/ArticleJResults/Figures/Figure2CCA_plot.sh';
system(['rm ' shp]);

[numericData, textData, ~]=xlsread('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/HCP_Cognition_byLXY0318.xlsx');

if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

%% Group mean - Across subject
[~,~,iS1]=intersect(subid,FCS1.subid);
[~,~,iS2]=intersect(subid,FCS2.subid);

[~,~,iSB]=intersect(subid,numericData(:,1));

ho_FC1=FCS1.homo(iS1,nid);
LI_intra_abs1=FCS1.intra_absAI(iS1,nid);
ho_FC2=FCS2.homo(iS2,nid);
LI_intra_abs2=FCS2.intra_absAI(iS2,nid);

[numData1, textData1, ~]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet1');
[numData2, ~, ~]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet2');
[~,~,iSg]=intersect(ID.StID,numData1(:,1));
[~,~,iSa]=intersect(ID.StID,numData2(:,1));
gen=textData1(iSg+1,2);
age=numData2(iSa,2);
gennum=strcmp(gen,'F')+1;

behaviours=numericData(iSB,3:end);
titles=textData(1,3:end)';
unadj_removed=[1,3,5,10,12,14,16:27,33:36,43,45,47:49,51];
% unadj_removed_xixi=[1,3,5,10,12,14,16:27,33:36,43,45:52];

behaviours_ageadj=behaviours;
behaviours_ageadj(:,unadj_removed)=[];
titles(unadj_removed)=[];

% behaviours_ageadj(:,unadj_removed_xixi)=[];
% titles(unadj_removed_xixi)=[];

% remove NaNs subjects in behaviours
absences=logical(sum(isnan(behaviours_ageadj),2));


%% type 1
%combined Homotopy and LIabs, covariances are not involved

[Brain_COEF1,Behaviour_COEF1,CCA_T_r1,Brain_ComSR1,Behaviour_ComSR1,CCA_T_stats1,Brain_LD1,Behaviour_LD1,Brain_CrsLD1,Behaviour_CrsLD1] = ZCX_canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:)],behaviours_ageadj(~absences,:));
[Brain_COEF1,Behaviour_COEF1,CCA_T_r1,Brain_ComSR1r,Behaviour_ComSR1r,CCA_T_stats1r,Brain_LD1r,Behaviour_LD1r,Brain_CrsLD1,Behaviour_CrsLD1] = ZCX_canoncorr_rev([ho_FC1(~absences,:),LI_intra_abs1(~absences,:)],behaviours_ageadj(~absences,:));

Brain_ComSR1(:,2)=Brain_ComSR1r(:,2);
Behaviour_ComSR1(:,2)=Behaviour_ComSR1r(:,2);
Brain_LD1(:,2)=Brain_LD1r(:,2);
Behaviour_LD1(:,2)=Behaviour_LD1r(:,2);
brain_CCA_num1=sum(CCA_T_stats1.pChisq<0.05);

[CCA_Bload_Order1,CCA_B_Ind1]=sort(Behaviour_LD1,'descend');
beh_order1=titles(CCA_B_Ind1(:,1:brain_CCA_num1));

for i=1:brain_CCA_num1
    
        PlotCorr([statspath,'/CCACombined/'],['CombxBehav_Rest1_CCA_',num2str(i)],Brain_ComSR1(:,i),Behaviour_ComSR1(:,i));
        PlotCorr([statspath,'/CCACombined/'],['Brain_HomoxLIabs_Rest1_LOAD_',num2str(i)],Brain_LD1(1:length(nid),i),Brain_LD1(length(nid)+1:2*length(nid),i));

        homo_comb_ld1=zeros(192,1);
        homo_comb_ld1(nid)=Brain_LD1(1:length(nid),i);
        
        liabs_comb_ld1=zeros(192,1);
        liabs_comb_ld1(nid)=Brain_LD1(length(nid)+1:2*length(nid),i);
        
 
        SaveAsAtlasMZ3_Plot(homo_comb_ld1,[statspath,'/CCACombined/'],['Comb_Homo_Rest1_LOAD_' num2str(i)],[-0.15,0.15],shp);
        SaveAsAtlasMZ3_Plot(liabs_comb_ld1,[statspath,'/CCACombined/'],['Comb_LIabs_Rest1_LOAD_' num2str(i)],[-0.15,0.15],shp);
        
end
