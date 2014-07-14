function walog_check_system()
global WHALETIME
persistent lastcheck
%min=datestr(now,'MM');
% min=WHALETIME;
if isempty(lastcheck) ;lastcheck=now;end;
if (WHALETIME-lastcheck>=1./24)
    lastcheck=WHALETIME;
    try
        % system.diskfree=dos('df | tail -1 | cut -c 42-50');
        [a diskfree] = dos('dir | find "Bytes frei"');
        [token remain] = strtok(diskfree,',');
        system.diskfree=remain(3:end-1);
        % diskfree=diskfree(1:end-1);
    end
    try
        %[a ip]=dos('ipconfig | find "IP-Adresse" | find /V ".0.1"');
        %ip=ip(1,:);
        %[token remain] = strtok(ip,':');
        %system.ip=remain(3:end-2);
        %Changed by Lars in July 2013
        [~,ip]=dos('ipconfig');
        token=regexp(ip,'IP.{0,2}-Adresse[ .]+: (\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})','tokens');
        system.ip=char(token{1});
        for i=2:length(token) system.ip=[system.ip ' ' char(token{i})]; end
    catch
        system.ip='127.0.0.1';
    end;
    walog_writelog('system info',system);
end
