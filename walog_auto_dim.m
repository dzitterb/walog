function walog_auto_dim()
global GPS DAYTIME
%[Az El] = SolarAzEl(GPS.TIME,GPS.latitude,GPS.longitude,0);
El=-30;
if (El < -20 && DAYTIME),
    walog_dim(0);
elseif ~DAYTIME
    walog_dim(1);
end;