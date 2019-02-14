[numAICHA,txtAICHA,atlas2networkAICHA]=xlsread('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/Volume_atlas_toclassify_network.xlsx','AICHA');
[numBNA,txtBNA,atlas2networkBNA]=xlsread('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/Volume_atlas_toclassify_network.xlsx','Briannetome');

% Yeo7nets=cell(7,4);
% for i=1:7
%     Yeo7nets{i,1}=numAICHA((numAICHA(:,3)==i)&repmat([1;0],192,1),1);
%     Yeo7nets{i,2}=numAICHA((numAICHA(:,3)==i)&repmat([0;1],192,1),1);
%     Yeo7nets{i,3}=intersect(Yeo7nets{i,1},Yeo7nets{i,2}-1);
%     Yeo7nets{i,4}=intersect(Yeo7nets{i,1}+1,Yeo7nets{i,2});
% end
% 
% Yeo17nets=cell(7,4);
% for i=1:17
%     Yeo17nets{i,1}=numAICHA((numAICHA(:,4)==i)&repmat([1;0],192,1),1);
%     Yeo17nets{i,2}=numAICHA((numAICHA(:,4)==i)&repmat([0;1],192,1),1);
%     Yeo17nets{i,3}=intersect(Yeo17nets{i,1},Yeo17nets{i,2}-1);
%     Yeo17nets{i,4}=intersect(Yeo17nets{i,1}+1,Yeo17nets{i,2});
% end
% 
% hiera=unique(atlas2networkAICHA(2:end,5));
% lobes=unique(atlas2networkAICHA(2:end,6));
% hierarchy6=cell(6,4);
% for i=1:6
%     hierarchy6{i,1}=numAICHA(strcmp(txtAICHA(2:end,5),hiera{i})&repmat([1;0],192,1),1);
%     hierarchy6{i,2}=numAICHA(strcmp(txtAICHA(2:end,5),hiera{i})&repmat([0;1],192,1),1);
%     hierarchy6{i,3}=intersect(hierarchy6{i,1},hierarchy6{i,2}-1);
%     hierarchy6{i,4}=intersect(hierarchy6{i,1}+1,hierarchy6{i,2});
% end
% 
% lobe8=cell(8,4);
% for i=1:8
%     lobe8{i,1}=numAICHA(strcmp(txtAICHA(2:end,6),lobes{i})&repmat([1;0],192,1),1);
%     lobe8{i,2}=numAICHA(strcmp(txtAICHA(2:end,6),lobes{i})&repmat([0;1],192,1),1);
%     lobe8{i,3}=intersect(lobe8{i,1},lobe8{i,2}-1);
%     lobe8{i,4}=intersect(lobe8{i,1}+1,lobe8{i,2});
% end

Yeo7nets=cell(7,4);
for i=1:7
    Yeo7nets{i,1}=numBNA((numBNA(:,4)==i)&repmat([1;0],123,1),1);
    Yeo7nets{i,2}=numBNA((numBNA(:,4)==i)&repmat([0;1],123,1),1);
    Yeo7nets{i,3}=intersect(Yeo7nets{i,1},Yeo7nets{i,2}-1);
    Yeo7nets{i,4}=intersect(Yeo7nets{i,1}+1,Yeo7nets{i,2});
end

Yeo17nets=cell(7,4);
for i=1:17
    Yeo17nets{i,1}=numBNA((numBNA(:,5)==i)&repmat([1;0],123,1),1);
    Yeo17nets{i,2}=numBNA((numBNA(:,5)==i)&repmat([0;1],123,1),1);
    Yeo17nets{i,3}=intersect(Yeo17nets{i,1},Yeo17nets{i,2}-1);
    Yeo17nets{i,4}=intersect(Yeo17nets{i,1}+1,Yeo17nets{i,2});
end

hiera=unique(atlas2networkBNA(2:end,6));
lobes=unique(atlas2networkBNA(2:end,7));
hierarchy6=cell(6,4);
for i=1:6
    hierarchy6{i,1}=numBNA(strcmp(txtBNA(2:end,6),hiera{i})&repmat([1;0],123,1),1);
    hierarchy6{i,2}=numBNA(strcmp(txtBNA(2:end,6),hiera{i})&repmat([0;1],123,1),1);
    hierarchy6{i,3}=intersect(hierarchy6{i,1},hierarchy6{i,2}-1);
    hierarchy6{i,4}=intersect(hierarchy6{i,1}+1,hierarchy6{i,2});
end

lobe7=cell(7,4);
for i=1:7
    lobe7{i,1}=numBNA(strcmp(txtBNA(2:end,7),lobes{i})&repmat([1;0],123,1),1);
    lobe7{i,2}=numBNA(strcmp(txtBNA(2:end,7),lobes{i})&repmat([0;1],123,1),1);
    lobe7{i,3}=intersect(lobe7{i,1},lobe7{i,2}-1);
    lobe7{i,4}=intersect(lobe7{i,1}+1,lobe7{i,2});
end