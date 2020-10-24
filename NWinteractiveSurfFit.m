function NWinteractiveSurfFit(im,xcell,ycell,zcell,sfitobj)
% 
%
% Currently, sfitobj must be a cell array of sfit objects returned from the
% fit function

if nargin~=5
    error('not yet implemented')
end

% if nargin==1    
%     if ndims(imcell)==4
%         xcell = 1:size(imcell,3);
%         ycell = 1:size(imcell,4);
%         newim = zeros(size(imcell,1),size(imcell,2),size(imcell,3)*size(imcell,4));
%         for ii=1:size(imcell,1)
%             for jj=1:size(imcell,2)
%                 [xcell,ycell,tempim] = prepareSurfaceData(xcell,ycell,squeeze(imcell(ii,jj,:,:)));
%                 newim(ii,jj,:) = tempim;
%             end
%         end
%         imcell = newim;
%         clear newim
%     else
%         error('missing input')
%     end
% end
% 
% if nargin<6 && nargin~=4
%     sfitobj = []; 
%     xvecfit = []; 
%     yvecfit = []; 
% end

im = squeeze(im);
si = size(im);
pix = round(si(1:2)/2);
frame = 1;

if ndims(im)>4
    error('input must be 3 or 4D')
end

f = figure('position',[125 90 700 680]);

ax = axes('Parent',f,'position',[.2 .4 .5 .5],'Ydir','reverse');
hIm = imagesc('Parent',ax,'cdata',squeeze(im(:,:,frame))); 

hpoint = impoint(ax,pix);
setColor(hpoint,'r')
fcn = makeConstrainToRectFcn('impoint',[1 si(2)],[1 si(1)]);
setPositionConstraintFcn(hpoint,fcn);
addNewPositionCallback(hpoint,@(pos) pixMove(pos));

cax = caxis(ax);
% caxis(ax,cax);
axis tight, axis equal, axis tight
axis off
colorbar(ax)

ax2 = axes('Parent',f,'position',[.2 .082 .6 .25]);
if isempty(sfitobj)
    hplot = plot(ax2,squeeze(xcell(pix(2),pix(1),:)),squeeze(im(pix(2),pix(1),:)),'o');
else
    hplot = plot(sfitobj{pix(2),pix(1)},[xcell{pix(2),pix(1)}, ycell{pix(2),pix(1)}],zcell{pix(2),pix(1)},'parent',ax2);
    grid on
    view( 125, 30.0 );
end

% xl = [min(xcell(:))-abs(min(xcell(:))/10) max(xcell(:))+abs(max(xcell(:))/10)];
% % yl = [-10 110];
% yl = cax;
% linelim = [-20 4096];
% hline = imline(ax2,xcell(pix(2),pix(1),1)*[1 1],linelim);
% setColor(hline,'r')
% setPositionConstraintFcn(hline,@(pos) [repmat(mean(pos(:,1)),2,1) linelim(:)]) % vertical
% addNewPositionCallback(hline,@(pos) lineMove(pos));


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


bg = uibuttongroup(f,'units','normalized','Position',[.60 .35 .35 .05],'bordertype','none','SelectionChangedFcn',@RadioPlot);
r1 = uicontrol(bg,'Style','radio','String','Set 1','fontweight','bold','units','normalized','position',[.05 .32 .4 .5]);
r2 = uicontrol(bg,'Style','radio','String','Set 2','fontweight','bold','units','normalized','position',[.35 .32 .4 .5]);

if isempty(sfitobj)
   bg.Visible = 'off';
end
   bg.Visible = 'off';


set(f,'visible','on','toolbar','figure')

setPix(pix)
updateStringsIm(cax)
updateImage
updatePlot

    function nextframe(source,callbackdata)
        frame = round(get(s1,'value'));
        updateImage
        updatePlot
        set(t1,'string',num2str(frame))
        set(s1,'value',frame)
        yl = ylim(ax2);
        temppos = [xcell(pix(2),pix(1),frame)*[1;1] linelim(:)];
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
        set(e1,'string',num2str(cax(1),'%u'))
        set(e2,'string',num2str(cax(2),'%u'))
    end

    function updateImage
        if strcmpi(get(get(bg,'SelectedObject'),'String'),'Z spec')
            set(hIm,'cdata',squeeze(im(:,:,get(s1,'Value'))))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'M- Asym')
            set(hIm,'cdata',squeeze(AimN(:,:,abs(get(s1,'Value')-si(3)/2-1)+si(3)/2+1)))
        elseif strcmpi(get(get(bg,'SelectedObject'),'String'),'M0 Asym')
            set(hIm,'cdata',squeeze(Aim0(:,:,abs(get(s1,'Value')-si(3)/2-1)+si(3)/2+1)))
        else
%             warning('unknown radio button')
            set(hIm,'cdata',squeeze(im(:,:,get(s1,'Value'))))
        end
    end

    function updatePlot
        set(hplot(1),'xdata',squeeze(xcell(pix(2),pix(1),:)),'ydata',squeeze(im(pix(2),pix(1),:)))
        if ~isempty(sfitobj)
            set(hplot(2),'xdata',squeeze(xvecfit(pix(2),pix(1),:)),'ydata',squeeze(sfitobj(pix(2),pix(1),:)))
        end
        xlim(ax2,xl);
    end

    function RadioPlot(source,callbackdata)
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
        [~,ind] = min(abs(xcell(pix(2),pix(1),:) - pos(1)));
        frame = ind;
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
