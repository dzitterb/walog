function walog_check_wache();
global handl WHALE
wacharray=get(handl.popup_wache,'String');
WHALE.wache=cell2mat(wacharray(get(handl.popup_wache,'Value'),:));