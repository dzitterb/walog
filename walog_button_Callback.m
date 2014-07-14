% --- Executes on button press in spec_button_2.
function walog_button_Callback
global handl WHALE DAYTIME WHALETIME GPS SHIPTIME
%get(gcbo)
if isempty(get(gcbo,'TooltipString'))
    stringname=get(gcbo,'string');
    commonname=stringname;
else
    stringname=get(gcbo,'TooltipString');
    commonname=get(gcbo,'string');
end
buttongrp=get(get(gcbo,'Parent'),'Title');
allbuttons=get(get(gcbo,'Parent'),'Children');

if ~ishandle(handl.species1extension)
    walog_load_species(handl.hemi);
end

% if (strcmp(buttongrp,'All_Species'))
%     delete(handl.ALLSPECIES.h);
%     set(handl.spec_button_16,'string',['other:' stringname]);
%     return
%    % buttongrp='Species';
%
% end




if (strcmp(buttongrp,'Species1ext'))
    set(handl.species1extension,'Visible','off')
    
    set(handl.spec_button_16,'string',[commonname]);
    uiresume(handl.species1extension)
end



if findstr(stringname,'other:')==1 %&& strcmp(buttongrp,'Species')
    % species=regexprep(stringname, 'other:\ ','');
    
    handl.ALLSPECIES.h=handl.species1extension;
    uiwait(handl.ALLSPECIES.h);
    if isempty(get(gcbo,'TooltipString'))
        stringname=get(gcbo,'string');
    else
        stringname=get(gcbo,'TooltipString');
        commonname=get(gcbo,'string');
    end
    stringname=regexprep(stringname, 'other:','');
    
    
    
    
    %  stringname
    %    delete(WHALE.species.h);
    %answer = char(inputdlg(buttongrp,'specify',1,{species}));
    %   answer
    %    if  ~isempty(answer)
    %    set(gcbo,'string',['other:' answer]);
    % stringname=['other:' answer];
    % stringname=species;
    %    end
    %elseif findstr(stringname,'other:')==1 && strcmp(buttongrp,'Number')
    
    
end

if findstr(stringname,'#:')==1
    prompt = {'Number of sighted anymals:'};
    stringname = inputdlg(prompt,'enter number of animals sighted',1);
end


WHALE.(buttongrp)=stringname;
if exist('commonname','var') && strcmp(buttongrp,'Species')==1 && isempty(strfind(stringname,'other:')); WHALE.Common=commonname;end;

%set locked mode
writeline=sprintf('Eingabemodus\n Zeit und Position temporär gespeichert.\n Bitte mit der Eingabe fortfahren');
set(handl.display_lastsight,'String',writeline,'BackgroundColor','yellow');
%stringname
%buttongrp




if ( (strcmp(buttongrp,'Species') == 1 || strcmp(buttongrp,'Number') == 1) && ~isfield(WHALE,'sighting') && ~isfield(WHALE,'sightingpos'))
    WHALE.sightingtime=datestr(WHALETIME,31);
    if ~isfield(WHALE,'sightingpctime'),
        WHALE.sightingpctime=datestr(now,31);
    end
    if isfield(GPS,'position')
        WHALE.sightingpos=GPS.position;
    else
        WHALE.sightingpos=NaN;
    end
    WHALE.shiptime=datestr(SHIPTIME,31);
    
end;
%debugging!!
%WHALE

if strcmp(buttongrp,'Species')==1 || strcmp(buttongrp,'All_Species')==1
    if findstr(stringname,'other:')==1
        stringname=regexprep(stringname, 'other:','');
    end
    if exist('commonname','var') && ~isempty(dir(sprintf('images/%s*.jpg',commonname)))
        
        set(handl.push_next_image,'Visible','off');
        set(handl.push_prev_image,'Visible','off');
        currentimage=imread(sprintf('images/%s.jpg',commonname));
        currentimage=currentimage(:,:,1:3);
            imfil=fspecial('gaussian');
            currentimage=imfilter(currentimage,imfil);
        if DAYTIME==0
            currentimage=walog_InvertIm(currentimage);
        end
        walog_image_display(walog_InvertIm(walog_InvertIm(currentimage)));
    else
        currentimage=imread(sprintf('images/noimage.jpg'));
        currentimage=currentimage(:,:,1:3);
        if DAYTIME==0
            currentimage=walog_InvertIm(currentimage);
        end
        walog_image_display(currentimage)
    end
   end



%fields(WHALE)
if (isfield(WHALE,'Species') && isfield(WHALE,'Certainity') && isfield(WHALE,'Number') && isfield(WHALE,'Direction')  && ~isempty(WHALE.Species) && ~isempty(WHALE.Direction) && ~isempty(WHALE.Certainity) && ~isempty(WHALE.Number))
    set(handl.save_button_1,'Enable','on');
    %set(handl.save_button_1,'BackgroundColor',[0 1 0.3]);
end;
set(gcbo,'Value',1);
allbuttons=get(get(gcbo,'Parent'),'Children');
walog_set_button_color( [0.8 0.8 0.8], allbuttons );
%set(allbuttons,'BackgroundColor',[1 1 1]);
set(gcbo,'BackgroundColor',[0.7 1 0]);
end


% Hint: get(hObjectet,'Value') returns toggle state of spec_button_2