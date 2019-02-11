[num,txt,atlas2network]=xlsread('/data/stalxy/Pipeline4JIN/Codes/Volume_atlas_toclassify_network.xlsx');

Yeo7nets=cell(7,4);
for i=1:7
    Yeo7nets{i,1}=num((num(:,3)==i)&repmat([1;0],192,1),1);
    Yeo7nets{i,2}=num((num(:,3)==i)&repmat([0;1],192,1),1);
    Yeo7nets{i,3}=intersect(Yeo7nets{i,1},Yeo7nets{i,2}-1);
    Yeo7nets{i,4}=intersect(Yeo7nets{i,1}+1,Yeo7nets{i,2});
end

Yeo17nets=cell(7,4);
for i=1:17
    Yeo17nets{i,1}=num((num(:,4)==i)&repmat([1;0],192,1),1);
    Yeo17nets{i,2}=num((num(:,4)==i)&repmat([0;1],192,1),1);
    Yeo17nets{i,3}=intersect(Yeo17nets{i,1},Yeo17nets{i,2}-1);
    Yeo17nets{i,4}=intersect(Yeo17nets{i,1}+1,Yeo17nets{i,2});
end

hiera=unique(atlas2network(2:end,5));
lobes=unique(atlas2network(2:end,6));
hierarchy7=cell(6,4);
for i=1:6
    hierarchy7{i,1}=num(strcmp(txt(2:end,5),hiera{i})&repmat([1;0],192,1),1);
    hierarchy7{i,2}=num(strcmp(txt(2:end,5),hiera{i})&repmat([0;1],192,1),1);
    hierarchy7{i,3}=intersect(hierarchy7{i,1},hierarchy7{i,2}-1);
    hierarchy7{i,4}=intersect(hierarchy7{i,1}+1,hierarchy7{i,2});
end

lobe8=cell(8,4);
for i=1:8
    lobe8{i,1}=num(strcmp(txt(2:end,6),lobes{i})&repmat([1;0],192,1),1);
    lobe8{i,2}=num(strcmp(txt(2:end,6),lobes{i})&repmat([0;1],192,1),1);
    lobe8{i,3}=intersect(lobe8{i,1},lobe8{i,2}-1);
    lobe8{i,4}=intersect(lobe8{i,1}+1,lobe8{i,2});
end
