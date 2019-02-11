function [Zvalue] = fisherR2Z(Rvalue)

Zvalue=0.5 .* reallog((1+Rvalue)./(1-Rvalue)); % R to Z
Zvalue(isnan(Zvalue))=0;
end

