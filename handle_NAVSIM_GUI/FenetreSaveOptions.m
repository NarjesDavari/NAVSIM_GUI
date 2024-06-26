function varargout = FenetreSaveOptions(varargin)
% FENETRESAVEOPTIONS M-file for FenetreSaveOptions.fig
%      FENETRESAVEOPTIONS, by itself, creates a new FENETRESAVEOPTIONS or raises the existing
%      singleton*.
%
%      H = FENETRESAVEOPTIONS returns the handle to a new FENETRESAVEOPTIONS or the handle to
%      the existing singleton*.
%
%      FENETRESAVEOPTIONS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FENETRESAVEOPTIONS.M with the given input arguments.
%
%      FENETRESAVEOPTIONS('Property','Value',...) creates a new FENETRESAVEOPTIONS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FenetreSaveOptions_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FenetreSaveOptions_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FenetreSaveOptions

% Last Modified by GUIDE v2.5 16-Aug-2012 18:46:17

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FenetreSaveOptions_OpeningFcn, ...
                   'gui_OutputFcn',  @FenetreSaveOptions_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
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


% --- Executes just before FenetreSaveOptions is made visible.
function FenetreSaveOptions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FenetreSaveOptions (see VARARGIN)

% Choose default command line output for FenetreSaveOptions
handles.output = hObject;
if isempty(varargin)
    handles.options = OptionsDeSauvegardeParDefaut;
else
    handles.options = varargin{1};
end
handles.optionsold = handles.options;

set(handles.edit_repertoire,'string',handles.options.repertoire);
set(handles.edit_nom_simulation,'string',handles.options.nom_simulation);

set(handles.popupmenu1,'string',handles.options.choix_signal);
set(handles.popupmenu1,'value',handles.options.choix_signal_value);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FenetreSaveOptions wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FenetreSaveOptions_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure

varargout{1} = handles.output;
varargout{1} = handles.options;
delete(handles.figure1);



function edit_repertoire_Callback(hObject, eventdata, handles)
% hObject    handle to edit_repertoire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_repertoire as text
%        str2double(get(hObject,'String')) returns contents of edit_repertoire as a double


% --- Executes during object creation, after setting all properties.
function edit_repertoire_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_repertoire (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_nom_simulation_Callback(hObject, eventdata, handles)
% hObject    handle to edit_nom_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_nom_simulation as text
%        str2double(get(hObject,'String')) returns contents of edit_nom_simulation as a double


% --- Executes during object creation, after setting all properties.
function edit_nom_simulation_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_nom_simulation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
handles.options.repertoire     = get(handles.edit_repertoire,'string');
if handles.options.repertoire(end)~='\'
    handles.options.repertoire = [handles.options.repertoire '\'];
end
handles.options.nom_simulation = get(handles.edit_nom_simulation,'string');

handles.options.choix_signal_value = get(handles.popupmenu1,'value');

handles.options.LogWindow       = 'OK';
% Update handles structure
guidata(hObject, handles);



% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
uiresume(handles.figure1);
handles.options = handles.optionsold;
handles.options.LogWindow       = 'Cancel';
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton_explorer.
function pushbutton_explorer_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_explorer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

rep = uigetdir;
if ~strcmp(rep,0)
    handles.options.repertoire = [rep '\'];
    set(handles.edit_repertoire,'string',[rep '\']);
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
