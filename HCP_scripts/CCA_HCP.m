function CCA_HCP(FCS1,FCS2,atlasflag,subid,statspath)

FCS1=FCS_Rstate1;
FCS2=FCS_TstateA;
atlasflag='AIC';
subid=ID.StID;
statspath='/data/stalxy/ArticleJResults/HCP/Results/CCA_AICHA_NGR/';
shp='/data/stalxy/ArticleJResults/plot.sh';

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

behaviours=numericData(iSB,3:end);
absences=logical(sum(isnan(behaviours),2));
titles=textData(1,3:end)';
unadj_removed=[1,3,5,10,12,14,16:27,35,36,43,45,47,49,51];

behaviours_ageadj=behaviours;
behaviours_ageadj(:,unadj_removed)=[];
titles(unadj_removed)=[];

% remove NaNs subjects in behaviours
nansubj=sum(isnan(behaviours_ageadj),2);


%% type 1
%combined Homotopy and LIabs, covariances are not involved

[Brain_COEF1,Behaviour_COEF1,CCA_T_r1,Brain_ComSR1,Behaviour_ComSR1,CCA_T_stats1,Brain_LD1,Behaviour_LD1,Brain_CrsLD1,Behaviour_CrsLD1] = ZCX_canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:)],behaviours_ageadj(~absences,:));
[Brain_COEF2,Behaviour_COEF2,CCA_T_r2,Brain_ComSR2,Behaviour_ComSR2,CCA_T_stats2,Brain_LD2,Behaviour_LD2,Brain_CrsLD2,Behaviour_CrsLD2] = ZCX_canoncorr([ho_FC2(~absences,:),LI_intra_abs2(~absences,:)],behaviours_ageadj(~absences,:));

%% type 3
%combined Homotopy and LIabs, covariances are involved

[Brain_COEF1_wCOV,Behaviour_COEF1_wCOV,CCA_T_r1_wCOV,Brain_ComSR1_wCOV,Behaviour_ComSR1_wCOV,CCA_T_stats1_wCOV,Brain_LD1_wCOV,Behaviour_LD1_wCOV,Brain_CrsLD1_wCOV,Behaviour_CrsLD1_wCOV] = ZCX_canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[Brain_COEF2_wCOV,Behaviour_COEF2_wCOV,CCA_T_r2_wCOV,Brain_ComSR2_wCOV,Behaviour_ComSR2_wCOV,CCA_T_stats2_wCOV,Brain_LD2_wCOV,Behaviour_LD2_wCOV,Brain_CrsLD2_wCOV,Behaviour_CrsLD2_wCOV] = ZCX_canoncorr([ho_FC2(~absences,:),LI_intra_abs2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));

% brain_CCA_num=max(sum(CCA_T_stats1.pChisq<0.05),sum(CCA_T_stats2.pChisq<0.05));
brain_CCA_num1=sum(CCA_T_stats1.pChisq<0.05);
brain_CCA_num2=sum(CCA_T_stats2.pChisq<0.05);

for i=1:brain_CCA_num1
    
    for j=1:brain_CCA_num2
        
        PlotCorr([statspath,'/Combined/'],['CombxBehav_Rest1_CCA_',num2str(i)],Brain_ComSR1(:,i),Behaviour_ComSR1(:,i));
        PlotCorr([statspath,'/Combined/'],['CombxBehav_Task_CCA_',num2str(i)],Brain_ComSR2(:,j),Behaviour_ComSR2(:,j));
        
        PlotCorr([statspath,'/Combined/'],['Behav_Comb_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],Behaviour_COEF1(:,i),Behaviour_COEF2(:,j));
        PlotCorr([statspath,'/Combined/'],['Brain_Comb_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],Brain_COEF1(:,i),Brain_COEF2(:,j));
        
        PlotCorr([statspath,'/Combined/'],['Behav_Comb_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],Behaviour_LD1(:,i),Behaviour_LD2(:,j));
        PlotCorr([statspath,'/Combined/'],['Brain_Comb_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],Brain_LD1(:,i),Brain_LD2(:,j));

        PlotCorr([statspath,'/Combined/'],['Brain_HomoxLIabs_Rest1_COEF_',num2str(i)],Brain_COEF1(1:length(nid),i),Brain_COEF1(length(nid)+1:2*length(nid),i));
        PlotCorr([statspath,'/Combined/'],['Brain_HomoxLIabs_Task_COEF_',num2str(j)],Brain_COEF2(1:length(nid),j),Brain_COEF2(length(nid)+1:2*length(nid),j));
        
        PlotCorr([statspath,'/Combined/'],['Brain_HomoxLIabs_Rest1_LOAD_',num2str(i)],Brain_LD1(1:length(nid),i),Brain_LD1(length(nid)+1:2*length(nid),i));
        PlotCorr([statspath,'/Combined/'],['Brain_HomoxLIabs_Task_LOAD_',num2str(j)],Brain_LD2(1:length(nid),j),Brain_LD2(length(nid)+1:2*length(nid),j));
        
        homo_comb_co1=zeros(192,1);
        homo_comb_co2=zeros(192,1);
        homo_comb_co1(nid)=Brain_COEF1(1:length(nid),i);
        homo_comb_co2(nid)=Brain_COEF2(1:length(nid),j);
        
        liabs_comb_co1=zeros(192,1);
        liabs_comb_co2=zeros(192,1);
        liabs_comb_co1(nid)=Brain_COEF1(length(nid)+1:2*length(nid),i);
        liabs_comb_co2(nid)=Brain_COEF2(length(nid)+1:2*length(nid),j);
        
        homo_comb_ld1=zeros(192,1);
        homo_comb_ld2=zeros(192,1);
        homo_comb_ld1(nid)=Brain_LD1(1:length(nid),i);
        homo_comb_ld2(nid)=Brain_LD2(1:length(nid),j);
        
        liabs_comb_ld1=zeros(192,1);
        liabs_comb_ld2=zeros(192,1);
        liabs_comb_ld1(nid)=Brain_LD1(length(nid)+1:2*length(nid),i);
        liabs_comb_ld2(nid)=Brain_LD2(length(nid)+1:2*length(nid),j);
        
        SaveAsAtlasMZ3_Plot(homo_comb_co1,[statspath,'/Combined/'],['Comb_Homo_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(homo_comb_co2,[statspath,'/Combined/'],['Comb_Homo_Task_COEF_' num2str(j)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(liabs_comb_co1,[statspath,'/Combined/'],['Comb_LIabs_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(liabs_comb_co2,[statspath,'/Combined/'],['Comb_LIabs_Task_COEF_' num2str(j)],[-0.2,0.2],shp);
        
        SaveAsAtlasMZ3_Plot(homo_comb_ld1,[statspath,'/Combined/'],['Comb_Homo_Rest1_LOAD_' num2str(i)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(homo_comb_ld2,[statspath,'/Combined/'],['Comb_Homo_Task_LOAD_' num2str(j)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(liabs_comb_ld1,[statspath,'/Combined/'],['Comb_LIabs_Rest1_LOAD_' num2str(i)],[-0.2,0.2],shp);
        SaveAsAtlasMZ3_Plot(liabs_comb_ld2,[statspath,'/Combined/'],['Comb_LIabs_Task_LOAD_' num2str(j)],[-0.2,0.2],shp);
        
    end
end
%% type 2
% seperated Homotopy and LIabs, covariances are not involved

[Homo_COEF1,BehxHomo_COEF1,CCA_Homo_r1,Homo_ComSR1,BehxHomo_ComSR1,CCA_Homo_stats1,Homo_LD1,BehxHomo_LD1,Homo_CrsLD1,BehxHomo_CrsLD1] = ZCX_canoncorr(ho_FC1(~absences,:),behaviours_ageadj(~absences,:));
[Homo_COEF2,BehxHomo_COEF2,CCA_Homo_r2,Homo_ComSR2,BehxHomo_ComSR2,CCA_Homo_stats2,Homo_LD2,BehxHomo_LD2,Homo_CrsLD2,BehxHomo_CrsLD2] = ZCX_canoncorr(ho_FC2(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_COEF1,BehxLIabs_COEF1,CCA_LIabs_r1,LIabs_ComSR1,BehxLIabs_ComSR1,CCA_LIabs_stats1,LIabs_LD1,BehxLIabs_LD1,LIabs_CrsLD1,BehxLIabs_CrsLD1] = ZCX_canoncorr(LI_intra_abs1(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_COEF2,BehxLIabs_COEF2,CCA_LIabs_r2,LIabs_ComSR2,BehxLIabs_ComSR2,CCA_LIabs_stats2,LIabs_LD2,BehxLIabs_LD2,LIabs_CrsLD2,BehxLIabs_CrsLD2] = ZCX_canoncorr(LI_intra_abs2(~absences,:),behaviours_ageadj(~absences,:));


%% type 4
% seperated Homotopy and LIabs, covariances are involved

[Homo_COEF1_wCOV,BehxHomo_COEF1_wCOV,CCA_Homo_r1_wCOV,Homo_ComSR1_wCOV,BehxHomo_ComSR1_wCOV,CCA_Homo_stats1_wCOV,Homo_LD1_wCOV,BehxHomo_LD1_wCOV,Homo_CrsLD1_wCOV,BehxHomo_CrsLD1_wCOV] = ZCX_canoncorr([ho_FC1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[Homo_COEF2_wCOV,BehxHomo_COEF2_wCOV,CCA_Homo_r2_wCOV,Homo_ComSR2_wCOV,BehxHomo_ComSR2_wCOV,CCA_Homo_stats2_wCOV,Homo_LD2_wCOV,BehxHomo_LD2_wCOV,Homo_CrsLD2_wCOV,BehxHomo_CrsLD2_wCOV] = ZCX_canoncorr([ho_FC2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[LIabs_COEF1_wCOV,BehxLIabs_COEF1_wCOV,CCA_LIabs_r1_wCOV,LIabs_ComSR1_wCOV,BehxLIabs_ComSR1_wCOV,CCA_LIabs_stats1_wCOV,LIabs_LD1_wCOV,BehxLIabs_LD1_wCOV,LIabs_CrsLD1_wCOV,BehxLIabs_CrsLD1_wCOV] = ZCX_canoncorr([LI_intra_abs1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[LIabs_COEF2_wCOV,BehxLIabs_COEF2_wCOV,CCA_LIabs_r2_wCOV,LIabs_ComSR2_wCOV,BehxLIabs_ComSR2_wCOV,CCA_LIabs_stats2_wCOV,LIabs_LD2_wCOV,BehxLIabs_LD2_wCOV,LIabs_CrsLD2_wCOV,BehxLIabs_CrsLD2_wCOV] = ZCX_canoncorr([LI_intra_abs2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));


% titles(abs(round(Behaviour_COEF1(:,1)./10))>0)
% titles(abs(round(Behaviour_COEF2(:,1)./10))>0)

homo_CCA_num1=CCA_Homo_stats1.pChisq<0.05;
homo_CCA_num2=sum(CCA_Homo_stats2.pChisq<0.05);
liabs_CCA_num1=CCA_LIabs_stats1.pChisq<0.05;
liabs_CCA_num2=sum(CCA_LIabs_stats2.pChisq<0.05);

for i=1:homo_CCA_num1
% titles(abs(round(BehxHomo_COEF1(:,i)./10))>0);
% titles(abs(round(BehxHomo_COEF2(:,i)./10))>0);
for j=1:homo_CCA_num2

PlotCorr([statspath,'/Separate/Homo/'],['HomoxBehav_Rest1_CCA_',num2str(i)],Homo_ComSR1(:,i),BehxHomo_ComSR1(:,i));
PlotCorr([statspath,'/Separate/Homo/'],['HomoxBehav_Task_CCA_',num2str(j)],Homo_ComSR2(:,j),BehxHomo_ComSR2(:,j));

PlotCorr([statspath,'/Separate/Homo/'],['Behav_Homo_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],BehxHomo_COEF1(:,i),BehxHomo_COEF2(:,j));
PlotCorr([statspath,'/Separate/Homo/'],['Brain_Homo_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],Homo_COEF1(:,i),Homo_COEF2(:,j));

PlotCorr([statspath,'/Separate/Homo/'],['Behav_Homo_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],BehxHomo_LD1(:,i),BehxHomo_LD2(:,j));
PlotCorr([statspath,'/Separate/Homo/'],['Brain_Homo_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],Homo_LD1(:,i),Homo_LD2(:,j));

homo_brain_co1=zeros(192,1);
homo_brain_co2=zeros(192,1);
homo_brain_co1(nid)=Homo_COEF1(:,i);
homo_brain_co2(nid)=Homo_COEF2(:,j);

homo_brain_ld1=zeros(192,1);
homo_brain_ld2=zeros(192,1);
homo_brain_ld1(nid)=Homo_LD1(:,i);
homo_brain_ld2(nid)=Homo_LD2(:,j);

SaveAsAtlasMZ3_Plot(homo_brain_co1,[statspath,'/Separate/Homo/'],['Brian_Homo_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(homo_brain_co2,[statspath,'/Separate/Homo/'],['Brian_Homo_Task_COEF_' num2str(j)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(homo_brain_ld1,[statspath,'/Separate/Homo/'],['Brian_Homo_Rest1_LOAD_' num2str(i)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(homo_brain_ld2,[statspath,'/Separate/Homo/'],['Brian_Homo_Task_LOAD_' num2str(j)],[-0.2,0.2],shp);

% ['BehavxHomo_Rest_Com',num2str(i),' r=',num2str(CCA_Homo_r1(i)),' p=',num2str(CCA_Homo_stats1.p(i))]
% ['BehavxHomo_Task_Com',num2str(i),' r=',num2str(CCA_Homo_r2(i)),' p=',num2str(CCA_Homo_stats2.p(i))]
end
end

for i=1:liabs_CCA_num1
% titles(abs(round(BehxLIabs_COEF1(:,i)./10))>0);
% titles(abs(round(BehxLIabs_COEF2(:,i)./10))>0);
for j=1:liabs_CCA_num2

PlotCorr([statspath,'/Separate/LIabs/'],['LIabsxBehav_Rest1_CCA_',num2str(i)],LIabs_ComSR1(:,i),BehxLIabs_ComSR1(:,i));
PlotCorr([statspath,'/Separate/LIabs/'],['LIabsxBehav_Task_CCA_',num2str(j)],LIabs_ComSR2(:,j),BehxLIabs_ComSR2(:,j));

PlotCorr([statspath,'/Separate/LIabs/'],['Behav_LIabs_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],BehxLIabs_COEF1(:,i),BehxLIabs_COEF2(:,j));
PlotCorr([statspath,'/Separate/LIabs/'],['Brain_LIabs_Rest1xTask_COEF_',num2str(i),'x',num2str(j)],LIabs_COEF1(:,i),LIabs_COEF2(:,j));

PlotCorr([statspath,'/Separate/LIabs/'],['Behav_LIabs_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],BehxLIabs_LD1(:,i),BehxLIabs_LD2(:,j));
PlotCorr([statspath,'/Separate/LIabs/'],['Brain_LIabs_Rest1xTask_LOAD_',num2str(i),'x',num2str(j)],LIabs_LD1(:,i),LIabs_LD2(:,j));
 
liabs_brain_co1=zeros(192,1);
liabs_brain_co2=zeros(192,1);
liabs_brain_co1(nid)=LIabs_COEF1(:,i);
liabs_brain_co2(nid)=LIabs_COEF2(:,j);

liabs_brain_ld1=zeros(192,1);
liabs_brain_ld2=zeros(192,1);
liabs_brain_ld1(nid)=LIabs_LD1(:,i);
liabs_brain_ld2(nid)=LIabs_LD2(:,j);

SaveAsAtlasMZ3_Plot(liabs_brain_co1,[statspath,'/Separate/LIabs/'],['Brian_LIabs_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(liabs_brain_co2,[statspath,'/Separate/LIabs/'],['Brian_LIabs_Task_COEF_' num2str(j)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(liabs_brain_ld1,[statspath,'/Separate/LIabs/'],['Brian_LIabs_Rest1_LOAD_' num2str(i)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(liabs_brain_ld2,[statspath,'/Separate/LIabs/'],['Brian_LIabs_Task_LOAD_' num2str(j)],[-0.2,0.2],shp);

% ['BehavxLIabs_Rest_Com',num2str(i),' r=',num2str(CCA_LIabs_r1(i)),' p=',num2str(CCA_LIabs_stats1.p(i))]
% ['BehavxLIabs_Task_Com',num2str(i),' r=',num2str(CCA_LIabs_r2(i)),' p=',num2str(CCA_LIabs_stats2.p(i))]
end
end

for i=1:homo_CCA_num1
    for j=1:liabs_CCA_num1
        PlotCorr([statspath,'/Separate/'],['Behav_HoxLI_Rest1_COEF_H',num2str(i),'&LI',num2str(j)],BehxHomo_COEF1(:,i),BehxLIabs_COEF1(:,j));
        PlotCorr([statspath,'/Separate/'],['Brian_HoxLI_Rest1_COEF_H',num2str(i),'&LI',num2str(j)],Homo_COEF1(:,i),LIabs_COEF1(:,j));
        PlotCorr([statspath,'/Separate/'],['Behav_HoxLI_Rest1_LOAD_H',num2str(i),'&LI',num2str(j)],BehxHomo_LD1(:,i),BehxLIabs_LD1(:,j));
        PlotCorr([statspath,'/Separate/'],['Brian_HoxLI_Rest1_LOAD_H',num2str(i),'&LI',num2str(j)],Homo_LD1(:,i),LIabs_LD1(:,j));
          
    end
end

for i=1:homo_CCA_num2
    for j=1:liabs_CCA_num2
        PlotCorr([statspath,'/Separate/'],['Behav_HoxLI_Task_COEF_H',num2str(i),'&LI',num2str(j)],BehxHomo_COEF2(:,i),BehxLIabs_COEF2(:,j));
        PlotCorr([statspath,'/Separate/'],['Brian_HoxLI_Task_COEF_H',num2str(i),'&LI',num2str(j)],Homo_COEF2(:,i),LIabs_COEF2(:,j));
        PlotCorr([statspath,'/Separate/'],['Behav_HoxLI_Task_LOAD_H',num2str(i),'&LI',num2str(j)],BehxHomo_LD2(:,i),BehxLIabs_LD2(:,j));
        PlotCorr([statspath,'/Separate/'],['Brian_HoxLI_Task_LOAD_H',num2str(i),'&LI',num2str(j)],Homo_LD2(:,i),LIabs_LD2(:,j));
    end
end