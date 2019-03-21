function SaveAsAtlasMZ3_Plot(metric,savepath,name,cbrange)

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

fileUtils.mz3.writeMz3([savepath,filesep,name,'.mz3'], faces, vertices,vertexColors,alpha);

colormapname='Viridis';
shadername='Toon';
surfbase='/data/pastlxy/HCP_S1200_GroupAvg_v1/S1200.L.white_MSMAll.32k_fs_LR.surf.gii';

fidl = fopen([savepath,filesep,name,'_lateral.gls'],'w');
fprintf(fidl,'%s\n','begin');
fprintf(fidl,'\t%s\n','resetdefaults()'); % reset parameters
fprintf(fidl,'\t%s\n',['meshload(''',savepath,filesep,name,'.mz3',''');']);  % firstly, add a basic mesh
fprintf(fidl,'\t%s\n','overlayvisible(1, false);'); % we don't use the basic mesh. so, set it dis-visible
fprintf(fidl,'\t%s\n',['overlayload(''',savepath,filesep,name,'.mz3',''');']); % secondly, add the regional values on atlas
fprintf(fidl,'\t%s\n',['overlayminmax(2, ',num2str(cbrange(1)),', ',num2str(cbrange(2)),');']); % colormap range
fprintf(fidl,'\t%s\n',['overlaycolorname(2, ''',colormapname,''');']); % colormap type
fprintf(fidl,'\t%s\n',['overlayload(''',surfbase,''');']); % finally, add the surf below atlas, using white surface
fprintf(fidl,'\t%s\n','overlaycolorname(3, ''gray'');'); % set the white surface as gray
fprintf(fidl,'\t%s\n','shaderxray(0, 0);');  % make the regions transparency 
fprintf(fidl,'\t%s\n','azimuthelevation(110, 15);'); 
fprintf(fidl,'\t%s\n','orientcubevisible(false);'); % don't display the orient cube
fprintf(fidl,'\t%s\n',['shadername(''',shadername,''');']);  % shader name
fprintf(fidl,'\t%s\n','shaderforbackgroundonly(false);'); % use the shader both on surface and atlas 
fprintf(fidl,'\t%s\n','shaderlightazimuthelevation(-10, 25);'); % the light directions
fprintf(fidl,'\t%s\n','shaderadjust(''Ambient'', 0.75);'); 
fprintf(fidl,'\t%s\n','shaderadjust(''Diffuse'', 0.6);');
fprintf(fidl,'\t%s\n','shaderadjust(''Specular'', 0);');
fprintf(fidl,'\t%s\n','shaderadjust(''Roughness'', 0);');
fprintf(fidl,'\t%s\n','shaderadjust(''Smooth'', 1.5);');
fprintf(fidl,'\t%s\n','shaderadjust(''OutlineWidth'', 0.3);');
fprintf(fidl,'\t%s\n','shaderambientocclusion(0.6);');
fprintf(fidl,'\t%s\n','viewsagittal(true);'); % surface orientation
fprintf(fidl,'\t%s\n','azimuth(180);'); % show lateral
fprintf(fidl,'\t%s\n','cameradistance(0.8);'); 
fprintf(fidl,'\t%s\n','colorbarvisible(true);');
fprintf(fidl,'\t%s\n','colorbarposition(1);'); % show colormap at the bottom
fprintf(fidl,'\t%s\n','bmpzoom(1000);'); 
fprintf(fidl,'\t%s\n',['savebmpxy(''',savepath,filesep,name,'_lateral.png',''',4000,4000);']); % save as png 
fprintf(fidl,'\t%s\n','quit;');
fprintf(fidl,'%s\n','end.');
fclose(fidl);

fidm = fopen([savepath,filesep,name,'_medial.gls'],'w');
fprintf(fidm,'%s\n','begin');
fprintf(fidm,'\t%s\n','resetdefaults()');
fprintf(fidm,'\t%s\n',['meshload(''',savepath,filesep,name,'.mz3',''');']);
fprintf(fidm,'\t%s\n','overlayvisible(1, false);');
fprintf(fidm,'\t%s\n',['overlayload(''',savepath,filesep,name,'.mz3',''');']);
fprintf(fidm,'\t%s\n',['overlayminmax(2, ',num2str(cbrange(1)),', ',num2str(cbrange(2)),');']);
fprintf(fidm,'\t%s\n',['overlaycolorname(2, ''',colormapname,''');']);
fprintf(fidm,'\t%s\n',['overlayload(''',surfbase,''');']);
fprintf(fidm,'\t%s\n','overlaycolorname(3, ''gray'');');
fprintf(fidm,'\t%s\n','shaderxray(0, 0);');
fprintf(fidm,'\t%s\n','azimuthelevation(110, 15);');
fprintf(fidm,'\t%s\n','orientcubevisible(false);');
fprintf(fidm,'\t%s\n',['shadername(''',shadername,''');']);
fprintf(fidm,'\t%s\n','shaderforbackgroundonly(false);');
fprintf(fidm,'\t%s\n','shaderlightazimuthelevation(-10, 25);');
fprintf(fidm,'\t%s\n','shaderadjust(''Ambient'', 0.75);');
fprintf(fidm,'\t%s\n','shaderadjust(''Diffuse'', 0.6);');
fprintf(fidm,'\t%s\n','shaderadjust(''Specular'', 0);');
fprintf(fidm,'\t%s\n','shaderadjust(''Roughness'', 0);');
fprintf(fidm,'\t%s\n','shaderadjust(''Smooth'', 1.5);');
fprintf(fidm,'\t%s\n','shaderadjust(''OutlineWidth'', 0.3);');
fprintf(fidm,'\t%s\n','shaderambientocclusion(0.6);');
fprintf(fidm,'\t%s\n','viewsagittal(true);');
fprintf(fidm,'\t%s\n','azimuth(0);'); % show medial
fprintf(fidm,'\t%s\n','cameradistance(0.8);');
fprintf(fidm,'\t%s\n','colorbarvisible(true);');
fprintf(fidm,'\t%s\n','colorbarposition(1);');
fprintf(fidm,'\t%s\n','bmpzoom(1000);');
fprintf(fidm,'\t%s\n',['savebmpxy(''',savepath,filesep,name,'_medial.png',''',4000,4000);']);
fprintf(fidm,'\t%s\n','quit;');
fprintf(fidm,'%s\n','end.');
fclose(fidm);

if isempty(dir('/data/stalxy/ArticleJResults/plot.sh'))
    fidcmd = fopen('/data/stalxy/ArticleJResults/plot.sh','w');
else
    fidcmd = fopen('/data/stalxy/ArticleJResults/plot.sh','a');
end
fprintf(fidcmd,'%s\n',['/opt/Surf_Ice/surfice ',savepath,filesep,name,'_lateral.gls;wait']);
fprintf(fidcmd,'%s\n',['/opt/Surf_Ice/surfice ',savepath,filesep,name,'_medial.gls;wait']);
fclose(fidcmd);



end

