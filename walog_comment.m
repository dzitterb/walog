function walog_comment
global handl WHALE
if strcmp(get(handl.display_edit_comments,'String'),'comment')==1
    set(handl.display_edit_comments,'String','');
    %set(handl.display_edit_comments,'Enable','on');
%     a='comment';
%     k=0;
%     for i=get(handl.display_edit_comments,'String')
%         k=k+1;
%         if a(i)~=i
%             set(handl.display_edit_comments,'String',a(i));
%         end
%     end
        
end
set(handl.save_button_1,'Enable','on');
WHALE.comment=get(handl.display_edit_comments,'String');
WHALE.comment=strrep(WHALE.comment,',',';');