function [] = NiiProj2Surf(Nii,surftype,projtype,hemitype,cbm)
% surftype = 'mid', mid-surface ; 'inf', inflated surface. 
% hemitype = 'bil', bi-hemisphere map; 'hemi', single left hemisphere map.
% projtype = 'ec', enclosing method; 'tri', trilinear method.
%
%
%

SurfAvgMidL='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.L.midthickness_MSMAll.32k_fs_LR.surf.gii';
SurfAvgMidR='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.R.midthickness_MSMAll.32k_fs_LR.surf.gii';

if strcmp(surftype,'mid')
    sL=gifti(SurfAvgMidL);
    sR=gifti(SurfAvgMidR);
    
elseif strcmp(surftype,'inf')
    
    SurfAvgInfL='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.L.inflated_MSMAll.32k_fs_LR.surf.gii';
    SurfAvgInfR='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.R.inflated_MSMAll.32k_fs_LR.surf.gii';
    
    sL=gifti(SurfAvgInfL);
    sR=gifti(SurfAvgInfR);
end
    
    
avsurfl.coord=sL.vertices';
avsurfl.tri=sL.faces;

avsurfr.coord=sR.vertices';
avsurfr.tri=sR.faces;

avsurf.coord=[avsurfl.coord,avsurfr.coord];
avsurf.tri=[avsurfl.tri;avsurfr.tri+32492];


[niipath,niiname,~]=fileparts(Nii);
if strcmp(projtype,'ec')
    cmd_projLec=['unset LD_LIBRARY_PATH;source /etc/profile;wb_command -volume-to-surface-mapping -enclosing ' Nii ' ' SurfAvgMidL ' ' niipath '/' niiname '_L_ec.func.gii'];
    cmd_projRec=['unset LD_LIBRARY_PATH;source /etc/profile;wb_command -volume-to-surface-mapping -enclosing ' Nii ' ' SurfAvgMidR ' ' niipath '/' niiname '_R_ec.func.gii'];
    system(cmd_projLec)
    system(cmd_projRec)
    smetricL=gifti([niipath '/' niiname '_L_ec.func.gii']);
    smetricR=gifti([niipath '/' niiname '_R_ec.func.gii']);
    
elseif strcmp(projtype,'tri')
    cmd_projLti=['unset LD_LIBRARY_PATH;source /etc/profile;wb_command -volume-to-surface-mapping -trilinear ' Nii ' ' SurfAvgMidL ' ' niipath '/' niiname '_L_tri.func.gii'];
    cmd_projRti=['unset LD_LIBRARY_PATH;source /etc/profile;wb_command -volume-to-surface-mapping -trilinear ' Nii ' ' SurfAvgMidR ' ' niipath '/' niiname '_R_tri.func.gii'];
    system(cmd_projLti);
    system(cmd_projRti);
    smetricL=gifti([niipath '/' niiname '_L_tri.func.gii']);
    smetricR=gifti([niipath '/' niiname '_R_tri.func.gii']);    
    
end

sml=smetricL.cdata';
smr=smetricR.cdata';

if strcmp(hemitype,'bil')
    
    a=figure,SurfStatViewData_lxy([sml,smr],avsurf, cbm, niiname),
    saveas(a,[niipath '/' niiname '.tif'],'tif');
    close(a);
    
elseif strcmp(hemitype,'hemi')
    b=figure,SurfStatViewData_lxy(sml,avsurfl, cbm, niiname),
    saveas(b,[niipath '/' niiname '.tif'],'tif');
    close(b)
end

end

