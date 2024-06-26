function Simulation = Scan_KF_Param(tab_in,Simulation,CalculType,varargin)
if ~isempty(Simulation.Input.User_Def_Sim) || ~isempty(Simulation.Input.PostProc_Real)
    tab = EvaluateTabScan(tab_in);
    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    % On verifie qu'il n'y a pas déjà des fichiers portant ce nom
    list = dir([Simulation.SaveOptions.repertoire Simulation.SaveOptions.nom_simulation '*.mat']);
    if ~isempty(list)&&((length(varargin)<2)||(strcmp(varargin{2},'ask')))
        answer = questdlg('Simulation already exist. Do you want to replace them ?','Question','Yes','No','No');
        if isequal(answer,'Yes')
            for I=1:length(list)
                delete([Simulation.SaveOptions.repertoire list(I).name]);
            end
            Simulation = Calcul(Simulation,tab,CalculType,varargin{1});
        end
    else
        if length(varargin)==1
            Simulation = Calcul(Simulation,tab,CalculType,varargin{1});
        elseif length(varargin)==2
            Simulation = Calcul(Simulation,tab,CalculType,varargin{1},varargin{2});
        end
    end
% else
%     warndlg('Pre-Defined Path have not been loaded','Warning','modal')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Simulation = Calcul(Simulation,tab,CalculType,varargin)

    handles_listbox_log = varargin{1};

    if size(tab,1)>1
        I   = tab{1,1};
        tag = tab{1,2};
        var = eval(tab{1,3});
    
        for J=1:length(var)
            Simulation = ModifySimulation(Simulation,I,tag,var(J),handles_listbox_log);
            Simulation = Calcul(Simulation,tab(2:end,1:end),CalculType,varargin{1});
        end
    
    else
        I   = tab{1,1};
        tag = tab{1,2};
        var = eval(tab{1,3});
    
        for J=1:length(var)
            Simulation = ModifySimulation(Simulation,I,tag,var(J),handles_listbox_log);
%             try
                Simulation = IINS_Scan(Simulation,handles_listbox_log,'increment',CalculType);
%             end
        end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Simulation = ModifySimulation(Simulation,I,tag,value,handles_listbox_log)

    switch I
        case 1
            % Accelerometer's Parameters
            Simulation.Parameters_Accel = SetParam(Simulation.Parameters_Accel,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_Accel = Simulation.Parameters_Accel;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_Accel = Simulation.Parameters_Accel;
            end            
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_Accel,tag) ' = ' num2str(value)],handles_listbox_log);
           
         case 2
            % Gyroscope's Parameters
            Simulation.Parameters_Gyro = SetParam(Simulation.Parameters_Gyro,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_Gyro = Simulation.Parameters_Gyro;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_Gyro = Simulation.Parameters_Gyro;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_Gyro,tag) ' = ' num2str(value)],handles_listbox_log);            

         case 3
            % DVL's Parameters
            Simulation.Parameters_DVL = SetParam(Simulation.Parameters_DVL,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_DVL = Simulation.Parameters_DVL;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_DVL = Simulation.Parameters_DVL;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_DVL,tag) ' = ' num2str(value)],handles_listbox_log);   
            
         case 4
            % Depth/Alitude's Parameters
            Simulation.Parameters_DepthMeter = SetParam(Simulation.Parameters_DepthMeter,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_DepthMeter = Simulation.Parameters_DepthMeter;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_DepthMeter = Simulation.Parameters_DepthMeter;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_DepthMeter,tag) ' = ' num2str(value)],handles_listbox_log);    
            
         case 5
            % Gyrocompass's Parameters
            Simulation.Parameters_GyroCompass = SetParam(Simulation.Parameters_GyroCompass,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_GyroCompass = Simulation.Parameters_GyroCompass;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_GyroCompass = Simulation.Parameters_GyroCompass;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_GyroCompass,tag) ' = ' num2str(value)],handles_listbox_log);
            
         case 6
            % Initial Value
            Simulation.Init_Value = SetParam(Simulation.Init_Value,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Init_Value = Simulation.Init_Value;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Init_Value = Simulation.Init_Value;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Init_Value,tag) ' = ' num2str(value)],handles_listbox_log);            
        case 7
            % IMU Noise PSD
            Simulation.Parameters_IMUNoisePSD = SetParam(Simulation.Parameters_IMUNoisePSD,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoisePSD = Simulation.Parameters_IMUNoisePSD;
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoisePSD = Simulation.Parameters_IMUNoisePSD;
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_IMUNoisePSD,tag) ' = ' num2str(value)],handles_listbox_log);
        case 8
            % IMU Noise Variance
            Simulation.Parameters_IMUNoiseVar = SetParam(Simulation.Parameters_IMUNoiseVar,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_IMUNoiseVar = Simulation.Parameters_IMUNoiseVar;    
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_IMUNoiseVar = Simulation.Parameters_IMUNoiseVar;    
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_IMUNoiseVar,tag) ' = ' num2str(value)],handles_listbox_log);
        case 9
            % Auxiliary Sensor Noise Variance
            Simulation.Parameters_AuxSnsrNoiseVar = SetParam(Simulation.Parameters_AuxSnsrNoiseVar,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_AuxSnsrNoiseVar = Simulation.Parameters_AuxSnsrNoiseVar;   
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_AuxSnsrNoiseVar = Simulation.Parameters_AuxSnsrNoiseVar;   
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_AuxSnsrNoiseVar,tag) ' = ' num2str(value)],handles_listbox_log);
        case 10
            % Parameters UKF
            Simulation.Parameters_UKF = SetParam(Simulation.Parameters_UKF,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_UKF = Simulation.Parameters_UKF;  
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_UKF = Simulation.Parameters_UKF;  
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_UKF,tag) ' = ' num2str(value)],handles_listbox_log);
        case 11
            % Complemenatry Filter
            Simulation.Parameters_CmplmntrFilter = SetParam(Simulation.Parameters_CmplmntrFilter,tag,value);
            if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
                Simulation.Output.User_Def_Sim.Parameters.Parameters_CmplmntrFilter = Simulation.Parameters_CmplmntrFilter;  
            end
            if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
                Simulation.Output.PostProc_Real.Parameters.Parameters_CmplmntrFilter = Simulation.Parameters_CmplmntrFilter;  
            end
            WriteInLogWindow([GetParamTitle(Simulation.Parameters_Loss,tag) ' = ' num2str(value)],handles_listbox_log);

    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%