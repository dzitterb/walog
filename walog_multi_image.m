function walog_multi_image(stringname,dirname,filename)
global handl DAYTIME
persistent currentnumber whalename pathname filelist
if isempty(currentnumber), currentnumber=1;end;
if ~(strcmp(stringname,'prev') || strcmp(stringname,'next'))
    whalename=stringname;
end
if nargin==1 && ~strcmp(whalename,'bla')
    filelist=dir(sprintf('images/%s*tif',whalename));
    if currentnumber>length(filelist),    currentnumber=1;end;
elseif nargin==3
    pathname=dirname;
    filelist=dir([ pathname '*JPG' ]);
    for i=1:length(filelist)
        if strcmp(filelist(i).name,filename)
             currentnumber=i;
        end;
    end; 
end
firstimage=1;
lastimage=length(filelist);


if strcmp(stringname,'prev')
    if currentnumber>1, 
        currentnumber=currentnumber-1;   
    end;
end;
if strcmp(stringname,'next')
    if currentnumber<lastimage, 
        currentnumber=currentnumber+1;   
    end;
end;
if nargin==1 && ~strcmp(whalename,'bla')
    currentimage=imread([ 'images/' filelist(currentnumber).name ]);
    currentimage=currentimage(:,:,1:3);
elseif nargin==3 || strcmp(whalename,'bla')
   % disp('huhu');
    %pathname
    %filelist(currentnumber.name)
    %[ dirname filelist(currentnumber).name ]
    currentimage=imread([ pathname filelist(currentnumber).name ]);   
end;


if DAYTIME==0
    currentimage=walog_InvertIm(currentimage);
end

walog_image_display(currentimage);


if currentnumber<lastimage && currentnumber>firstimage
    set(handl.push_next_image,'Visible','on');
    set(handl.push_prev_image,'Visible','on');
end;

if currentnumber==firstimage
    set(handl.push_next_image,'Visible','on');
    set(handl.push_prev_image,'Visible','off');
end;
    
if currentnumber==lastimage
    set(handl.push_next_image,'Visible','off');
    set(handl.push_prev_image,'Visible','on');
end;


    