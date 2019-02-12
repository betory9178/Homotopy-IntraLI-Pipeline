function varargout = SysDiv2Plot(SysName,Yrange,FigTitle,FigPath,varargin)
%UNTITLED3 此处显示有关此函数的摘要
%   此处显示详细说明

load('/data/stalxy/github/Homotopy-IntraLI-Pipeline/Utilized/atlas2nets.mat');
if strcmp(SysName,'Yeo7')
    a2n=atlas2net.Yeo7nets(:,3);
    a2n_l={'Visual','Somatomotor','Dorsal-attention','Ventral-attention','Limbic','Frontalparietal','Default'};
elseif strcmp(SysName,'Yeo17')
    a2n=atlas2net.Yeo17nets(:,3);
    a2n_l={'Visual_peripheral','Visual_central','Somatomotor_A','Somatomotor_B','Dorsal_attention_A','Dorsal_attention_B','Ventral_attention','Salience','Limbic_A','Limbic_B','Control_C','Control_A','Control_B','Default_D','Default_C','Default_A','Default_B'};
elseif strcmp(SysName,'Hierarchy')
    a2no=atlas2net.hierarchy6(:,3);
%     a2n_ol={'Heteromodal','Limbic','Paralimbic','Primary','Subcortical','Unimodal'};
    a2n_l={'Heteromodal','Unimodal','Primary','Limbic','Paralimbic','Subcortical'};
    a2n=a2no([1;6;4;2;3;5]);

end

if nargin==5
    VarMap=varargin{1};
    if size(VarMap,1)>1
        nets=zeros(size(VarMap,1),length(a2n));
        for i=1:length(a2n)
            nets(:,i)=mean(VarMap(:,(a2n{i}+1)/2),2);
        end
        varargout={nets};
    elseif size(VarMap,1)==1
        for i=1:length(a2n)
            a2ns(:,i)=size(a2n{i},1);
        end
        nets=zeros(max(a2ns),length(a2n));
        for i=1:length(a2n)
            nets(:,i)=[VarMap(:,(a2n{i}+1)/2)';nan(max(a2ns)-a2ns(i),1)];
        end
    end
    
elseif nargin==6
    VarMap=varargin{1};
    VarMapa=varargin{2};
    nets=zeros(size(VarMap,1),length(a2n));
    netsa=zeros(size(VarMapa,1),length(a2n));
    for i=1:length(a2n)
        nets(:,i)=mean(VarMap(:,(a2n{i}+1)/2),2);
        netsa(:,i)=mean(VarMapa(:,(a2n{i}+1)/2),2);
    end
    varargout={nets,netsa};
end

% [p,table,stats]=anova1(nets);
% c = multcompare(stats,'display','off');

Vpot=figure,
tmp=get(gcf,'Position'),
set(gcf,'Position', [50, tmp(2) ,tmp(4)*3, tmp(4)*1.5]),
violinplot(nets,a2n_l,'Width',0.3,'ViolinAlpha',0.1,'BoxColor',[0.1 0.1 0.1],'ShowMean',true),
yticks(Yrange),
set(gca,'FontSize',10,'FontWeight','Bold','FontName','Ubuntu Light'),

%xlabel(SysName,'FontName','Ubuntu Light','FontSize',15,'Interpreter','none'),
%ylabel(FigTitle,'FontName','Ubuntu Light','FontSize',15,'Rotation',90,'Interpreter','none'),

til=title([FigTitle '_' SysName],'Interpreter','none'),
set(til,'FontSize',20,'FontWeight','Bold','FontName','Ubuntu Light');

background='white',
whitebg(gcf,background),
set(gcf,'Color',background,'InvertHardcopy','off'),

saveas(Vpot,[FigPath '/' FigTitle '_' SysName '.tif'],'tif');
close(Vpot);



end

