function [finalFCS] = tFCSrmrs(statspath,r2zflag,Sid,taskFC_path1,taskFC_path2,restFC_path1,restFC_path2)

%% get FCS

SubSize=length(Sid);

id=[2:2:384;1:2:384]';
ho_FC=zeros(SubSize,192);

for i=1:length(taskFC_path1)
    [~,tmpname,~]=fileparts(taskFC_path1{i});
    tID1(i,1)=str2num(tmpname(2:end));
end
for i=1:length(taskFC_path2)
    [~,tmpname,~]=fileparts(taskFC_path2{i});
    tID2(i,1)=str2num(tmpname(2:end));
end
for i=1:length(restFC_path1)
    [~,tmpname,~]=fileparts(restFC_path1{i});
    rID1(i,1)=str2num(tmpname(2:end));
end
for i=1:length(restFC_path2)
    [~,tmpname,~]=fileparts(restFC_path2{i});
    rID2(i,1)=str2num(tmpname(2:end));
end

[~,iSt1,~]=intersect(tID1,Sid);
[~,iSt2,~]=intersect(tID2,Sid);
[~,iSr1,~]=intersect(rID1,Sid);
[~,iSr2,~]=intersect(rID2,Sid);

FCmap=zeros(384,384);

for k=1:SubSize
    
    tmpFCtask1=load(taskFC_path1{iSt1(k)});
    tmpFCtask2=load(taskFC_path2{iSt2(k)});
    tmpFCrest1=load(restFC_path1{iSr1(k)});
    tmpFCrest2=load(restFC_path2{iSr2(k)});
    
    if r2zflag==1
        temptask1=fisherR2Z(tril(tmpFCtask1,-1)); % R to Z
        temptask2=fisherR2Z(tril(tmpFCtask2,-1));
        temprest1=fisherR2Z(tril(tmpFCrest1,-1));
        temprest2=fisherR2Z(tril(tmpFCrest2,-1));
    else
        temptask1=tril(tmpFCtask1,-1);
        temptask2=tril(tmpFCtask2,-1);
        temprest1=tril(tmpFCrest1,-1);
        temprest2=tril(tmpFCrest2,-1);
    end

    
    temp=(temptask1+temptask2)/2-(temprest1+temprest2)/2;
   
    FCmap=FCmap+temp;
    
    for i=1:192
        ho_FC(k,i)=temp(id(i,1),id(i,2));
    end
    
    FCC=temp+temp';
    
    
    LL=FCC(1:2:end,1:2:end);
    RR=FCC(2:2:end,2:2:end);
    FCS_LL=sum(LL);
    FCS_RR=sum(RR);
    L_L(k,:)=FCS_LL;
    R_R(k,:)=FCS_RR;
    global_mean(k,1)=mean(mean(temp));
    global_absmean(k,1)=mean(mean(abs(temp)));
end

intra_LL=L_L;
intra_RR=R_R;
AI_intra = (intra_LL-intra_RR) ./ (abs(intra_LL)+abs(intra_RR));
AI_intra_abs = abs(intra_LL-intra_RR) ./ (abs(intra_LL)+abs(intra_RR));
AI_intra(isnan(AI_intra))=0;
AI_intra_abs(isnan(AI_intra_abs))=0;

finalFCS.subid=Sid;
finalFCS.homo=ho_FC;
finalFCS.intra_L=intra_LL;
finalFCS.intra_R=intra_RR;
finalFCS.intra_AI=AI_intra;
finalFCS.intra_absAI=AI_intra_abs;
finalFCS.global=global_mean;
finalFCS.global_abs=global_absmean;
finalFCS.FCmap_avg=FCmap./SubSize;


save([statspath '.mat'],'finalFCS');
end
% %% Group mean - Across subject
% [~,iS,~]=intersect(CIDS,Sid);
% 
% IntraFC_mean(1:2:384)=mean(intra_LL(iS,:))';
% IntraFC_std(1:2:384)=std(intra_LL(iS,:))';
% IntraFC_mean(2:2:384)=mean(intra_RR(iS,:))';
% IntraFC_std(2:2:384)=std(intra_RR(iS,:))';
% HomoFC_mean=mean(ho_FC(iS,:))';
% HomoFC_std=std(ho_FC(iS,:))';
% 
% SaveAsAtlasNii(IntraFC_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_mean',0)
% SaveAsAtlasNii(IntraFC_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_std',0)
% SaveAsAtlasNii(HomoFC_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'HomoFC_mean',1)
% SaveAsAtlasNii(HomoFC_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'HomoFC_std',1)
% 
% NiiProj2Surf([statspath,'IntraFC_mean','.nii'],'inf','tri','bil',[0 50]);
% NiiProj2Surf([statspath,'IntraFC_std','.nii'],'inf','tri','bil',[0 25]);
% NiiProj2Surf([statspath,'HomoFC_mean','.nii'],'inf','tri','hemi',[0 1.8]);
% NiiProj2Surf([statspath,'HomoFC_std','.nii'],'inf','tri','hemi',[0 0.35]);
% 
% 
% AI_mean=mean(AI_intra(iS,:))';
% AI_std=std(AI_intra(iS,:))';
% AI_abs_mean=mean(AI_intra_abs(iS,:))';
% AI_abs_std=std(AI_intra_abs(iS,:))';
% 
% SaveAsAtlasNii(AI_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_AI_mean',1)
% SaveAsAtlasNii(AI_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_AI_std',1)
% SaveAsAtlasNii(AI_abs_mean,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_absAI_mean',1)
% SaveAsAtlasNii(AI_abs_std,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_absAI_std',1)
% 
% NiiProj2Surf([statspath,'IntraFC_AI_mean','.nii'],'inf','tri','hemi',[-0.5 0.5]);
% NiiProj2Surf([statspath,'IntraFC_AI_std','.nii'],'inf','tri','hemi',[0 0.3]);
% NiiProj2Surf([statspath,'IntraFC_absAI_mean','.nii'],'inf','tri','hemi',[0 0.5]);
% NiiProj2Surf([statspath,'IntraFC_absAI_std','.nii'],'inf','tri','hemi',[0 0.2]);
% 
% 
% h1=zeros(1,192);
% p1=zeros(1,192);
% t_intra=zeros(1,192);
% for j=1:192
%     [h1(1,j),p1(1,j),~,stats1]=ttest(intra_LL(iS,j),intra_RR(iS,j));
%     t_intra(1,j)=stats1.tstat;
% end
% 
% SaveAsAtlasNii(t_intra,'/data/stalxy/sharefolder/HCP/AICHA/AICHA.nii',statspath,'IntraFC_HemiTmap',1)
% NiiProj2Surf([statspath,'IntraFC_HemiTmap','.nii'],'inf','tri','hemi',[-40 40]);

