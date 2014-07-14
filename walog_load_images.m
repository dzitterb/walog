function walog_load_images()
global handl
try
%[img, map, alpha, filename, pathname, allFileNames] = uiselectim('CANON/');
[filename, pathname]=uigetfile({'*.jpg','All Image Files';},'Choose a file to display','CANON/');
%loadedimage=imread([pathname filename]);
walog_multi_image('bla',pathname,filename);
%walog_image_display(loadedimage);
end
