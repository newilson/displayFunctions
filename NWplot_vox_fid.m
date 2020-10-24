function h = NWplot_vox_fid(fid,bw,f0,zp,ysc,xl,step,lw)
%
if nargin<7, step = 1; end
t2pts = length(fid);
if nargin<8, lw = bw/t2pts; end

t = (0:t2pts-1)/bw; % time points
filt = exp(-pi*t*lw);

fid = cat(1,fid(:).*filt(:),zeros(t2pts,1)); % zero filling
spec = ffts(fid,1);

t2pts = t2pts*2; % for zero filling

ax = bw/f0/t2pts*[-t2pts/2:1:t2pts/2-1] + zp;
if nargin<6 || isempty(xl), xl = [min(ax), max(ax)]; end


colordef white
figure, h = plot(ax,real(spec));
set(gca,'Ytick',[],'Xtick',round(min(ax)):step:round(max(ax)))
% set(gca,'XMinortick',round(min(ax)):step/4:round(max(ax)))
ylim(ysc)
xlim(xl)
set(gca,'Xdir','reverse')
xlabel('ppm','fontunits','normalized','fontsize',0.045,'fontweight','b')
set(gca,'fontunits','normalized','fontsize',0.045,'fontweight','b')
set(gcf,'color','white')