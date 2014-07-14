function walog_send_email(force)
global SETUP SETUPFILENAME WHALETIME
persistent setsmtp lastcheck

if nargin<1, force=0; end;
if isempty(lastcheck), lastcheck=now; end
if WHALETIME-lastcheck<1/144 && force==0, return; end;
lastcheck=WHALETIME;
computername=getenv('COMPUTERNAME');
if isempty(setsmtp)
    blatinst=['blat -install my.smtp.server me@mydomain.com'];
    dos(blatinst);
    setsmtp=1;
end;
fid=fopen('WHALE.mail','r');
text=fread(fid,'*char');
det=strfind(text','event=detection');
detections=length(det);
fclose(fid);
cmd=['blat WHALE.mail -server my.smtp.server -from sender@mydomain.de -to me@mydomain.com -cf email_addressen.txt -replyto me@mydomain.com -subject "WALLOG from ' datestr(now,'yyyy-mm-dd HH:MM') ' ' computername ' detections: ' num2str(detections) '"'];

    a=datestr(now,'MMSS');a=a(1:3);
    if (force || ( now-SETUP.lastmail>=1 &&  strcmp(a,'150')==1) || ( strcmp(datestr(now,'HH'),'06')==1 && now-SETUP.lastmail>1/12))
        if (force) 
            walog_writelog('email button','');
        end
        walog_writelog('email send','');
        if ~dos(cmd);
            delete('WHALE.mail');
            walog_writelog('email newfile','');
            SETUP.lastmail=now;
            save(SETUPFILENAME,'SETUP');
        else
            walog_writelog('email error','');
        end    
    end
end