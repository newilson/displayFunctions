function NWinteractiveCSI(im,axppm,title)

im = squeeze(im);
si = size(im);
pix = round(si(1:2)/2);
frame = 1;

if ndims(im)>3
%     im = reshape(im,[si(1:2), numel(im)/prod(si(1:2))]);
    error('input must be 3D')
end

if nargin<3
    f = figure('position',[125 90 700 680]);
else
    f = figure('position',[125 90 700 608],'Name',title);
end

ax = axes('Parent',f,'position',[.2 .4 .5 .5],'Ydir','reverse');
hIm = imagesc('Parent',ax,'cdata',squeeze(real(im(:,:,frame)))); 

hpoint = impoint(ax,pix);
setColor(hpoint,'r')
fcn = makeConstrainToRectFcn('impoint',[1 si(1)],[1 si(2)]);
setPositionConstraintFcn(hpoint,fcn);
addNewPositionCallback(hpoint,@(pos) pixMove(pos));

% cax = [1.1*min(im(:)), 0.9*max(im(:))];
% cax = sort(cax); % in case min>max
% caxis(ax,cax);
cax = caxis(ax);
axis tight, axis equal, axis tight
axis off
colorbar(ax)

ax2 = axes('Parent',f,'position',[.2 .082 .6 .25]);
hplot = plot(ax2,axppm,abs(squeeze(im(pix(1),pix(2),:))));
xlabel('ppm')
axis tight

xl = xlim(ax2);
yl = ylim(ax2);
temp = [-max(abs(yl)) max(abs(yl))];
ylim(ax2,temp);
linelim = 1000*temp;
% hline = imline(ax2,axppm(1)*[1 1],yl);
hline = imline(ax2,axppm(1)*[1 1],linelim);
setColor(hline,'r')
% setPositionConstraintFcn(hline,@(pos) [repmat(mean(pos(:,1)),2,1) pos(:,2)]) % vertical
% setPositionConstraintFcn(hline,@(pos) [repmat(mean(pos(:,1)),2,1) yl(:)]) % vertical
setPositionConstraintFcn(hline,@(pos) [repmat(mean(pos(:,1)),2,1) linelim(:)]) % vertical
addNewPositionCallback(hline,@(pos) lineMove(pos));


if ndims(im)>2
    s1 = uicontrol('Parent',f,'Style','slider','units','normalized','Position',[.74 .46 .05 .052],...
        'value',frame,'min',1,'max',si(3),...
        'sliderstep',[1 1]/(si(3)-1),'callback',@nextframe);
    t1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.74 .41 .05 .05],...
        'string',num2str(frame),'fontweight','bold');
end
b0 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .93 .07 .05],...
    'callback',@printax,'string','Print','fontweight','bold');

b1 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .85 .05 .05],...
    'callback',@caxis_2,'string','/2');

b2 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.9 .80 .05 .05],...
    'callback',@caxisX2,'string','x2');

% tog1 = uicontrol('Parent',f,'style','togglebutton','units','normalized','position',[.74 .65 .06 .05],...
%     'callback',@magnitude,'string','AutoScale','fontweight','bold');

e1 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .70 .07 .05],...
    'callback',@caxisMin);

e2 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .65 .07 .05],...
    'callback',@caxisMax);

e3 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.2 .37 .1 .04],...
    'callback',@pixChange);

e4 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .30 .07 .05],...
    'callback',@ylimMin);

e5 = uicontrol('Parent',f,'style','edit','units','normalized','position',[.9 .25 .07 .05],...
    'callback',@ylimMax);

t3 = uicontrol('Parent',f,'style','text','units','normalized','position',[.14 .36 .05 .04],...
    'string','Pixel','HorizontalAlignment','right','fontweight','bold');

te1 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .70 .05 .05],...
    'string','Min','HorizontalAlignment','right','fontweight','bold');

te2 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .65 .05 .05],...
    'string','Max','HorizontalAlignment','right','fontweight','bold');

te4 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .30 .05 .05],...
    'string','Min','HorizontalAlignment','right','fontweight','bold');

te5 = uicontrol('Parent',f,'style','text','units','normalized','position',[.84 .25 .05 .05],...
    'string','Max','HorizontalAlignment','right','fontweight','bold');


bg = uibuttongroup(f,'units','normalized','Position',[.5 .35 .35 .05],'bordertype','none','SelectionChangedFcn',@RealImSelect);
r1 = uicontrol(bg,'Style','radio','String','Real','fontweight','bold','units','normalized','position',[.1 .32 .25 .5]);
r2 = uicontrol(bg,'style','radio','string','Imag','fontweight','bold','units','normalized','position',[.3 .32 .25 .5]);
r3 = uicontrol(bg,'style','radio','string','Mag','fontweight','bold','units','normalized','position',[.5 .32 .25 .5]);
r4 = uicontrol(bg,'style','radio','string','Phase','fontweight','bold','units','normalized','position',[.7 .32 .25 .5]);

set(f,'visible','on','toolbar','figure')

setPix(pix)
updateStringsIm(cax)
updateStringsPlot(yl)
updateImage
updatePlot

    function nextframe(source,callbackdata)
        frame = round(get(s1,'value'));
        updateImage
        updatePlot
        set(t1,'string',num2str(frame))
        set(s1,'value',frame)
        yl = ylim(ax2);
        temppos = [axppm(frame)*[1;1] linelim(:)];
%         temppos = [axppm(frame) yl(1); axppm(frame) yl(2)]; 
        setPosition(hline,temppos);
    end

    function caxis_2(source,callbackdata)
        cax = caxis(ax)/2;
        caxis(ax,cax);
        updateStringsIm(cax)
    end
    
    function caxisX2(source,callbackdata)
        cax = caxis(ax)*2;
        caxis(ax,cax);
        updateStringsIm(cax)
    end

    function caxisMax(source,callbackdata)
        cax = caxis(ax);
        if str2double(get(e2,'string'))>cax(1)
            cax(2) = str2double(get(e2,'string'));
            caxis(ax,cax);
        else
            updateStringsIm(cax)
        end
    end

    function caxisMin(source,callbackdata)
        cax = caxis(ax);
        if str2double(get(e1,'string'))<cax(2)
            cax(1) = str2double(get(e1,'string'));
            caxis(ax,cax);
        else
            updateStringsIm(cax)
        end
    end

    function ylimMax(source,callbackdata)
        yl = ylim(ax2);
        if str2double(get(e5,'string'))>yl(1)
            yl(2) = str2double(get(e5,'string'));
            ylim(ax2,yl);
        else
            updateStringsPlot(yl)
        end
    end

    function ylimMin(source,callbackdata)
        yl = ylim(ax2);
        if str2double(get(e4,'string'))<yl(2)
            yl(1) = str2double(get(e4,'string'));
            ylim(ax2,yl);
        else
            updateStringsPlot(yl)
        end
    end

    function updateStringsIm(cax)
        set(e1,'string',num2str(cax(1),3))
        set(e2,'string',num2str(cax(2),3))
    end

    function updateStringsPlot(yl)
        set(e4,'string',num2str(yl(1),3))
        set(e5,'string',num2str(yl(2),3))
        ylim(ax2,yl)
    end

    function updateImage
        if strcmpi(get(get(bg,'SelectedObject'),'String'),'real')
            set(hIm,'cdata',squeeze(real(im(:,:,get(s1,'Value')))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'imag')
            set(hIm,'cdata',squeeze(imag(im(:,:,get(s1,'Value')))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'phase')
            set(hIm,'cdata',squeeze(angle(im(:,:,get(s1,'Value')))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'mag')
            set(hIm,'cdata',squeeze(abs(im(:,:,get(s1,'Value')))))
        else
            warning('unknown radio button')
            set(hIm,'cdata',squeeze(abs(im(:,:,get(s1,'Value')))))
        end
    end

    function updatePlot
        if strcmpi(get(get(bg,'SelectedObject'),'String'),'real')
            set(hplot,'ydata',squeeze(real(im(pix(2),pix(1),:))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'imag')
            set(hplot,'ydata',squeeze(imag(im(pix(2),pix(1),:))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'phase')
            set(hplot,'ydata',squeeze(angle(im(pix(2),pix(1),:))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'mag')
            set(hplot,'ydata',squeeze(abs(im(pix(2),pix(1),:))))
        else
            warning('unknown radio button')
            set(hplot,'ydata',squeeze(abs(im(pix(2),pix(1),:))))
        end
        xlim(ax2,xl);
    end

    function RealImSelect(source,callbackdata)
        updatePlot
        updateImage
    end
    
    function pixChange(source,callbackdata)
        pixorig = pix;
        value = get(e3,'String');
        expression = ['[' value ']'];
        try
            temp = eval(expression);
            if length(temp)~=2 || any(temp<1) || temp(2)>size(im,1) || temp(1)>size(im,2)
                warndlg('Invalid Pixel')
                setPix(pixorig)
            else
                pix = flip(round(temp));
                setPosition(hpoint,pix)
                updatePlot
            end
        catch
            warndlg('Invalid Pixel')
            setPix(pixorig)
        end        
    end

    function setPix(pixel)
        set(e3,'String',[num2str(pixel(2)) ', ' num2str(pixel(1))])
    end

    function pixMove(pos)
        pix = round(pos);
        setPosition(hpoint,pix)
        setPix(pix)
        updatePlot
    end

    function lineMove(pos)
        [~,ind] = min(abs(axppm - pos(1)));
        frame = ind;
%         frame = axppm(ind);
        set(s1,'Value',frame)
        set(t1,'String',num2str(frame))
        
        updateImage
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
