function walog_saveandclear_Callback
global handl WHALE

if isempty(get(gcbo,'TooltipString'))
    stringname=get(gcbo,'string');
else 
    stringname=get(gcbo,'TooltipString'); 
end
buttongrp=get(get(gcbo,'Parent'),'Title');
allbuttons=findall(handl.figure1,'Style','Togglebutton');
activebuttons=findall(handl.figure1,'Style','Togglebutton','Value',1);
if findstr(stringname,'verwerfen')==1
    walog_set_button_color( [0.8 0.8 0.8], allbuttons )
    %set(allbuttons,'BackgroundColor',[1 1 1]);
    set(allbuttons,'Value',0);
    WHALE = [];
    writeline=sprintf('letzte Eingabe verworfen!');
    set(handl.display_lastsight,'String',writeline);
    walog_record('cancel');
elseif findstr(stringname,'speichern')==1
    output=[];
    
    
    if isfield(WHALE,'Species1ext'),
        WHALE.Common=WHALE.Species;
        WHALE.Species=WHALE.Species1ext;
        WHALE=rmfield(WHALE,'Species1ext');
    end
    %activebuttons
    %if isfield(WHALE,'comment') && disp(isempty(activebuttons))
   %disp(isempty(findstr(WHALE.comment,'comment')))
    %isempty(findstr(WHALE.comment,'comment'))
    %end
    %isempty(activebuttons)
    %isfield(WHALE,'comment')
    if length(activebuttons)<4
        walog_writelog('comment',WHALE);
        walog_set_button_color( [0.8 0.8 0.8], allbuttons );
        %set(allbuttons,'BackgroundColor',[1 1 1]);
        set(allbuttons,'Value',0);
      %  walog_record('save');
        WHALE=[];
    elseif length(activebuttons)==4
        walog_writelog('detection',WHALE);
        walog_set_button_color( [0.8 0.8 0.8], allbuttons );
        %set(allbuttons,'BackgroundColor',[1 1 1]);
        set(allbuttons,'Value',0);
        %walog_send_email(1) %send an email after each detection, only for debugging!
        WHALE = [];
    else
        walog_set_button_color( [0.8 0.8 0.8] , allbuttons)
        %set(allbuttons,'BackgroundColor',[1 1 1]);
        set(allbuttons,'Value',0);
        WHALE = [];
    %    walog_record('cancel');
    end
    
end
    set(handl.save_button_1,'Enable','off');
    set(handl.save_button_1,'BackgroundColor',[0.8 0.8 0.8]);
    set(handl.num_button_10,'String','#:');
    set(handl.display_lastsight,'BackgroundColor',[.8 .8 .8]);
    set(handl.display_edit_comments,'String','comment');
    walog_image_display(imread('images/start.jpg'));
    set(handl.push_next_image,'Visible','off');
    set(handl.push_prev_image,'Visible','off');
    set(handl.spec_button_16,'string','other:');