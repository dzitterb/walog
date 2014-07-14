function varargout = walog_gui(varargin)
%WALOG_GUI M-file for walog_gui.fig
%      WALOG_GUI, by itself, creates a new WALOG_GUI or raises the existing
%      singleton*.
%
%      H = WALOG_GUI returns the handle to a new WALOG_GUI or the handle to
%      the existing singleton*.
%
%      WALOG_GUI('Property','Value',...) creates a new WALOG_GUI using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to walog_gui_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      WALOG_GUI('CALLBACK') and WALOG_GUI('CALLBACK',hObject,...) call the
%      local function named CALLBACK in WALOG_GUI.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help walog_gui

% Last Modified by GUIDE v2.5 23-May-2012 15:03:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @walog_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @walog_gui_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before walog_gui is made visible.
function walog_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for walog_gui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);
walog_aufruf(handles);



% UIWAIT makes walog_gui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = walog_gui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function display_shipname_Callback(hObject, eventdata, handles)
% hObject    handle to display_shipname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_shipname as text
%        str2double(get(hObject,'String')) returns contents of display_shipname as a double


% --- Executes during object creation, after setting all properties.
function display_shipname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_shipname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_zeit_Callback(hObject, eventdata, handles)
% hObject    handle to display_zeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_zeit as text
%        str2double(get(hObject,'String')) returns contents of display_zeit as a double


% --- Executes during object creation, after setting all properties.
function display_zeit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_zeit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_gps_Callback(hObject, eventdata, handles)
% hObject    handle to display_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_gps as text
%        str2double(get(hObject,'String')) returns contents of display_gps as a double


% --- Executes during object creation, after setting all properties.
function display_gps_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_gps (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_expedition_Callback(hObject, eventdata, handles)
% hObject    handle to display_expedition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_expedition as text
%        str2double(get(hObject,'String')) returns contents of display_expedition as a double


% --- Executes during object creation, after setting all properties.
function display_expedition_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_expedition (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function display_lastsight_Callback(hObject, eventdata, handles)
% hObject    handle to display_lastsight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_lastsight as text
%        str2double(get(hObject,'String')) returns contents of display_lastsight as a double


% --- Executes during object creation, after setting all properties.
function display_lastsight_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_lastsight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popup_wache.
function popup_wache_Callback(hObject, eventdata, handles)
% hObject    handle to popup_wache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns popup_wache contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popup_wache


% --- Executes during object creation, after setting all properties.
function popup_wache_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popup_wache (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in save_button_1.
function save_button_1_Callback(hObject, eventdata, handles)
% hObject    handle to save_button_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in save_button_2.
function save_button_2_Callback(hObject, eventdata, handles)
% hObject    handle to save_button_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit6 as text
%        str2double(get(hObject,'String')) returns contents of edit6 as a double


% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on display_edit_comments and none of its controls.
function display_edit_comments_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to display_edit_comments (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Options_Callback(hObject, eventdata, handles)
% hObject    handle to Options (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_Day_Callback(hObject, eventdata, handles)
% hObject    handle to View_Day (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_Night_Callback(hObject, eventdata, handles)
% hObject    handle to View_Night (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function properties_Callback(hObject, eventdata, handles)
% hObject    handle to properties (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function View_Callback(hObject, eventdata, handles)
% hObject    handle to View (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in dim_button.
function dim_button_Callback(hObject, eventdata, handles)
% hObject    handle to dim_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of dim_button


% --------------------------------------------------------------------
function browse_images_Callback(hObject, eventdata, handles)
% hObject    handle to browse_images (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rec_button.
function rec_button_Callback(hObject, eventdata, handles)
% hObject    handle to rec_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of rec_button



function display_localtime_Callback(hObject, eventdata, handles)
% hObject    handle to display_localtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of display_localtime as text
%        str2double(get(hObject,'String')) returns contents of display_localtime as a double


% --- Executes during object creation, after setting all properties.
function display_localtime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to display_localtime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in push_prev_image.
function push_prev_image_Callback(hObject, eventdata, handles)
% hObject    handle to push_prev_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in push_next_image.
function push_next_image_Callback(hObject, eventdata, handles)
% hObject    handle to push_next_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
global handl
handl.close=true;
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
%delete(hObject);


% --------------------------------------------------------------------
function North_Callback(hObject, eventdata, handles)
% hObject    handle to North (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function menu_hemi_Callback(hObject, eventdata, handles)
% hObject    handle to menu_hemi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
