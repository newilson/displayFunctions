function NWpixel_over_series(im)

im = squeeze(im);
if ndims(im)>3
    error('input must be 3D')
end

si = size(im);

% fitting function
fitfun = @(a,t) a(1)*sin(a(2)*t+a(3)) + a(4);

npts = max(256,si(3));
a0 = [10 1 0 0];
tfit = linspace(1,si(3),npts);

f = figure;

set(f,'visible','on','toolbar','figure')

ax = axes('Parent',f,'position',[.15 .35 .7 .65]);
h = imagesc('Parent',ax,'cdata',squeeze(im(:,:,1)));
axis tight, axis equal, axis tight

ax2 = axes('Parent',f,'position',[.1 .05 .7 .25]);
h1 = plot(ax2,1:si(3),zeros(1,si(3)),'ro');
hold on
h2 = plot(ax2,tfit,zeros(1,npts),'k-');

datacursormode on
dcm_obj = datacursormode(f);


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

b3 = uicontrol('Parent',f,'style','pushbutton','units','normalized','position',[.875 .75 .1 .05],...
    'callback',@calc,'string','Fit ROI');

t2 = uicontrol('Parent',f,'style','text','units','normalized','position',[.25 .35 .3 .05],...
    'string',['y = ' num2str(a0(1)) 'sin(' num2str(a0(2)) 'x+' num2str(a0(3)) ')+' num2str(a0(4))]);

c1 = uicontrol('Parent',f,'style','checkbox','units','normalized','position',[.025 .4 .1 .05],...
    'value',0,'string','3x3');

    function nextslice(source,callbackdata)
        slice = round(get(source,'value'));
        set(h,'cdata',squeeze(im(:,:,slice)))
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

    function calc(source,callbackdata)
        lb = [20 0 -2*pi 0];
        ub = [4096 1e9 2*pi 4096];
        dcm_info = getCursorInfo(dcm_obj);
        pix = dcm_info.Position;
        if get(c1,'value')==1
            fitdata = mean(mean(im(pix(2)-1:pix(2)+1,pix(1)-1:pix(1)+1,:),1),2);
            disp('using mean')
        else
            fitdata = im(pix(2),pix(1),:);
            disp('using single point')
        end
        options = optimoptions('lsqcurvefit','TolFun',1e-9);
        [a,resnorm,res,exitflag]  = lsqcurvefit(fitfun,a0,1:si(3),fitdata(:)',lb,ub,options);
%         [a,resnorm,res,exitflag]  = lsqcurvefit(fitfun,a0,1:si(3),fitdata(:)',[],[],options);
        a0 = a;
        fitcurve = fitfun(a,tfit);
        set(h1,'ydata',fitdata)
        set(h2,'ydata',fitcurve)
        set(t2,'string',['y = ' num2str(a0(1)) 'sin(' num2str(a0(2)) 'x+' num2str(a0(3)) ')+' num2str(a0(4))])
    end

end

