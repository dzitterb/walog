function walog_check_dir
global handl WHALETIME
persistent lastcheck
%curdir=pwd;

if isempty(lastcheck), lastcheck=now; end
if WHALETIME-lastcheck<1/8640, return; end;
lastcheck=WHALETIME;

filedir='CANON\';
filelist=rdir([filedir '\**\' 'IMG*.JPG']);
if length(filelist)==0,return; end;
count=0;
%for file=filelist',

file=filelist(1).name;
count=count+1;
exifinfo=imfinfo(file);
creationtime=datenum(exifinfo.DigitalCamera.DateTimeOriginal,'yyyy:mm:dd HH:MM:SS');
if isempty(creationtime),creationtime=datenum(exifinfo.DigitalCamera.DateTimeDigitized,'yyyy:mm:dd HH:MM:SS');end;
if isempty(creationtime),creationtime=datenum(exifinfo.DateTime,'yyyy:mm:dd HH:MM:SS');end;

fileindex=0;
newname=sprintf('%s%s MAPS Foto.jpg',filedir,datestr(creationtime,'yyyymmdd-HHMMSS'));
while exist(newname,'file')
    fileindex=fileindex+1;
    newname=sprintf('%s%s.%d MAPS Foto.jpg',filedir,datestr(creationtime,'yyyymmdd-HHMMSS'),fileindex);
end

try
    movefile(file,newname,'f');
    [d f e]=fileparts(newname);
    walog_writelog('picture',[f e]);
    currentimage=imread(newname);
    disp('currentimage');
    %walog_multi_image('bla',filedir,newname);
    walog_image_display(currentimage);
catch
    lasterror;
end
return;
end
%cd(curdir);
