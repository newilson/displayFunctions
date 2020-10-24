function NWanimated_gif(filename,in,cmap,cax,DelayTime,aspectratio)

if nargin<3 || isempty(cmap), cmap = 'default'; end
if nargin<4, cax = []; end
if nargin<5 || isempty(DelayTime), DelayTime = 0.1; end
if nargin<6, aspectratio = []; end

[~,name,ext] = fileparts(filename);
if ~strcmp(ext,'.gif')
    ext = '.gif';
    filename = [name ext];
end
si = size(in);
if si(3)<2
    error('input must be 3D image with frames last dimension')
end

figure
nframes = si(3);
for ii=1:nframes
    imagesc(squeeze(in(:,:,ii)))
    colormap(cmap)
    if ~isempty(cax), caxis(cax), end
    if ~isempty(aspectratio)
        daspect(aspectratio)
    else
        axis equal, axis tight
    end
    drawnow
    pause(.1)
    fr = getframe(gca);
    im = frame2im(fr);
    [A,map] = rgb2ind(im,256); 
	if ii == 1
		imwrite(A,map,filename,'gif','LoopCount',Inf,'DelayTime',DelayTime);
	else
		imwrite(A,map,filename,'gif','WriteMode','append','DelayTime',DelayTime);
	end
end
    