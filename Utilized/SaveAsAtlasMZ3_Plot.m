function SaveAsAtlasMZ3_Plot(metric,savepath,name,cbrange,shpath)

[faces, vertices, vertexColors, ~] = fileUtils.mz3.readMz3('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/AICHA_lh.mz3');

alpha=zeros(length(vertexColors),1);

for i=1:max(vertexColors)
    vertexColors(vertexColors==i)=metric(i);
    if metric(i) == 0 || isnan(metric(i))
        alpha(vertexColors==i)=0;
    else
        alpha(vertexColors==i)=1;
    end
end
if isempty(dir(savepath))
    system(['mkdir -p ' savepath]);
end
fileUtils.mz3.writeMz3([savepath,filesep,name,'.mz3'], faces, vertices,vertexColors,alpha);

surftransparencyflag=0;
cms={'Viridis_revised','Blue2Red'};
sds={'Toon','Metal'};
surfbase='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.L.white_MSMAll.32k_fs_LR.surf.gii';
for i=1:2
for j=1
    colormapname=cms{i};
    shadername=sds{j};
fidl = fopen([savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_lateral.gls'],'w');
fprintf(fidl,'%s\n','begin');
fprintf(fidl,'\t%s\n','resetdefaults()'); % reset parameters
fprintf(fidl,'\t%s\n',['meshload(''',savepath,filesep,name,'.mz3',''');']);  % firstly, add a basic mesh
fprintf(fidl,'\t%s\n','overlayvisible(1, false);'); % we don't use the basic mesh. so, set it dis-visible
fprintf(fidl,'\t%s\n',['overlayload(''',savepath,filesep,name,'.mz3',''');']); % secondly, add the regional values on atlas
fprintf(fidl,'\t%s\n',['overlayminmax(2, ',num2str(cbrange(1)),', ',num2str(cbrange(2)),');']); % colormap range
fprintf(fidl,'\t%s\n',['overlaycolorname(2, ''',colormapname,''');']); % colormap type
if cbrange(1)<0 && cbrange(2)<0
    fprintf(fidl,'\t%s\n','overlayinvert(2, true)'); % Surf-Ice auto-reverse the colormap if all value below zero, so we need to invert it
end
fprintf(fidl,'\t%s\n',['overlayload(''',surfbase,''');']); % finally, add the surf below atlas, using white surface
fprintf(fidl,'\t%s\n','overlaycolorname(3, ''gray'');'); % set the white surface as gray
fprintf(fidl,'\t%s\n','azimuthelevation(110, 15);'); 
fprintf(fidl,'\t%s\n','orientcubevisible(false);'); % don't display the orient cube
fprintf(fidl,'\t%s\n','shaderforbackgroundonly(false);'); % use the shader both on surface and atlas 
fprintf(fidl,'\t%s\n',['shadername(''',shadername,''');']);  % shader name
if surftransparencyflag==1
    fprintf(fidl,'\t%s\n','shaderxray(0, 0);');  % make the regions transparency
    fprintf(fidl,'\t%s\n','shaderadjust(''Ambient'', 0.8);');
    fprintf(fidl,'\t%s\n','shaderadjust(''Diffuse'', 0.55);');
    fprintf(fidl,'\t%s\n','shaderadjust(''Specular'', 0);');
    fprintf(fidl,'\t%s\n','shaderadjust(''Roughness'', 0);');
    fprintf(fidl,'\t%s\n','shaderadjust(''Smooth'', 1.5);');
    fprintf(fidl,'\t%s\n','shaderadjust(''OutlineWidth'', 0.5);');
    fprintf(fidl,'\t%s\n','shaderambientocclusion(0.6);');
    fprintf(fidl,'\t%s\n','shaderlightazimuthelevation(-12, -12);'); % the light directions
elseif surftransparencyflag==0
    fprintf(fidl,'\t%s\n','shaderxray(100, 0);');  % make the regions transparency
    if strcmp(shadername,'Toon')
        fprintf(fidl,'\t%s\n','shaderadjust(''Ambient'', 0.8);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Diffuse'', 0.8);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Specular'', 0);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Roughness'', 0);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Smooth'', 1.2);');
        fprintf(fidl,'\t%s\n','shaderadjust(''OutlineWidth'', 0.6);');
        fprintf(fidl,'\t%s\n','shaderambientocclusion(0.6);');
        fprintf(fidl,'\t%s\n','shaderlightazimuthelevation(-12, -12);'); % the light directions
    elseif strcmp(shadername,'Mental')
        fprintf(fidl,'\t%s\n','shaderadjust(''Ambient'', 1.1);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Diffuse'', 1);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Specular'', 0.3);');
        fprintf(fidl,'\t%s\n','shaderadjust(''Shininess'', 50);');
        fprintf(fidl,'\t%s\n','shaderambientocclusion(0);');
        fprintf(fidl,'\t%s\n','shaderlightazimuthelevation(-2, 2);'); % the light directions
    end
end
fprintf(fidl,'\t%s\n','viewsagittal(true);'); % surface orientation
fprintf(fidl,'\t%s\n','azimuth(180);'); % show lateral
fprintf(fidl,'\t%s\n','cameradistance(0.8);'); 
fprintf(fidl,'\t%s\n','colorbarvisible(false);');
% fprintf(fidl,'\t%s\n','colorbarposition(1);'); % show colormap at the bottom
fprintf(fidl,'\t%s\n','bmpzoom(1000);'); 
fprintf(fidl,'\t%s\n',['savebmpxy(''',savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_lateral.png',''',1000,1000);']); % save as png 
fprintf(fidl,'\t%s\n','quit;');
fprintf(fidl,'%s\n','end.');
fclose(fidl);

% system(['/opt/Surf_Ice/surfice -S ',savepath,filesep,name,'_lateral.gls;']);


fidm = fopen([savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_medial.gls'],'w');
fprintf(fidm,'%s\n','begin');
fprintf(fidm,'\t%s\n','resetdefaults()');
fprintf(fidm,'\t%s\n',['meshload(''',savepath,filesep,name,'.mz3',''');']);
fprintf(fidm,'\t%s\n','overlayvisible(1, false);');
fprintf(fidm,'\t%s\n',['overlayload(''',savepath,filesep,name,'.mz3',''');']);
fprintf(fidm,'\t%s\n',['overlayminmax(2, ',num2str(cbrange(1)),', ',num2str(cbrange(2)),');']);
fprintf(fidm,'\t%s\n',['overlaycolorname(2, ''',colormapname,''');']);
if cbrange(1)<0 && cbrange(2)<0
    fprintf(fidm,'\t%s\n','overlayinvert(2, true)'); % Surf-Ice auto-reverse the colormap if all value below zero, so we need to invert it
end
fprintf(fidm,'\t%s\n',['overlayload(''',surfbase,''');']);
fprintf(fidm,'\t%s\n','overlaycolorname(3, ''gray'');');
fprintf(fidm,'\t%s\n','azimuthelevation(110, 15);');
fprintf(fidm,'\t%s\n','orientcubevisible(false);');
fprintf(fidm,'\t%s\n','shaderforbackgroundonly(false);'); 
fprintf(fidm,'\t%s\n',['shadername(''',shadername,''');']);
if surftransparencyflag==1
    fprintf(fidm,'\t%s\n','shaderxray(0, 0);');  % make the regions transparency
    fprintf(fidm,'\t%s\n','shaderadjust(''Ambient'', 0.8);');
    fprintf(fidm,'\t%s\n','shaderadjust(''Diffuse'', 0.55);');
    fprintf(fidm,'\t%s\n','shaderadjust(''Specular'', 0);');
    fprintf(fidm,'\t%s\n','shaderadjust(''Roughness'', 0);');
    fprintf(fidm,'\t%s\n','shaderadjust(''Smooth'', 1.5);');
    fprintf(fidm,'\t%s\n','shaderadjust(''OutlineWidth'', 0.5);');
    fprintf(fidm,'\t%s\n','shaderambientocclusion(0.6);');
    fprintf(fidm,'\t%s\n','shaderlightazimuthelevation(-12, -12);'); % the light directions
elseif surftransparencyflag==0
    fprintf(fidm,'\t%s\n','shaderxray(100, 0);');  % make the regions transparency
    if strcmp(shadername,'Toon')
        fprintf(fidm,'\t%s\n','shaderadjust(''Ambient'', 0.8);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Diffuse'', 0.8);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Specular'', 0);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Roughness'', 0);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Smooth'', 1.2);');
        fprintf(fidm,'\t%s\n','shaderadjust(''OutlineWidth'', 0.6);');
        fprintf(fidm,'\t%s\n','shaderambientocclusion(0.6);');
        fprintf(fidm,'\t%s\n','shaderlightazimuthelevation(-12, -12);'); % the light directions
    elseif strcmp(shadername,'Mental')
        fprintf(fidm,'\t%s\n','shaderadjust(''Ambient'', 1.1);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Diffuse'', 1);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Specular'', 0.3);');
        fprintf(fidm,'\t%s\n','shaderadjust(''Shininess'', 50);');
        fprintf(fidm,'\t%s\n','shaderambientocclusion(0);');
        fprintf(fidm,'\t%s\n','shaderlightazimuthelevation(-2, 2);'); % the light directions
    end
end
fprintf(fidm,'\t%s\n','viewsagittal(true);');
fprintf(fidm,'\t%s\n','azimuth(0);'); % show medial
fprintf(fidm,'\t%s\n','cameradistance(0.8);');
fprintf(fidm,'\t%s\n','colorbarvisible(false);');
% fprintf(fidm,'\t%s\n','colorbarposition(1);');
fprintf(fidm,'\t%s\n','bmpzoom(1000);');
fprintf(fidm,'\t%s\n',['savebmpxy(''',savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_medial.png',''',1000,1000);']); % save as png 
fprintf(fidm,'\t%s\n','quit;');
fprintf(fidm,'%s\n','end.');
fclose(fidm);

% system(['/opt/Surf_Ice/surfice -S ',savepath,filesep,name,'_medial.gls;']);
    
if isempty(dir(shpath))
    fidcmd = fopen(shpath,'w');
else
    fidcmd = fopen(shpath,'a');
end
fprintf(fidcmd,'%s\n',['/opt/Surf_Ice/surfice ',savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_lateral.gls;wait']);
fprintf(fidcmd,'%s\n',['/opt/Surf_Ice/surfice ',savepath,filesep,name,'_',shadername,num2str(surftransparencyflag),'_',colormapname,'_medial.gls;wait']);
fclose(fidcmd);

end
end

end

