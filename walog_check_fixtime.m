function walog_check_fixtime
global handl GPS WHALETIME WHALE
if isfield(GPS,'fixtime')
t=GPS.fixtime;
else
    t=[];
end
%if ~isfield(GPS,'idle') GPS.idle=100; end;
if  isempty(t) || (abs(datenum(t)-now) > 10/86400)
    WHALETIME=now;
    WHALE.gpsfix=0;
     set(handl.display_zeit,'BackgroundColor','yellow');
else
    WHALETIME=datenum(t);
    WHALE.gpsfix=1;
    set(handl.display_zeit,'BackgroundColor',[0.8 0.8 0.8]);
end
