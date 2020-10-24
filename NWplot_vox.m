function NWplot_vox(spec,bw,f0,zp,ysc,xl,step)
%
if nargin<7, step = 1; end

t2pts = length(spec);

ax = bw/f0/t2pts*[-t2pts/2:1:t2pts/2-1] + zp;
if nargin<6, xl = [min(ax), max(ax)]; end

colordef white
figure, plot(ax,real(spec))
set(gca,'Ytick',[],'Xtick',round(min(ax)):step:round(max(ax)))
% set(gca,'XMinortick',round(min(ax)):step/4:round(max(ax)))
ylim(ysc)
xlim(xl)
set(gca,'Xdir','reverse')
xlabel('ppm','fontunits','normalized','fontsize',0.045,'fontweight','b')
set(gca,'fontunits','normalized','fontsize',0.045,'fontweight','b')
set(gcf,'color','white')