function [Tab_Fix,Tab_Var] = Export_XLS_Scan(Simulation_files,varargin)

% if IsConsistent(Simulation_files)
    Liste{1} = 'Parameters Accelerometer';
    Liste{2} = 'Parameters Gyroscope';
    Liste{3} = 'Parameters DVL';
    Liste{4} = 'Parameters DepthMeter';
    Liste{5} = 'Parameters GyroCompass';    
    Liste{6} = 'Initial Value';
    Liste{7} = 'Parameters IMU Noise PSD';
    Liste{8} = 'Parameters IMU Noise Variance';
    Liste{9} = 'Parameters Auxiliary Sensor Noise Variance';
    Liste{10}= 'Parameters UKF';
    Liste{11}= 'Parameters Complementary Filter';

    [index,v] = listdlg('PromptString','Select a file:','SelectionMode','multiple','ListString',Liste);

    Tab_Fix = [];
    Tab_Var = [];
    h        = waitbar(0,'Loading files ...');
    N        = length(index)*(length(Simulation_files)-1);
    compteur = 1;
    % First file
    load(Simulation_files{1},'Simulation');
    Tab      = [];
    Tab_temp = [];
    %%%
    if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
        if ~isempty(Simulation.Output.User_Def_Sim.INS_EKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result);  
        end
        if ~isempty(Simulation.Output.User_Def_Sim.INS_UKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result);  
        end 
        if ~isempty(Simulation.Output.User_Def_Sim.ESKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.ESKF.Scan_Result);  
        end
    end
    if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
        if ~isempty(Simulation.Output.PostProc_Real.INS_EKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_EKF.Scan_Result);  
        end
        if ~isempty(Simulation.Output.PostProc_Real.INS_UKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_UKF.Scan_Result);  
        end 
        if ~isempty(Simulation.Output.PostProc_Real.ESKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.ESKF.Scan_Result);  
        end        
    end
    %%%
    Tab_temp = TabResults;
    for I=1:length(index)
        Tab_temp_ = BuildTab(Simulation,index(I));
        Tab_temp_ = Tab_temp_(3:end,1:3)';
        for P=4:size(TabResults,1)
            Tab_temp_ = [Tab_temp_ ; Tab_temp_(end,:)];
        end
        Tab_temp  = [Tab_temp Tab_temp_];
    end
    Tab = Tab_temp;
    
    for J=2:length(Simulation_files)
        load(Simulation_files{J},'Simulation');
        Tab_temp = [];
        %%%
        if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
            if ~isempty(Simulation.Output.User_Def_Sim.INS_EKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result);
            end
            if ~isempty(Simulation.Output.User_Def_Sim.INS_UKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result);
            end    
            if ~isempty(Simulation.Output.User_Def_Sim.ESKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.ESKF.Scan_Result);
            end   
        end
        if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
            if ~isempty(Simulation.Output.PostProc_Real.INS_EKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_EKF.Scan_Result);
            end
            if ~isempty(Simulation.Output.PostProc_Real.INS_UKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_UKF.Scan_Result);
            end    
            if ~isempty(Simulation.Output.PostProc_Real.ESKF)
                TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.ESKF.Scan_Result);
            end            
        end
        %%%
        TabResults = TabResults(3:end,:);
        Tab_temp = TabResults;
        for I=1:length(index)
            Tab_temp_ = BuildTab(Simulation,index(I));            
            Tab_temp_ = Tab_temp_(3:end,3)';
            for P=2:size(TabResults,1)
                Tab_temp_ = [Tab_temp_ ; Tab_temp_(end,:)]; %#ok<AGROW>
            end
            Tab_temp  = [Tab_temp Tab_temp_];
            waitbar(compteur/(N-1),h);
            compteur = compteur+1;
        end
        Tab = [Tab ; Tab_temp];
    end
    delete(h)
    % on cherche les colonnes semblables
    [index_id,index_noid] = Traite(Tab);
    Tab_temp = [];
    %%%
    if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
        if ~isempty(Simulation.Output.User_Def_Sim.INS_EKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result);
        end
        if ~isempty(Simulation.Output.User_Def_Sim.INS_UKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result);
        end
        if ~isempty(Simulation.Output.User_Def_Sim.ESKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.User_Def_Sim.ESKF.Scan_Result);
        end  
    end
    if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
        if ~isempty(Simulation.Output.PostProc_Real.INS_EKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_EKF.Scan_Result);
        end
        if ~isempty(Simulation.Output.PostProc_Real.INS_UKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.INS_UKF.Scan_Result);
        end
        if ~isempty(Simulation.Output.PostProc_Real.ESKF)
            TabResults = NAVSIM_GenTab_EKF(Simulation.Output.PostProc_Real.ESKF.Scan_Result);
        end         
    end
    %%%
    Tab_temp = TabResults(1:3,:)';
    for I=1:length(index)
        Tab_temp_ = BuildTab(Simulation,index(I));
        Tab_temp  = ConcatenateTabV(Tab_temp,Tab_temp_);
    end
    Tab_Fix = Tab_temp(index_id,:);
    Tab_Var   = Tab(:,index_noid);

    % On supprime les lignes vides dans Tab_Var
    index = [];
    for I=1:size(Tab_Var,1)
        if IsTabCellLineEmpty(Tab_Var,I)
            index = [index I];
        end
    end
    Tab_Var = Tab_Var(setdiff(1:size(Tab_Var,1),index),:);
    if isempty(Tab_Var)
        Tab_Var = {[]};
    end
    if isempty(Tab_Fix)
        Tab_Fix = {[]};
    end

    if isempty(varargin)
        Excel = actxserver('Excel.Application');
        set(Excel, 'Visible', 1);

        % Insert a new workbook.
        Workbooks = Excel.Workbooks;
        Workbook  = invoke(Workbooks, 'Add');

        exlSheet_1  = Workbook.Sheets.Item(1);
        lastcell = [collabel(size(Tab_Var,2)) num2str(size(Tab_Var,1))];
        firstcell = ['A' '1'];
        ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
        % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
        set(ActivesheetRange, 'Value', Tab_Var);
        set(exlSheet_1,'Name','Scan Results');

        exlSheet_1  = Workbook.Sheets.Item(2);
        lastcell = [collabel(size(Tab_Fix,2)) num2str(size(Tab_Fix,1))];
        firstcell = ['A' '1'];
        ActivesheetRange = get(exlSheet_1,'Range',firstcell,lastcell);
        % R13 command: ActivesheetRange = Activesheet.Range(firstcell, lastcell);
        set(ActivesheetRange, 'Value', Tab_Fix);
        set(exlSheet_1,'Name','Unchanged Parameters');

    end
% end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [index_id,index_noid] = Traite(Tab_temp)
index_id   = [];
index_noid = [];
for I=1:size(Tab_temp,2)
    answer = true;
    val    = Tab_temp{3,I};
    k      = 4;
    while answer&&k<size(Tab_temp,1)+1
        if ~isequal(Tab_temp{k,I},val)
            answer = false;
        end
        k = k + 1;
    end
    if answer
        index_id = [index_id I];
    else
        index_noid = [index_noid I];
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function answer = IsConsistent(Simulation_files)
% 
% load(Simulation_files{1},'Simulation');
% temp = Simulation.Results.Profil.definition.name;
% answer = true;
% if ~isfield(Simulation.Results,'Modes')
%     answer = false;
% end
% 
% h        = waitbar(1,'Analysing files ...');
% N        = length(Simulation_files);
% compteur = 2;
% 
% 
% I = 2;
% while (I<length(Simulation_files)+1)&&answer
%     load(Simulation_files{I},'Simulation');
%     temp2 = Simulation.Results.Profil.definition.name;
%     if ~isequal(temp,temp2)
%         answer = false;
%     end
%     if ~isfield(Simulation.Results,'Modes')
%         answer = false;
%     end
%     waitbar(compteur/N,h);
%     compteur = compteur + 1;
%     I = I + 1;
% end
% close(h);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Tab,name] = BuildTab(Simulation,I)
name = [];
Tab  = [];
if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
    switch I
        case 1
            % Acceleration's Parameters
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_Accel')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_Accel.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_Accel);
            end
        case 2
            % Gyroscope's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_Gyro')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_Gyro.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_Gyro);
            end
        case 3
            % DVL's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_DVL')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_DVL.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_DVL);
            end 
        case 4
            % DepthMeter's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_DepthMeter')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_DepthMeter.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_DepthMeter);
            end
        case 5
            % GyroCompass's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_GyroCompass')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_GyroCompass.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_GyroCompass);
            end 
        case 6
            % Initial Value
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Init_Value')
                name = Simulation.Output.User_Def_Sim.Parameters.Init_Value.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Init_Value);
            end  
        case 7
            % IMU Noise PSD 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_IMUNoisePSD')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoisePSD.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoisePSD);
            end
        case 8
            % IMU Noise Variance
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_IMUNoiseVar')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoiseVar.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoiseVar);
            end 
        case 9
            % Auxiliary Sensor Noise Variance
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_AuxSnsrNoiseVar')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_AuxSnsrNoiseVar.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_AuxSnsrNoiseVar);
            end 
        case 10
            % UKF's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_UKF')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_UKF.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_UKF);
            end 
        case 11
            % Complemenatry Filter's Parameters 
            if isfield(Simulation.Output.User_Def_Sim.Parameters,'Parameters_CmplmntrFilter')
                name = Simulation.Output.User_Def_Sim.Parameters.Parameters_CmplmntrFilter.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.User_Def_Sim.Parameters.Parameters_CmplmntrFilter);
            end  
    end
end
if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
    switch I
        case 1
            % Acceleration's Parameters
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_Accel')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_Accel.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_Accel);
            end
        case 2
            % Gyroscope's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_Gyro')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_Gyro.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_Gyro);
            end
        case 3
            % DVL's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_DVL')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_DVL.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_DVL);
            end 
        case 4
            % DepthMeter's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_DepthMeter')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_DepthMeter.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_DepthMeter);
            end
        case 5
            % GyroCompass's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_GyroCompass')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_GyroCompass.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_GyroCompass);
            end 
        case 6
            % Initial Value
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Init_Value')
                name = Simulation.Output.PostProc_Real.Parameters.Init_Value.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Init_Value);
            end  
        case 7
            % IMU Noise PSD 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_IMUNoisePSD')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoisePSD.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoisePSD);
            end
        case 8
            % IMU Noise Variance
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_IMUNoiseVar')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoiseVar.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoiseVar);
            end 
        case 9
            % Auxiliary Sensor Noise Variance
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_AuxSnsrNoiseVar')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_AuxSnsrNoiseVar.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_AuxSnsrNoiseVar);
            end 
        case 10
            % UKF's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_UKF')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_UKF.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_UKF);
            end 
        case 11
            % Complemenatry Filter's Parameters 
            if isfield(Simulation.Output.PostProc_Real.Parameters,'Parameters_CmplmntrFilter')
                name = Simulation.Output.PostProc_Real.Parameters.Parameters_CmplmntrFilter.name;
                Tab  = NAVSIM_GenTab_Param(Simulation.Output.PostProc_Real.Parameters.Parameters_CmplmntrFilter);
            end  
    end    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Tab = ConcatenateTabV(Tab1,Tab2)


nb_col_tab           = size(Tab1,2);
nb_col_tab_temp      = size(Tab2,2);
if nb_col_tab==nb_col_tab_temp
    Tab = [Tab1 ; Tab2];
elseif nb_col_tab>nb_col_tab_temp
    Tab = [Tab1 ; [Tab2 cell(size(Tab2,1),size(Tab1,2)-size(Tab2,2))]];
else
    Tab = [[Tab1 cell(size(Tab1,1),size(Tab2,2)-size(Tab1,2))] ; Tab2];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function answer = IsTabCellLineEmpty(Tab,I)

answer = true;

J = 1;
while answer&&(J<size(Tab,2)+1)
    if ~isempty(Tab{I,J})
        answer = false;
    end
    J = J + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%