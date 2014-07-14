function walog_image_display(currentimage)
global handl
%currentimage=imresize(currentimage, [400 NaN],'bicubic');

%if size(currentimage,3)==3
%currentimage(1,1,:)=[255 0 34];
%end
%h = fspecial('average');
%currentimage=imfilter(currentimage,h);

%if size(currentimage,3)<3
%colormap gray;
%currentimage(:,:,2)=currentimage;
%currentimage(:,:,3)=currentimage(:,:,1);
%end
image(currentimage,'Parent',handl.axes1);
%figure(2)
%image(currentimage);
%imagesc(currentimage,'Parent',handl.axes1);colormap gray;

set(handl.axes1,'DataAspectRatio',[1 1 1]);
set(handl.axes1,'Visible','off');
