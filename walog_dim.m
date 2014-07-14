function walog_dim(daytime)
global DAYTIME handl
if isempty(DAYTIME);DAYTIME=0;walog_auto_dim();end;
if daytime==-1
    daytime = ~DAYTIME;
end
DAYTIME=daytime;
allbuttons=findall(handl.figure1,'Style','Togglebutton','Value',0);
alledit=findall(handl.figure1,'Style','Edit');
alltext=findall(handl.figure1,'Style','Text');
allpop=findall(handl.figure1,'Style','popupmenu');
allpush=findall(handl.figure1,'Style','Pushbutton');
button=findobj(handl.figure1,'Tag','View_Day');
allpanel=findobj(handl.figure1,'-regexp','Tag','panel');
if daytime
    walog_set_button_color( [ 0.8 0.8 0.8 ] , allbuttons);
    set(handl.display_edit_comments,'ForegroundColor',[0 0 0]);
    set(handl.display_edit_comments,'BackgroundColor',[1 1 1]);
    set(handl.figure1,'Color',[0.8 0.8 0.8]);
    set(allpush,'Backgroundcolor',[0.8 0.8 0.8]);
    set(alledit,'Backgroundcolor',[0.78 0.78 0.78]);
    set(alltext,'Backgroundcolor',[0.78 0.78 0.78]);
    set(allpop,'Backgroundcolor',[0.78 0.78 0.78]);
    set(allpanel,'Backgroundcolor',[0.78 0.78 0.78]);
    %set(handl.save_button_1,'BackgroundColor','red');
    set(handl.display_edit_comments,'BackgroundColor','white');
else
    walog_set_button_color( [ 0.8 0.8 0.8 ] , allbuttons);
    set(handl.display_edit_comments,'ForegroundColor',[0.5 0.5 0.5]);
    set(handl.display_edit_comments,'BackgroundColor',[0 0 0]);
    set(handl.figure1,'Color',[0.2 0.2 0.2]);
    set(allpush,'Backgroundcolor',[0.7 0.7 0.7]);
    set(alledit,'Backgroundcolor',[0.7 0.7 0.7]);
    set(alltext,'Backgroundcolor',[0.7 0.7 0.7]);
    set(allpop,'Backgroundcolor',[0.7 0.7 0.7]);
    set(allpanel,'Backgroundcolor',[0.7 0.7 0.7]);
    %set(handl.save_button_1,'BackgroundColor','red');
end
set(gcbo,'Enable','off');
set(gcbo,'Enable','on');

