%compile.m

delete walog.exe

disp ('start compiling')
mcc -m walog.m -a ./images
%mcc -m walog.m
disp ('compiling done')

delete readme.txt
delete mccExcludedFiles.log

%!copy walog.exe c:\wallog

%mcc -e fuer kein fenster
%mcc -m mit dosfenster