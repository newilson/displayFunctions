function f = NWplayplot(im,ax_vals,fig_title,im2,ax_vals2)

if nargin<4, im2 = []; end
if nargin<5, ax_vals2 = []; end

if ~isequal(real(im),im)
    im = abs(im);
end
im = squeeze(im);
si = size(im);

if ndims(im)>2
    im = reshape(im,[si(1), numel(im)/si(1)]);
end

if isvector(im)==1
    im = im(:);
end
si = size(im); % update

if nargin<2 || isempty(ax_vals) || ~isequal(length(ax_vals),si(1))
    ax_vals = 1:si(1);
end
if isempty(ax_vals2)
    ax_vals2 = 1:size(im2,1);
end

f = figure('position',[200 200 800 450]);
if nargin>2 && ~isempty(fig_title)
    if iscell(fig_title)
        set(f,'Name',fig_title{1},'NumberTitle','off')
    else
        set(f,'Name',fig_title,'NumberTitle','off');
    end
else
    fig_title = [];
end
ax = axes('Parent',f,'position',[.1 .1 .7 .8]);
if isempty(im2)
    h = plot(ax,ax_vals,squeeze(im(:,1)));
else
    h = plot(ax,ax_vals,squeeze(im(:,1)),'k-',ax_vals2,squeeze(im2(:,1)),'r-');
    set(h(1),'color',[0.5 0.5 0.5]); % gray
end
yl = [1.1*min(im(:)), 0.9*max(im(:))];
yl = sort(yl); % in case min>max
ylim(ax,yl);
xlim(ax,[min(ax_vals) max(ax_vals)]);


if ~isvector(im)
    s1 = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.9 .1 .05 .55],...
        'value',1,'min',1,'max',si(2),...
        'sliderstep',[1 1]/(si(2)-1),'callback',@nextslice);
    t1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.9 .05 .05 .05],...
        'string',num2str(1));
end
b0 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .93 .07 .05],...
    'callback',@printax,'string','Print','fontweight','bold');

b1 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .85 .05 .05],...
    'callback',@ylim_2,'string','/2');

b2 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .80 .05 .05],...
    'callback',@ylimX2,'string','x2');

e1 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .70 .07 .05],...
    'callback',@ylimMin);

e2 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .65 .07 .05],...
    'callback',@ylimMax);
updateStrings(yl)

te1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .70 .05 .05],...
    'string','Min','HorizontalAlignment','right','fontweight','bold');

te2 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .65 .05 .05],...
    'string','Max','HorizontalAlignment','right','fontweight','bold');

set(f,'visible','on','toolbar','figure')

    function nextslice(source,callbackdata)
        slice = round(get(source,'value'));
        set(h(1),'ydata',squeeze(im(:,slice)))
        if ~isempty(im2)
            set(h(2),'ydata',squeeze(im2(:,slice)))
        end
        set(t1,'string',num2str(slice))
        set(s1,'value',slice)
        if iscell(fig_title)
            set(f,'Name',fig_title{slice})
        end
    end

    function ylim_2(source,callbackdata)
        yl = ylim(ax)/2;
        ylim(ax,yl);
        updateStrings(yl)
    end
    
    function ylimX2(source,callbackdata)
        yl = ylim(ax)*2;
        ylim(ax,yl);
        updateStrings(yl)
    end

    function ylimMax(source,callbackdata)
        yl = ylim(ax);
        if str2double(get(e2,'string'))>yl(1)
            yl(2) = str2double(get(e2,'string'));
            ylim(ax,yl);
        else
            updateStrings(yl)
        end
    end

    function ylimMin(source,callbackdata)
        yl = ylim(ax);
        if str2double(get(e1,'string'))<yl(2)
            yl(1) = str2double(get(e1,'string'));
            ylim(ax,yl);
        else
            updateStrings(yl)
        end
    end

    function updateStrings(yl)
        set(e1,'string',num2str(yl(1),3))
        set(e2,'string',num2str(yl(2),3))
    end

    function printax(source,callbackdata)
        prompt = {'FullName (no extension)','Format (vector: eps,pdf / bitmap: tiff,png,bmp,jpeg)','DPI','Renderer (painters or opengl)'};
        defvals = {fullfile(pwd,'myFigure'),'eps','300','painters'};
        nlines = 1;
        vals = inputdlg(prompt,'Options',nlines,defvals);
        if ~isempty(vals)
            fname = vals{1};
            if strcmp(vals{2},'eps') && ~strcmp(cmap,'bone')
                form = '-depsc';
            else
                form = ['-d' vals{2}];
            end
            res = ['-r' vals{3}];
            rend = ['-' vals{4}]; 
            print(f,fname,form,res,rend,'-noui')
        end
    end
  
end