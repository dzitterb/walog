function walog2kml

%global P

%for debugging: delete old data to force rebuild:
if ~isdeployed delete('walog.txt'); end

disp -------------------------------------------------------------------------------
disp 'walog2kml Version vom 9.7.2013 Daniel&Lars'

disp (['which kml: ' which('walog_template.kml')])

infile='http://ch5.de/walog/walog.txt';
infile='walog.dat';
txtfile='walog.txt';
csvfile='walog.csv';
kmlfile='walog.kml';
logfile='';
statusfile='';
copydir1='';
copydir2='';
imagedir='';
imagelink='http://CSYSP017/WALOG/FOTOS';
iconpath='';
syslog=false;
googleearth=true;

if isequal(getenv('COMPUTERNAME'),'CSYSP017')
  disp(['Using Settings for ' getenv('COMPUTERNAME')])
  %infile='http://ch5.de/walog/walog.txt';
  %create walog.dat from the maildir on csysp017
  !mail2dat.cmd
  infile='walog.dat';
  txtfile='walog.txt';
  csvfile='walog.csv';
  kmlfile='walog.kml';
  logfile='walog2kml.log';
  statusfile='walog.status.txt';
  copydir1='C:\PALAOA\FTP\Public\WebCam';
  copydir2='D:\WALOG';
  imagedir='D:\WALOG\FOTOS';
  imagelink='http://CSYSP017/WALOG/FOTOS';
  %iconpath='http://CSYSP017/WALOG/';
  syslog=true;
  googleearth=false;
end

if isequal(getenv('COMPUTERNAME'),'WALLOG')
  disp(['Using Settings for ' getenv('COMPUTERNAME')])
  infile='C:\WALLOG\logs\*.log';
  txtfile='C:\WALLOG\KML\walog.txt';
  csvfile='C:\WALLOG\KML\walog.csv';
  kmlfile='C:\WALLOG\KML\walog.kml';
  logfile='C:\WALLOG\KML\walog2kml.log';
  statusfile='';
  copydir1='';
  copydir2='';
  imagedir='C:\WALLOG\CANON';
  imagelink='http://wallog.fs-polarstern.de/CANON';
  %iconpath='http://wallog.fs-polarstern.de/KML/';
  syslog=false;
  googleearth=false;
end

if isequal(getenv('COMPUTERNAME'),'CSYSPHP') %polarstern
  disp(['Using Settings for ' getenv('COMPUTERNAME')])
  infile='\\wallog.fs-polarstern.de\WALLOG\logs\2013*.log';
  txtfile='walog.txt';
  csvfile='walog.csv';
  kmlfile='walog.kml';
  logfile='walog2kml.log';
  statusfile='';
  copydir1='';
  copydir2='';
  imagedir='\\wallog.fs-polarstern.de\WALLOG\CANON';
  imagelink='http://wallog.fs-polarstern.de/CANON';
  %iconpath='http://wallog.fs-polarstern.de/KML/';
  syslog=false;
  googleearth=false;
end

if isequal(getenv('COMPUTERNAME'),'CSYSP019')
  disp(['Using Settings for ' getenv('COMPUTERNAME')])
  infile='W:\logs\*.log';
  txtfile='walog.txt';
  csvfile='walog.csv';
  kmlfile='walog.kml';
  logfile='walog2kml.log';
  statusfile='';
  copydir1='';
  copydir2='';
  imagedir='W:\CANON';
  imagelink='http://wallog.fs-polarstern.de/CANON';
  syslog=false;
  googleearth=true;
end

%%

if ~isempty(logfile)
  logid=fopen(logfile,'at');
else
  logid=1;
end

if findstr(infile,'tp:')
  disp(['downloading ' infile])
  text=urlread(infile);
elseif findstr(infile,'*')
  text='';
  d=dir(infile);
  disp(['loading ' infile ' (' num2str(length(d)) ' files)'])
  for f=sort({d.name})
    f=[fileparts(infile) '\' char(f)];
    fid=fopen(f);text=[text fread(fid,'*char')'];fclose(fid);
  end
else
  disp(['loading ' infile])
  fid=fopen(infile);text=fread(fid,'*char')';fclose(fid);
end

text=regexprep(text, '=192\.168\.0\.1[^:]+:.', '='); %ploblem with walog and multiple IPs

newtext=textscan(text,'%s','delimiter', '\n','whitespace','');

if ~isempty(txtfile) && exist(txtfile,'file')
  disp(['comparing with old ' txtfile])
  oid=fopen(txtfile);
  oldtext=textscan(oid,'%s','delimiter', '\n','whitespace','');
  fclose(oid);
else
  oldtext='';
end

if isequal(newtext,oldtext)
  fprintf(logid,'%s %s %s\n',datestr(now),'checking',infile);
  disp 'no new data - done'
  fclose all;
  if syslog dos(['C:\PALAOA\IceCast\klog.exe -h %COMPUTERNAME% -m "WALOG2KML Nothing new"']); end
  return
end
clear oldtext

fprintf(logid,'%s %s %s %s\n',datestr(now),'checking',infile,' - NEW DATA AVAILABE');

if ~isempty(txtfile)
  disp(['saving as new ' txtfile ])
  rid=fopen(txtfile,'wt');
  fprintf(rid, '%s',text);
  fclose(rid);
end

text=newtext{1,1};
clear newtext

disp 'analyzing...'

text=strrep(text,char(13),'');
text=strrep(text,'','°');
text=strrep(text,'&','&amp;');

P(1).timestamp=[];
P(size(text,1)).timestamp=[];
n=0;

for line=text'
  %disp (char(line))
  %try
  elements=textscan(char(line),'%s','Delimiter',',')';
  n=n+1;
  %Pn=[];
  for element=elements{:}'
    element=char(element);
    if isempty(element) continue; end
    entry=textscan(element,'%s','Delimiter','=');
    entry=entry{:};
    
    if length(entry)==1
      if findstr(entry{1},'MAPS Foto.jpg')
        entry=[{'Foto'}; entry{:}];
      else
        entry(2,1)={'#'};
      end
    else
      entry;
    end
    %entry
    try
      field=char(entry(1));
      value=char(entry(2));
      P(n).(field)=value;
    catch
      disp(['Bad field: "' entry{1} '" in "' char(line) '"'])
    end
  end
  %P(n)=Pn;
  %end
end

text=text(end); %%just to save space

c={P.computer};
I=cellfun('isempty',c) | cellfun(@(x) isequal(x,'WALLOG'),c);
P=P(I);

try
    T=datenum({P.timestamp});
catch
    T=nan(length(P),1);
    for i=1:length(P)
        try T(i)=datenum(P(i).timestamp); end
    end
    T(T<datenum('2000-01-01'))=nan;
end

[T,I]=sort(T);
P=P(I);

P(isnan(T))=[]; %%new by Lars
T(isnan(T))=[]; %%new by Lars

disp (['found data from ' P(1).timestamp ' till ' P(end).timestamp])
disp(P)

TT=nan(length(P),1);
for i=1:length(P)
 try TT(i)=datenum(P(i).TIME); end
end
TT(TT<datenum('2000-01-01'))=nan;

%figure(1);clf;plot(T,T  ,'.r');hold on; plot(T,TT  ,'b.');datetick x keeplimits;datetick y keeplimits;
%figure(2);clf;plot(T,T-T,'.r');hold on; plot(T,TT-T,'b.');datetick x keeplimits;datetick y keeplimits;

TTvalid=T-TT<5/1440 & TT>datenum('2000-01-01');
TT(~TTvalid)=nan;

if ~isempty(csvfile)
  disp(['writing ' csvfile]);
  fil=fopen(csvfile,'wt');
  header='';
  for f=fields(P)'
    if isempty(header)
      header=char(f);
    else
      header=[header ',' char(f)];
    end
  end
  %disp(header)
  fprintf(fil,'%s\n',header);
  
  for p=(P)
    line= '';
    for f=fields(p)'
      %p;
      if isempty(line)
        line=p.(char(f));
      else
        line=[line ',' p.(char(f))];
      end
    end
    %I=find(~cellfun('isempty',strfind({P.event},'detection')));
    %if I
    %disp(line)
    fprintf(fil,'%s\n',line);
    %end
  end
  fclose(fil);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%kml file generation:
if ~isempty(kmlfile)
  disp(['writing ' kmlfile]);
  
  %copyfile('walog_template.kml',kmlfile);
  fid=fopen('walog_template.kml');header=fread(fid,'*char')';fclose(fid);
  header=strrep(header,'<!-- #iconpath -->',iconpath);
  
  fid = fopen(kmlfile,'w');
  fwrite(fid,header);
  
  expedition=[];

  expedition(end+1).name='ARK-XXIV';
  expedition(end  ).date='2009-06-20';
   
  expedition(end+1).name='ANT-XXVI/1';
  expedition(end  ).date='2009-10-16';
  expedition(end+1).name='ANT-XXVI/2';
  expedition(end  ).date='2009-11-27';
  expedition(end+1).name='ANT-XXVI/3';
  expedition(end  ).date='2010-01-30';
  expedition(end+1).name='ANT-XXVI/4';
  expedition(end  ).date='2010-04-07';
  
  expedition(end+1).name='ARK-XXV';
  expedition(end  ).date='2010-06-10';
  
  expedition(end+1).name='ANT-XXVII/1';
  expedition(end  ).date='2010-10-24';
  expedition(end+1).name='ANT-XXVII/2';
  expedition(end  ).date='2010-11-28';
  expedition(end+1).name='ANT-XXVII/3';
  expedition(end  ).date='2011-02-06';
  expedition(end+1).name='ANT-XXVII/4';
  expedition(end  ).date='2011-04-20';
  
  expedition(end+1).name='Port-2011-1';
  expedition(end  ).date='2011-05-21';
  expedition(end+1).name='ARK-XXVI/1';
  expedition(end  ).date='2011-06-15';
  expedition(end+1).name='ARK-XXVI/2';
  expedition(end  ).date='2011-07-13';
  expedition(end+1).name='ARK-XXVI/3';
  expedition(end  ).date='2011-08-05';
  
  expedition(end+1).name='Port-2011-2';
  expedition(end  ).date='2011-10-07';
  expedition(end+1).name='ANT-XXVIII/1';
  expedition(end  ).date='2011-10-28';
  expedition(end+1).name='ANT-XXVIII/2';
  expedition(end  ).date='2011-12-03';
  expedition(end+1).name='ANT-XXVIII/3';
  expedition(end  ).date='2012-01-07';
  expedition(end+1).name='ANT-XXVIII/4';
  expedition(end  ).date='2012-03-13';
  expedition(end+1).name='ANT-XXVIII/5';
  expedition(end  ).date='2012-04-11';

  expedition(end+1).name='Port-2012-1';
  expedition(end  ).date='2012-05-16';
  expedition(end+1).name='ARK-XXVII/1';
  expedition(end  ).date='2012-06-14';
  expedition(end+1).name='ARK-XXVII/2';
  expedition(end  ).date='2012-07-15';
  expedition(end+1).name='ARK-XXVII/3';
  expedition(end  ).date='2012-08-02';

  expedition(end+1).name='Port-2012-2';
  expedition(end  ).date='2012-10-08';
  expedition(end+1).name='ANT-XXIX/1';
  expedition(end  ).date='2012-10-27';
  expedition(end+1).name='ANT-XXIX/2';
  expedition(end  ).date='2012-11-30';
  expedition(end+1).name='ANT-XXIX/3';
  expedition(end  ).date='2013-01-20';
  expedition(end+1).name='ANT-XXIX/4';
  expedition(end  ).date='2013-03-22';
  expedition(end+1).name='ANT-XXIX/5';
  expedition(end  ).date='2013-04-18';
  expedition(end+1).name='ANT-XXIX/6';
  expedition(end  ).date='2013-06-08';
  expedition(end+1).name='ANT-XXIX/7';
  expedition(end  ).date='2013-08-14';
  expedition(end+1).name='ANT-XXIX/8';
  expedition(end  ).date='2013-11-09';
  expedition(end+1).name='ANT-XXIX/9';
  expedition(end  ).date='2013-12-20';
  expedition(end+1).name='ANT-XXIX/10';
  expedition(end  ).date='2014-03-08';
  
  expedition(end+1).name='Port-2014-1';
  expedition(end  ).date='2014-04-08';
  expedition(end+1).name='ARK-XXVIII/1';
  expedition(end  ).date='2014-05-08';
  expedition(end+1).name='ARK-XXVIII/2';
  expedition(end  ).date='2014-06-24';
  expedition(end+1).name='ARK-XXVIII/1';
  expedition(end  ).date='2014-07-30';

  expedition(end+1).name='Port-2014-2';
  expedition(end  ).date='2014-10-07';
  expedition(end+1).name='ANT-XXX';
  expedition(end  ).date='2014-10-28';

  
  Pt=T';
  %Pt=datenum(char({P.timestamp}))';
  %for i=1:length(P) P(i).T=T(i); end

  imglist=dir([imagedir '\*.jpg']);
  imglist={imglist.name}';
  Pfoto={P.Foto}';
  isFoto=~cellfun('isempty',Pfoto);
  [Pfoto{~isFoto}]=deal('');
  [~,I]=intersect(Pfoto,imglist);
  isDiskFoto=false(size(P));
  isDiskFoto(I)=true;
  
  %%
  for i=find(~cellfun('isempty',{P.comment}))
    P(i).comment=strrep(P(i).comment,'&','&amp;');
    P(i).comment=strrep(P(i).comment,'<','&lt;');
    P(i).comment=strrep(P(i).comment,'>','&gt;');
  end
    
  %%
  for ex=0:length(expedition)
                
    if ex>0 exstart=fix(datenum(expedition(ex).date)); else exstart=0; end
    if ex<length(expedition) exend=fix(datenum(expedition(ex+1).date)); else exend=inf; end
    if ex>0 exname=expedition(ex).name; else exname='OLD'; end
    
    leg= Pt>=exstart & Pt<=exend;
    leg= leg & TTvalid'; %Stehengebliebene NMEA Daten ausblenden
    
    if ~any(leg) 
        if exend<inf; ee=datestr(exend); else ee='inf'; end
        disp ([exname ' ' datestr(exstart) ' - ' ee ' - NO DATA'])
        continue; 
    end
        
    visibility='0'; 
    if exend>now visibility='1'; end
    
    disp ([exname ' ' datestr(exstart) ' - ' datestr(exend) ' - ' num2str(sum(leg)) ' entries'])
    fprintf(fid,'<Folder><name>%s</name><visibility>%s</visibility><open>%s</open>\n',exname,visibility,visibility);
    
    %look for events or comments
    det=~cellfun('isempty',strfind({P.event},'detection')) & leg;
    com=~cellfun('isempty',strfind({P.event},'comment'))   & leg;
    pic=~cellfun('isempty',strfind({P.event},'picture'))   & leg &  isDiskFoto;
    nop=~cellfun('isempty',strfind({P.event},'picture'))   & leg & ~isDiskFoto;
    
    if exend>now
        %%
        WAL=[];
        disp 'Writing Sightings to WALpos.mat'
        I=find(det|com|pic);
        WAL.det=det(I);
        WAL.com=com(I);
        WAL.pic=pic(I);
        for i=1:length(I);   
         WAL.fixtime(i)=datenum(P(I(i)).timestamp);
         [WAL.latitude(i),WAL.longitude(i)]=pos2latlon(P(I(i)).POSITION);
         WAL.name{i}=char(P(I(i)).Common);
         WAL.info{i}=char(P(I(i)).comment);
         if WAL.pic(i) WAL.info{i}=P(I(i)).Foto; end
         WAL.mink(i) =false;
         WAL.hump(i) =false;
         WAL.fin(i)  =false;
         WAL.undef(i)=false;
         if WAL.det(i)
             switch WAL.name{i}
                 case 'Minke'
                     WAL.mink(i)=true; 
                 case 'Hback' 
                     WAL.hump(i)=true; 
                 case 'Fin'   
                     WAL.fin(i) =true;
                 otherwise
                     WAL.undef(i) =true;
             end
         end
        end
        
        save WALpos WAL
        
%         cla;
%         I=WAL.pic;plot(WAL.longitude(I),WAL.latitude(I),'.k','markersize',1);
%         hold on
%         %I=WAL.com;  plot(WAL.longitude(I),WAL.latitude(I),'s');
%         I=WAL.mink; plot(WAL.longitude(I),WAL.latitude(I),'Ob');
%         I=WAL.hump; plot(WAL.longitude(I),WAL.latitude(I),'Og');
%         I=WAL.fin;  plot(WAL.longitude(I),WAL.latitude(I),'Or');
%         I=WAL.undef;plot(WAL.longitude(I),WAL.latitude(I),'Ok');
        
        %%
    end
    
     %Images
    P2=P(pic);
    if ~isempty(P2)
      n=0;
      fprintf(fid,'<Folder><name>Fotos</name><visibility>%s</visibility><open>0</open>\n',visibility);
      for k=1:length(P2)
        nam=P2(k).Foto;
        writestring=[ P2(k).TIME ' ' P2(k).POSITION];
        [lat lon]=pos2latlon(P2(k).POSITION) ;
        if ~isnan(lat)
          n=n+1;
          link=[imagelink '/' strrep(P2(k).Foto,' ','%20')];
          fprintf(fid,'<Placemark><visibility>0</visibility>\n<name>%s</name>\n<description>\n%s\n',nam,writestring);
          fprintf(fid,'<![CDATA[<a href="%s"><img src="%s" width="800"></a>]]>\n',link,link);
          fprintf(fid,'</description>\n<styleUrl>#%s</styleUrl>\n<Point><coordinates>',P2(k).event);
          fprintf(fid, '%.6f,%.6f', lon,lat);
          fprintf(fid,'</coordinates></Point>\n</Placemark>\n');
        end
      end
      fprintf(fid,'</Folder>\n');
      disp([num2str(n) ' Fotos on Disk'])
    end
    
    %missing Images 
    P2=P(nop);
    if ~isempty(P2)
      n=0;
      fprintf(fid,'<Folder><name>Fotos Missing</name><visibility>%s</visibility><open>0</open>\n',visibility);
      for k=1:length(P2)
        nam=P2(k).Foto;
        writestring=[ P2(k).TIME ' ' P2(k).POSITION];
        [lat lon]=pos2latlon(P2(k).POSITION) ;
        if ~isnan(lat)
          n=n+1;
          link=[imagelink '/' strrep(P2(k).Foto,' ','%20')];
          fprintf(fid,'<Placemark><visibility>0</visibility>\n<name>%s</name>\n<description>\n%s\n',nam,writestring);
          fprintf(fid,'</description>\n<styleUrl>#no%s</styleUrl>\n<Point><coordinates>',P2(k).event);
          fprintf(fid, '%.6f,%.6f', lon,lat);
          fprintf(fid,'</coordinates></Point>\n</Placemark>\n');
        end
      end
      fprintf(fid,'</Folder>\n');
      disp([num2str(n) ' Fotos not on Disk'])
    end
    
    %Detections
    P2=P(det);
    if ~isempty(P2)
      fprintf(fid,'<Folder><name>Detections</name><visibility>%s</visibility><open>0</open>\n',visibility);
      n=0;
      for k=1:length(P2)
        pos=pos2latlon(P2(k).POSITION);
        if isfield(P2(k),'sightingpos') && ~isempty(P2(k).sightingpos), pos=P2(k).sightingpos; end
        tim=P2(k).timestamp;
        if isfield(P2(k),'TIME') && ~isempty(P2(k).TIME), tim=P2(k).TIME; end
        if isfield(P2(k),'sightingtime') && ~isempty(P2(k).sightingtime), tim=P2(k).sightingtime; end
        nam=[tim(1:16) ' ' P2(k).Species];
        writestring='';c='';
        for f=fields(P2(k))'
          if ~isempty(char(P2(k).(char(f))))
            writestring=[writestring c char(f) '=' char(P2(k).(char(f)))];
            c=', ';
          end
        end
        
        [lat lon]=pos2latlon(pos);
        if ~isnan(lat)
          n=n+1;
          fprintf(fid,'<Placemark>\n<name>%s</name><visibility>%s</visibility>\n<description>\n%s\n</description>\n<styleUrl>#%s</styleUrl>\n<Point>\n<coordinates>\n',nam,visibility,writestring,P2(k).event);
          fprintf(fid, '%.6f,%.6f\n', lon,lat);
          fprintf(fid,'</coordinates>\n</Point>\n</Placemark>\n');
        end
      end
      fprintf(fid,'</Folder>\n');
      disp([num2str(n) ' Detections'])
    end
    
    %Comments
    P2=P(com);
    if ~isempty(P2)
      fprintf(fid,'<Folder><name>Comments</name><visibility>%s</visibility><open>0</open>\n',visibility);
      n=0;
      for k=1:length(P2)
        pos=P2(k).POSITION;
        if isfield(P2(k),'sightingpos') && ~isempty(P2(k).sightingpos) && ~isequal(P2(k).sightingpos,'no position') pos=P2(k).sightingpos; end
        tim=P2(k).timestamp;
        if isfield(P2(k),'TIME') && ~isempty(P2(k).TIME), tim=P2(k).TIME; end
        if isfield(P2(k),'sightingtime') && ~isempty(P2(k).sightingtime) && length(P2(k).sightingtime)>=16; tim=P2(k).sightingtime; end
        nam=[tim(1:16) ' ' P2(k).comment];
        writestring='';c='';
        for f=fields(P2(k))'
          if ~isempty(char(P2(k).(char(f))))
            writestring=[writestring c char(f) '=' char(P2(k).(char(f)))];
            c=', ';
          end
        end
        
        [lat lon]=pos2latlon(pos);
        if ~isnan(lat)
          n=n+1;
          fprintf(fid,'<Placemark><visibility>%s</visibility>\n<name>%s</name>\n<description>\n%s\n</description>\n<styleUrl>#%s</styleUrl><Point>\n<coordinates>\n',visibility,nam,writestring,P2(k).event);
          fprintf(fid, '%.6f,%.6f\n', lon,lat);
          fprintf(fid,'</coordinates>\n</Point>\n</Placemark>\n');
        else
          disp(['Comment without position: ' writestring])
        end
      end
      fprintf(fid,'</Folder>\n');
      disp([num2str(n) ' Comments'])
    end
    
    % write systeminfos (Midnight)
    P2=P(leg);
    T2=T(leg);
    
    %T3=[0 diff(fix(T2))];
    %P2=P2(T3);
    
    if ~isempty(P2)
      fprintf(fid,'<Folder><name>Midnight Positions</name><visibility>%s</visibility><open>0</open>\n',visibility);
      n=0;
      for k=1:length(P2)
        %if strcmp(datestr(P2(k).timestamp,'HH:MM'),'00:00')
        %if T2(k)-fix(T2(k))<1/1440
        if T2(k)-fix(T2(k))<30/1440
          pos=P2(k).POSITION;
          tim=P2(k).timestamp;
          %if isfield(P2(k),'TIME') && ~isempty(P2(k).TIME), tim=P2(k).TIME; end
          nam=tim(1:16);
          writestring='';c='';
          for f=fields(P2(k))'
            if ~isempty(char(P2(k).(char(f))))
              writestring=[writestring c char(f) '=' char(P2(k).(char(f)))];
              c=', ';
            end
          end
          [lat lon]=pos2latlon(pos);
          if ~isnan(lat)
            n=n+1;
            %template=strrep(P2(k).event,' ','-');
            template='system-info'; % evtl midnight was anderes
            fprintf(fid,'<Placemark><visibility>%s</visibility>\n<name>%s</name>\n<description>\n%s\n</description>\n<styleUrl>#%s</styleUrl>\n<Point>\n<coordinates>\n',visibility,nam,writestring,template);
            fprintf(fid, '%.6f,%.6f\n', lon,lat);
            fprintf(fid,'</coordinates>\n</Point>\n</Placemark>\n');
          end
        end
      end
      fprintf(fid,'</Folder>\n');
      disp([num2str(n) ' Midnight Positions'])
    end
        
    %write lines
    P2=P(leg);
    if ~isempty(P2)
      n=0;
      fprintf(fid,'<Placemark>\n<name>Track</name><visibility>%s</visibility>\n',visibility);
      fprintf(fid,'<LineString>\n<tessellate>1</tessellate>\n<coordinates>\n');
      for k=1:length(P2)
        n=n+1;
        if isfield(P2(k),'POSITION')
          [lat lon]=pos2latlon(P2(k).POSITION);
          if k>1 && abs((lat-lato))>1
             disp(['Unplausible Position: ' P2(k).timestamp ' ' P2(k).event ' ' P2(k).TIME ' ' P2(k).POSITION])
             lato=lat;
             continue
          else lato=lat; end  
          if ~isnan(lat)
            fprintf(fid, '%.6f,%.6f\n', lon,lat);
          end;
        end;
      end
      fprintf(fid,'</coordinates>\n</LineString>\n</Placemark>\n');
      disp([num2str(n) ' Track Positions'])
    end
    
    fprintf(fid,'</Folder>\n');
    
  end
  
  %Current ship position
  pos=P(end).POSITION;
  tim=P(end).timestamp;
  nam=tim(1:16);
  writestring='';c='';
  for f=fields(P(end))'
    if ~isempty(char(P(end).(char(f))))
      writestring=[writestring c char(f) '=' char(P(end).(char(f)))];
      c=', ';
    end
  end
  writestring=[writestring c 'walog2kml' '=' datestr(now,'yyyy-mm-dd HH:MM')];
  
  [lat lon]=pos2latlon(pos);
  fprintf(fid,'<Placemark><visibility>1</visibility>\n<name>%s</name>\n',nam);
  fprintf(fid,'<description>\n%s\n</description>\n',writestring);
  fprintf(fid,'<styleUrl>#bal</styleUrl>\n<Point><coordinates>');
  fprintf(fid, '%.6f,%.6f', lon,lat);
  fprintf(fid,'</coordinates></Point>\n</Placemark>\n');
  
  fprintf(fid,'<LookAt>\n<heading>0</heading>\n<range>5000000</range>\n');
  fprintf(fid,'<longitude>%.6f</longitude>\n<latitude>%.6f</latitude>\n',lon,lat);
  fprintf(fid,'</LookAt>\n');
  
  %documentfooter
  fprintf(fid,'</Document>\n</kml>\n');
  fclose(fid);
  
  kmzfile=strrep(kmlfile,'.kml','.kmz');
  
  if exist(kmzfile,'file') delete(kmzfile); end
  zip(kmzfile,{kmlfile, '*.gif', '*.png'})
  delete(kmlfile)
  copyfile([kmzfile '.zip'],kmzfile)
  
  for n=1:60
      try
          delete([kmzfile '.zip'])
          if n>1 warning 'But it did work now'; end
          break
      catch
          if n==1 warning 'Cannot delete .kmz.zip'; end
          pause(1)
      end
  end
  
end %kmlfile

%reverse logfile
if ~isempty(statusfile)
  logid=fopen(logfile,'r');
  statusid=fopen(statusfile,'wt');
  logtext=textscan(logid,'%s','delimiter', '\n','whitespace','');
  logtext=logtext{1};
  for i=length(logtext):-1:1
    if length(logtext)-i<=100
      fprintf(statusid,'%s\n',cell2mat(logtext(i,:)));
    end
  end
end

fclose all;

if ~isempty(copydir1) dos(['copy walog.* "' copydir1 '"']); end
if ~isempty(copydir2) dos(['copy walog.* "' copydir2 '"']); end
if syslog dos(['C:\PALAOA\IceCast\klog.exe -h %COMPUTERNAME% -m "WALOG2KML New KML generated: ' char(text(end)) ' "']); end

if googleearth
  winopen(kmzfile);
end;

% t=datenum({P.timestamp});
%
% figure(1)
% plot(t,t,'.'
% datetick('x')
% datetick('y')
%
% figure(2)
% x=[P.LAT];
% y=[P.LON];
% plot(x,y,'.')


return

function [lat lon]=pos2latlon(pos)

% if ~iscellstr(pos)
%   pos={pos}
% end

lat=[];lon=[];

%pos
po=pos;
%for po=pos;

try
  po=char(po);
catch
  po='';
end
try
  degmin=po([1:2,4:9]);
  EWNS=po(12);
  lat=[lat str2num(DegMin_2_Dec(degmin,EWNS))];
catch
  lat=[lat nan];
end

try
  degmin=po([14:16,18:23]);
  EWNS=po(26);
  lon=[lon str2num(DegMin_2_Dec(degmin,EWNS))];
catch
  lon=[lon nan];
end
%end


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

