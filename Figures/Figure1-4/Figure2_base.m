ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
[numData1, textData1, rawData1]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet1');
[numData2, textData2, rawData2]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet2');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');

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

%% Part1 baseline
filepath='/data/stalxy/ArticleJResults/Figures/Figure2/';
shp='/data/stalxy/ArticleJResults/Figures/Figure2_plot.sh';
system(['rm ' shp]);

FCS_R1=load(FCS_R1path{k});
FCS_Rstate1=FCS_R1.finalFCS;

Fbase(FCS_Rstate1,af,ID.StID,filepath,'Rstate1_',0.3,shp)

%% Part3 relation of HomoxIntra within each STATE

Fcorr(FCS_Rstate1,af,ID.StID,term(age)+term(gen),filepath,'Rstate1',[age,gennum],[-0.5,0.5],shp)



