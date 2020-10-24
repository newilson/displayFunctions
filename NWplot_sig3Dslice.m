function [sig, mont] = NWplot_sig3Dslice(fid,isfilt,nicefig)
% NWplot_sig3Dslice(fid,isfilt,x,y,z)
%
% fid is x-y-z-t-t
% 

% if exist('slice','var') && slice>0, scale = 'y'; end
si = size(fid);
if nargin<2, isfilt=false; end
if nargin<3, nicefig=false; end

x = [1 si(1)];
y = [1 si(2)];
z = [1 si(3)];

sig = zeros(si(1:3));
if ~isfilt
    for ii=x(1):x(2)
        for jj=y(1):y(2)
            for kk=z(1):z(2)
                sig(ii,jj,kk) = abs(fid(ii,jj,kk,1,1)); % uses first time point as a measure of signal intensity
            end
        end
    end
else
    if numel(si)==3, si(4)=8; si(5)=2; elseif numel(si)==4, si(5)=2; end
    for ii=x(1):x(2)
        for jj=y(1):y(2)
            for kk=z(1):z(2)
                sig(ii,jj,kk) = abs(fid(ii,jj,kk,si(4)/8,si(5)/2)); % uses middle time point as a measure of signal intensity
            end
        end
    end
end

% si = size(sig);

if nicefig
    mont = imshow3NW(sig,'min','col',true,bone(256));
else
    mont = imshow3NW(sig,'min','col',true,jet(256));
end

% temp = factor(si(3));
% ind = round(length(temp)/2);
% n = prod(temp(1:ind));
% m = prod(temp(ind+1:length(temp)));
% 
% handle = zeros(1,si(3));
% for kk=1:si(3)
%     handle(ii) = subplot(n,m,kk); imagesc(squeeze(sig(:,:,kk))),
%     title(['Slice #' num2str(kk)]),colorbar
%     set(handle(ii),'Tag',num2str(kk))
% end
% 
% if ~exist('scale','var')
%     scale = input('Same scale for each slice (y/n)? ','s');
% end
% scale = lower(scale);
% if strcmp(scale,'y')
%     if ~exist('slice','var') || isempty(slice), slice = input('Enter slice number to scale to: '); end
%     subplot(n,m,slice), cax = caxis;
%     for ii=1:si(3)
%         subplot(n,m,ii); caxis(cax), colorbar off%, colormap bone, axis off, axis square
%     end
% elseif ~strcmp(scale,'n')
%     warning('Invalid input: scaling not performed')
% end
% 
% if ~strcmp(scale,'y'),nicefig = 0;end
% if nicefig
%     figure('position',[200 200 575 575])
%     freespace = 0.05;
%     height = 1/n-freespace; width = 1/m-freespace; kk = 0;
%     if width>height,width = height;else height = width;end
%     for ii=1:n
%         for jj=1:m
%             kk = kk+1;
%             left = (jj-1)*(width+freespace); bottom = 1 - ii*(height+freespace);
%             subplot('position',[left bottom width height])
%             imagesc(squeeze(sig(:,:,kk))), title(['Slice #' num2str(kk)])
%             caxis(cax/2), colormap bone, axis off, axis square
%         end
%     end
%     figname = input('Save figure as (no extension) ','s');
%     if ~isempty(figname),
%     set(gcf,'color','none')    
%     saveas(gcf,figname,'fig')
%     export_fig(figname,'-png','-m2','-transparent')
%     end
% end

return