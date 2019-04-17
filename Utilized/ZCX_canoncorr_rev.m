function [A,B,r,U,V,stats,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr_rev(X,Y)
X = (X-mean(X))./std(X); Y = (Y-mean(Y))./std(Y);
% [m,n]=find(Y>3);
% [p,q]=find(X>3);
% idx = unique([m;q]);
% X(idx,:)=[];
% Y(idx,:)=[];
[A,B,r,U,V,stats] = canoncorr(X,Y);
t = corrcoef([U,X]); N = size(U,2);
Xld = t(1:N,N+1:end)';
% xiu zheng fu hao
%     XldU1 = [Xld(1:2,1)];
%     [~,XldmaxI] = max(abs(XldU1));
%     if XldU1(XldmaxI)<0
       A = -1*A;    B = -1*B;   U = -1*U;   V = -1*V;     
%     end
t = corrcoef([V,Y]); N = size(V,2);
Yld = t(1:N,N+1:end)';
t = corrcoef([V,X]); N = size(U,2);
XCrsld = t(1:N,N+1:end)';
t = corrcoef([U,Y]); N = size(V,2);
YCrsld = t(1:N,N+1:end)';

