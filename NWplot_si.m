function NWplot_si(spec,bw,f0,center,x,y,label,ppmrange,ylims)
% NWplot_si(spec,x,y)
% third dimension of spec is spectral, first and second are spatial
% x and y are both vectors of the form [xmin xmax]

% f0 = 123.23; % 3T
% f0 = 297.22; % 7T

tic
if ~exist('center','var'), center = 4.72; end
if ~exist('label','var') || isempty(label), label = false; end
spec = real(spec);
si = size(spec);
ax = bw /f0/si(3)*[-si(3)/2:1:si(3)/2-1] + center;
if ~exist('ppmrange','var') || isempty(ppmrange),
    ppm1 = ax(1); ppm2 = ax(end);
else
    ppm1 = ppmrange(1); ppm2 = ppmrange(2);
end

if ~exist('x','var') || isempty(x),
    x = 1:si(1); y = 1:si(2);
end

lx = length(x); ly = length(y);

xf =[];
for ii=1:lx
    for jj=1:ly
        xf = [xf x(ii)];
    end
end
yf = repmat(y,1,lx);

figure
% Plot locations as determined by the vectors x and y
for ii=1:length(xf)
    xstr = int2str(xf(ii)); ystr = int2str(yf(ii));
    subplot(lx,ly,ii), plot(ax,squeeze(spec(xf(ii),yf(ii),:))),xlim([ppm1 ppm2])
    axis off, set(gca,'Xdir','reverse')
    if label, title([xstr ', ' ystr]), axis on, else colordef black, end
end

if ~exist('ylims','var') || isempty(ylims)
    disp('click voxel to scale to...')
    w=1;
    while w~=0
        w = waitforbuttonpress;
    end
    ylims = get(gca,'Ylim');
end

for ii=1:length(xf)
    subplot(lx,ly,ii), ylim(ylims)
end

toc