function [finalFCS] = getFCSTvsRHCP(statspath,Sid,taskFC_path,restFC_path,atlas)

%% get FCS

SubSize=length(Sid);

if strcmp(atlas,'AIC')
    id=[2:2:384;1:2:384]';
    homonum=384/2;
elseif strcmp(atlas,'BNA')
    id=[2:2:246;1:2:246]';
    homonum=246/2;
end

ho_FC=zeros(SubSize,homonum);

for i=1:length(taskFC_path)
    [~,tmpname,~]=fileparts(taskFC_path{i});
    tID(i,1)=str2num(tmpname(end-5:end));
end

for i=1:length(restFC_path)
    [~,tmpname,~]=fileparts(restFC_path{i});
    rID(i,1)=str2num(tmpname(end-5:end));
end

[StID,iSt,~]=intersect(tID,Sid);
[~,iSr,~]=intersect(rID,StID);

for k=1:length(StID)
    
    tmpFCtask=load(taskFC_path{iSt(k)});
    tmpFCrest=load(restFC_path{iSr(k)});
    
    temptask=tril(tmpFCtask.FCMat,-1);
    temprest=tril(tmpFCrest.FCMat,-1);
    
    temp=temptask-temprest;
       
    for i=1:homonum
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

finalFCS.subid=StID;
finalFCS.homo=ho_FC;
finalFCS.intra_L=intra_LL;
finalFCS.intra_R=intra_RR;
finalFCS.intra_AI=AI_intra;
finalFCS.intra_absAI=AI_intra_abs;
finalFCS.global=global_mean;
finalFCS.global_abs=global_absmean;

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

