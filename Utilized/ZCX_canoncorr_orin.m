function [A,B,r,U,V,stats,Xld,Yld,XCrsld,YCrsld] = ZCX_canoncorr(X,Y)
X = (X-mean(X))./std(X); Y = (Y-mean(Y))./std(Y);
% [m,n]=find(Y>3);
% [p,q]=find(X>3);
% idx = unique([m;q]);
% X(idx,:)=[];
% Y(idx,:)=[];
[A,B,r,U,V,stats] = canoncorr(X,Y);
t = corrcoef([U,X]); N = size(U,2);
Xld = array2table(t(1:N,N+1:end),'VariableNames',var2fac(1:size(X,2),'X'),'RowNames',var2fac(1:size(U,2),'U'));
% xiu zheng fu hao
    XldU1 = [Xld.X1(1),Xld.X2(1)];
    [~,XldmaxI] = max(abs(XldU1));
    if XldU1(XldmaxI)<0
       A = -1*A;    B = -1*B;   U = -1*U;   V = -1*V;     
    end
t = corrcoef([V,Y]); N = size(V,2);
Yld = array2table(t(1:N,N+1:end),'VariableNames',var2fac(1:size(Y,2),'Y'),'RowNames',var2fac(1:size(V,2),'V'));
t = corrcoef([V,X]); N = size(U,2);
XCrsld = array2table(t(1:N,N+1:end),'VariableNames',var2fac(1:size(X,2),'X'),'RowNames',var2fac(1:size(V,2),'V'));
t = corrcoef([U,Y]); N = size(V,2);
YCrsld = array2table(t(1:N,N+1:end),'VariableNames',var2fac(1:size(Y,2),'Y'),'RowNames',var2fac(1:size(U,2),'U'));

