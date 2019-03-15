function [F_HxLa,P_HxLa] = geninteractionHCP(FCS1,FCS2,atlasflag,subid,statspath,statename)
%UNTITLED5 此处显示有关此函数的摘要
%   此处显示详细说明
if strcmp(atlasflag,'AIC')
    nid=[1:174,176:190,192];
elseif strcmp(atlasflag,'BNA')
    nid=[1:123];
end

[~,~,iS1]=intersect(subid,FCS1.subid);
[~,~,iS2]=intersect(subid,FCS2.subid);

ho_FC1=FCS1.homo(iS1,:);
LI_abs1=FCS1.intra_absAI(iS1,:);

ho_FC2=FCS2.homo(iS2,:);
LI_abs2=FCS2.intra_absAI(iS2,:);

for i=1:length(iS1)
Homo=[ho_FC1(i,nid),ho_FC2(i,nid)];
LIabs=[LI_abs1(i,nid),LI_abs2(i,nid)];
Group=var2fac([ones(1,length(nid)),ones(1,length(nid))*2],{'State1','State2'});
M1=1+term(Homo')+term(Group');
M2=1+term(Homo')+term(Group')+term(Homo')*term(Group');

slm1=SurfStatLinMod(LIabs',M1);
slm2=SurfStatLinMod(LIabs',M2);

slmF=SurfStatF(slm1,slm2);

F_HxLa(i,1)=slmF.t;
P_HxLa(i,1)=1-fcdf(slmF.t,slmF.df(1),slmF.df(2));

end

hist_lxy(F_HxLa,13.11,statspath,[statename '_HomoxIntraLIabs_mapFtest_hist']);
hist_lxy(P_HxLa,0.05/length(887),statspath,[statename '_HomoxIntraLIabs_mapFtestP_hist']);

end

