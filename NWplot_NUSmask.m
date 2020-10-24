function NWplot_NUSmask(mask)

switch ndims(mask)
    case 2
        figure,
        imagesc(mask),colormap(blue)
    case 3
        [nx nz nt1] = size(mask);
        
%         % Slice by slice style
%         temp = factor(nz);
%         ind = round(length(temp)/2);
%         n = prod(temp(1:ind));
%         m = prod(temp(ind+1:length(temp)));
%         figure('position',[200 200 575 575])
%         freespace = 0.05;
%         height = 1/n-freespace; width = 1/m-freespace; kk = -nz/2;
% %         if width>height,width = height;else height = width;end
%         for ii=1:n
%             for jj=1:m
%                 left = (jj-1)*(width+freespace); bottom = 1 - ii*(height+freespace);
%                 subplot('position',[left bottom width height])
%                 imagesc(squeeze(mask(:,kk+nz/2+1,:))), title(['k_z = ' num2str(kk)])
% %                 imagesc(squeeze(mask(:,kk+nz/2+1,:))), title(['k_z = ' num2str(kk)])
%                 colormap(bone), axis off, axis equal
%                 kk = kk+1;
%             end
%         end
%         annotation(gcf,'doublearrow',[0.964782608695652 0.964782608695652],...
%             [0.045 0.154],'Head2Length',8,'Head2Width',8,'Head1Length',8,'Head1Width',8);
%         annotation(gcf,'arrow',[0.504 0.946],...
%             [0.00882608695652175 0.00982608695652175],'HeadLength',8,'HeadWidth',8);
%         annotation(gcf,'textbox',[0.961304347826087 0.08 0.045 0.039],...
%             'String',{'k_y'},...
%             'HorizontalAlignment','right',...
%             'FitBoxToText','off',...
%             'LineStyle','none');
%         annotation(gcf,'textbox',[0.7 0.0130434782608696 0.045 0.039],...
%             'String',{'t_1'},...
%             'HorizontalAlignment','center',...
%             'FitBoxToText','off',...
%             'LineStyle','none');
        
%         % Slice by slice style
%         imshow3NW(permute(mask,[1 3 2]),[0 1],[4 2],true,bone(2));
        
        % 3D slices style
        xvec = floor(-nx/2):floor((nx-1)/2);
        yvec = floor(-nz/2):floor((nz-1)/2);
        zvec = 0:(nt1-1);
        xvec(end+1) = xvec(end)+1; % added extra point so that there would be enough faces
        zvec(end+1) = zvec(end)+1;
        mask = cat(1,mask,zeros(1,nz,nt1)); % see above
        mask = cat(3,mask,zeros(nx+1,nz,1));
        mask = permute(double(mask),[2 1 3]);
        
        [x,y,z] = meshgrid(xvec,yvec,zvec);
        
        figure
        h = slice(x,y,z,mask,[],yvec,[],'nearest');
        axis tight,
%         view([0 0])
        view([-83.5,10])
        colormap(bone)
        shading flat
%         shading faceted
              
        xtic = xvec(1:nx/4:nx);
        xtic(end+1) = xvec(end-1);
        ztic = zvec(1:nt1/2:nt1);
        ztic(end+1) = zvec(end-1);
        
        set(gca,'xtick',xtic+0.5,'xticklabel',num2cell(xtic),'fontweight','bold','fontunits','normalized','fontsize',0.02)
        set(gca,'ytick',yvec(1:end),'fontweight','bold','fontunits','normalized','fontsize',0.02)
        set(gca,'ztick',ztic+0.5,'zticklabel',num2cell(ztic),'fontweight','bold','fontunits','normalized','fontsize',0.02)
        set(gca,'xminorgrid','on','xminortick','off','zminorgrid','on','zminortick','off')
        xlabel('k_y','fontweight','bold','fontunits','normalized','fontsize',0.03) % kx or ky?
        ylabel('k_z','fontweight','bold','fontunits','normalized','fontsize',0.03)
        zlabel('t_1','fontweight','bold','fontunits','normalized','fontsize',0.03)
        xh = get(gca,'xlabel'); yh = get(gca,'ylabel'); zh = get(gca,'zlabel');
        set(xh,'units','normalized'), set(yh,'units','normalized'), set(zh,'units','normalized')
        posx = get(xh,'position'); posy = get(yh,'position'); posz = get(zh,'position');
        set(zh,'rotation',0)
        set(xh,'position',posx+[0 0.12 0])
        set(yh,'position',posy+[-0.05 0.03 0])
        whitebg(gcf,[0.9 0.9 0.9])
        set(gcf,'color','w')

end
% figname = input('Save figure as (no extension) ','s');
% if ~isempty(figname),
%     set(gcf,'color','none')
%     saveas(gcf,figname,'fig')
%     export_fig(figname,'-png','-m2','-transparent')
% end

% export_fig(figname,'-eps','-painters','-transparent','-q101');
