%function P=walog2csv(varargin)
%persistent filepath;

filepath=''
disp *******************************************************************************

a=nargin;
if a & (a<1000)
  infiles=varargin;
else
  [infiles,f]=uigetfile([filepath '*.log'],'Select some log files',[],'MultiSelect','on');
  if f filepath=f; end
  infiles=cellstr(strcat(filepath,infiles));
end

disp(char(infiles))

P=[];n=0;

for infile=infiles
  
  infile=char(infile);
  disp -------------------------------------------------------------------------------
  disp(infile)
  
  text=textread(infile,'%s','delimiter', '\n','whitespace','')
  strrep(text,char(13),'');
  
  for line=text'
    %try
    disp([char(line) '.'])
    elements=textscan(char(line),'%s','Delimiter',',')';
    n=n+1;
    for element=elements{:}'
      element=char(element)
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
      P(n).(char(entry(1)))=char(entry(2));
    end
    %end
  end
  
end


[dummy,I]=sort({P.timestamp});
P=P(I);

disp ===============================================================================

[pathstr, name] = fileparts(infile);
outfile=fullfile(pathstr,[name '.csv']);
disp(outfile)

fil=fopen(outfile,'w');

header='';
for f=fields(P)'
  if isempty(header)
    header=char(f);
  else
    header=[header ',' char(f)];
  end
end
disp(header)
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
  disp(line)
  fprintf(fil,'%s\n',line);
  %end
end
fclose(fil);

det=~cellfun('isempty',strfind({P.event},'detection'));
com=~cellfun('isempty',strfind({P.event},'comment'));
I=find( det | com);
P=P(I);

% t=datenum({P.timestamp});
% 
% figure(1)
% plot(t,t,'.')
% datetick('x')
% datetick('y')
% 
% figure(2)
% x=[P.LAT];
% y=[P.LON];
% plot(x,y,'.')
