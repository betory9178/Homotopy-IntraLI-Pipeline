function CCA_HCP(FCS1,FCS2,atlasflag,subid,statspath)

FCS1=FCS_Rstate1;
FCS2=FCS_TstateA;
atlasflag='AIC';
subid=ID.StID;
statspath='/data/stalxy/ArticleJResults/HCP/Results/CCA_AICHA_NGR/';

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
% [Brain_Weight1,Behaviour_Weight1,CCA_T_r1,Brain_ComScore1,Behaviour_ComScore1,CCA_T_stats1] = canoncorr([ho_FC1(~absences,:),LI_intra_abs1(~absences,:)],behaviours_ageadj(~absences,:));
% [Brain_Weight2,Behaviour_Weight2,CCA_T_r2,Brain_ComScore2,Behaviour_ComScore2,CCA_T_stats2] = canoncorr([ho_FC2(~absences,:),LI_intra_abs2(~absences,:)],behaviours_ageadj(~absences,:));

[Homo_Weight1,BehxHomo_Weight1,CCA_Homo_r1,Homo_ComScore1,BehxHomo_ComScore1,CCA_Homo_stats1,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr(ho_FC1(~absences,:),behaviours_ageadj(~absences,:));
[Homo_Weight2,BehxHomo_Weight2,CCA_Homo_r2,Homo_ComScore2,BehxHomo_ComScore2,CCA_Homo_stats2,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr(ho_FC2(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_Weight1,BehxLIabs_Weight1,CCA_LIabs_r1,LIabs_ComScore1,BehxLIabs_ComScore1,CCA_LIabs_stats1,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr(LI_intra_abs1(~absences,:),behaviours_ageadj(~absences,:));
[LIabs_Weight2,BehxLIabs_Weight2,CCA_LIabs_r2,LIabs_ComScore2,BehxLIabs_ComScore2,CCA_LIabs_stats2,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr(LI_intra_abs2(~absences,:),behaviours_ageadj(~absences,:));

% titles(abs(round(Behaviour_Weight1(:,1)./10))>0)
% titles(abs(round(Behaviour_Weight2(:,1)./10))>0)

homo_CCA_num=max(sum(CCA_Homo_stats1.p<0.05),sum(CCA_Homo_stats2.p<0.05));
liabs_CCA_num=max(sum(CCA_LIabs_stats1.p<0.05),sum(CCA_LIabs_stats2.p<0.05));

for i=1:homo_CCA_num
% titles(abs(round(BehxHomo_Weight1(:,i)./10))>0);
% titles(abs(round(BehxHomo_Weight2(:,i)./10))>0);

PlotCorr([statspath,'/Homo/'],['HomoxBehav_Rest1_CCA_' num2str(i)],Homo_ComScore1(:,i),BehxHomo_ComScore1(:,i));
PlotCorr([statspath,'/Homo/'],['HomoxBehav_Task_CCA_' num2str(i)],Homo_ComScore2(:,i),BehxHomo_ComScore2(:,i));

PlotCorr([statspath,'/Homo/'],['Behav_Homo_Rest1xTask_Weight_' num2str(i)],BehxHomo_Weight1(:,i),BehxHomo_Weight2(:,i));
PlotCorr([statspath,'/Homo/'],['Brian_Homo_Rest1xTask_Weight_' num2str(i)],Homo_Weight1(:,i),Homo_Weight2(:,i));
homo_brain1=zeros(192,1);
homo_brain2=zeros(192,1);
homo_brain1(nid)=Homo_Weight1(:,i);
homo_brain2(nid)=Homo_Weight2(:,i);

SaveAsAtlasMZ3_Plot(homo_brain1,[statspath,'/Homo/'],['Brian_Homo_Rest1_Weight_' num2str(i)],[-0.2,0.2]);

SaveAsAtlasMZ3_Plot(homo_brain2,[statspath,'/Homo/'],['Brian_Homo_Task_Weight_' num2str(i)],[-0.2,0.2]);

% ['BehavxHomo_Rest_Com',num2str(i),' r=',num2str(CCA_Homo_r1(i)),' p=',num2str(CCA_Homo_stats1.p(i))]
% ['BehavxHomo_Task_Com',num2str(i),' r=',num2str(CCA_Homo_r2(i)),' p=',num2str(CCA_Homo_stats2.p(i))]

end

for i=1:liabs_CCA_num
titles(abs(round(BehxLIabs_Weight1(:,i)./10))>0);
% titles(abs(round(BehxLIabs_Weight2(:,i)./10))>0);

PlotCorr([statspath,'/LIabs/'],['LIabsxBehav_Rest1_CCA_' num2str(i)],LIabs_ComScore1(:,i),BehxLIabs_ComScore1(:,i));
PlotCorr([statspath,'/LIabs/'],['LIabsxBehav_Task_CCA_' num2str(i)],LIabs_ComScore2(:,i),BehxLIabs_ComScore2(:,i));

PlotCorr([statspath,'/LIabs/'],['Behav_LIabs_Rest1xTask_Weight_' num2str(i)],BehxLIabs_Weight1(:,i),BehxLIabs_Weight2(:,i));
PlotCorr([statspath,'/LIabs/'],['Brian_LIabs_Rest1xTask_Weight_' num2str(i)],LIabs_Weight1(:,i),LIabs_Weight2(:,i));
 
liabs_brain1=zeros(192,1);
liabs_brain2=zeros(192,1);
liabs_brain1(nid)=LIabs_Weight1(:,i);
liabs_brain2(nid)=LIabs_Weight2(:,i);


SaveAsAtlasMZ3_Plot(liabs_brain1,[statspath,'/LIabs/'],['Brian_LIabs_Rest1_Weight_' num2str(i)],[-0.2,0.2]);

SaveAsAtlasMZ3_Plot(liabs_brain2,[statspath,'/LIabs/'],['Brian_LIabs_Task_Weight_' num2str(i)],[-0.2,0.2]);

% ['BehavxLIabs_Rest_Com',num2str(i),' r=',num2str(CCA_LIabs_r1(i)),' p=',num2str(CCA_LIabs_stats1.p(i))]
% ['BehavxLIabs_Task_Com',num2str(i),' r=',num2str(CCA_LIabs_r2(i)),' p=',num2str(CCA_LIabs_stats2.p(i))]
end

Rhoxli_ho_num=sum(CCA_Homo_stats1.p<0.05);
Rhoxli_li_num=sum(CCA_LIabs_stats1.p<0.05);
Thoxli_ho_num=sum(CCA_Homo_stats2.p<0.05);
Thoxli_li_num=sum(CCA_LIabs_stats2.p<0.05);

for i=1:Rhoxli_ho_num
    for j=1:Rhoxli_li_num
        PlotCorr([statspath,'/'],['Behav_HoxLI_Rest1_Weight_H',num2str(i),'&LI',num2str(j)],BehxHomo_Weight1(:,i),BehxLIabs_Weight1(:,j));
        PlotCorr([statspath,'/'],['Brian_HoxLI_Rest1_Weight_H',num2str(i),'&LI',num2str(j)],Homo_Weight1(:,i),LIabs_Weight1(:,j));
    end
end

for i=1:Thoxli_ho_num
    for j=1:Thoxli_li_num
        PlotCorr([statspath,'/'],['Behav_HoxLI_Task_Weight_H',num2str(i),'&LI',num2str(j)],BehxHomo_Weight2(:,i),BehxLIabs_Weight2(:,j));
        PlotCorr([statspath,'/'],['Brian_HoxLI_Task_Weight_H',num2str(i),'&LI',num2str(j)],Homo_Weight2(:,i),LIabs_Weight2(:,j));
    end
end