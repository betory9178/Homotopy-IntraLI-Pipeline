ID=load('/data/stalxy/Pipeline4JIN/Results1228/SUBID.mat');
[numData1, textData1, rawData1]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet1');
[numData2, textData2, rawData2]=xlsread('/data/stalxy/HCP_CC/HCP_baseinform.xlsx','Sheet2');

FCS_R1path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST1_*.mat');
FCS_R2path=g_ls('/data/stalxy/ArticleJResults/HCP/FCSmat/REST2_*.mat');

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

%% Part

FCS_R1=load(FCS_R1path{k});
FCS_R2=load(FCS_R2path{k});

FCS_Rstate1=FCS_R1.finalFCS;
FCS_Rstate2=FCS_R2.finalFCS;

filepath='/data/stalxy/ArticleJResults/Figures/Figure1/';
shp='/data/stalxy/ArticleJResults/Figures/Figure1_plot.sh';
system(['rm ' shp]);

subid=ID.StID;

[~,~,iS1]=intersect(subid,FCS_Rstate1.subid);
[~,~,iS2]=intersect(subid,FCS_Rstate2.subid);

FCS_global1=FCS_Rstate1.global(iS1,:);
FCS_global2=FCS_Rstate2.global(iS2,:);

ho_FC1=FCS_Rstate1.homo(iS1,:);
LI_intra_abs1=FCS_Rstate1.intra_absAI(iS1,:);

HomoFC_mean1=mean(ho_FC1)';
LI_abs_mean1=mean(LI_intra_abs1)';     

ho_FC2=FCS_Rstate2.homo(iS2,:);
LI_intra_abs2=FCS_Rstate2.intra_absAI(iS2,:);

HomoFC_mean2=mean(ho_FC2)';
LI_abs_mean2=mean(LI_intra_abs2)';

statename='Rest';
% unirandsub=[180129;206727];
% for i=1:2
%     [~,~,Cid]=intersect(unirandsub(i),subid);
%     HomoFC_sub1=ho_FC1(Cid,:)';
%     SaveAsAtlasMZ3_Plot(HomoFC_sub1,filepath,[statename,'HomoFC1','_sub' num2str(unirandsub(i)),'_SFICE'],[-1.8 1.8],shp);
%     HomoFC_sub2=ho_FC2(Cid,:)';
%     SaveAsAtlasMZ3_Plot(HomoFC_sub2,filepath,[statename,'HomoFC2','_sub' num2str(unirandsub(i)),'_SFICE'],[-1.8 1.8],shp);
% 
%     LI_abs_sub1=LI_intra_abs1(Cid,:)';
%     SaveAsAtlasMZ3_Plot(LI_abs_sub1,filepath,[statename,'IntraFC_LIabs1','_sub' num2str(unirandsub(i)),'_SFICE'],[-0.3 0.3],shp);
%     LI_abs_sub2=LI_intra_abs2(Cid,:)';
%     SaveAsAtlasMZ3_Plot(LI_abs_sub2,filepath,[statename,'IntraFC_LIabs2','_sub' num2str(unirandsub(i)),'_SFICE'],[-0.3 0.3],shp);
%     
% end

if strcmp(af,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(af,'BNA')
    nid=[1:123];
end
for i=1:length(subid)
    [homoc_R_sub(i,1),homoc_P_sub(i,1)]=corr(ho_FC1(i,nid)',ho_FC2(i,nid)');       
    [intraLIabsc_R_sub(i,1),intraLIabsc_P_sub(i,1)]=corr(LI_intra_abs1(i,nid)',LI_intra_abs2(i,nid)');
end

    hist_lxy(homoc_R_sub,[],filepath,[statename '_homo_mapR_hist']);
    hist_lxy(intraLIabsc_R_sub,[],filepath,[statename '_intraLIabs_mapR_hist']);



%% ICC

for j=1:size(ho_FC1,2)

    ICC_homo(1,j)=IPN_icc([ho_FC1(:,j),ho_FC2(:,j)],1,'single');
    ICC_LIabs(1,j)=IPN_icc([LI_intra_abs1(:,j),LI_intra_abs2(:,j)],1,'single');
end
ICC_homo(isnan(ICC_homo))=0;
ICC_LIabs(isnan(ICC_LIabs))=0;

SaveAsAtlasMZ3_Plot(ICC_homo,filepath,[statename,'_ICC_Homo','_map','_SFICE'],[-1,1],shp);
SaveAsAtlasMZ3_Plot(ICC_LIabs,filepath,[statename,'_ICC_IntraLIabs','_map','_SFICE'],[-0.5,0.5],shp);