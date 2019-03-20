function SaveAsAtlasMZ3(metric,savepath,name)


[faces, vertices, vertexColors, ~] = fileUtils.mz3.readMz3('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/AICHA_test.mz3');

alpha=zeros(length(vertexColors),1);

for i=1:192
    vertexColors(vertexColors==i)=metric(i);
    if metric(i)~= 0
        alpha(vertexColors==i)=1;
    else
        alpha(vertexColors==i)=0;
    end
end

fileUtils.mz3.writeMz3([savepath,filesep,name,'.mz3'], faces, vertices,vertexColors,alpha);
end

