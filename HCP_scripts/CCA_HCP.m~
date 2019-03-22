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
%% type 1
%combined Homotopy and LIabs, covariances are not involved

[Brain_COEF1,Behaviour_COEF1,CCA_T_r1,Brain_ComSR1,Behaviour_ComSR1,CCA_T_stats1,Brain_LD1,Behaviour_LD1,Brain_CrsLD1,Behaviour_CrsLD1] = ZCX_canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:)],behaviours_ageadj(~absences,:));
[Brain_COEF2,Behaviour_COEF2,CCA_T_r2,Brain_ComSR2,Behaviour_ComSR2,CCA_T_stats2,Brain_LD2,Behaviour_LD2,Brain_CrsLD2,Behaviour_CrsLD2] = ZCX_canoncorr([ho_FC2(~absences,:),LI_intra_abs2(~absences,:)],behaviours_ageadj(~absences,:));

%% type 2
% seperated Homotopy and LIabs, covariances are not involved

[Homo_COEF1,BehxHomo_COEF1,CCA_Homo_r1,Homo_ComSR1,BehxHomo_ComSR1,CCA_Homo_stats1,Homo_LD1,BehxHomo_LD1,Homo_CrsLD1,BehxHomo_CrsLD1] = ZCX_canoncorr(ho_FC1(~absences,:),behaviours_ageadj(~absences,:));
[Homo_COEF2,BehxHomo_COEF2,CCA_Homo_r2,Homo_ComSR2,BehxHomo_ComSR2,CCA_Homo_stats2,Homo_LD2,BehxHomo_LD2,Homo_CrsLD2,BehxHomo_CrsLD2] = ZCX_canoncorr(ho_FC2(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_COEF1,BehxLIabs_COEF1,CCA_LIabs_r1,LIabs_ComSR1,BehxLIabs_ComSR1,CCA_LIabs_stats1,LIabs_LD1,BehxLIabs_LD1,LIabs_CrsLD1,BehxLIabs_CrsLD1] = ZCX_canoncorr(LI_intra_abs1(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_COEF2,BehxLIabs_COEF2,CCA_LIabs_r2,LIabs_ComSR2,BehxLIabs_ComSR2,CCA_LIabs_stats2,LIabs_LD2,BehxLIabs_LD1,LIabs_CrsLD2,BehxLIabs_CrsLD1] = ZCX_canoncorr(LI_intra_abs2(~absences,:),behaviours_ageadj(~absences,:));

%% type 3
%combined Homotopy and LIabs, covariances are involved

[Brain_COEF1_wCOV,Behaviour_COEF1_wCOV,CCA_T_r1_wCOV,Brain_ComSR1_wCOV,Behaviour_ComSR1_wCOV,CCA_T_stats1_wCOV,Brain_LD1_wCOV,Behaviour_LD1_wCOV,Brain_CrsLD1_wCOV,Behaviour_CrsLD1_wCOV] = ZCX_canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[Brain_COEF2_wCOV,Behaviour_COEF2_wCOV,CCA_T_r2_wCOV,Brain_ComSR2_wCOV,Behaviour_ComSR2_wCOV,CCA_T_stats2_wCOV,Brain_LD2_wCOV,Behaviour_LD2_wCOV,Brain_CrsLD2_wCOV,Behaviour_CrsLD2_wCOV] = ZCX_canoncorr([ho_FC2(~absences,:),LI_intra_abs2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));

%% type 4
% seperated Homotopy and LIabs, covariances are involved

[Homo_COEF1_wCOV,BehxHomo_COEF1_wCOV,CCA_Homo_r1_wCOV,Homo_ComSR1_wCOV,BehxHomo_ComSR1_wCOV,CCA_Homo_stats1_wCOV,Homo_LD1_wCOV,BehxHomo_LD1_wCOV,Homo_CrsLD1_wCOV,BehxHomo_CrsLD1_wCOV] = ZCX_canoncorr([ho_FC1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[Homo_COEF2_wCOV,BehxHomo_COEF2_wCOV,CCA_Homo_r2_wCOV,Homo_ComSR2_wCOV,BehxHomo_ComSR2_wCOV,CCA_Homo_stats2_wCOV,Homo_LD2_wCOV,BehxHomo_LD2_wCOV,Homo_CrsLD2_wCOV,BehxHomo_CrsLD2_wCOV] = ZCX_canoncorr([ho_FC2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[LIabs_COEF1_wCOV,BehxLIabs_COEF1_wCOV,CCA_LIabs_r1_wCOV,LIabs_ComSR1_wCOV,BehxLIabs_ComSR1_wCOV,CCA_LIabs_stats1_wCOV,LIabs_LD1_wCOV,BehxLIabs_LD1_wCOV,LIabs_CrsLD1_wCOV,BehxLIabs_CrsLD1_wCOV] = ZCX_canoncorr([LI_intra_abs1(~absences,:),age,gennum],behaviours_ageadj(~absences,:));
[LIabs_COEF2_wCOV,BehxLIabs_COEF2_wCOV,CCA_LIabs_r2_wCOV,LIabs_ComSR2_wCOV,BehxLIabs_ComSR2_wCOV,CCA_LIabs_stats2_wCOV,LIabs_LD2_wCOV,BehxLIabs_LD1_wCOV,LIabs_CrsLD2_wCOV,BehxLIabs_CrsLD1_wCOV] = ZCX_canoncorr([LI_intra_abs2(~absences,:),age,gennum],behaviours_ageadj(~absences,:));


% titles(abs(round(Behaviour_COEF1(:,1)./10))>0)
% titles(abs(round(Behaviour_COEF2(:,1)./10))>0)

homo_CCA_num=max(sum(CCA_Homo_stats1.p<0.05),sum(CCA_Homo_stats2.p<0.05));
liabs_CCA_num=max(sum(CCA_LIabs_stats1.p<0.05),sum(CCA_LIabs_stats2.p<0.05));

for i=1:homo_CCA_num
% titles(abs(round(BehxHomo_COEF1(:,i)./10))>0);
% titles(abs(round(BehxHomo_COEF2(:,i)./10))>0);

PlotCorr([statspath,'/Homo/'],['HomoxBehav_Rest1_CCA_' num2str(i)],Homo_ComSR1(:,i),BehxHomo_ComSR1(:,i));
PlotCorr([statspath,'/Homo/'],['HomoxBehav_Task_CCA_' num2str(i)],Homo_ComSR2(:,i),BehxHomo_ComSR2(:,i));

PlotCorr([statspath,'/Homo/'],['Behav_Homo_Rest1xTask_COEF_' num2str(i)],BehxHomo_COEF1(:,i),BehxHomo_COEF2(:,i));
PlotCorr([statspath,'/Homo/'],['Brian_Homo_Rest1xTask_COEF_' num2str(i)],Homo_COEF1(:,i),Homo_COEF2(:,i));
homo_brain1=zeros(192,1);
homo_brain2=zeros(192,1);
homo_brain1(nid)=Homo_COEF1(:,i);
homo_brain2(nid)=Homo_COEF2(:,i);

SaveAsAtlasMZ3_Plot(homo_brain1,[statspath,'/Homo/'],['Brian_Homo_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);
SaveAsAtlasMZ3_Plot(homo_brain2,[statspath,'/Homo/'],['Brian_Homo_Task_COEF_' num2str(i)],[-0.2,0.2],shp);

% ['BehavxHomo_Rest_Com',num2str(i),' r=',num2str(CCA_Homo_r1(i)),' p=',num2str(CCA_Homo_stats1.p(i))]
% ['BehavxHomo_Task_Com',num2str(i),' r=',num2str(CCA_Homo_r2(i)),' p=',num2str(CCA_Homo_stats2.p(i))]

end

for i=1:liabs_CCA_num
titles(abs(round(BehxLIabs_COEF1(:,i)./10))>0);
% titles(abs(round(BehxLIabs_COEF2(:,i)./10))>0);

PlotCorr([statspath,'/LIabs/'],['LIabsxBehav_Rest1_CCA_' num2str(i)],LIabs_ComSR1(:,i),BehxLIabs_ComSR1(:,i));
PlotCorr([statspath,'/LIabs/'],['LIabsxBehav_Task_CCA_' num2str(i)],LIabs_ComSR2(:,i),BehxLIabs_ComSR2(:,i));

PlotCorr([statspath,'/LIabs/'],['Behav_LIabs_Rest1xTask_COEF_' num2str(i)],BehxLIabs_COEF1(:,i),BehxLIabs_COEF2(:,i));
PlotCorr([statspath,'/LIabs/'],['Brian_LIabs_Rest1xTask_COEF_' num2str(i)],LIabs_COEF1(:,i),LIabs_COEF2(:,i));
 
liabs_brain1=zeros(192,1);
liabs_brain2=zeros(192,1);
liabs_brain1(nid)=LIabs_COEF1(:,i);
liabs_brain2(nid)=LIabs_COEF2(:,i);


SaveAsAtlasMZ3_Plot(liabs_brain1,[statspath,'/LIabs/'],['Brian_LIabs_Rest1_COEF_' num2str(i)],[-0.2,0.2],shp);

SaveAsAtlasMZ3_Plot(liabs_brain2,[statspath,'/LIabs/'],['Brian_LIabs_Task_COEF_' num2str(i)],[-0.2,0.2],shp);

% ['BehavxLIabs_Rest_Com',num2str(i),' r=',num2str(CCA_LIabs_r1(i)),' p=',num2str(CCA_LIabs_stats1.p(i))]
% ['BehavxLIabs_Task_Com',num2str(i),' r=',num2str(CCA_LIabs_r2(i)),' p=',num2str(CCA_LIabs_stats2.p(i))]
end

Rhoxli_ho_num=sum(CCA_Homo_stats1.p<0.05);
Rhoxli_li_num=sum(CCA_LIabs_stats1.p<0.05);
Thoxli_ho_num=sum(CCA_Homo_stats2.p<0.05);
Thoxli_li_num=sum(CCA_LIabs_stats2.p<0.05);

for i=1:Rhoxli_ho_num
    for j=1:Rhoxli_li_num
        PlotCorr([statspath,'/'],['Behav_HoxLI_Rest1_COEF_H',num2str(i),'&LI',num2str(j)],BehxHomo_COEF1(:,i),BehxLIabs_COEF1(:,j));
        PlotCorr([statspath,'/'],['Brian_HoxLI_Rest1_COEF_H',num2str(i),'&LI',num2str(j)],Homo_COEF1(:,i),LIabs_COEF1(:,j));
    end
end

for i=1:Thoxli_ho_num
    for j=1:Thoxli_li_num
        PlotCorr([statspath,'/'],['Behav_HoxLI_Task_COEF_H',num2str(i),'&LI',num2str(j)],BehxHomo_COEF2(:,i),BehxLIabs_COEF2(:,j));
        PlotCorr([statspath,'/'],['Brian_HoxLI_Task_COEF_H',num2str(i),'&LI',num2str(j)],Homo_COEF2(:,i),LIabs_COEF2(:,j));
    end
end