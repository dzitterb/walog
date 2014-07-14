function walog_check_shiptime()
global handl SHIPTIME WHALETIME SETUP SETUPFILENAME
persistent shipt dS lastcheck
if isempty(lastcheck), lastcheck=now; end;
if isempty(shipt), shipt=0;end;

if WHALETIME-lastcheck > 1./24 , %check once per hour for local time
    try
    a=regexp(urlread('http://www.fs-polarstern.de'),'mtime\s?+=\s?+\(gmt\s?+(.\d{1,2})\);','tokens');
    if ~isempty(a), shipt=str2num(char(a{1})); end
    
    
    if shipt>12
        dS=shipt-24;
    else
        dS=shipt;
    end
    end
    lastcheck=WHALETIME;
end
SHIPTIME=WHALETIME+(shipt/24);
if isempty(dS), dS=-999; end;
set(handl.display_localtime,'String',sprintf('BORD: %s (%.0fh)',datestr(SHIPTIME,'HH:MM'),dS));