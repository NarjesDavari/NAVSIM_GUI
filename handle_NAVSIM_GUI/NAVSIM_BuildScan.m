function varargout = NAVSIM_BuildScan(varargin)
% NAVSIM_BUILDSCAN M-file for NAVSIM_BuildScan.fig
%      NAVSIM_BUILDSCAN, by itself, creates a new NAVSIM_BUILDSCAN or raises the existing
%      singleton*.
%
%      H = NAVSIM_BUILDSCAN returns the handle to a new NAVSIM_BUILDSCAN or the handle to
%      the existing singleton*.
%
%      NAVSIM_BUILDSCAN('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAVSIM_BUILDSCAN.M with the given input arguments.
%
%      NAVSIM_BUILDSCAN('Property','Value',...) creates a new NAVSIM_BUILDSCAN or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Decart_Window_BuildScan_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NAVSIM_BuildScan_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NAVSIM_BuildScan

% Last Modified by GUIDE v2.5 03-Oct-2012 13:14:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NAVSIM_BuildScan_OpeningFcn, ...
                   'gui_OutputFcn',  @NAVSIM_BuildScan_OutputFcn, ...
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


% --- Executes just before NAVSIM_BuildScan is made visible.
function NAVSIM_BuildScan_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NAVSIM_BuildScan (see VARARGIN)

% Choose default command line output for NAVSIM_BuildScan
handles.Params = varargin{1};
if length(varargin)==1
    handles.choix     = [];
    handles.choixold  = [];    
else
    handles.choix     = varargin{2};
    handles.choixold  = varargin{2};    
end
Liste = {};
for I=1:size(handles.choixold,1)
    Liste{I} = [handles.Params{handles.choixold{I,1}}.name ' ' GetParamTitle(handles.Params{handles.choixold{I,1}},handles.choixold{I,2}) ' : ' handles.choixold{I,3}];    
end
set(handles.listbox_scans,'String',Liste);


Liste = cell(length(handles.Params),1);
for I=1:length(handles.Params)
    Liste{I} = handles.Params{I}.name;
end
set(handles.listbox_param,'String',Liste);
set(handles.listbox_param,'value',1);
set(handles.listbox_param,'TooltipString',handles.Params{1}.text);
I = get(handles.listbox_param,'Value');
set(handles.listbox_param,'value',I);
set(handles.listbox_param,'TooltipString',handles.Params{I}.text);
Liste = cell(length(handles.Params{I}.Param),1);
for J=1:length(handles.Params{I}.Param)
    Liste{J} = handles.Params{I}.Param(J).title;
end
set(handles.listbox_variables,'String',Liste);
set(handles.listbox_variables,'Value',1);
set(handles.edit_scan_values,'String',num2str(handles.Params{1}.Param(1).val));
handles.output = handles.choix;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NAVSIM_BuildScan wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NAVSIM_BuildScan_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
delete(handles.figure1);

% --- Executes on selection change in listbox_param.
function listbox_param_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_param contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_param
I = get(hObject,'Value');
set(handles.listbox_param,'value',I);
set(handles.listbox_param,'TooltipString',handles.Params{I}.text);
Liste = cell(length(handles.Params{I}.Param),1);
for J=1:length(handles.Params{I}.Param)
    Liste{J} = handles.Params{I}.Param(J).title;
end
set(handles.listbox_variables,'String',Liste);
set(handles.listbox_variables,'Value',1);
    set(handles.edit_scan_values,'String',num2str(handles.Params{I}.Param(1).val));
% Update handles structure
guidata(hObject, handles);

% --- Executes during object creation, after setting all properties.
function listbox_param_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox_variables.
function listbox_variables_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_variables contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_variables
I = get(handles.listbox_param,'Value');
set(handles.listbox_param,'value',I);
J = get(handles.listbox_variables,'Value');
set(handles.listbox_variables,'TooltipString',handles.Params{I}.Param(J).tooltipstring);
set(handles.edit_scan_values,'String',num2str(handles.Params{I}.Param(J).val));

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox_variables_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_variables (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_scan_values_Callback(hObject, eventdata, handles)
% hObject    handle to edit_scan_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_scan_values as text
%        str2double(get(hObject,'String')) returns contents of edit_scan_values as a double


% --- Executes during object creation, after setting all properties.
function edit_scan_values_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_scan_values (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_add.
function pushbutton_add_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_add (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I         = get(handles.listbox_param,'Value');
J         = get(handles.listbox_variables,'Value');
variation = ['[' get(handles.edit_scan_values,'String') ']'];
handles.choix  = [handles.choix ; {I handles.Params{I}.Param(J).tag variation}];
Liste = get(handles.listbox_scans,'String');
if iscell(Liste)
    Liste{end+1} = [handles.Params{I}.name ' ' handles.Params{I}.Param(J).title ' : ' variation];
    set(handles.listbox_scans,'String',Liste);
    set(handles.listbox_scans,'Value',length(Liste));
else
    Liste = [handles.Params{I}.name ' ' handles.Param{I}.Params(J).title ' : ' variation];
    set(handles.listbox_scans,'String',Liste);
    set(handles.listbox_scans,'Value',1);
end

set(handles.listbox_variables,'TooltipString',handles.Params{I}.Param(J).tooltipstring);
% Update handles structure
guidata(hObject, handles);


% --- Executes on selection change in listbox_scans.
function listbox_scans_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_scans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns listbox_scans contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_scans
I         = get(handles.listbox_param,'Value');
J         = get(handles.listbox_variables,'Value');

set(handles.listbox_variables,'TooltipString',handles.Params{I}.Param(J).tooltipstring);
% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function listbox_scans_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_scans (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_delete.
function pushbutton_delete_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_delete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
I = get(handles.listbox_scans,'value');
ListeOld = get(handles.listbox_scans,'String');
temp = handles.choix;
handles.choix = {};
Liste          = {};
K = 1;
for J=1:size(temp)
    if I~=J
        handles.choix = [handles.choix ; {temp{J,1} temp{J,2} temp{J,3}}];
        if iscell(ListeOld)
            Liste{K} = ListeOld{J};
        end
        K = K + 1;
    end
end
if isempty(handles.choix)
    set(handles.listbox_scans,'String',{});
    set(handles.listbox_scans,'Value',1);
else
    if length(handles.choix)>1
        set(handles.listbox_scans,'String',Liste);
    else
        set(handles.listbox_scans,'String',Liste{1});
    end
    set(handles.listbox_scans,'Value',1);
end
% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in pushbutton_OK.
function pushbutton_OK_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_OK (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
temp  = zeros(size(handles.choix,1),1);
temp2 = temp;
Tags = {'centerx' 'centery' 'angle_quadrant' 'angle_clivage' 'spot_diameter'};

for I=1:size(handles.choix)
    temp(I)  = handles.choix{I,1};
    temp2(I) = 0;    
    for J=1:length(Tags)
        if isequal(Tags{J},handles.choix{I,2})
            temp2(I) = 0;
        end
    end
end
[temp,index] = sort(temp*10+temp2);
temp = handles.choix;
for I=1:length(index)
    for J=1:size(temp,2)
        handles.choix{I,J} = temp{index(I),J};
    end
end

handles.output = handles.choix;
% Update handles structure
guidata(hObject, handles);

uiresume(handles.figure1);
% --- Executes on button press in pushbutton_cancel.
function pushbutton_cancel_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_cancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.choix = handles.choixold;
% Update handles structure
guidata(hObject, handles);

uiresume(handles.figure1);
