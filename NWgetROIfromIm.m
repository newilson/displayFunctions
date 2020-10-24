function [pos,mask,avg,sd] = NWgetROIfromIm(nrois,ax)
%
% gets roi info from specified axis or current one if not supplied
%

if nargin<2 || isempty(ax), ax = gca; end
if nargin<1, nrois = 1; end

if isnumeric(nrois)
    opt = 0;
elseif iscell(nrois)
    opt = 1;
    init_pos = nrois;
    nrois = length(init_pos);
else
    error('incorrect number of rois')
end

im = getimage(ax);

mask = zeros([size(im) nrois]);
avg = zeros(nrois,1);
sd = zeros(nrois,1);
for ii=1:nrois
    switch opt
        case 0
            h{ii} = impoly(ax);
        case 1
            h{ii} = impoly(ax,init_pos{ii});
    end
    setColor(h{ii},'r')
    pos{ii} = wait(h{ii});
    mask(:,:,ii) = createMask(h{ii});
    if nargout>2
        avg(ii) = mean2(im(mask(:,:,ii)>0));
        sd(ii) = std2(im(mask(:,:,ii)>0));
    end
end


