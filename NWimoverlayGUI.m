function NWimoverlayGUI(B,F,roimask,cmap,fig_title,alpha)

if nargin<6 || isempty(alpha), alpha = 0.8; end
hsize = 3;
hshape = 0.5;
fontsize = 12;

siF = size(F);
siB = size(B);

if nargin<3 || isempty(roimask), roimask = ones(size(B)); end

if ndims(B)>3
    error('must be 3D or less')
end
if ~isequal(siB,siF)
    if ndims(B)==2 && ndims(F)==3
        if ~isequal(siB,siF(1:2))
            error('background and foreground images must be the same size')
        end
    else
        error('background and foreground images must be the same size')
    end
end

siROI = size(roimask);
if ~isequal(siROI,siF)
    if isequal(siF,siB)
        roimask = repmat(roimask,[1 1 siF(3)]);
        siROI = size(roimask);
    end
end

f = figure('position',[200 200 800 450]);
if nargin>=5 && ~isempty(fig_title)
    set(f,'Name',fig_title,'NumberTitle','off');
end

Ffilt = F;

% background
axb = axes('Parent',f,'position',[.1 .1 .7 .8]);
hb = imagesc('Parent',axb,'cdata',squeeze(B(:,:,1))); 
climB = round([min(B(:)), max(B(:))],2,'significant');
caxis(axb,climB);
colormap(axb,'gray')
set(axb,'Ydir','reverse')


%foreground
axf = axes('Parent',f,'position',[.1 .1 .7 .8]); % same axes position
hf = imagesc('Parent',axf,'cdata',squeeze(F(:,:,1))); 
climF = round([1.1*min(F(:)), 0.9*max(F(:))],2,'significant');
climF = sort(climF); % in case min>max
caxis(axf,climF);
set(axf,'Ydir','reverse')

axis(axf,'tight'),axis(axb,'tight')
axis(axf,'off'), axis(axb,'off')
axis(axf,'equal'),axis(axb,'equal')
axis(axf,'tight'),axis(axb,'tight')

% link axes for zooming, etc.
linkaxes([axb axf]);

% alphadat = alpha.*(F>=climF(1)).*roimask;
alphadat = alpha.*roimask;
set(hf,'AlphaData',alphadat(:,:,1))
colorbar(axb,'Ticks',[],'TickLabels',{}), colorbar(axf,'Ticks',climF,'Fontweight','bold','Fontsize',fontsize) % must include both colorbars for sizing

if nargin<4 || isempty(cmap)
    colormap(axf,'jet')
else
    try
        colormap(axf,cmap)
    catch
        cmap = 'jet'; % default
        colormap(axf,cmap)
    end
end


if ndims(F)>2
    s1 = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.74 .1 .05 .55],...
        'value',1,'min',1,'max',siF(3),...
        'sliderstep',[1 1]/(siF(3)-1),'callback',@nextslice);
    t1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.74 .05 .05 .05],...
        'string',num2str(1));
end

pop = uicontrol('Parent',f,'style','popup','units','normalized','position',[.85 .35 .07 .05],...
    'String',{'None','Avg','Blur','Sharp'},'Callback', @doFilt);

tpop = uicontrol('Parent',f,'style','text','units','normalized','position',[.85 .40 .05 .05],...
    'string','Filter','HorizontalAlignment','left','fontweight','bold');

es1 = uicontrol('Parent',f,'Style','edit','units','normalized','Position',[.89 .30 .04 .04],...
    'callback',@doFilt,'string',num2str(hsize));

tes1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.85 .30 .04 .04],...
    'string','Size','HorizontalAlignment','left','fontweight','normal');

es2 = uicontrol('Parent',f,'Style','edit','units','normalized','Position',[.89 .25 .04 .04],...
    'callback',@doFilt,'String',num2str(hshape));

tes2 = uicontrol('Parent',f,'style','text','units','normalized','position',[.85 .25 .04 .04],...
    'string','Shape','HorizontalAlignment','left','fontweight','normal');

ea = uicontrol('Parent',f,'Style','edit','units','normalized','Position',[.92 .55 .04 .05],...
    'callback',@editAlpha);

ta = uicontrol('Parent',f,'style','text','units','normalized','position',[.82 .54 .09 .05],...
    'string','Transparency','HorizontalAlignment','center','fontweight','bold');

sa = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.82 .52 .14 .02],...
        'value',alpha,'min',0,'max',1,...
        'sliderstep',[1 2]*0.05,'callback',@slideAlpha);
    
b0 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .93 .07 .05],...
    'callback',@printax,'string','Print','fontweight','bold');

e1b = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .70 .07 .05],...
    'callback',@caxisMin);

e2b = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .65 .07 .05],...
    'callback',@caxisMax);

e1f = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .85 .07 .05],...
    'callback',@caxisMin);

e2f = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .80 .07 .05],...
    'callback',@caxisMax);

updateStrings(climB,climF)

te1b = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .69 .05 .05],...
    'string','Min','HorizontalAlignment','right','fontweight','bold');

te2b = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .64 .05 .05],...
    'string','Max','HorizontalAlignment','right','fontweight','bold');

teB = uicontrol('Parent',f,'style','text','units','normalized','position',[.82 .66 .02 .07],...
    'string','B','HorizontalAlignment','right','fontweight','bold','fontsize',14);

te1f = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .84 .05 .05],...
    'string','Min','HorizontalAlignment','right','fontweight','bold');

te2f = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .79 .05 .05],...
    'string','Max','HorizontalAlignment','right','fontweight','bold');

teF = uicontrol('Parent',f,'style','text','units','normalized','position',[.82 .81 .02 .07],...
    'string','F','HorizontalAlignment','right','fontweight','bold','fontsize',14);

cb = uicontrol('Parent',f,'style','checkbox','units','normalized','position',[.93 .15 .05 .05],...
    'callback',@updateColorbar,'value',true);

tcb = uicontrol('Parent',f,'style','text','units','normalized','position',[.85 .14 .08 .05],...
    'string','ColorBar','HorizontalAlignment','left','fontweight','bold');

set(f,'visible','on','toolbar','figure')

    function nextslice(source,callbackdata)
        if length(siB)==3
            slice = round(get(source,'value'));
        else
            slice = 1;
        end
        displaySlice(slice)
    end

    function displaySlice(slice)
        if ndims(F)==3
            set(t1,'string',num2str(slice))
            set(s1,'value',slice)
        end
        set(hf,'cdata',squeeze(Ffilt(:,:,slice)))
        set(hf,'AlphaData',squeeze(alphadat(:,:,slice)))
        set(hb,'cdata',squeeze(B(:,:,slice)))
    end

    function caxisMax(source,callbackdata)
        climB = caxis(axb);
        if str2double(get(e2b,'string'))>climB(1)
            climB(2) = str2double(get(e2b,'string'));
            caxis(axb,climB);
        end
        
        climF = caxis(axf);
        if str2double(get(e2f,'string'))>climF(1)
            climF(2) = str2double(get(e2f,'string'));
            caxis(axf,climF);
        end
        
        updateStrings(climB,climF)
        updateColorbar
    end

    function caxisMin(source,callbackdata)
        climB = caxis(axb);
        if str2double(get(e1b,'string'))<climB(2)
            climB(1) = str2double(get(e1b,'string'));
            caxis(axb,climB);
        end
        
        climF = caxis(axf);
        if str2double(get(e1f,'string'))<climF(2)
            climF(1) = str2double(get(e1f,'string'));
            caxis(axf,climF);
        end
        
        updateStrings(climB,climF)
        updateColorbar
    end

    function updateColorbar(source,callbackdata)
        if get(cb,'Value')==true
            colorbar(axb,'Ticks',[],'TickLabels',{}), colorbar(axf,'Ticks',climF,'Fontweight','bold','Fontsize',fontsize) % must include both colorbars for sizing
        else
            colorbar(axb,'off'), colorbar(axf,'off') % must include both colorbars for sizing
        end
    end

    function editAlpha(source,callbackdata)
        tempalpha = str2double(get(source,'string'));
        if tempalpha<=1 && tempalpha>=0
            changeAlpha(tempalpha)
        else
            changeAlpha(get(sa,'value'))
        end
    end

    function slideAlpha(source,callbackdata)
        changeAlpha(get(source,'value'))
    end        

    function changeAlpha(alpha)
%         alphadat = alpha.*(F>=climF(1)).*roimask;
        alphadat = alpha.*roimask;
        if ndims(F)>2
            set(hf,'AlphaData',alphadat(:,:,get(s1,'value')))
        else
            set(hf,'AlphaData',alphadat)
        end
        set(ea,'string',num2str(alpha))
        set(sa,'value',alpha)
    end

    function updateStrings(caxB,caxF)
        set(e1b,'string',num2str(caxB(1),3))
        set(e2b,'string',num2str(caxB(2),3))
        
        set(e1f,'string',num2str(caxF(1),3))
        set(e2f,'string',num2str(caxF(2),3))
        
        set(ea,'string',alpha)
    end

    function doFilt(source,callbackdata)
        hsize = str2double(es1.String);
        hshape = str2double(es2.String);
        if isequal(pop.Value,2)
            filt = fspecial('average',hsize);
            Ffilt = imfilter(F,filt,'replicate');
        elseif isequal(pop.Value,3)
            Ffilt = imgaussfilt(F,hshape,'FilterSize',hsize,'Padding','replicate');
        elseif isequal(pop.Value,4)
            if ndims(F)==2
                Ffilt = imsharpen(F,'Radius',hsize/2,'Amount',hshape);
            else
                for ii=1:siF(3)
                    Ffilt(:,:,ii) = imsharpen(F(:,:,ii),'Radius',hsize/2,'Amount',hshape);
                end
            end
        elseif isequal(pop.Value,1)
            Ffilt = F;
        end
        if ndims(F)==2
            slice = 1;
        else
            slice = get(s1,'Value');
        end
        displaySlice(slice)
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