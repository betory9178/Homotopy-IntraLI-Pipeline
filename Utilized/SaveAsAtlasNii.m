function SaveAsAtlasNii(metric,atlasflag,savepath,name,hemiflag)
% project results to according atlas
%
% mertic: results
% atlas: nii
% savepath: dir to save 
% name: save as 

if strcmp(atlasflag,'AIC2')
    AtlasP='/data/stalxy/Pipeline4JIN/atlas/HCP_2mm/AICHA.nii';
elseif strcmp(atlasflag,'BNA2')
    AtlasP='/data/stalxy/Pipeline4JIN/atlas/HCP_2mm/BNA.nii';
elseif strcmp(atlasflag,'AIC3')    
    AtlasP='/data/stalxy/Pipeline4JIN/atlas/Cam_Turner_3mm/AICHA.nii';
elseif strcmp(atlasflag,'BNA3')
    AtlasP='/data/stalxy/Pipeline4JIN/atlas/Cam_Turner_3mm/BNA.nii';
end

A=load_untouch_nii(AtlasP);
B=A;
if hemiflag==1
    for i=1:2:(max(unique(A.img)))
        
        B.img(A.img==i) = metric((i+1)/2);
    end
    
    for j=2:2:(max(unique(A.img)))
        B.img(A.img==j) = metric((j)/2);
    end
    
elseif hemiflag==0
    
    for i=1:(max(unique(A.img)))
        B.img(A.img==i) = metric(i);
    end
end

save_untouch_nii(B,[savepath name '.nii']);