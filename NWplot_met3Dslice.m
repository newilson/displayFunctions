function [met, flag, mont, mask, rat, wattailtest, fattest, noisetest, watpeaktest] = NWplot_met3Dslice(seq,name,spec,bw2,bw1,zp,mode,plt,nicefig)
% NWplot_met3Dslice(seq,name,spec,bw2,bw1,zp,mode,x,y,z)
%
% spec is x-y-z-f-f
% mode(1): 0 for peak height, 1 for peak volume
% mode(2): 0 for metabolite values, 1 for ratios wrt water

%ZI - added wattest, fattest, and noisetest to see upper and lower
%boundaries - wattailtest and watpeaktest seperated

test = false;

if strcmp(seq,'cosy')
    seq = 1;
    spec = abs(spec);
elseif strcmp(seq,'jpress')
    seq = 2;
    spec = abs(spec);
elseif strcmp(seq,'press')
    seq = 3;
    spec = abs(spec);
else
    error('input a valid sequence')
end


si = size(spec);

if nargin<6, zp = 4.72; end
if nargin<7 || isempty(mode), mode = [0 0]; end % 1st: 0 = max point, 1 = sum over range, 2nd: 0 = metabolite, 1 = ratio to water

x = [1 si(1)];
y = [1 si(2)];
z = [1 si(3)];
    
if nargin<8, plt = true; end
if nargin<9, nicefig = false; end
if nicefig, plt = true; end

if test, plt = true; end

switch seq
    case 1
        ax2 = bw2 /123.23/si(4)*[-si(4)/2:1:si(4)/2-1] + zp;
        ax1 = -bw1 /123.23/si(5)*[si(5)/2:-1:-si(5)/2+1] - zp;
        
        while 1
            if strcmp(name,'naa')
                temp = find(ax1>-2.1); ind11 = temp(1);
                temp = find(ax1>-1.9); ind12 = temp(1);
                
                temp = find(ax2>1.9); ind21 = temp(1);
                temp = find(ax2>2.1); ind22 = temp(2);
                break
            elseif strcmp(name,'cre30')
                temp = find(ax1>-3.1); ind11 = temp(1);
                temp = find(ax1>-2.9); ind12 = temp(1);
                
                temp = find(ax2>2.9); ind21 = temp(1);
                temp = find(ax2>3.1); ind22 = temp(2);
                break
            elseif strcmp(name, 'cre39')
                temp = find(ax1>-4.2); ind11 = temp(1);
                temp = find(ax1>-3.6); ind12 = temp(1);
                
                temp = find(ax2>3.8); ind21 = temp(1);
                temp = find(ax2>4.0); ind22 = temp(2);
                break
            elseif strcmp(name, 'cho')
                temp = find(ax1>-3.3); ind11 = temp(1);
                temp = find(ax1>-3.1); ind12 = temp(1);
                
                temp = find(ax2>3.1); ind21 = temp(1);
                temp = find(ax2>3.3); ind22 = temp(2);
                break
            elseif strcmp(name, 'lac')
                temp = find(ax1>-1.6); ind11 = temp(1);
                temp = find(ax1>-1.2); ind12 = temp(1);
                
                temp = find(ax2>1.2); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'wat')
                temp = find(ax1>-4.9); ind11 = temp(1);
                temp = find(ax1>-4.5); ind12 = temp(1);
                
                temp = find(ax2>4.5); ind21 = temp(1);
                temp = find(ax2>4.9); ind22 = temp(2);
                break
            elseif strcmp(name, 'fat')
                temp = find(ax1>-1.6); ind11 = temp(1);
                temp = find(ax1>-1.1); ind12 = temp(1);
                
                temp = find(ax2>1.1); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'MCLlow')
                temp = find(ax1>-3.5); ind11 = temp(1);
                temp = find(ax1>-2.0); ind12 = temp(1);
                
                temp = find(ax2>5.0); ind21 = temp(1);
                temp = find(ax2>6.0); ind22 = temp(2);
                break
            elseif strcmp(name, 'MCLupp')
                temp = find(ax1>-6.0); ind11 = temp(1);
                temp = find(ax1>-5.0); ind12 = temp(1);
                
                temp = find(ax2>2.0); ind21 = temp(1);
                temp = find(ax2>3.5); ind22 = temp(2);
                break
            elseif strcmp(name, 'other')
                r11 = input('Input LOWER bound of ppm range in F1: ');
                r12 = input('Input UPPER bound of ppm range in F1: ');
                r21 = input('Input LOWER bound of ppm range in F2: ');
                r22 = input('Input UPPER bound of ppm range in F2: ');
                temp = find(ax1>-r12); ind11 = temp(1);
                temp = find(ax1>-r11); ind12 = temp(1);
                
                temp = find(ax2>r21); ind21 = temp(1);
                temp = find(ax2>r22); ind22 = temp(2);
                break
            else
                name = input('Enter a different metabolite: ','s');
            end
        end
        
        % water signal
        temp = find(ax1>-4.9); ind11w = temp(1);
        temp = find(ax1>-4.5); ind12w = temp(1);
        
        temp = find(ax2>4.5); ind21w = temp(1);
        temp = find(ax2>4.9); ind22w = temp(2);
        
        % THIS DOES NOT WORK YET. CHANGE THE VALUES.
        % measure of water tail
        ind11tu = 1; ind12tu = si(5)/2-5;
        temp = find(ax2>2.0); ind21tu = temp(1);
        temp = find(ax2>4.3); ind22tu = temp(2);
        
        % measure of noisy region
        ind11n = round(3/4*si(5)); ind12n = si(5);
        temp = find(ax2>1.3); ind21n = temp(1);
        temp = find(ax2>2.5); ind22n = temp(2);
        
        % measure of overall signal
        temp = find(ax2>2.4); ind21s = temp(1);
        temp = find(ax2>3.3); ind22s = temp(2);
        
        % measure of fat signal
        temp = find(ax2>0.7); ind21f = temp(1);
        temp = find(ax2>1.8); ind22f = temp(2);
               
        % measure of water peak
        temp = find(ax2>4.0); ind21wp = temp(1);
        temp = find(ax2>4.8); ind22wp = temp(2);
        
    case 2
        ax2 = bw2 /123.23/si(4)*[-si(4)/2:1:si(4)/2-1] + zp;
        ax1 = -bw1/2/si(5)*[si(5)/2:-1:-si(5)/2+1];
%         ind11 = si(5)/2-5; ind12 = si(5)/2+5;
        ind11 = si(5)/2-1; ind12 = si(5)/2+3;
        
        while 1
            if strcmp(name,'naa')
                temp = find(ax2>1.9); ind21 = temp(1);
                temp = find(ax2>2.1); ind22 = temp(2);
                break
            elseif strcmp(name,'cre30')
                temp = find(ax2>2.9); ind21 = temp(1);
                temp = find(ax2>3.1); ind22 = temp(2);
                break
            elseif strcmp(name, 'cre39')
                temp = find(ax2>3.8); ind21 = temp(1);
                temp = find(ax2>4.0); ind22 = temp(2);
                break
            elseif strcmp(name, 'cho')
                temp = find(ax2>3.1); ind21 = temp(1);
                temp = find(ax2>3.3); ind22 = temp(2);
                break
            elseif strcmp(name, 'lac')               
                temp = find(ax2>1.2); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'wat')                
                temp = find(ax2>4.5); ind21 = temp(1);
                temp = find(ax2>4.9); ind22 = temp(2);
                break
            elseif strcmp(name, 'fat')
                temp = find(ax2>1.1); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'cit')
                temp = find(ax2>2.4); ind21 = temp(1);
                temp = find(ax2>2.8); ind22 = temp(2);
                break
            elseif strcmp(name, 'formic')
                temp = find(ax2>8.2); ind21 = temp(1);
                temp = find(ax2>8.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'dss')
                temp = find(ax2>-0.1); ind21 = temp(1);
                temp = find(ax2>0.2); ind22 = temp(2);
                break
            elseif strcmp(name, 'mi')
                temp = find(ax2>3.4); ind21 = temp(1);
                temp = find(ax2>3.7); ind22 = temp(2);
                break
            elseif strcmp(name, 'glx')
                temp = find(ax2>2.2); ind21 = temp(1);
                temp = find(ax2>2.6); ind22 = temp(2); 
                break
            elseif strcmp(name, 'other')
                r21 = input('Input LOWER bound of ppm range in F2: ');
                r22 = input('Input UPPER bound of ppm range in F2: ');
                temp = find(ax2>r21); ind21 = temp(1);
                temp = find(ax2>r22); ind22 = temp(2);
                break
            else
                name = input('Enter a different metabolite: ','s');
            end
        end
        % water
        ind11w = si(5)/2-5; ind12w = si(5)/2+5;
        temp = find(ax2>4.5); ind21w = temp(1);
        temp = find(ax2>4.9); ind22w = temp(2);
        
        % measure of water tail
        ind11tu = 1; ind12tu = si(5)/2-5;
        temp = find(ax2>2.0); ind21tu = temp(1);
        temp = find(ax2>4.3); ind22tu = temp(2);
        
        % measure of noisy region
        ind11n = round(3/4*si(5)); ind12n = si(5);
        temp = find(ax2>1.3); ind21n = temp(1);
        temp = find(ax2>2.5); ind22n = temp(2);
        
        % measure of overall signal
        temp = find(ax2>2.4); ind21s = temp(1);
        temp = find(ax2>3.1); ind22s = temp(2);
        
        % measure of fat signal
        temp = find(ax2>0.7); ind21f = temp(1);
        temp = find(ax2>1.8); ind22f = temp(2);
        
        % measure of water peak
        temp = find(ax2>4.0); ind21wp = temp(1);
        temp = find(ax2>4.8); ind22wp = temp(2);
        
    case 3
        ax2 = bw2 /123.23/si(4)*[-si(4)/2:1:si(4)/2-1] + zp;
        
        while 1
            if strcmp(name,'naa')
                temp = find(ax2>1.9); ind21 = temp(1);
                temp = find(ax2>2.1); ind22 = temp(2);
                break
            elseif strcmp(name,'cre30')
                temp = find(ax2>2.9); ind21 = temp(1);
                temp = find(ax2>3.1); ind22 = temp(2);
                break
            elseif strcmp(name, 'cre39')
                temp = find(ax2>3.8); ind21 = temp(1);
                temp = find(ax2>4.0); ind22 = temp(2);
                break
            elseif strcmp(name, 'cho')
                temp = find(ax2>3.1); ind21 = temp(1);
                temp = find(ax2>3.3); ind22 = temp(2);
                break
            elseif strcmp(name, 'lac')               
                temp = find(ax2>1.2); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'wat')                
                temp = find(ax2>4.5); ind21 = temp(1);
                temp = find(ax2>4.9); ind22 = temp(2);
                break
            elseif strcmp(name, 'fat')
                temp = find(ax2>1.1); ind21 = temp(1);
                temp = find(ax2>1.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'cit')
                temp = find(ax2>2.4); ind21 = temp(1);
                temp = find(ax2>2.8); ind22 = temp(2);
                break
            elseif strcmp(name, 'formic')
                temp = find(ax2>8.2); ind21 = temp(1);
                temp = find(ax2>8.6); ind22 = temp(2);
                break
            elseif strcmp(name, 'dss')
                temp = find(ax2>-0.1); ind21 = temp(1);
                temp = find(ax2>0.2); ind22 = temp(2);
                break
            elseif strcmp(name, 'other')
                r21 = input('Input LOWER bound of ppm range in F2: ');
                r22 = input('Input UPPER bound of ppm range in F2: ');
                temp = find(ax2>r21); ind21 = temp(1);
                temp = find(ax2>r22); ind22 = temp(2);
                break
            else
                name = input('Enter a different metabolite: ','s');
            end
        end
        ind11 = 1; ind12 = 1; ind11w = 1; ind12w = 1;
        temp = find(ax2>4.5); ind21w = temp(1);
        temp = find(ax2>4.9); ind22w = temp(2);
end

met = zeros(si(1:3));
wat = zeros(si(1:3));
tailup = zeros(si(1:3));
% taildown = zeros(si(1:3));
sig = zeros(si(1:3));
fat = zeros(si(1:3));
noise = zeros(si(1:3));
for ii=x(1):x(2)
    for jj=y(1):y(2)
        for kk=z(1):z(2)
            switch mode(1)
                case 0
                    met(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21:ind22,ind11:ind12))));
                    wat(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21w:ind22w,ind11w:ind12w))));
                    tailup(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21tu:ind22tu,ind11tu:ind12tu))));
%                     taildown(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21td:ind22td,ind11td:ind12td))));
                    sig(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21s:ind22s,ind11:ind12))));
                    fat(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21f:ind22f,ind11:ind12))));
                    noise(ii,jj,kk) = std(colNW(squeeze(spec(ii,jj,kk,ind21n:ind22n,ind11n:ind12n))));
                    watp(ii,jj,kk) = max(max(squeeze(spec(ii,jj,kk,ind21wp:ind22wp,ind11:ind12))));
                case 1
                    met(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21:ind22,ind11:ind12))));
                    wat(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21w:ind22w,ind11w:ind12w))));
                    tailup(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21tu:ind22tu,ind11tu:ind12tu))));
%                     taildown(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21td:ind22td,ind11td:ind12td))));
                    sig(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21s:ind22s,ind11:ind12))));
                    fat(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21f:ind22f,ind11:ind12))));
                    noise(ii,jj,kk) = std(colNW(squeeze(spec(ii,jj,kk,ind21n:ind22n,ind11n:ind12n))));
                    watp(ii,jj,kk) = sum(sum(squeeze(spec(ii,jj,kk,ind21wp:ind22wp,ind11:ind12))));

            end
        end
    end
end
rat = met./wat;
% si = size(met);

flag{1} = 100*sig./(tailup);
flag{2} = sig./fat;
flag{3} = sig./noise/((ind11-ind12+1)*(ind21s-ind22s+1))/4; % NW 4 is arbitrary
flag{4} = 100*sig./(watp);


switch mode(2)
    case 0
        if nicefig
            mont = imshow3NW(met,'min','col',true,bone(256));
        else
            if plt
                mont = imshow3NW(met,'min','col',true,jet(256));
%                 imshow3NW(flag{1},'min0','col',true,bone(2));
%                 imshow3NW(flag{2},'min0','col',true,bone(2));
%                 imshow3NW(flag{3},'min0','col',true,bone(2));
            else
                mont = imshow3NW(met,'min','col',false,jet(256));
            end
        end
    case 1
        if nicefig
            mont = imshow3NW(rat,'min0','col',true,bone(256));
        else
            if plt
                mont = imshow3NW(rat,'min0','col',true,jet(256));
%                 imshow3NW(flag{1},'min0','col',true,bone(2));
%                 imshow3NW(flag{2},'min0','col',true,bone(2));
%                 imshow3NW(flag{3},'min0','col',true,bone(2));
            else
                mont = imshow3NW(rat,'min0','col',false,jet(256));
            end
        end
end

if test    
    [col, row, button] = ginput(2);
    col = round(col); row = round(row);
    rx = mod(row,si(1));
    irx = find(rx==0);
    if ~isempty(irx)
        rx(irx) = si(1);
    end
    
    rz = ceil(row/si(1));
    
    if rx(1)>rx(2)
        rx(2) = si(1);
        rz(2) = rz(2)-1;
    end
    
    %----------------------------------------------------------------------
    %ZI - introduced new variables for wattest, fattest, noisetest
    %seperated wattail and watpeak variables
    wattailtest{1} = [100 0];
    fattest{1} = [100 0];
    noisetest{1} = [100 0];
    watpeaktest{1} = [100 0];
    wattailtest{2} = [100 0];
    fattest{2} = [100 0];
    noisetest{2} = [100 0];
    watpeaktest{2} = [100 0];
    %----------------------------------------------------------------------
    
    mask = false(x(2)-x(1)+1,y(2)-y(1)+1,z(2)-z(1)+1);
    figure('units','normalized','outerposition',[.5 .5 .3 .4])
    voxelscomp = 1;
    voxelstot = length(rx(1):rx(2))*length(col(1):col(2))*length(rz(1):rz(2));
    for ii=rx(1):rx(2)
        for jj=col(1):col(2)
            for kk=rz(1):rz(2)
                NWcontour_vox([ii,jj,kk],spec,'jpress');
                title(['(' num2str(ii) ',' num2str(jj) ',' num2str(kk) ')' '   wat: ' num2str(flag{1}(ii,jj,kk)) '   fat: ' num2str(flag{2}(ii,jj,kk)), '   noise: ' num2str(flag{3}(ii,jj,kk)) '   ' num2str(voxelscomp) '/' num2str(voxelstot)])
                button = MFquestdlg([0.6 0.3],'Keep voxel?','Voxel Test','true','false','false');
                mask(ii,jj,kk) = str2num(button);
                voxelscomp = voxelscomp + 1;
                %----------------------------------------------------------
                %----------------------------------------------------------
                %ZI - added to see limits of 3 diff comparison
                if str2num(button) == 0
                    if flag{1}(ii,jj,kk) < wattailtest{2}(1,1)
                        wattailtest{2}(1,1) = flag{1}(ii,jj,kk);
                    end
                    if flag{2}(ii,jj,kk) < fattest{2}(1,1)
                        fattest{2}(1,1) = flag{2}(ii,jj,kk);
                    end
                    if flag{3}(ii,jj,kk) < noisetest{2}(1,1)
                        noisetest{2}(1,1) = flag{3}(ii,jj,kk);
                    end
                    if flag{4}(ii,jj,kk) < watpeaktest{2}(1,1)
                        watpeaktest{2}(1,1) = flag{4}(ii,jj,kk);
                    end
                    if flag{1}(ii,jj,kk) > wattailtest{2}(1,2)
                        wattailtest{2}(1,2) = flag{1}(ii,jj,kk);
                    end
                    if flag{2}(ii,jj,kk) > fattest{2}(1,2)
                        fattest{2}(1,2) = flag{2}(ii,jj,kk);
                    end
                    if flag{3}(ii,jj,kk) > noisetest{2}(1,2)
                        noisetest{2}(1,2) = flag{3}(ii,jj,kk);
                    end   
                    if flag{4}(ii,jj,kk) > watpeaktest{2}(1,2)
                        watpeaktest{2}(1,2) = flag{4}(ii,jj,kk);
                    end 
                end
                if str2num(button) == 1
                    if flag{1}(ii,jj,kk) < wattailtest{1}(1,1)
                        wattailtest{1}(1,1) = flag{1}(ii,jj,kk);
                    end
                    if flag{2}(ii,jj,kk) < fattest{1}(1,1)
                        fattest{1}(1,1) = flag{2}(ii,jj,kk);
                    end
                    if flag{3}(ii,jj,kk) < noisetest{1}(1,1)
                        noisetest{1}(1,1) = flag{3}(ii,jj,kk);
                    end
                    if flag{4}(ii,jj,kk) < watpeaktest{1}(1,1)
                        watpeaktest{1}(1,1) = flag{4}(ii,jj,kk);
                    end
                    if flag{1}(ii,jj,kk) > wattailtest{1}(1,2)
                        wattailtest{1}(1,2) = flag{1}(ii,jj,kk);
                    end
                    if flag{2}(ii,jj,kk) > fattest{1}(1,2)
                        fattest{1}(1,2) = flag{2}(ii,jj,kk);
                    end
                    if flag{3}(ii,jj,kk) > noisetest{1}(1,2)
                        noisetest{1}(1,2) = flag{3}(ii,jj,kk);
                    end   
                    if flag{4}(ii,jj,kk) > watpeaktest{1}(1,2)
                        watpeaktest{1}(1,2) = flag{4}(ii,jj,kk);
                    end
                end
                %----------------------------------------------------------
                %----------------------------------------------------------

            end
        end
    end
end


% temp = factor(si(3));
% ind = round(length(temp)/2);
% n = prod(temp(1:ind));
% m = prod(temp(ind+1:length(temp)));
% 
% figure
% switch mode(2)
%     case 0
%         for kk=1:si(3)
%             subplot(n,m,kk), imagesc(squeeze(met(:,:,kk))),
%             title([name ': Slice #' num2str(kk)]),colorbar
%         end
%     case 1
%         for kk=1:si(3)
%             subplot(n,m,kk), imagesc(squeeze(rat(:,:,kk))), 
%             title([name '/wat : Slice #' num2str(kk)]),colorbar
%         end
% end
% 
% if si(3)>1
%     scale = input('Same scale for each slice (y/n)? ','s');
%     scale = lower(scale);
%     if strcmp(scale,'y')
%         slice = input('Enter slice number to scale to: ');
%         subplot(n,m,slice), cax = caxis;
%         for ii=1:si(3)
%             subplot(n,m,ii), caxis(cax), colorbar off%, colormap bone, axis off, axis square
%         end
%     elseif ~strcmp(scale,'n')
%         warning('Invalid input: scaling not performed')
%     end
%     suptitle(name)
%     if ~strcmp(scale,'y'),nicefig = 0;end
% end
% 
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
%             imagesc(squeeze(met(:,:,kk))), title(['Slice #' num2str(kk)])
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
