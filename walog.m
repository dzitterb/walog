function walog
% ----------------------------------
% -- WALOG --
% ----------------------------------
% by Daniel P. Zitterbart & Lars Kindermann, AWI 2009
% daniel.zitterbart@awi.de
% last edited 8.08.2013 by Lars Kindermann
% last edited 24.04.2014 by Daniel Zitterbart
% all rights reserved
%#function walog_button_Callback
%#function walog_saveandclear_Callback
%#function walog_record_Callback
%#function walog_comment
global handl GPS WHALE WHALETIME SHIPTIME SETUP SETUPFILENAME CONTROL

WHALE=[];
H=walog_gui;
computername=getenv('COMPUTERNAME');
vers='WALOG v2.1 24.04.2014';
SETUPFILENAME=['SETUP.' computername '.mat'];

%kill all timer
if ~isempty(timerfindall)
    stop(timerfindall);
    delete(timerfindall);
end;

walog_readCFG();
if ~isfield(CONTROL,'usecom'), CONTROL.usecom=0; end;
%if ~isfield(CONTROL,'autosend_email'),CONTROL.autosend_email=0;end;
if CONTROL.usecom
    GPSstart(CONTROL.comport);
else
if strcmp(getenv('COMPUTERNAME'),'WALLOG')
    GPSstart(5001); %UDP
    GPS.dump=0;
else
    GPSstart('wallog:10001');
end;
end
%init
if exist(SETUPFILENAME,'file')
    load(SETUPFILENAME);
else
    SETUP.lastmail=now-1;
    SETUP.shiptimeN=0;
end
%walog_check_shiptime(SETUP.shiptimeN);

scrsz=get(0,'ScreenSize');
set(H,'Position',[1 1 scrsz(3) scrsz(4)]);

allbuttons=findall(handl.figure1,'Style','Togglebutton','Value',0);
handl.spec_panelH=findall(handl.figure1,'Tag','spec_panel');
handl.toggle1buttons=allchild(handl.spec_panelH);
handl.species1buttons=findall(handl.toggle1buttons,'string','species1');
axis(handl.axes2,'off');
set(allbuttons,'Callback','walog_button_Callback');
walog_dim(1);
set(handl.figure1,'Name',vers);

WHALETIME=now;
walog_load_species('auto');
set(handl.spec_panel,'SelectionChangeFcn','walog_button_Callback');
set(handl.num_panel,'SelectionChangeFcn','walog_button_Callback');
set(handl.certain_panel,'SelectionChangeFcn','walog_button_Callback');
set(handl.save_panel,'SelectionChangeFcn','walog_saveandclear_Callback');
walog_image_display(imread('images/start.jpg'));
walog_writelog('system start')
waitt=now;
while ishandle(handl.figure1)
    tic
    walog_check_dir();
    walog_check_fixtime();
    walog_check_shiptime();
    walog_send_email();
    walog_check_system();
    walog_load_species('auto');
    if WHALE.gpsfix
        showtimestring=sprintf('UTC: %s',datestr(WHALETIME));
    elseif ~isempty(GPS)
        showtimestring=sprintf('PC: %s',datestr(WHALETIME));
    else
        showtimestring=sprintf('pc: %s',datestr(WHALETIME));
    end
    
    set(handl.display_zeit,'String',showtimestring);
    set(handl.display_localtime,'String',sprintf('BORD: %s',datestr(SHIPTIME)));
    z=toc;
    if z<0.05, pause(0.05-z);end
end
if ~isempty(GPS),GPS.stop();end;
