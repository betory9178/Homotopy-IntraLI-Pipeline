function [Z,P] = FisherZtest(r1,r2,n1,n2)
%UNTITLED17 此处显示有关此函数的摘要
%   此处显示详细说明
    z1=fisherR2Z(r1);
    z2=fisherR2Z(r2);
    
    Z = (z1-z2) ./ sqrt(1/(n1-3)+1/(n2-3));
    
    P = 2 * (1-normcdf(abs(Z)));
    
end

