% --- Executes on button press in spec_button_2.
function walog_record_Callback
global handl RECORD
%get(gcbo)
status=get(gcbo,'Value');
if status
    walog_record('listen');
    set(handl.rec_button,'BackgroundColor',[1 0 0]);
    set(handl.save_button_1,'Enable','on');
else
    walog_record('save');
    set(handl.rec_button,'BackgroundColor',[0.8 0.8 0.8]);
    set(handl.save_button_1,'Enable','off');
end
    



% Hint: get(hObjectet,'Value') returns toggle state of spec_button_2