function NWmultroi_over_series(im,ref,posROI_objects)

im = squeeze(im);
if ndims(im)>3
    error('input must be 3D')
end

si = size(im);
if length(si)==2
    si(3) = 1;
end

if nargin>=2
    ref = squeeze(ref);
    if ~isempty(ref) && ~isequal(si(1:2),size(ref))
        error('reference must have same image size')
    elseif isempty(ref)
        imref = im;
    else
        imref = cat(3,ref,im); % reference is first
    end
else
    imref = im;
end

% f = figure('position',[1921 -662 1080 1834]);
f = figure('position',[2561 -789 1080 1782]);
set(f,'visible','on','toolbar','figure')

% ax = axes('Parent',f,'position',[.1 .35 .8 .8*si(1)/si(2)]);
ax = axes('Parent',f,'position',[.15 .35 .7 .65]);
h = imagesc('Parent',ax,'cdata',squeeze(imref(:,:,1)));
colorbar
caxis([0 120])
axis tight, axis equal, axis tight

ax2 = axes('Parent',f,'position',[.1 .05 .7 .25]);

if ndims(im)>2
    s1 = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.9 .1 .05 .6],...
        'value',1,'min',1,'max',size(imref,3),...
        'sliderstep',[1 1]/(size(imref,3)-1),'callback',@nextslice);
    t1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.9 .05 .05 .05],...
        'string',num2str(1));
end
b1 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .85 .05 .05],...
    'callback',@caxis_2,'string','/2');

b2 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .80 .05 .05],...
    'callback',@caxisX2,'string','x2');

b3 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.025 .4 .1 .05],...
    'callback',@calcmean,'string','mean');

str = {'1','2','3','4','6','8','10','12','16'};
p1 = uicontrol('Parent',f,'style','popup','units','normalized','position',[.025 .6 .1 .05],...
    'string',str,'callback',@numroi);

if nargin==3
    n = size(posROI_objects,1);
    set(p1,'Value',find(strcmp(str,num2str(n))))
else % defaults
    set(p1,'Value',6)
    n = str2double(str{get(p1,'Value')});
end

r = round(si(1)/15);
theta = -pi:2*pi/n:pi-2*pi/n;
rcos = r*cos(theta); rsin = r*sin(theta);
if exist('posROI_objects','var')
    for ii=1:n
        V{ii} = imrect(ax,posROI_objects(ii,:));
    end
else % defaults
    for ii=1:n
        V{ii} = imrect(ax,[si(2)/2+rcos(ii) si(1)/2+rsin(ii) 3 3]);
    end
end

% cmap = colorcube(16);
cmap = prism(16);
markers = {'+','o','*','.','x','s','d','^','v','>','<','p','h'};
h2 = zeros(n,1);
for ii=1:n
    h2(ii) = plot(ax2,1:si(3),zeros(1,si(3)));
    set(h2(ii),'color',cmap(ii,:))
    set(h2(ii),'marker',markers{mod(ii,length(markers))+1})
    hold on
end

flag_mask = 0;
flag_means = 0;

    function numroi(source,callbackdata)
        roi_old = length(V); roi_new = str2double(str{get(p1,'Value')});
        theta = -pi:2*pi/roi_new:pi-2*pi/roi_new;
        rcos = r*cos(theta); rsin = r*sin(theta);
        if roi_old>roi_new
            for aa=roi_new+1:roi_old
                delete(V{aa})
                delete(h2(aa))
            end
            V = V(1:roi_new);
            h2 = h2(1:roi_new);
        elseif roi_old<roi_new
            for aa=roi_old+1:roi_new
                V{aa} = imrect(ax,[si(2)/2+rcos(aa) si(1)/2+rsin(aa) 3 3]);
                h2(aa) = plot(ax2,1:si(3),zeros(1,si(3)));
                set(h2(aa),'color',cmap(ii,:))
                set(h2(aa),'marker',markers{mod(aa,length(markers))+1})
                set(h2(aa),'visible','off')
            end
        end
    end

    function nextslice(source,callbackdata)
        slice = round(get(source,'value'));
        set(h,'cdata',squeeze(imref(:,:,slice)))
        set(t1,'string',num2str(slice))
        set(s1,'value',slice)
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
        means = zeros(si(3),length(V)); stds = zeros(si(3),length(V));
        mask = zeros(si(1),si(2),length(V));
        posROI_objects = zeros(length(V),4);
        for jj=1:length(V)
            mask(:,:,jj) = createMask(V{jj},h);
            posROI_objects(jj,:) = getPosition(V{jj});
            for bb=1:si(3)
                tmp_im = squeeze(im(:,:,bb));
                tmp_im = tmp_im(find(squeeze(mask(:,:,jj))));
                means(bb,jj) = mean(tmp_im(:));
                stds(bb,jj) = std(tmp_im(:));
            end
            set(h2(jj),'Ydata',means(:,jj))
            set(h2(jj),'color',cmap(jj,:))
            set(h2(jj),'marker',markers{mod(jj,length(markers))+1})
        end
        assignin('caller','posROI_objects',posROI_objects); % assumes the variable 'posROI_objects' is not previously defined
        if isequal(flag_mask,1) % deletes previously stored value
            evalin('caller','clear mask');
        elseif isequal(flag_mask,2)
            evalin('caller','clear MASK');
        end
        ismask = evalin('caller','exist(''mask'',''var'')');
        if ~ismask
            assignin('caller','mask',mask);
            flag_mask = 1;
        else
            ismask = evalin('caller','exist(''MASK'',''var'')');
            if ~ismask
                assignin('caller','MASK',mask);
                flag_mask = 2;
            else
                warning('not assigning mask variable')
                flag_mask = 3;
            end
        end
        if isequal(flag_means,1) % deletes previously stored value
            evalin('caller','clear means');
        elseif isequal(flag_means,2)
            evalin('caller','clear MEANS');
        end
        ismeans = evalin('caller','exist(''means'',''var'')');
        if ~ismeans
            assignin('caller','means',means);
            flag_means = 1;
        else
            ismeans = evalin('caller','exist(''MEANS'',''var'')');
            if ~ismeans
                assignin('caller','MEANS',means);
                flag_means = 2;
            else
                warning('not assigning means variable')
                flag_means = 3;
            end
        end
    end

end