function varargout = NAVSIM(varargin)
% NAVSIM M-file for NAVSIM.fig
%      NAVSIM, by itself, creates a new NAVSIM or raises the existing
%      singleton*.
%
%      H = NAVSIM returns the handle to a new NAVSIM or the handle to
%      the existing singleton*.
%
%      NAVSIM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NAVSIM.M with the given input arguments.
%
%      NAVSIM('Property','Value',...) creates a new NAVSIM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NAVSIM_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NAVSIM_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NAVSIM

% Last Modified by GUIDE v2.5 22-Jul-2013 18:14:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NAVSIM_OpeningFcn, ...
                   'gui_OutputFcn',  @NAVSIM_OutputFcn, ...
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


% --- Executes just before NAVSIM is made visible.
function NAVSIM_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NAVSIM (see VARARGIN)

% Choose default command line output for NAVSIM

handles.Simulation.Parameters_Accel        = Parameters_Default_Accel();
handles.Simulation.Parameters_Gyro         = Parameters_Default_Gyro();
handles.Simulation.Parameters_GPS          = Parameters_Default_GPS();
handles.Simulation.Parameters_DVL          = Parameters_Default_DVL();
handles.Simulation.Parameters_DepthMeter   = Parameters_Default_DepthMeter();
handles.Simulation.Parameters_GyroCompass  = Parameters_Default_GyroCompass();
handles.Simulation.Parameters_Inclenometer = Parameters_Default_Inclenometer();
handles.Simulation.Init_Value             = Default_Initialization_Values();

handles.Simulation.Parameters_IMUNoisePSD     = Parameters_Default_IMUNoisePSD(handles.Simulation);
handles.Simulation.Parameters_AuxSnsrNoiseVar = Parameters_Default_AuxSnsrNoiseVar(handles.Simulation);
handles.Simulation.Parameters_UKF             = Parameters_Default_UKF();

handles.Simulation.New_Path        = NewPath();

handles.Simulation.SaveOptions     = OptionsDeSauvegardeParDefaut;

% handles.Simulation.Output.User_Def_Sim        = [];
handles.Simulation.Output.User_Def_Sim.Noise  = [];
handles.Simulation.Output                     = [];
handles.Simulation.Input                      = [];

%Scan
handles.TabScan                        = [];

handles.Simulation.Input.NAVSIM_Mode     = ' ';
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes NAVSIM wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = NAVSIM_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function menu_FIle_Callback(hObject, eventdata, handles)
% hObject    handle to menu_FIle (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_Load_PrePath_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Load_PrePath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.mat','MAT-files (*.mat)','Load Pre-Defined Path File');
    if  ~isequal(filename(1:4),'Path')
        WriteInLogWindow('Pre-Defined Path have not been loaded',handles.listbox_log); 
        warndlg('Pre-Defined Path have not been loaded','Warning','modal')
    else
        load(fullfile(pathname,filename));
        handles.Simulation.Input.User_Def_Sim.Path.Points = Path;
        WriteInLogWindow('Pre-Defined Path have been loaded',handles.listbox_log); 
        
        handles.Simulation.Input.NAVSIM_Mode='User Defined Path Simulation';
        % Update handles structure
        guidata(hObject, handles);        
    end
catch
    WriteInLogWindow('Pre-Defined Path have not been loaded',handles.listbox_log); 
    warndlg('Pre-Defined Path have not been loaded','Warning','modal')    
end
% --------------------------------------------------------------------
function Menu_NewPath_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_NewPath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Param{1} = handles.Simulation.New_Path;

Param = DynGUI_Parameters3(Param);

handles.Simulation.New_Path = Param{1};
handles.Simulation.Input.User_Def_Sim.Path.Points = GetParam_MultipleLines(handles.Simulation.New_Path ,'points');

if ~isempty(handles.Simulation.Input.User_Def_Sim.Path.Points)
    WriteInLogWindow('New Path has been imported',handles.listbox_log);
else
    WriteInLogWindow('New Path has not been imported',handles.listbox_log); 
end
handles.Simulation.Input.NAVSIM_Mode='User Defined Path Simulation';
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_LoadMeasure_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_LoadMeasure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.mat','MAT-files (*.mat)','Load Real Measurements File');
    if ~isequal(filename(1:4),'Real')
        WriteInLogWindow('Real Measurements file have not been loaded',handles.listbox_log); 
        warndlg('Real Measurements file have not been loaded','Warning','modal')
    else
        load(fullfile(pathname,filename));

        handles.Simulation.Input.Measurements.IMU       = Real_Measurement.IMU;
        handles.Simulation.Input.Measurements.RollPitch = Real_Measurement.RollPitch;
        handles.Simulation.Input.Measurements.Heading   = Real_Measurement.Heading;
        handles.Simulation.Input.Measurements.Ref_Pos   = Real_Measurement.Ref_Pos;
        handles.Simulation.Input.Measurements.DVL       = Real_Measurement.DVL;
        handles.Simulation.Input.Measurements.Depth     = Real_Measurement.Depth;
        handles.Simulation.Input.Measurements.GPS       = Real_Measurement.GPS;

        WriteInLogWindow('Real measurements have been loaded',handles.listbox_log); 

        handles.Simulation.Input.NAVSIM_Mode='Processing of Real Measurments';
        
        % Update handles structure
        guidata(hObject, handles);        
    end
catch
    WriteInLogWindow('Real Measurements file have not been loaded',handles.listbox_log); 
    warndlg('Real Measurements file have not been loaded','Warning','modal')    
end


% --------------------------------------------------------------------
function Menu_Load_IMU_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Load_IMU (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.mat','MAT-files (*.mat)','Load IMU File');
    if ~ischar(filename)
        WriteInLogWindow('IMU file have not been loaded',handles.listbox_log); 
        warndlg('IMU file have not been loaded','Warning','modal')
    else
        load(fullfile(pathname,filename));
        handles.Simulation.Parameters_Accel           = Simulation.Parameters_Accel;
        handles.Simulation.Parameters_Gyro            = Simulation.Parameters_Gyro;
        handles.Simulation.Parameters_IMUNoisePSD     = Parameters_Default_IMUNoisePSD(handles.Simulation);
        handles.Simulation.Parameters_AuxSnsrNoiseVar = Parameters_Default_AuxSnsrNoiseVar(handles.Simulation);        
        WriteInLogWindow([filename ' have been loaded'],handles.listbox_log); 
    end
catch
    WriteInLogWindow('IMU file have not been loaded',handles.listbox_log); 
    warndlg('IMU file have not been loaded','Warning','modal')    
end
% Update handles structure
 guidata(hObject, handles); 

% --------------------------------------------------------------------
function Menu_LoadSim_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_LoadSim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename, pathname] = uigetfile('*.mat','MAT-files (*.mat)','Load Simulation File');
    if ~ischar(filename)
        WriteInLogWindow('Simulation file have not been loaded',handles.listbox_log); 
        warndlg('Simulation file have not been loaded','Warning','modal')
    else
        load(fullfile(pathname,filename));
        handles.Simulation = Simulation;
        WriteInLogWindow([filename ' have been loaded'],handles.listbox_log); 
    end
catch
    WriteInLogWindow('Simulation file have not been loaded',handles.listbox_log); 
    warndlg('Simulation file have not been loaded','Warning','modal')    
end
% Update handles structure
 guidata(hObject, handles); 

 % --------------------------------------------------------------------
function SaveAs_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to SaveAs_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    [filename,pathname] = uiputfile('*.mat','MAT-files (*.mat)','Save Simulation File');
    if ~ischar(filename)
        %
        %
    else
        Simulation = ReduitSimulation(handles.Simulation);
        save(fullfile(pathname,filename),'Simulation');
        WriteInLogWindow([filename ' have been saved'],handles.listbox_log);
    end
catch
    WriteInLogWindow('Simulation file have not been saved',handles.listbox_log); 
    warndlg('Simulation file have not been saved','Warning','modal')    
end
% Update handles structure
 guidata(hObject, handles); 
% --------------------------------------------------------------------
function Menu_Empty_Buffer_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Empty_Buffer (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA) 
handles.Simulation.Output = [];
handles.Simulation.Input  = [];
% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Menu_Param_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Param (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_Sensors_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Sensors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Param{1} = handles.Simulation.Parameters_Accel;
Param{2} = handles.Simulation.Parameters_Gyro;
Param{3} = handles.Simulation.Parameters_GPS;
Param{4} = handles.Simulation.Parameters_DVL;
Param{5} = handles.Simulation.Parameters_DepthMeter;
Param{6} = handles.Simulation.Parameters_GyroCompass;
Param{7} = handles.Simulation.Parameters_Inclenometer;

[Param,sortie] = DynGUI_Parameters(Param);

handles.Simulation.Parameters_Accel       = Param{1};
handles.Simulation.Parameters_Gyro        = Param{2};
handles.Simulation.Parameters_GPS         = Param{3};
handles.Simulation.Parameters_DVL         = Param{4};
handles.Simulation.Parameters_DepthMeter  = Param{5};
handles.Simulation.Parameters_GyroCompass = Param{6};
handles.Simulation.Parameters_Inclenometer= Param{7};
if strcmp(handles.Simulation.Input.NAVSIM_Mode ,'User Defined Path Simulation')
    handles.Simulation.Parameters_IMUNoisePSD     = Parameters_Default_IMUNoisePSD(handles.Simulation);
    handles.Simulation.Parameters_AuxSnsrNoiseVar = Parameters_Default_AuxSnsrNoiseVar(handles.Simulation);
end

if strcmp(sortie,'OK')
    WriteInLogWindow('Sensors parameters modified',handles.listbox_log);
end
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_KlmnFltr_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_KlmnFltr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Param{1} = handles.Simulation.Parameters_IMUNoisePSD;
Param{2} = handles.Simulation.Parameters_AuxSnsrNoiseVar;
Param{3} = handles.Simulation.Parameters_UKF;

[Param,sortie] = DynGUI_Parameters(Param);

handles.Simulation.Parameters_IMUNoisePSD     = Param{1};
handles.Simulation.Parameters_AuxSnsrNoiseVar = Param{2};
handles.Simulation.Parameters_UKF             = Param{3};
if strcmp(sortie,'OK')
    WriteInLogWindow('Kalman Filter parameters modified',handles.listbox_log);
end
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_Setting_Scan_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Setting_Scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

I = 1;
Params{I} = handles.Simulation.Parameters_Accel;
I = I + 1;
Params{I} = handles.Simulation.Parameters_Gyro;
I = I + 1;
Params{I} = handles.Simulation.Parameters_GPS;
I = I + 1;
Params{I} = handles.Simulation.Parameters_DVL;
I = I + 1;
Params{I} = handles.Simulation.Parameters_DepthMeter;
I = I + 1;
Params{I} = handles.Simulation.Parameters_GyroCompass;
I = I + 1;
Params{I} = handles.Simulation.Parameters_Inclenometer;
I = I + 1;
Params{I} = handles.Simulation.Init_Value;
I = I + 1;
Params{I} = handles.Simulation.Parameters_IMUNoisePSD;
I = I + 1;
Params{I} = handles.Simulation.Parameters_AuxSnsrNoiseVar;
I = I + 1;
Params{I} = handles.Simulation.Parameters_UKF;
if isempty(handles.TabScan)
     handles.TabScan   = NAVSIM_BuildScan(Params);
else
     handles.TabScan   = NAVSIM_BuildScan(Params,handles.TabScan);
end

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_initvalue_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_initvalue (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
Param{1} = handles.Simulation.Init_Value;

[Param,sortie] = DynGUI_Parameters2(Param);

handles.Simulation.Init_Value      = Param{1};
if strcmp(sortie,'OK')
    WriteInLogWindow('Initial Values modified',handles.listbox_log);
end
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_Save_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
options = FenetreSaveOptions(handles.Simulation.SaveOptions);
handles.Simulation.SaveOptions = options;

if strcmp(handles.Simulation.SaveOptions.LogWindow,'OK')
    WriteInLogWindow('Save settings modified',handles.listbox_log);
end
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
%--------------------------------------------------------------------
function Menu_Cmptns_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Cmptns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function DR_Tag_Callback(hObject, eventdata, handles)
% hObject    handle to DR_Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Simulation.Output.ESKF       = [];
handles.Simulation.Output.Kalman_mtx = [];
handles.Simulation.Output.INS        = [];
handles.Simulation.Output.INS_EKF    = [];
handles.Simulation.Output.INS_UKF    = [];
handles.Simulation.Output.DR         = [];
handles.Simulation = IINS(handles.Simulation,handles.listbox_log,'ask','DR');

% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Menu_EKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_EKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Simulation.Output.ESKF       = [];
handles.Simulation.Output.Kalman_mtx = [];
handles.Simulation.Output.INS        = [];
handles.Simulation.Output.INS_EKF    = [];
handles.Simulation.Output.INS_UKF    = [];
handles.Simulation.Output.DR         = [];
handles.Simulation = IINS(handles.Simulation,handles.listbox_log,'ask','EKF');

% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Menu_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Simulation.Output.ESKF       = [];
handles.Simulation.Output.Kalman_mtx = [];
handles.Simulation.Output.INS        = [];
handles.Simulation.Output.INS_EKF    = [];
handles.Simulation.Output.INS_UKF    = [];
handles.Simulation.Output.DR         = [];
handles.Simulation = IINS(handles.Simulation,handles.listbox_log,'ask','UKF');

% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Menu_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_FeedForward_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_FeedForward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Simulation.Output.ESKF       = [];
handles.Simulation.Output.Kalman_mtx = [];
handles.Simulation.Output.INS        = [];
handles.Simulation.Output.INS_EKF    = [];
handles.Simulation.Output.INS_UKF    = [];
handles.Simulation.Output.DR         = [];
handles.Simulation = IINS(handles.Simulation,handles.listbox_log,'ask','FeedForward');

% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function Menu_FeedBack_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_FeedBack (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.Simulation.Output.ESKF       = [];
handles.Simulation.Output.Kalman_mtx = [];
handles.Simulation.Output.INS        = [];
handles.Simulation.Output.INS_EKF    = [];
handles.Simulation.Output.INS_UKF    = [];
handles.Simulation.Output.DR         = [];
handles.Simulation = IINS(handles.Simulation,handles.listbox_log,'ask','FeedBack');

% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function Menu_ScanKFParam_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_ScanKFParam (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function MenuScanKFParamEKF_Callback(hObject, eventdata, handles)
% hObject    handle to MenuScanKFParamEKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Simulation.Output.User_Def_Sim.Noise      = [];
handles.Simulation.Output.User_Def_Sim.INS_EKF    = [];
handles.Simulation.Output.User_Def_Sim.INS_UKF    = [];
handles.Simulation.Output.User_Def_Sim.ESKF       = [];
handles.Simulation.Output.User_Def_Sim.INS        = [];
handles.Simulation.Output.User_Def_Sim.Parameters = [];
handles.Simulation.Output.User_Def_Sim.Kalman_mtx = [];

handles.Simulation.Output.PostProc_Real.ESKF       = [];
handles.Simulation.Output.PostProc_Real.Kalman_mtx = [];
handles.Simulation.Output.PostProc_Real.INS        = [];
handles.Simulation.Output.PostProc_Real.INS_EKF    = [];
handles.Simulation.Output.PostProc_Real.INS_UKF    = [];
handles.Simulation = Scan_KF_Param(handles.TabScan,handles.Simulation,'EKF',handles.listbox_log);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function MenuScanKFParamUKF_Callback(hObject, eventdata, handles)
% hObject    handle to MenuScanKFParamUKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Simulation.Output.User_Def_Sim.Noise      = [];
handles.Simulation.Output.User_Def_Sim.INS_EKF    = [];
handles.Simulation.Output.User_Def_Sim.INS_UKF    = [];
handles.Simulation.Output.User_Def_Sim.ESKF       = [];
handles.Simulation.Output.User_Def_Sim.INS        = [];
handles.Simulation.Output.User_Def_Sim.Parameters = [];
handles.Simulation.Output.User_Def_Sim.Kalman_mtx = [];

handles.Simulation.Output.PostProc_Real.ESKF       = [];
handles.Simulation.Output.PostProc_Real.Kalman_mtx = [];
handles.Simulation.Output.PostProc_Real.INS        = [];
handles.Simulation.Output.PostProc_Real.INS_EKF    = [];
handles.Simulation.Output.PostProc_Real.INS_UKF    = [];
handles.Simulation = Scan_KF_Param(handles.TabScan,handles.Simulation,'UKF',handles.listbox_log);
% Update handles structure
guidata(hObject, handles);

% --------------------------------------------------------------------
function MenuScanKFParamFeedforward_Callback(hObject, eventdata, handles)
% hObject    handle to MenuScanKFParamFeedforward (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Simulation.Output.User_Def_Sim.Noise      = [];
handles.Simulation.Output.User_Def_Sim.INS_EKF    = [];
handles.Simulation.Output.User_Def_Sim.INS_UKF    = [];
handles.Simulation.Output.User_Def_Sim.ESKF       = [];
handles.Simulation.Output.User_Def_Sim.INS        = [];
handles.Simulation.Output.User_Def_Sim.Parameters = [];
handles.Simulation.Output.User_Def_Sim.Kalman_mtx = [];

handles.Simulation.Output.PostProc_Real.ESKF       = [];
handles.Simulation.Output.PostProc_Real.Kalman_mtx = [];
handles.Simulation.Output.PostProc_Real.INS        = [];
handles.Simulation.Output.PostProc_Real.INS_EKF    = [];
handles.Simulation.Output.PostProc_Real.INS_UKF    = [];
handles.Simulation = Scan_KF_Param(handles.TabScan,handles.Simulation,'FeedForward',handles.listbox_log);
% Update handles structure
guidata(hObject, handles);
% --------------------------------------------------------------------
function MenuScanKFParamFeedback_Callback(hObject, eventdata, handles)
% hObject    handle to MenuScanKFParamFeedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
handles.Simulation.Output.User_Def_Sim.Noise      = [];
handles.Simulation.Output.User_Def_Sim.INS_EKF    = [];
handles.Simulation.Output.User_Def_Sim.INS_UKF    = [];
handles.Simulation.Output.User_Def_Sim.ESKF       = [];
handles.Simulation.Output.User_Def_Sim.INS        = [];
handles.Simulation.Output.User_Def_Sim.Parameters = [];
handles.Simulation.Output.User_Def_Sim.Kalman_mtx = [];

handles.Simulation.Output.PostProc_Real.ESKF       = [];
handles.Simulation.Output.PostProc_Real.Kalman_mtx = [];
handles.Simulation.Output.PostProc_Real.INS        = [];
handles.Simulation.Output.PostProc_Real.INS_EKF    = [];
handles.Simulation.Output.PostProc_Real.INS_UKF    = [];
handles.Simulation = Scan_KF_Param(handles.TabScan,handles.Simulation,'FeedBack',handles.listbox_log);
% Update handles structure
guidata(hObject, handles);
%---------------------------------------------------------------------
function Menu_PostProcess_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_PostProcess (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_Plot_Input_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Plot_Input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
function Menu_Path_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Path (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------

if isfield(handles.Simulation.Input.User_Def_Sim,'Path')
    PlotPath(handles)
else
    WriteInLogWindow('No Points available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_Plot_EKFOutput_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Plot_EKFOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------
% --------------------------------------------------------------------
function Menu_Pos_m_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_m (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Pos_deg_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_deg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_AbsltErr_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AbsltErr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_RltvErr_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_RltvErr (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --------------------------------------------------------------------

function Menu_Plot_UKFOutput_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Plot_UKFOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Pos_m_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_m_DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'INS_UKF'))
    select_figure.meter_3D=1;
    select_figure.deg_3D=0;
    select_figure.relative_error=0;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'UKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_Pos_deg_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_deg_DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'INS_UKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=1;
    select_figure.relative_error=0;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'UKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_AbsltErr_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AbsltErr_DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'INS_UKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.relative_error=0;
    select_figure.absolute_error=1;
    plot_figure( handles.Simulation,select_figure,'UKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_RltvErr_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_RltvErr_DR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'INS_UKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.relative_error=1;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'UKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
% --------------------------------------------------------------------
function Menu_Plot_ESKFOutput_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Plot_ESKFOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Menu_Pos_m_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_m_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if(isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'ESKF'))
    select_figure.meter_3D=1;
    select_figure.deg_3D=0;
    select_figure.relative_error=0;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'ESKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_Pos_deg_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_deg_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'ESKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=1;
    select_figure.relative_error=0;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'ESKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
% --------------------------------------------------------------------
function Menu_AbsltErr_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AbsltErr_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'ESKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.relative_error=0;
    select_figure.absolute_error=1;
    plot_figure( handles.Simulation,select_figure,'ESKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
% --------------------------------------------------------------------
function Menu_RltvErr_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_RltvErr_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'ESKF'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.relative_error=1;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'ESKF');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
% --------------------------------------------------------------------
% --- Executes on selection change in listbox_log.
function listbox_log_Callback(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox_log contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox_log


% --- Executes during object creation, after setting all properties.
function listbox_log_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_clear_log.
function pushbutton_clear_log_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_clear_log (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox_log,'String','');
set(handles.listbox_log,'value',1);


% --------------------------------------------------------------------
function Menu_ExportXLS_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_ExportXLS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function Menu_XLS_EKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_XLS_EKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Output.User_Def_Sim,'INS_EKF') &&...
   isfield(handles.Simulation.Input.User_Def_Sim,'Path')) || ...
   (isfield(handles.Simulation.Output.PostProc_Real,'INS_EKF') &&...
   isfield(handles.Simulation.Input.PostProc_Real,'Measurements'))

    Export_XLS_EKF(handles.Simulation);
else
    WriteInLogWindow('No simulation available',handles.listbox_log);
    warndlg('No simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_XLS_UKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_XLS_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Output.User_Def_Sim,'INS_UKF') &&...
   isfield(handles.Simulation.Input.User_Def_Sim,'Path')) || ...
   (isfield(handles.Simulation.Output.PostProc_Real,'INS_UKF') &&...
   isfield(handles.Simulation.Input.PostProc_Real,'Measurements'))

    Export_XLS_UKF(handles.Simulation);
else
    WriteInLogWindow('No simulation available',handles.listbox_log);
    warndlg('No simulation available','Warning','modal')
end
% --------------------------------------------------------------------
function Menu_XLS_ESKF_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_XLS_ESKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Output.User_Def_Sim,'ESKF') &&...
   isfield(handles.Simulation.Input.User_Def_Sim,'Path')) || ...
   (isfield(handles.Simulation.Output.PostProc_Real,'ESKF') &&...
   isfield(handles.Simulation.Input.PostProc_Real,'Measurements'))

    Export_XLS_ESKF(handles.Simulation);
else
    WriteInLogWindow('No simulation available',handles.listbox_log);
    warndlg('No simulation available','Warning','modal')
end


% --------------------------------------------------------------------
function MenuExportXLSScan_Callback(hObject, eventdata, handles)
% hObject    handle to MenuExportXLSScan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
    {'*.mat','MAT-files (*.mat)'; ...
    '*.*',  'All Files (*.*)'}, ...
    'Select Simulation Files', ...
    'MultiSelect', 'on');
if iscell(filename)
    for I=1:length(filename)
        files{I} = fullfile(pathname,filename{I});
    end
    Export_XLS_Scan(files);
elseif ischar(filename)
    files{1} = fullfile(pathname,filename);
    Export_XLS_Scan(files);
end


% --------------------------------------------------------------------
function Plot_DR_Output_Tag_Callback(hObject, eventdata, handles)
% hObject    handle to Plot_DR_Output_Tag (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function Menu_Pos_m_DR_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_m_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if   (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'DR'))
    select_figure.meter_3D=1;
    select_figure.deg_3D=0;
    select_figure.relative_error=0;
    select_figure.absolute_error=0;
    plot_figure( handles.Simulation,select_figure,'DR');
else
    WriteInLogWindow('No Simulation available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end    

% --------------------------------------------------------------------
function Menu_Pos_deg_DR_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_Pos_deg_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'DR'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=1;
    select_figure.absolute_error=0;
    select_figure.relative_error=0;
    plot_figure( handles.Simulation,select_figure,'DR');
else
    WriteInLogWindow('No input and output Path available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end

% --------------------------------------------------------------------
function Menu_AbsltErr_DR_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_AbsltErr_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'DR'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.absolute_error=1;
    select_figure.relative_error=0;
    plot_figure( handles.Simulation,select_figure,'DR');
else
    WriteInLogWindow('No Results available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
% --------------------------------------------------------------------
function Menu_RltvErr_DR_Callback(hObject, eventdata, handles)
% hObject    handle to Menu_RltvErr_UKF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if (isfield(handles.Simulation.Input,'Measurements') &&...
    isfield(handles.Simulation.Output,'DR'))
    select_figure.meter_3D=0;
    select_figure.deg_3D=0;
    select_figure.absolute_error=0;
    select_figure.relative_error=1;
    plot_figure( handles.Simulation,select_figure,'DR');
else
    WriteInLogWindow('No Results available',handles.listbox_log);
    warndlg('No Simulation available','Warning','modal')
end
