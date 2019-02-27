function [finalFCS] = getFCS(statspath,FCmap_path,atlas,idrange)

%% get FCS
SubSize=length(FCmap_path);
if strcmp(atlas,'AIC')
    id=[2:2:384;1:2:384]';
    homonum=384/2;
elseif strcmp(atlas,'BNA')
    id=[2:2:246;1:2:246]';
    homonum=246/2;
end

pos_flag=1;

ho_FC=zeros(SubSize,homonum);
for k=1:SubSize
    [~,tmpname,~]=fileparts(FCmap_path{k});
    IDS(k,1)=str2num(tmpname(end-5:end));
    tmpFC=load(FCmap_path{k});
    tempFC=tril(tmpFC.FCMat,-1);

    temp=tempFC;
    
    for i=1:homonum
        ho_FC(k,i)=temp(id(i,1),id(i,2));
    end
    
    FCC=temp+temp';
    
    LL=FCC(1:2:end,1:2:end);
    RR=FCC(2:2:end,2:2:end);
    %         LR=FCC(2:2:end,1:2:end);
    %         RL=FCC(1:2:end,2:2:end);
    if pos_flag==1
        FCS_LL=sum(LL);
        FCS_RR=sum(RR);
        %         FCS_LR=sum(LR);
        %         FCS_RL=sum(RL);
        L_L(k,:)=FCS_LL;
        R_R(k,:)=FCS_RR;
        %         L_R(k,:)=FCS_LR;
        %         R_L(k,:)=FCS_RL;
        global_mean(k,1)=mean(mean(temp));
        global_absmean(k,1)=mean(mean(abs(temp)));
    elseif pos_flag==0
        FCS_LL=sum(LL(LL>0))./sum(LL>0);
        FCS_RR=sum(RR(RR>0))./sum(RR>0);
        L_L(k,:)=FCS_LL;
        R_R(k,:)=FCS_RR;        
        global_mean(k,1)=mean(mean(temp(temp>0)));
        global_absmean(k,1)=mean(mean(abs(temp(temp>0))));
    end
end

% left_seg=L_L-(L_R-ho_FC);right_seg=R_R-(R_L-ho_FC);
% left_inte=L_L+(L_R-ho_FC);right_inte=R_R+(R_L-ho_FC);
intra_LL=L_L;intra_RR=R_R;
% he_LR=L_R-ho_FC;he_RL=R_L-ho_FC;
AI_intra = (intra_LL-intra_RR) ./ (abs(intra_LL)+abs(intra_RR));
AI_intra_abs = abs(intra_LL-intra_RR) ./ (abs(intra_LL)+abs(intra_RR));
AI_intra(isnan(AI_intra))=0;
AI_intra_abs(isnan(AI_intra_abs))=0;

finalFCS.subid=IDS;
finalFCS.homo=ho_FC;
finalFCS.intra_L=intra_LL;
finalFCS.intra_R=intra_RR;
finalFCS.intra_AI=AI_intra;
finalFCS.intra_absAI=AI_intra_abs;
finalFCS.global=global_mean;
finalFCS.global_abs=global_absmean;

[svp,~,~]=fileparts(statspath);
system(['mkdir -p ' svp]);
save([statspath '.mat'],'finalFCS');
