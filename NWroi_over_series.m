function NWroi_over_series(im)

im = squeeze(im);
if ndims(im)>3
    error('input must be 3D')
end

si = size(im);

% f = figure('position',[1921 -662 1080 1834]);
f = figure('position',[2561 -789 1080 1782]);
set(f,'visible','on','toolbar','figure')

% ax = axes('Parent',f,'position',[.1 .35 .8 .8*si(1)/si(2)]);
ax = axes('Parent',f,'position',[.15 .35 .7 .65]);
h = imagesc('Parent',ax,'cdata',squeeze(im(:,:,1)));
axis tight, axis equal, axis tight

ax2 = axes('Parent',f,'position',[.1 .05 .7 .25]);
h2 = plot(ax2,1:si(3),zeros(1,si(3)));
% h2 = errorbar(ax2,1:si(3),zeros(1,si(3)),zeros(1,si(3)),zeros(1,si(3)));


if ndims(im)>2
    s1 = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.9 .1 .05 .6],...
        'value',1,'min',1,'max',si(3),...
        'sliderstep',[1 1]/(si(3)-1),'callback',@nextslice);
    t1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.9 .05 .05 .05],...
        'string',num2str(1));
end
b1 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .85 .05 .05],...
    'callback',@caxis_2,'string','/2');

b2 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .80 .05 .05],...
    'callback',@caxisX2,'string','x2');

b3 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.025 .4 .1 .05],...
    'callback',@calcmean,'string','mean');

b4 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.875 .7 .1 .05],...
    'callback',@saveroi,'string','save this ROI');

b5 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.875 .75 .1 .05],...
    'callback',@saveallroi,'string','save all ROI');

% V = imellipse(ax,[50 50 5 5]);
V = imrect(ax,[50 50 5 5]);
pos = cell(1,si(3));
mask = cell(1,si(3));
% pos = getPosition(V);
% mask = createMask(V,h);


    function nextslice(source,callbackdata)
        slice = round(get(source,'value'));
        set(h,'cdata',squeeze(im(:,:,slice)))
        set(t1,'string',num2str(slice))
        set(s1,'value',slice)
        if ~isempty(pos{slice})
            delete(V)
%             V = imellipse(ax, pos{slice});
            V = imrect(ax, pos{slice});
        end
    end

    function caxis_2(source,callbackdata)
        cax = caxis(ax)/2;
        caxis(ax,cax);
    end
    
    function caxisX2(source,callbackdata)
        cax = caxis(ax)*2;
        caxis(ax,cax);
    end
  
    function calcmean(source,callbackdata)
        means = zeros(si(3),1); stds = zeros(si(3),1);
        for ii=1:si(3)
            if ~isempty(mask{ii})
                tmp_im = squeeze(im(:,:,ii));
                tmp_im = tmp_im(find(mask{ii}));
                means(ii) = mean(tmp_im(:));
                stds(ii) = std(tmp_im(:));
            end
        end
        set(h2,'Ydata',means)
%         set(h2,'Ldata',stds)
%         set(h2,'Udata',stds)
    end

    function saveroi(source,callbackdata)
        mask{get(s1,'value')} = createMask(V,h);
        pos{get(s1,'value')} = getPosition(V);
        tmp = evalin('caller','exist(''mask'',''var'')');
        if ~tmp
            assignin('caller','mask',mask{get(s1,'value')});
        else
            tmp2 = evalin('caller','exist(''MASK'',''var'')');
            if ~tmp2
                assignin('caller','MASK',mask{get(s1,'value')})
            else
                warning('not assigning mask variable')
            end
        end
        uiresume
    end

    function saveallroi(source,callbackdata)
        for ii=1:si(3)
            mask{ii} = createMask(V,h);
            pos{ii} = getPosition(V);
        end
        tmp = evalin('caller','exist(''mask'',''var'')');
        if ~tmp
            assignin('caller','mask',mask);
        else
            tmp2 = evalin('caller','exist(''MASK'',''var'')');
            if ~tmp2
                assignin('caller','MASK',mask)
            else
                warning('not assigning mask variable')
            end
        end
        uiresume
    end
end