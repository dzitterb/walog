function GPSstart(port,path)
%Starts Logging NMEA data to the global var GPS
%Version 18.03.2005
%(C) Lars Kindermann, AWI
%Usage GPSstart(port,file)
% port is 'COMx'       for serial connection
%         'host:port'  for TCP connection
%         ':localport' for TCP listen connection
%          localport   for UDP listen connection

 if ~exist('port','var')
  %port='COM7'               %RS232
 % port=':5000';              %Listen on TCP Port, (PODAS,Polarstern)
  %port='csyspx1:10001'      %Connect to TCP Port (Server on csyspx1)
  %port='192.168.0.62:10001' %Connect to TCP Port (RS232 on Barionet)
  %port=2021                 %Listen on UDP Port
  noparams=true;
 end
 if ~exist('path','var'); path=''; end
 
 %---------------------------------------------------------------------
 global GPS
 evalin('base','global GPS');
 evalin('caller','global GPS');
 
 try 
   GPS.stop(); 
 catch
   ; 
 end %try
 
 GPS=[];
 if exist('noparams','var') 
   GPS.dump=2; 
 else
   GPS.dump=0; 
 end %if exist('...
 %---------------------------------------------------------------------
 
 %GPS.dump=1; % You can set set to 0,1, 2 or 3 to dump incoming data

 %%%%%%% User defined entries, filled in evaluateNMEA()
 GPS.valid=false;
 GPS.fixtime=0;
 GPS.position='';
 GPS.latitude=nan; 
 GPS.longitude=nan;
 GPS.course=nan;
 GPS.knots=nan;
 GPS.speed=nan;
 GPS.INFO='';
 
 GPS.quality=nan; 
 GPS.satellites=nan;
  % Add aditional entries here and set them below in evaluateNMEA()

 GPSinit(port,path)
return
  

function known=evaluateNMEA(NMEA)
 global GPS
 try
   known=true;  
   switch NMEA{1}
         
       case '$GPRMC' %richtiges GPS
        %disp start
        %disp(NMEA)
        try
         ds=NMEA{10}; if length(ds)<6; ds=[ds '      '];ds=ds(1:6); end
         hs=NMEA{2};  if length(hs)<6; hs=[hs '      '];hs=hs(1:6); end
         yy=str2num(ds(5:end));
         if isempty(yy)
           yy=clock;  
           yy=yy(1);
         elseif yy<100
           yy=yy+2000; 
         end
         GPS.fixtime=[yy str2num(ds(3:4)) str2num(ds(1:2)) str2num(hs(1:2)) str2num(hs(3:4)) str2num(hs(5:6))];
        catch; GPS.fixtime=''; end
        GPS.valid= (NMEA{3}=='A');
        try
         la=NMEA{4};lo=NMEA{6};
         GPS.position=[la(1:2) '°' la(3:end) ''' ' NMEA{5}, ' ' lo(1:3) '°' lo(4:end) ''' ' NMEA{7}];
        catch
            GPS.position=''; 
        end
        GPS.latitude=str2num(DegMin_2_Dec(NMEA{4},NMEA{5}));
        GPS.longitude=str2num(DegMin_2_Dec(NMEA{6},NMEA{7}));
        GPS.knots=str2num(NMEA{8});
        GPS.speed=GPS.knots*0.5140;
        GPS.course=str2num(NMEA{9});
        %disp done

       case '$xGPRMC' %Polarstern old DSHIP
        %disp start
        NMEA={NMEA{1:2} 'A' NMEA{3:end}};
       % disp(NMEA)
        try
         ds=NMEA{10}; if length(ds)<6; ds=[ds '      '];ds=ds(1:6); end
         hs=NMEA{2};  if length(hs)<6; hs=[hs '      '];hs=hs(1:6); end
         yy=str2num(ds(5:end));
         if isempty(yy)
           yy=clock;  
           yy=yy(1);
         elseif yy<100
           yy=yy+2000; 
         end
         GPS.fixtime=[yy str2num(ds(3:4)) str2num(ds(1:2)) str2num(hs(1:2)) str2num(hs(3:4)) str2num(hs(5:6))];
        catch; GPS.fixtime=''; end
        GPS.valid= (NMEA{3}=='A');
        try
         la=NMEA{4};lo=NMEA{6};
         GPS.position=[la(1:2) '°' la(3:end) ''' ' NMEA{5}, ' ' lo(1:3) '°' lo(4:end) ''' ' NMEA{7}];
        catch
            GPS.position=''; 
        end
        GPS.latitude=str2num(DegMin_2_Dec(NMEA{4},NMEA{5}));
        GPS.longitude=str2num(DegMin_2_Dec(NMEA{6},NMEA{7}));
        GPS.knots=str2num(NMEA{8});
        GPS.speed=GPS.knots*0.5140;
        GPS.course=str2num(NMEA{9});
        %disp done
         
       case '$GPGGA'
        GPS.quality=str2num(NMEA{7});
        GPS.satellites=str2num(NMEA{8});
    
       case '$GPDBT'
        GPS.depth=str2num(NMEA{4});
    
       case '$GPMTW'
        GPS.temperature=str2num(NMEA{2});
               
       otherwise
        known=false;
   end
 catch
  disp(['GPS: Problem evaluating NMEA string: '])
  disp(NMEA)
 end    
return



function GPSinit(port,path)
 global GPS
 GPS.port=port;
 GPS.mode='';
 GPS.running=false;
 GPS.connected=false;
 GPS.idle=inf;
 GPS.time=nan;
 GPS.remotehost='';
 GPS.remoteport=nan;
 GPS.messagesReceived=0;
 GPS.bytesSinceLastMessage=0;
 GPS.pollperiod=0.5;
 GPS.connectperiod=0.5;
 GPS.start=@StartFcn;
 GPS.serversocket=-1;
 GPS.serversockets=[];
 GPS.serverport=10001;
 GPS.serveridle=0;
 GPS.client=[];
 
 if GPS.serverport
  disp(['GPS: Starting to  serve on TCP port ' num2str(GPS.serverport)])
  GPS.serversocket=pnet('tcpsocket',GPS.serverport);
  if GPS.serversocket<0
   error(['GPS: cannot bind to TCP port ' num2str(GPS.serverport)]) 
  end    
  GPS.servertimer=timer('TimerFcn',@cServerTimer, 'Period', 1, 'ExecutionMode','fixedDelay');
  start(GPS.servertimer);
 end    
 
 try; p=num2str(port); catch; p=port; end

 if strfind(port,'COM')==1 %'COMx'

  GPS.mode='SERIAL';
  disp(['GPS: Starting to listen on serial port ' p])
  delete(instrfind('Port',port));
  obj=serial(port,'Baudrate',4800);
  GPS.serial=obj;
  obj.BytesAvailableFcnCount = 1;
  %obj.BytesAvailableFcnMode = 'byte';
  obj.BytesAvailableFcnMode = 'terminator';
  obj.Terminator='$';
  obj.BytesAvailableFcn = @cSerial;
  GPS.stop=@SerialStop;
  fopen(obj);
  GPS.connected=true;

 elseif isnumeric(port) %UDP
 
  GPS.mode='UDP-LISTEN';
  disp(['GPS: Starting to listen on UDP port ' p])
  GPS.socket=pnet('udpsocket',port);
  if GPS.socket<0
   error(['GPS: cannot bind to UDP port ' p]) 
  end    
  GPS.connected=true;
  GPS.timer=timer('TimerFcn',@cUDPtimer, 'Period', GPS.pollperiod, 'ExecutionMode','fixedSpacing','BusyMode','drop');
  GPS.stop=@TCPStop;
  start(GPS.timer);

 elseif findstr(port,':')==1
 
  GPS.mode='TCP-LISTEN';
  port=str2num(strrep(port,':',''));   
  disp(['GPS: Starting to listen on TCP port ' num2str(port)])
  GPS.listensocket=pnet('tcpsocket',port);
  if GPS.listensocket<0
   error(['GPS: cannot bind to TCP port ' num2str(port)]) 
  end    
  GPS.timer=timer('TimerFcn',@cTCPtimer, 'Period', GPS.pollperiod, 'ExecutionMode','fixedSpacing','BusyMode','drop');
  GPS.stop=@TCPStop;
  start(GPS.timer);
  
 elseif findstr(port,':')  %TCP 'host:port'
  
  GPS.mode='TCP-CONNECT'; 
  disp(['GPS: Will try to connect via TCP to host:port ' p])
  [GPS.tcphost GPS.tcpport]=strtok(port,':');
  GPS.tcpport=strtok(GPS.tcpport,':');
  GPS.timer=timer('TimerFcn',@cTCPtimer, 'Period', GPS.connectperiod, 'ExecutionMode','fixedSpacing','BusyMode','drop');
  GPS.stop=@TCPStop;
  start(GPS.timer);
  
 end    
  
 GPS.starttime=clock;
 GPS.running=true;
return

function StartFcn(port,path)
 GPSstart(port,path)
return

function SerialStop
 global GPS
 try; fclose(GPS.serial); end;
 delete(GPS.serial);
 if GPS.running; disp('GPS: Stopped'); end
 serverclose; 
 GPS.running=false;
return


function TCPStop
 global GPS
 try 
  stop(GPS.timer); 
  delete(GPS.timer);
 catch
  if GPS.running; warning('GPS: Error on stopping timer'); end   
 end
 try; if GPS.connected; pnet(GPS.socket,'close'); end; end 
 try; pnet(GPS.listensocket,'close'); end
 serverclose;
 if GPS.running; disp('GPS: Stopped'); end
 GPS.connected=false;
 GPS.running=false;
return


function cUDPtimer(obj,event)
 global GPS
 size=pnet(GPS.socket,'readpacket',10000,'noblock');
 if size
  s=pnet(GPS.socket,'read','noblock');
  [GPS.remotehost GPS.remoteport]=pnet(GPS.socket,'gethost');
  DataInject(s,clock);
  GPS.idle=0;
 else
  GPS.idle=GPS.idle+GPS.pollperiod;
 end
return
 

function cTCPtimer(obj,event)

 global GPS
 persistent idlemsg
 
 GPS.idle=GPS.idle+GPS.pollperiod;
 
 if ~GPS.connected
 
  if strcmp(GPS.mode,'TCP-CONNECT')   
   %disp 'try tcpconnect'
   GPS.socket=pnet('tcpconnect',GPS.tcphost,GPS.tcpport);
   %disp done
   if GPS.socket>=0
     [rh rp]=pnet(GPS.socket,'gethost');
     %if idlemsg<2
      disp(sprintf('GPS: TCP Connection established to %d.%d.%d.%d:%d',rh(1),rh(2),rh(3),rh(4),rp))
      idlemsg=2;
     %end
     GPS.remotehost=rh;
     GPS.remoteport=rp;
     %stop(GPS.timer)
     %set(GPS.timer,'Period',GPS.pollperiod)
     %start(GPS.timer)
     GPS.connected=true;
     GPS.idle=1;
     %disp 'yes connected'
   else
    %disp 'GPS: TCP is not connected'   
    return   
   end

  elseif strcmp(GPS.mode,'TCP-LISTEN')   
   GPS.socket=pnet(GPS.listensocket,'tcplisten','noblock');
   if GPS.socket>=0
    [rh rp]=pnet(GPS.socket,'gethost');
    disp(sprintf('GPS: TCP Connection on port %s established from %d.%d.%d.%d:%d',GPS.port,rh(1),rh(2),rh(3),rh(4),rp))
    GPS.remotehost=rh;
    GPS.remoteport=rp;
    %stop(GPS.timer)
    %set(GPS.timer,'Period',GPS.pollperiod)
    %start(GPS.timer)
    GPS.connected=true;
    GPS.idle=1;
   else       
    %pnet(GPS.socket,'close')   
    %disp 'GPS: TCP is not connected'   
    return   
   end   
  end

 end % if ~ GPS.connected
  
 if GPS.connected  
     
  if ~pnet(GPS.socket,'status')
   GPS.connected=false;
   pnet(GPS.socket,'close'); %?
   disp('GPS: TCP connection lost...')   
  end
 
  if GPS.idle>120 % && strcmp(GPS.mode,'TCP-CONNECT')
   try; pnet(GPS.socket,'close'); end   
   GPS.connected=false;
   if ~idlemsg
     idlemsg=1;  
     disp('GPS: TCP connection idle - will try to reconnect...') 
   end   
  end

  if ~GPS.connected
   if strcmp(GPS.mode,'TCP-CONNECT')
    %stop(GPS.timer)
    %set(GPS.timer,'Period',GPS.connectperiod)
    %start(GPS.timer)
   end   
   return
  end  
  

  try 
   s=pnet(GPS.socket,'read','noblock');
  catch
   s='';
   disp('GPS: TCP connection error - disconnecting')
   GPS.connected=false;
  end
  if ~isempty(s)
   DataInject(s,clock);
   GPS.idle=0;
   idlemsg=0;
  end
   
 end
 
return


function cSerial(obj,event)
 if obj.BytesAvailable
  DataInject(transpose(char(fread(obj,obj.BytesAvailable))),clock)
 end
return


function DataInject(a,t)
 try
 global GPS
 persistent s
 
 persistent first
 if isempty(first)
   disp(['GPS: First bytes received on ' GPS.port '...'])
   first=1;
 end

 if GPS.dump==3 disp (['GPS: Raw dump: "' a '"']); end
 
 GPS.bytesSinceLastMessage=GPS.bytesSinceLastMessage+length(a);
 if GPS.bytesSinceLastMessage>1000
   disp(['GPS: Received ' num2str(GPS.bytesSinceLastMessage) ' bytes of non-NMEA data'])
   GPS.bytesSinceLastMessage=0;
 end    
  
 ts=timestring(t);
 %a=[a '[' ts ']']; %include [time]...

 a=strrep(a,char(13),char(10));
 
 s=[s a]; % add new data to s

 if length(s)>2048
  s=s(end-2048:end); %can happen in case of $ but no CR present  
 end    

 startpos=strfind(s,'$');
 if isempty(startpos)
   s=''; %delete s if no $ present at all
 elseif startpos(1)>1
   s=s(startpos(1):end); %remove everything before the $ 
 end    
 %now s is empty or begins with an $
 
 while ~isempty(strfind(s,char(10)))
  i=strfind(s,char(10));   
  if i(1)==1
   s=s(2:end); %remove trailing LF
  else
   [nmea s]=strtok(s,char(10));
   [NMEA,nt]=NMEAparse(nmea);
   if isempty(nt); nt=t; end;
   ts=timestring(nt);
   if isempty(NMEA)
    disp(['GPS: Bad NMEA String received: ' nmea])
   else   
    if GPS.dump>=2; disp(['GPS: NMEA dump: ' ts ' ' nmea]); end      
    if first==1
     first=0;
     disp('GPS: First NMEA string received...')
    end     
    c=NMEA{1};c=c(2:end);
    GPS.time=t;
    GPS.messagesReceived=GPS.messagesReceived+1;
    GPS.bytesSinceLastMessage=0;
    GPS.NMEA.(c).string=nmea;
    GPS.NMEA.(c).fields=NMEA;
    GPS.NMEA.(c).time=nt;
    if ~isfield(GPS.NMEA.(c),'validstring')
     GPS.NMEA.(c).validstring='';
     GPS.NMEA.(c).validfields={};
     GPS.NMEA.(c).validtime=0;
    end
    %NMEA{2}
    if ~isempty(NMEA{2})
     GPS.NMEA.(c).validstring=nmea;
     GPS.NMEA.(c).validfields=NMEA;
     GPS.NMEA.(c).validtime=nt;
    else
     if datenum(nt)>datenum(GPS.NMEA.(c).validtime)+(10/1440)
       GPS.NMEA.(c).validstring='';
       GPS.NMEA.(c).validfields={'' ''};
       GPS.NMEA.(c).validtime=0;
     end    
    end    
    if evaluateNMEA(NMEA)
      if GPS.dump==1; disp(['GPS: NMEA dump: ' ts ' ' nmea]); end
      %serve(nmea);
    end    
    statusupdate;
    serve(nmea);
    
   end 
  end 
 end
 catch ME
     ME
     ME.stack(1)
     s='';
     warning('Error in Data Inject'); 
 end 
return


function statusupdate
global GPS
if ~isfield(GPS,'DSHIP') GPS.DSHIP=[]; end  
for f=fields(GPS.NMEA)'
  f=char(f);
  if ~isequal(f(1:2),'GP');
   GPS.DSHIP.(f)=strtrim(GPS.NMEA.(f).validfields{2});
  end 
end    
GPS.DSHIP.TIME=datestr(GPS.fixtime,'yyyy-mm-dd HH:MM:SS');
GPS.DSHIP.POSITION=GPS.position;
%GPS.DSHIP.LAT=num2str(GPS.latitude);
%GPS.DSHIP.LON=num2str(GPS.longitude);
GPS.DSHIP.COURSE=num2str(GPS.course);
GPS.DSHIP.SPEED=num2str(GPS.knots);

%GPS.DSHIP
s='';
for f=fields(GPS.DSHIP)'
  f=char(f);
  if ~isempty(GPS.DSHIP.(f))
   s=[s ',' f '=' GPS.DSHIP.(f)];
  end
end    
GPS.INFO=s(2:end);


function [fields t] = NMEAparse(s)
 s0=s;
 %seperate a nmea string into comma separated fields
 t='';
 fields={};
 if ~ValidateNMEAChecksum(s)
  disp (['GPS: NMEA Checksum Error: ' s])
  return
 end
 s=strrep(strtrim(s),'*',',*'); %Separate Checksum also
 s=strrep(s,',',',~'); % insert dummy chars
 while size(s,1)>0
  [a s]=strtok(s,',');   
  fields=[fields {a}];
 end
 fields=strrep(fields,'~',''); %delete dummy chars
 fields=fields(1:end-1);
 if ~(isequal(strfind(fields{1},'$'),1) && length(fields{1})>1 && length(fields{1})<10 )
  disp (['GPS: NMEA Identifier Error in "' s0 '"'])
  fields=[];    
 end    
return


function ts=timestring(t)
 if size(t,2)~=6; t=datevec(t); end
 ts=[datestr(t,'yyyymmdd-HHMM') sprintf('%06.3f',t(6))];
return


function serve(nmea)
 global GPS
 try
 GPS.serveridle=0; 
 %disp serving
 for i=find(GPS.serversockets>-1)
  s=GPS.serversockets(i);   
  if pnet(s,'status')  
   r=deblank(pnet(s,'read','noblock'));
   if r; 
    [rh rp]=pnet(s,'gethost');
    disp(sprintf('GPS: Client %d.%d.%d.%d:%d %s transmitted %s',rh(1),rh(2),rh(3),rh(4),rp,r)) 
   end
   %disp(['SERVING:' nmea])  
   nmea=[ nmea 10 13 ]; 
   pnet(s,'printf','%s',nmea)
  else
   [rh rp]=pnet(s,'gethost');
   disp(sprintf('GPS: Client %d.%d.%d.%d:%d is disconnected',rh(1),rh(2),rh(3),rh(4),rp))
   pnet(s,'close')
   GPS.serversockets(i)=-1;
  end    
 end
 catch; disp('ERROR in server') ;end
return


function cServerTimer(obj,event)
 global GPS
 clients=false;
 ssocket=pnet(GPS.serversocket,'tcplisten','noblock');
 if ssocket>-1
  for i=1:length(GPS.serversockets);
    if GPS.serversockets(i)>-1
      if ~pnet(GPS.serversockets(i),'status')
        [rh rp]=pnet(GPS.serversockets(i),'gethost');
        disp(sprintf('GPS: Client %d.%d.%d.%d:%d is disconnected',rh(1),rh(2),rh(3),rh(4),rp))
        pnet(GPS.serversockets(i),'close') 
        GPS.serversockets(i)=-1;
      end    
    end    
  end    
  [rh rp]=pnet(ssocket,'gethost');
  disp(sprintf('GPS: Client %d.%d.%d.%d:%d is connected',rh(1),rh(2),rh(3),rh(4),rp))
  i=find([GPS.serversockets -1]<0,1);
  GPS.serversockets(i)=ssocket;  
 else
  %pnet(ssocket,'close')   
 end
 GPS.serveridle=GPS.serveridle+1;
 GPS.serveridle;
 if GPS.serveridle>60 && length(find(GPS.serversockets>-1))
    s=['$SERVER,' datestr(clock,'yyyy.mm.dd HH:MM:SS')];
    if GPS.dump>1
        disp(['GPS: Sending to ' num2str(length(find(GPS.serversockets>-1))) ' Clients ' s '*' CreateNMEAChecksum(s)])
    end    
    serve([s '*' CreateNMEAChecksum(s)]);
 end    
return


function serverclose()
 global GPS
 if GPS.serversocket>=0
  try stop(GPS.servertimer);delete(GPS.servertimer); end
  try
    %disp 'Closing serversocket'  
    pnet(GPS.serversocket,'close'); 
  end
  for s=GPS.serversockets
   %disp 'Closing_serversocketS'   
   try pnet(s,'close'); end   
  end   
  GPS.serversockets=[];
 end 
return 


% Function validates NMEA checksum
% input:    NMEA_String -   character string containing NMEA string which needs a checksum 
%                           validating
% returns:  0 = invalid checksum
%           1 = valid checksum
% *****************************************************************************
% Revision History:
%  1 - Initial release
% *****************************************************************************
% Version: 1
% Release Date: 20/05/2003
% Author: Steve Dodds
% E-Mail: stevedodds@dsl.pipex.com
% *****************************************************************************
function Checksum_Valid = ValidateNMEAChecksum(NMEA_String)

NMEA_Str_Len = length(NMEA_String);  % get length of NMEA data string

if NMEA_Str_Len==0
  Checksum_Valid=0;  
  return  
end    

% extract checksum from NMEA data string (last 2 items in string)
str_checksum = NMEA_String(NMEA_Str_Len-1:NMEA_Str_Len); 

% generate checksum value for NMEA string
checksum = CreateNMEAChecksum(NMEA_String);

% compare calculated checksum to that in the string
if strcmp(str_checksum,checksum)
    Checksum_Valid = 1; % checksum is valid
else
    Checksum_Valid = 0; % checksum is invalid
end


% Function creates NMEA checksum from a NMEA string
% input:    NMEA_String -   character string containing NMEA string which needs a checksum 
%                           creating.  Assumes that string starts with $
% output:   checksum -      Result of checksum calculation as a string
%
% *****************************************************************************
% Revision History:
%  1 - Initial release
%  2 - Addition of checksum length check, if checksum result is single
%  digit leading zero is added
% *****************************************************************************
% Version: 2
% Release Date: 20/05/2003
% Author: Steve Dodds
% E-Mail: stevedodds@dsl.pipex.com
% *****************************************************************************
function checksum = CreateNMEAChecksum(NMEA_String)

checksum = 0; % zero checksum

% see if string contains the * which starts the checksum and keep string
% upto * for generating checksum
NMEA_String = strtok(NMEA_String,'*');

NMEA_String_d = double(NMEA_String);    % convert characters in string to double values
for count = 2:length(NMEA_String)       % checksum calculation ignores $ at start
    checksum = bitxor(checksum,NMEA_String_d(count));  % checksum calculation
    checksum = uint16(checksum);        % make sure that checksum is unsigned int16
end

% convert checksum to hex value
checksum = double(checksum);
checksum = dec2hex(checksum);

% add leading zero to checksum if it is a single digit, e.g. 4 has a 0
% added so that the checksum is 04
if length(checksum) == 1
    checksum = strcat('0',checksum);
end



% Converts a GPS latitude or longitude degrees minutes string to a decimal
% degrees latitude or longitude
% *****************************************************************************
%
% Returns -1 if called with input argument in wrong format
% Returns -2 if not called with input arguments
% 
% Inputs:       degmin - latitude or longitude string to convert
%               EWNS - East, West, North, South indicator from NMEA string,
%               or use a NULL field ('') if not used
% Returns:      dec - decimal degrees version of input
% 
% *****************************************************************************
% Revision History:
%  1 - Initial release
%  2 - Use of E,W,N & S to indicate a positive or negative latitude or
%  longitude added
%  3 - Number of decimal places of output increased from default 4 to a max of 10 
%      (due to num2str function in line 53).
% *****************************************************************************
% Version: 3
% Release Date: 22/05/2003
% Author: Steve Dodds
% E-Mail: stevedodds@dsl.pipex.com
% *****************************************************************************
% Function convert latitude and longitude from degrees minutes to decimal degrees number
function dec = DegMin_2_Dec(degmin,EWNS)
% Latitude string format: ddmm.mmmm (dd = degrees)
% Longitude string format: dddmm.mmmm (ddd = degrees)

if nargin ~= 2
    dec = '-2'
else
    % Determine  if data is latitude or longitude
    switch length(strtok(degmin,'.'))
        case 4
            % latitude data
            deg = str2num(degmin(1:2)); % extract degrees portion of latitude string and convert to number
            min_start = 3;              % position in string for start of minutes
        case 5
            % longitude data
            deg = str2num(degmin(1:3)); % extract degrees portion of longitude string and convert to number
            min_start = 4;              % position in string for start of minutes
        otherwise
            % data not in correct format
            dec = '-1';
            return;
    end

    minutes = (str2num(degmin(min_start:length(degmin))))/60; % convert minutes to decimal degrees

    dec = num2str(deg + minutes,'%11.10g'); % degrees as decimal number

    % add negative sign to decimal degrees if south of equator or west
    switch EWNS
        case 'S'
            % south of equator is negative, add -ve sign
            dec = strcat('-',dec);
        case 'W'
            % west of Greenwich meridian is negative, add -ve sign
            dec = strcat('-',dec);
        otherwise
            % do nothing
    end
end
