function mycolor = ZCX_color(n)

Bcmapp = [247,251,255;222,235,247;198,219,239;158,202,225;107,174,214;66,146,198;33,113,181;8,81,156;8,48,107];
Rcmapp = [255,245,240;254,224,210;252,187,161;252,146,114;251,106,74;239,59,44;203,24,29;165,15,21;103,0,13];


x = linspace(1,n,size(Bcmapp,1));xi = 1:n; Bcmap = zeros(n,3);
for ii=1:3
    Bcmap(:,ii) = pchip(x,Bcmapp(:,ii),xi);
end
Bcmap = (Bcmap/255); % flipud??

x = linspace(1,n,size(Rcmapp,1));xi = 1:n; Rcmap = zeros(n,3);
for ii=1:3
    Rcmap(:,ii) = pchip(x,Rcmapp(:,ii),xi);
end
Rcmap = (Rcmap/255); % flipud??


mycolor = abs([flipud(Bcmap);0.95,0.95,0.95;Rcmap]);