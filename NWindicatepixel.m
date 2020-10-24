function NWindicatepixel(pixel,color,width,style)

if length(pixel)~=2, error('pixel must include x and y values'), end
if nargin<4,style = '-';end
if nargin<3,width = 2;end
if nargin<2,color = 'r';end
 
hold on
rectangle('position',[pixel(2)-0.5 pixel(1)-0.5 1 1],'linewidth',width,'edgecolor',color,'linestyle',style)
