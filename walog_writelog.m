function walog_writelog(logtype,entry)
global GPS WHALETIME handl
computername=getenv('COMPUTERNAME');

if ~exist('logs/','dir')
    mkdir('logs');
end;
dayfile=fopen(['logs/' datestr(now,'yyyymmdd') ' MAPS Wallog.log'],'a');
mailfile=fopen('WHALE.mail','a');
if ~exist('entry')
    output=[];
elseif ischar(entry)
    output=entry;
elseif isstruct(entry)
    output=[];
   % entry
    for f=sort(fields(entry)')
        f=char(f);
        e=entry.(f);
        if isnumeric(e), e=num2str(e);end;
        e=char(e);
        if isempty(output)
            if ~isempty(e)
                output=[f '=' e];
            else
                output=[f '='];
            end
        else
            if ~isempty(e)
                output=[output ',' f '=' e];
            else
                output=[output ',' f '='];
            end;
        end
    end;
end;     
%if ~isempty(output)
%    output=[output ','];
%end
%output
%writestring=char(['timestamp=' datestr(now,31) ',event=' logtype ',' output ',' GPS.INFO]);
if isempty(GPS)
    writestring=sprintf('timestamp=%s,event=%s,computer=%s,%s,%s',datestr(now,31),logtype,computername,output,'nan');

else
    writestring=sprintf('timestamp=%s,event=%s,computer=%s,%s,%s',datestr(now,31),logtype,computername,output,GPS.INFO);
end
%writestring2=sprintf('timestamp=%s,event=%s,\n%s,\n%s',datestr(now,31),log
%type,output,GPS.INFO);
writestring=strrep(writestring,',,',',');writestring=strrep(writestring,',,',',');
if writestring(end)==',', writestring=writestring(1:end-1); end;
set(handl.display_lastsight,'String',writestring);
fprintf('%s\n',writestring);
fprintf(mailfile,'%s\n',writestring);
fprintf(dayfile,'%s\n',writestring);
fclose all;
