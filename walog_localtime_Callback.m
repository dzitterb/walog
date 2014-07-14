% --- Executes on button press in spec_button_2.
function walog_localtime_Callback
global handl SHIPTIME WHALETIME
%get(gcbo)
persistent n
if (~exist('n','var') || isempty(n));n=0;end;
if strcmp(get(gcbo,'String'),'+');
    n=n+1;
else
    n=n-1;
end
walog_check_shiptime(n);
    



% Hint: get(hObjectet,'Value') returns toggle state of spec_button_2