function SaveAsAtlasNii(metric,atlas,savepath,name,hemiflag)
% project results to according atlas
%
% mertic: results
% atlas: nii
% savepath: dir to save 
% name: save as 


A=load_untouch_nii(atlas);
B=A;
if hemiflag==1
    for i=1:2:384
        
        B.img(A.img==i) = metric((i+1)/2);
    end
    
    for j=2:2:384
        B.img(A.img==j) = metric((j)/2);
    end
    
elseif hemiflag==0
    
    for i=1:384
        B.img(A.img==i) = metric(i);
    end
end

save_untouch_nii(B,[savepath name '.nii']);