function walog_set_button_color( color, allbuttons )
global DAYTIME handl
%allbuttons=get(get(gcbo,'Parent'),'Children');
%allbuttons=findall(handl.figure1,'Style','Togglebutton');
if DAYTIME==0
    background = 1.1 - color;
   % foreground = color - 0.5;
    foreground = color;
else
    background = color;
    foreground = 1-color;
end;
set(allbuttons,'BackgroundColor',background);
set(allbuttons,'ForegroundColor',foreground);
    