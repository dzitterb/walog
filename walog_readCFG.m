function  walog_readCFG(file)
global CONTROL
%clear all
if nargin<1, file='walog.cfg'; end;
%file='../../cfg/TashAlyse.cfg';
disp(['opening tashtego config file ' file]);
fid = fopen(file);
C = textscan(fid, '%s %s %*[^\n]','delimiter', '=','commentStyle', '#');
if size(C,1>0)
for k=1:size(C{1},1)
    CFGVAR=C{1}(k);
    switch char(CFGVAR)
        case 'comport'
            CONTROL.comport=char(C{2}(k));
        
        case 'usecom'
            CONTROL.usecom=str2num(char(C{2}(k)));
            %CONTROL.kn=str2num(char(C{2}(k)));
        case 'autosend_email'
            CONTROL.autosend_email=str2num(char(C{2}(k)));

            
            
    end
end
end
