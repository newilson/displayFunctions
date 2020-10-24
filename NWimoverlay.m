function NWimoverlay(Im,alpha,ax)
%
% Im is 3d matrix of base image and overlay(s)
%
% Example
% im1 = phantom(128);
% im2 = 0*im1;
% im2(find(im1>.2))=im1(find(im1>.2));
% NWimoverlay(cat(3,im1,im2))

if nargin < 2
    alpha = 0.5;
end

if ndims(Im)~=3
    error('input must be 3d')
end

si = size(Im);
nIm_over = si(3)-1;

if nargin<3
    hfig = figure;
    ax = axes(hfig);
end

imagesc(ax,squeeze(Im(:,:,1))); colormap bone
hold on

% color overlays
red = cat(3,ones(si(1:2)),zeros(si(1:2)),zeros(si(1:2)));
green = cat(3,zeros(si(1:2)),ones(si(1:2)),zeros(si(1:2)));
yellow = cat(3,ones(si(1:2)),ones(si(1:2)),zeros(si(1:2)));
orange = cat(3,ones(si(1:2)),0.5*ones(si(1:2)),zeros(si(1:2)));
blue = cat(3,zeros(si(1:2)),zeros(si(1:2)),ones(si(1:2)));
colors = cat(4,red,green,yellow,orange,blue);

h = zeros(1,nIm_over);
for ii=1:nIm_over
    h(ii) = imagesc(ax,squeeze(colors(:,:,:,mod(ii,size(colors,4)))));
    set(h(ii),'AlphaData',alpha * squeeze(Im(:,:,ii+1)))
end
hold off
