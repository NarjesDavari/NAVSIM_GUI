function Export_XLS_ESKF(Simulation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
select_navsim_mode  = Simulation.Input.NAVSIM_Mode;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Liste{1} = 'Parameters sensors';

Liste{2} = 'System state in User-Defined Path Simulation'; 
Liste{3} = 'Designed Path'; 
Liste{4} = 'Error Reports in User-Defined Path Simulation';

Liste{5} = 'System state in Processing of Real Measurments';
Liste{6} = 'Error Reports in Processing of Real Measurments';
Liste{7} = 'Simulated signals';
Liste{8} = 'Measured signals';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch select_navsim_mode
    case 'User Defined Path Simulation'
        Simulation.Input.PostProc_Real=[];
        Simulation.Output.PostProc_Real=[];        
    case 'Processing of Real Measurments'
        Simulation.Input.User_Def_Sim=[];
        Simulation.Output.User_Def_Sim=[];        
end

index    = 0*(1:length(Liste));
for I=1:length(index)
    switch I
        case 1
            %Parameters sensors
            if isfield(Simulation,'Parameters_Accel') && isfield(Simulation,'Parameters_Gyro') ...
                       && isfield(Simulation,'Parameters_DVL') && isfield(Simulation,'Parameters_DepthMeter') ...
                       && isfield(Simulation,'Parameters_GyroCompass')
                index(I) = 1;
            end         
        case 2
            % System State User-Defined Path Simulation
            if isfield(Simulation.Output.User_Def_Sim,'ESKF')
                index(I) = 1;
            end
        case 3
            % Designed Path
            if isfield(Simulation.Input.User_Def_Sim,'Path')
                index(I) = 1;
            end      
        case 4
            %Error Reports in State User-Defined Path Simulation
            if isfield(Simulation.Output.User_Def_Sim,'ESKF')
                index(I) = 1;
            end    
        case 5
            %System state in Processing of Real Measurments
            if isfield(Simulation.Output.PostProc_Real,'ESKF')
                index(I) = 1;
            end
        case 6
            %Error Reports in Processing of Real Measurments
            if isfield(Simulation.Output.PostProc_Real,'ESKF')
                index(I) = 1;
            end  
        case 7
            %Simulated signals
            if isfield(Simulation.Output.User_Def_Sim,'Noise')
                index(I) = 1;
            end 
        case 8
            %Measured signals
            if isfield(Simulation.Input.PostProc_Real,'Measurements')
                index(I) = 1;
            end            
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indexdisp = find(index==1);
[index,v] = listdlg('PromptString','Select a file:','SelectionMode','multiple','ListString',Liste(indexdisp));
index     = indexdisp(index);

if v&&~isempty(index)

    % Activate Server Excel application.
    Excel = actxserver('Excel.Application');
    set(Excel, 'Visible', 1);

    % Insert a new workbook.
    Workbooks = Excel.Workbooks;
    Workbook  = invoke(Workbooks, 'Add');

    nbsheet = 1;
    [Tab,name] = BuildTab(Simulation,index(nbsheet));
    exlSheet_1  = Workbook.Sheets.Item(1);
    lastcell = [collabel(size(Tab,2)) num2str(size(Tab,1))];
    firstcell = ['A' '1'];
    ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
    % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
    set(ActivesheetRange, 'Value', Tab);
    set(exlSheet_1,'Name',name);

    if length(index)>1
        nbsheet = nbsheet+1;
        [Tab,name] = BuildTab(Simulation,index(nbsheet));
        exlSheet_1  = Workbook.Sheets.Item(2);
        lastcell = [collabel(size(Tab,2)) num2str(size(Tab,1))];
        firstcell = ['A' '1'];
        ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
        % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
        set(ActivesheetRange, 'Value', Tab);
        set(exlSheet_1,'Name',name);
        if length(index)>2
            nbsheet = nbsheet+1;
            [Tab,name] = BuildTab(Simulation,index(nbsheet));
            exlSheet_1  = Workbook.Sheets.Item(3);
            lastcell = [collabel(size(Tab,2)) num2str(size(Tab,1))];
            firstcell = ['A' '1'];
            ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
            % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
            set(ActivesheetRange, 'Value', Tab);
            set(exlSheet_1,'Name',name);
            for I=4:length(index)
                nbsheet = nbsheet+1;
                [Tab,name] = BuildTab(Simulation,index(nbsheet));
                exlSheet_1  = invoke(Excel.Sheets,'Add');
                lastcell = [collabel(size(Tab,2)) num2str(size(Tab,1))];
                firstcell = ['A' '1'];
                ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
                % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
                set(ActivesheetRange, 'Value', Tab);
                set(exlSheet_1,'Name',name);
            end
        end
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Tab,name] = BuildTab(Simulation,I)
name = [];
Tab  = [];
switch I
    case 1
        %Parameters sensors
        if isfield(Simulation,'Parameters_Accel') &&... 
           isfield(Simulation,'Parameters_Gyro')  &&...
           isfield(Simulation,'Parameters_DVL')   &&...
           isfield(Simulation,'Parameters_DepthMeter') && ...
           isfield(Simulation,'Parameters_GyroCompass')
       
           name = 'Parameters sensors';
           Tab  = NAVSIM_GenTab_ParamSensors(Simulation);
        end
    case 2
        % System State User-Defined Path Simulation
        if isfield(Simulation.Input.User_Def_Sim,'Path') &&...
           isfield(Simulation.Output.User_Def_Sim,'Noise') &&...     
           isfield(Simulation.Output.User_Def_Sim,'ESKF')
           
           name = 'System State'; 
           Tab  = NAVSIM_GenTab_SystemStateUDPS(Simulation,'ESKF');
        end  
    case 3
        % Designed Path
        if isfield(Simulation.Input.User_Def_Sim,'Path')
            name = 'Designed Path';
            Tab  = 	NAVSIM_GenTab_DesignedPath(Simulation.Input.User_Def_Sim.Path);
        end        
 
    case 4
        %Error Reports State User-Defined Path Simulation
        if isfield(Simulation.Output.User_Def_Sim,'ESKF')
            name = 'Error Reports';
            Tab  = NAVSIM_GenTab_ErrorUDPS(Simulation,'ESKF');
        end  
    case 5
        %System state in Processing of Real Measurments
        if isfield(Simulation.Input.PostProc_Real,'Measurements') &&...     
           isfield(Simulation.Output.PostProc_Real,'ESKF')
           
           name = 'System State'; 
           Tab  = NAVSIM_GenTab_SystemStatePRM(Simulation,'ESKF');
        end  
    case 6
        %Error Reports in Processing of Real Measurments
        if isfield(Simulation.Output.PostProc_Real,'ESKF')
            name = 'Error Reports';
            Tab  = NAVSIM_GenTab_ErrorPRM(Simulation,'ESKF');
        end  
    case 7
        % Simulated signals
        if isfield(Simulation.Output.User_Def_Sim,'Noise')           
           name = 'Simulated signals'; 
           Tab  = NAVSIM_GenTab_SimulatedSignals(Simulation);
        end  
    case 8
        % Measured signals
        if isfield(Simulation.Input.PostProc_Real,'Measurements')          
           name = 'Measured signals'; 
           Tab  = NAVSIM_GenTab_MeasuredSignals(Simulation);
        end         
end
