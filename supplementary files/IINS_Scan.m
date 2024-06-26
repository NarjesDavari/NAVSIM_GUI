%Integrated Navigation System using EKF and UKF
function [Simulation]=IINS_Scan(Simulation,handles_listbox_log,option,CalculType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Simulation          = NAVSIM_Evaluate_Parameters(Simulation);

select_navsim_mode  = Simulation.Input.NAVSIM_Mode;
fs                  = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
InitPosdeg          = GetParam(Simulation.Init_Value ,'initial_geo_position');
InitPosm            = GetParam(Simulation.Init_Value ,'Initial_m_Position');
include_depthmeter  = GetParam(Simulation.Parameters_DepthMeter ,'include_depthmeter');
include_dvl         = GetParam(Simulation.Parameters_DVL ,'include_dvl');
include_heading     = GetParam(Simulation.Parameters_GyroCompass ,'include_heading');
include_rollpitch   = GetParam(Simulation.Parameters_GyroCompass ,'include_roll&pitch');

K                   = GetParam(Simulation.Parameters_CmplmntrFilter ,'edit_K');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%            
% try
    if strcmp(select_navsim_mode,'User Defined Path Simulation')
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        if strcmp(CalculType,'EKF') || strcmp(CalculType,'UKF')
            if ~isempty(Simulation.Input.User_Def_Sim)
                IOtest = true;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 if isempty(Simulation.Output.User_Def_Sim.Noise)
                    [Simulation] = Signal_Simulation( Simulation , select_navsim_mode , handles_listbox_log );
%                 end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %length of Data
                Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(CalculType,'EKF')
                    Simulation.Output.User_Def_Sim.INS_EKF.X_i             = zeros(Dlength,3,1);
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.Tab = zeros(1,4);
                end
                if strcmp(CalculType,'UKF')
                    Simulation.Output.User_Def_Sim.INS_UKF.X_i             = zeros(Dlength,3,1);
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.Tab = zeros(1,4);
                end    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation]=Qc_setting(Simulation);
                [Simulation]=R_setting(Simulation);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                tic 
                [Simulation]=PositionCalcul(Simulation,CalculType,1,handles_listbox_log);
                if strcmp(CalculType,'EKF')
                    Simulation.Output.User_Def_Sim.INS_EKF.X_i(:,:,1)=Simulation.Output.User_Def_Sim.INS_EKF.X(:,1:3);
                end
                if strcmp(CalculType,'UKF')
                    Simulation.Output.User_Def_Sim.INS_UKF.X_i(:,:,1)=Simulation.Output.User_Def_Sim.INS_UKF.X(:,1:3);
                end    
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                a=toc;
                a_min=fix(a)/60;
                a_sec=(a_min-fix(a_min))*60;
                WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
                WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);        
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation] = conversion( Simulation , CalculType );                
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation] = distance_cacul( Simulation );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation] = Navigate_Error( Simulation , CalculType);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation] = m2deg_output( Simulation , CalculType );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if strcmp(CalculType,'EKF')
                    
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.Tab (1,1) = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.ave_relative_error_i(end);
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.Tab (1,2) = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.ave_absolute_error_i(end);
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.Tab (1,3) = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.RMSE_ave;
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.Tab (1,4) = Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.Relative_RMSE_ave;
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                    Simulation.Output.User_Def_Sim.INS_EKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                end
                if strcmp(CalculType,'UKF')

                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.Tab (1,1) = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.ave_relative_error_i(end);
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.Tab (1,2) = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.ave_absolute_error_i(end);
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.Tab (1,3) = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.RMSE_ave;
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.Tab (1,4) = Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.Relative_RMSE_ave;
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                    Simulation.Output.User_Def_Sim.INS_UKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                end                
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if strcmp(CalculType,'EKF')
                    WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                    WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                    WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                    WriteInLogWindow(['Relative RMSE : '  num2str(Simulation.Output.User_Def_Sim.INS_EKF.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);                
                end
                if strcmp(CalculType,'UKF')
                    WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                    WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                    WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                    WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.User_Def_Sim.INS_UKF.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);                
                end                
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                %%%%%%%%%       Saving the simulation result       %%%%%%%%                
                try
                    [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
                catch
                    IOtest = false;          
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if IOtest&&~isequal('nosave',option)
                    WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                    WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
                elseif ~isequal('nosave',option)
                    WriteInLogWindow('Saving aborted',handles_listbox_log);            
                end
                WriteInLogWindow('',handles_listbox_log); 
            else
                WriteInLogWindow('The User-Defined Path has not been loaded',handles_listbox_log);
                warndlg('The User-Defined Path has not been loaded','Warning','modal')
            end
        end
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        if strcmp(CalculType,'FeedBack')
            if ~isempty(Simulation.Input.User_Def_Sim)
                IOtest = true;
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if isempty(Simulation.Output.User_Def_Sim.Noise)
                    [Simulation] = Signal_Simulation( Simulation , select_navsim_mode , handles_listbox_log );
                end                
                tic
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Simulation.Output.User_Def_Sim.ESKF.X_i             = zeros(Dlength,3,1);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab = zeros(1,4);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [ Simulation ] = Qc_setting( Simulation );
                [ Simulation ] = R_setting( Simulation );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                tic                   
                WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
                h = waitbar(0,[CalculType ' computations is runing ... ']);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
                [ Simulation ] = Initialization( Simulation ,select_navsim_mode ,InitPosm , InitPosdeg , fs , CalculType);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                for I=2:Dlength
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [Simulation]=RH_calcul(Simulation,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch,I); 
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [Simulation]=SDINS(Simulation,1,I,select_navsim_mode,fs,InitPosdeg,include_heading,include_rollpitch , CalculType);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    Simulation=kalman_filter(Simulation , I , select_navsim_mode);                        
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if include_dvl || include_depthmeter || include_heading || include_rollpitch
                        [Simulation]=ESKF(Simulation,I,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter <= length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                            Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,1)=Simulation.Output.User_Def_Sim.INS.X_INS(I,3)-Simulation.Output.User_Def_Sim.ESKF.dX(I,1);
                            Simulation.Output.User_Def_Sim.INS.Posm(I,3)     = Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,1);
                        else
                            %
                        end
                    else
                        %
                    end
                    if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter <= length(Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                            Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,2:4)=Simulation.Output.User_Def_Sim.INS.X_INS(I,4:6)-Simulation.Output.User_Def_Sim.ESKF.dX(I,2:4);
                            Simulation.Output.User_Def_Sim.INS.X_INS(I,4:6) = Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,2:4);
                        else
                            %
                        end
                    else
                        %
                    end
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,5:7)=Simulation.Output.User_Def_Sim.INS.X_INS(I,7:9)-Simulation.Output.User_Def_Sim.ESKF.dX(I,5:7);%corrected height,Eulers angles and velocity
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if (include_heading && include_rollpitch)
                        Simulation.Output.User_Def_Sim.INS.Cbn_corrected(:,:,I) = InCBN([Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,7),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,6),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,5)],select_navsim_mode);%corrected transformation matrix  
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [Simulation]=Pos_calcul(Simulation,I,select_navsim_mode,fs,CalculType);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    x=[Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1:2),Simulation.Output.User_Def_Sim.INS.X_INS(I,3),Simulation.Output.User_Def_Sim.INS.X_INS(I,4:6),Simulation.Output.User_Def_Sim.INS.X_INS(I,10:12)]; 
                    C=Simulation.Output.User_Def_Sim.INS.Cbn_corrected(:,:,I);
                    [Simulation]=AQ_calcul(x,C,Simulation,select_navsim_mode,fs);   
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                    if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter < length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                            
                            Simulation.Input.User_Def_Sim.TempSig.Depth_Counter = Simulation.Input.User_Def_Sim.TempSig.Depth_Counter + 1;                    
                            Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter);
                            Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1);
    
                        end
                    end
                    if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter < length (Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                            
                            Simulation.Input.User_Def_Sim.TempSig.DVL_Counter = Simulation.Input.User_Def_Sim.TempSig.DVL_Counter + 1;
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1) = Simulation.Output.User_Def_Sim.Noise.DVL.Time(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter);
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1),...
                                                                                                                                Simulation.Output.User_Def_Sim.Noise.DVL.Vy(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1),...
                                                                                                                                Simulation.Output.User_Def_Sim.Noise.DVL.Vz(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1)];                    
                        end
                    end                
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                          
                    if rem(I,1000)==0
                        waitbar(I/Dlength,h);
                    end
                end
                Simulation.Output.User_Def_Sim.ESKF.X_i(:,:,1)=[Simulation.Output.User_Def_Sim.ESKF.P_rad(:,1:2),Simulation.Output.User_Def_Sim.ESKF.z_KF_Ave];
                delete(h)                    
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                a=toc;
                a_min=fix(a)/60;
                a_sec=(a_min-fix(a_min))*60;
                WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
                WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=conversion(Simulation , CalculType);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=distance_cacul( Simulation );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=Navigate_Error(Simulation , CalculType);
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=m2deg_output(Simulation , CalculType);                
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,1) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i(end);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,2) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i(end);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,3) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.RMSE_ave;
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,4) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.Relative_RMSE_ave;
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
                WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);                
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                
                %%%%%%%%%       Saving the simulation result       %%%%%%%%
                try
                    [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
                catch
                    IOtest = false;          
                end
                 %
                 if IOtest&&~isequal('nosave',option)
                    WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                    WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
                 elseif ~isequal('nosave',option)
                    WriteInLogWindow('Saving aborted',handles_listbox_log);            
                 end
                 WriteInLogWindow('',handles_listbox_log); 
                %%%%%%%%%                                          %%%%%%%%
            else  
                WriteInLogWindow('The User-Defined Path has not been loaded',handles_listbox_log);
                warndlg('The User-Defined Path has not been loaded','Warning','modal')                
            end
        end
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        if strcmp(CalculType,'FeedForward')
            if ~isempty(Simulation.Input.User_Def_Sim)
                IOtest = true;
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if isempty(Simulation.Output.User_Def_Sim.Noise)
                    [Simulation] = Signal_Simulation( Simulation , select_navsim_mode , handles_listbox_log );
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Simulation.Output.User_Def_Sim.ESKF.X_i             = zeros(Dlength,3,1);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab = zeros(1,4);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [ Simulation ] = Qc_setting( Simulation );
                [ Simulation ] = R_setting( Simulation );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                tic                    
                WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
                h = waitbar(0,[CalculType ' computations is runing ... ,' ]);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&    
                [ Simulation ] = Initialization( Simulation , select_navsim_mode , InitPosm , InitPosdeg , fs , CalculType); 
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                for I=2:Dlength
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                    
                    [Simulation]=RH_calcul(Simulation,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch,I); 
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    [Simulation]=SDINS(Simulation,1,I,select_navsim_mode,fs,InitPosdeg,include_heading,include_rollpitch,CalculType);
                    %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                    if include_dvl || include_depthmeter || include_heading || include_rollpitch
                        [Simulation]=ESKF(Simulation,I,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch);
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,1:7)=Simulation.Output.User_Def_Sim.INS.X_INS(I,3:9)-Simulation.Output.User_Def_Sim.ESKF.dX(I,1:7);%corrected height,Eulers angles and velocity
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if (include_heading && include_rollpitch)
                        Simulation.Output.User_Def_Sim.INS.Cbn_corrected(:,:,I) = InCBN([Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,7),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,6),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,5)],select_navsim_mode);%corrected transformation matrix  
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [Simulation]=Pos_calcul(Simulation,I,select_navsim_mode,fs,CalculType);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if include_depthmeter
                        [Simulation]=comp_filter(Simulation,I,select_navsim_mode,K );   
                        x=[Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1:2),Simulation.Output.User_Def_Sim.ESKF.z_c(I),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,2:4),Simulation.Output.User_Def_Sim.INS.X_INS(I,10:12)]; 
                    else
                        x=[Simulation.Output.User_Def_Sim.ESKF.P_rad(I,1:3),Simulation.Output.User_Def_Sim.ESKF.O_corrected(I,2:4),Simulation.Output.User_Def_Sim.INS.X_INS(I,10:12)]; 
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    C=Simulation.Output.User_Def_Sim.INS.Cbn_corrected(:,:,I);
                    [Simulation]=AQ_calcul(x,C,Simulation,select_navsim_mode,fs);   
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                    if Simulation.Input.User_Def_Sim.TempSig.Depth_Counter < length(Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1))
                        
                            Simulation.Input.User_Def_Sim.TempSig.Depth_Counter = Simulation.Input.User_Def_Sim.TempSig.Depth_Counter + 1;                    
                            Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter);
                            Simulation.Input.User_Def_Sim.TempSig.Depth(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,2) = Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(Simulation.Input.User_Def_Sim.TempSig.Depth_Counter,1);
                                
                        end
                    end
                    if Simulation.Input.User_Def_Sim.TempSig.DVL_Counter < length (Simulation.Output.User_Def_Sim.Noise.DVL.Vx)
                        if isequal(Simulation.Input.User_Def_Sim.Path.P_ned(I-1,4),Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1))
                        
                            Simulation.Input.User_Def_Sim.TempSig.DVL_Counter = Simulation.Input.User_Def_Sim.TempSig.DVL_Counter + 1;
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1) = Simulation.Output.User_Def_Sim.Noise.DVL.Time(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter);
                            Simulation.Input.User_Def_Sim.TempSig.DVL(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,2:4) = [Simulation.Output.User_Def_Sim.Noise.DVL.Vx(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1),...
                                                                                                                                Simulation.Output.User_Def_Sim.Noise.DVL.Vy(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1),...
                                                                                                                                Simulation.Output.User_Def_Sim.Noise.DVL.Vz(Simulation.Input.User_Def_Sim.TempSig.DVL_Counter,1)];                    
                        end
                    end                
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if rem(I,1000)==0
                        waitbar(I/Dlength,h);
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if include_depthmeter
                    Simulation.Output.User_Def_Sim.ESKF.X_i(:,:,1)=[Simulation.Output.User_Def_Sim.ESKF.P_rad(:,1:2),Simulation.Output.User_Def_Sim.ESKF.z_c];
                else
                    Simulation.Output.User_Def_Sim.ESKF.X_i(:,:,1)=Simulation.Output.User_Def_Sim.ESKF.P_rad(:,1:3);
                end
                delete(h)                    
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                a=toc;
                a_min=fix(a)/60;
                a_sec=(a_min-fix(a_min))*60;
                WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
                WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=conversion(Simulation , CalculType);
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=distance_cacul( Simulation );
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=Navigate_Error(Simulation , CalculType);
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                [Simulation]=m2deg_output(Simulation , CalculType);  
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,1) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_relative_error_i(end);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,2) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.ave_absolute_error_i(end);
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,3) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.RMSE_ave;
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.Tab (1,4) = Simulation.Output.User_Def_Sim.ESKF.Pos_Error.Relative_RMSE_ave;
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                Simulation.Output.User_Def_Sim.ESKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.User_Def_Sim.ESKF.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);                
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                
                %%%%%%%%%       Saving the simulation result       %%%%%%%%
                try
                    [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
                catch
                    IOtest = false;          
                end
                %
                if IOtest&&~isequal('nosave',option)
                    WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                    WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
                elseif ~isequal('nosave',option)
                    WriteInLogWindow('Saving aborted',handles_listbox_log);            
                end
                %%%%%%%%%                                          %%%%%%%%
            else  
                WriteInLogWindow('The User-Defined Path has not been loaded',handles_listbox_log);
                warndlg('The User-Defined Path has not been loaded','Warning','modal')                
            end
        end
    end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

if strcmp(select_navsim_mode,'Processing of Real Measurments')
    
    select_func.kalman         = 1;
    select_func.PositionCalcul = 1;
    select_func.conversion     = 1;
    select_func.distance_cacul = 1;
    select_func.Navigate_Error = 1;
    select_func.m2deg_output   = 1;
    select_func.m2deg_input    = 1;

    if strcmp(CalculType,'EKF') || strcmp(CalculType,'UKF')
        if ~isempty(Simulation.Input.PostProc_Real)
            IOtest = true;
            tic
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.kalman
                [Simulation]=Qc_setting(Simulation);
                [Simulation]=R_setting(Simulation);
%                 [Simulation]=KlmnIniMatx(Simulation);
            end
            % %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.PositionCalcul
                [Simulation]=PositionCalcul(Simulation,CalculType,1,handles_listbox_log);
            end        
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            a=toc;
            a_min=fix(a)/60;
            a_sec=(a_min-fix(a_min))*60;
            WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
            WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);    
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.conversion
                [Simulation]=conversion(Simulation  , CalculType);
            end    
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.distance_cacul
                [Simulation]=distance_cacul(Simulation);
            end                    
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.Navigate_Error
                [Simulation]=Navigate_Error(Simulation , CalculType);
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_output
                [ Simulation ] = m2deg_output( Simulation , CalculType );
            end        
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_input
                [ Simulation ] = m2deg_input( Simulation );
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
                if strcmp(CalculType,'EKF')
                    
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.Tab (1,1) = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.relative_error(end);
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.Tab (1,2) = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.absolute_error(end);
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.Tab (1,3) = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.RMSE;
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.Tab (1,4) = Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.Relative_RMSE;
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                    Simulation.Output.PostProc_Real.INS_EKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                end
                if strcmp(CalculType,'UKF')

                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.Tab (1,1) = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.relative_error(end);
                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.Tab (1,2) = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.absolute_error(end);
                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.Tab (1,3) = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.RMSE;
                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.Tab (1,4) = Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.Relative_RMSE;
                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
                    Simulation.Output.PostProc_Real.INS_UKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
                end            
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if strcmp(CalculType,'EKF')
                    WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                    WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                    WriteInLogWindow(['RMSE: ' num2str(Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.RMSE) 'meters'],handles_listbox_log);                
                    WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.PostProc_Real.INS_EKF.Pos_Error.Relative_RMSE) '%'],handles_listbox_log);                
                end
                if strcmp(CalculType,'UKF')
                    WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                    WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                    WriteInLogWindow(['RMSE: ' num2str(Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.RMSE) 'meters'],handles_listbox_log);                
                    WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.PostProc_Real.INS_UKF.Pos_Error.Relative_RMSE) '%'],handles_listbox_log);                
                end             
            % %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %%%%%%%%%       Saving the simulation result       %%%%%%%%            
            try
                [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
            catch
                IOtest = false;         
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if IOtest&&~isequal('nosave',option)
                WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
            elseif ~isequal('nosave',option)
                WriteInLogWindow('Saving aborted',handles_listbox_log);            
            end
            WriteInLogWindow('',handles_listbox_log); 
            %&&&&&&&&&&                                          &&&&&&&&&&            
        else
            WriteInLogWindow('Real measurements has not been loaded',handles_listbox_log);
            warndlg('Real measurements has not been loaded','Warning','modal')             
        end
    end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    if strcmp(CalculType,'FeedBack')
        if ~isempty(Simulation.Input.PostProc_Real)
            IOtest = true;
            tic
            %Dlength:length of data(time step) 
            Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab = zeros(1,4);
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %error states
            dX1=(zeros(1,7))';%column vector
            Simulation.Output.PostProc_Real.ESKF.dX=zeros(Dlength,size(dX1,1));
            Simulation.Output.PostProc_Real.ESKF.dX(1,:)=dX1';        
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %O_corrected:corrected ouyput(position,veloccity and euler angles)
            Simulation.Output.PostProc_Real.ESKF.O_corrected=zeros(Dlength,7);
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.kalman
                [ Simulation ] = Qc_setting( Simulation );
                [ Simulation ] = R_setting( Simulation );
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
            h = waitbar(0,[CalculType ' computations is running ... ']);  
            
            [ Simulation ] = Initialization( Simulation ,select_navsim_mode ,InitPosm , InitPosdeg , fs , CalculType);            
            for I=2:Dlength% Main loop of the system    
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
                [Simulation]=RH_calcul(Simulation,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch,I);                
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation]=SDINS(Simulation,1,I,select_navsim_mode,fs,InitPosdeg,include_heading,include_rollpitch,CalculType);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Simulation=kalman_filter(Simulation , I , select_navsim_mode);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation]=ESKF(Simulation,I,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch);  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Simulation.Input.PostProc_Real.TempSig.Depth_Counter <= length(Simulation.Input.PostProc_Real.Measurements.Depth)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))
                        Simulation.Output.PostProc_Real.ESKF.O_corrected(I,1)  = Simulation.Output.PostProc_Real.INS.X_INS(I,3)-Simulation.Output.PostProc_Real.ESKF.dX(I,1);%corrected height
                        Simulation.Output.PostProc_Real.INS.Posm(I,3) = Simulation.Output.PostProc_Real.ESKF.O_corrected(I,1);
                    end
                end
                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter <= length(Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1))
                        Simulation.Output.PostProc_Real.ESKF.O_corrected(I,2:4)  = Simulation.Output.PostProc_Real.INS.X_INS(I,4:6)-Simulation.Output.PostProc_Real.ESKF.dX(I,2:4);%corrected velocity
                        Simulation.Output.PostProc_Real.INS.X_INS(I,4:6) = Simulation.Output.PostProc_Real.ESKF.O_corrected(I,2:4);
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                Simulation.Output.PostProc_Real.ESKF.O_corrected(I,5:7)  = Simulation.Output.PostProc_Real.INS.X_INS(I,7:9)-Simulation.Output.PostProc_Real.ESKF.dX(I,5:7);%corrected Eulers angles
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
                Simulation.Output.PostProc_Real.INS.Cbn_corrected(:,:,I) = InCBN(Simulation.Output.PostProc_Real.ESKF.O_corrected(I,5:7),select_navsim_mode);%corrected transformation matrix  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation] = Pos_calcul(Simulation,I,select_navsim_mode,fs,CalculType);  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                x=[Simulation.Output.PostProc_Real.ESKF.P_rad(I,1:2),Simulation.Output.PostProc_Real.INS.X_INS(I,3),Simulation.Output.PostProc_Real.INS.X_INS(I,4:6),Simulation.Output.PostProc_Real.INS.X_INS(I,10:12)]; 
                C=Simulation.Output.PostProc_Real.INS.Cbn_corrected(:,:,I); 
                [Simulation]=AQ_calcul(x,C,Simulation,select_navsim_mode,fs);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Simulation.Input.PostProc_Real.TempSig.Depth_Counter < length(Simulation.Input.PostProc_Real.Measurements.Depth)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.Depth_Counter = Simulation.Input.PostProc_Real.TempSig.Depth_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:);
                        
                    end
                end
                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter < length (Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1)) 
                        
                        Simulation.Input.PostProc_Real.TempSig.DVL_Counter = Simulation.Input.PostProc_Real.TempSig.DVL_Counter + 1;
                        Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:) = Simulation.Input.PostProc_Real.Measurements.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:);
                        
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if rem(I,1000)==0
                    waitbar(I/Dlength,h);
                end                
            end
            delete(h)            
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            a=toc;
            a_min=fix(a)/60;
            a_sec=(a_min-fix(a_min))*60;
            WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
            WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
            if select_func.conversion
                [Simulation]=conversion(Simulation , CalculType ,include_depthmeter);
            end         
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.distance_cacul
                [ Simulation ] = distance_cacul( Simulation );
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.Navigate_Error
                [Simulation]=Navigate_Error(Simulation , CalculType);
            end
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_output
                [Simulation]=m2deg_output(Simulation , CalculType);
            end
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_input
                [Simulation]=m2deg_input(Simulation);
            end
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,1) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.relative_error(end);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,2) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.absolute_error(end);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,3) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.RMSE;
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,4) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.Relative_RMSE;
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&           
            WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
            WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
            WriteInLogWindow(['RMSE: ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.RMSE) 'meters'],handles_listbox_log);                
            WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.Relative_RMSE) '%'],handles_listbox_log);             
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&           
            %%%%%%%%%       Saving the simulation result       %%%%%%%%            
            try
                [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
            catch
                IOtest = false;          
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if IOtest&&~isequal('nosave',option)
                WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
            elseif ~isequal('nosave',option)
                WriteInLogWindow('Saving aborted',handles_listbox_log);            
            end
            WriteInLogWindow('',handles_listbox_log); 
            %&&&&&&&&&                                             &&&&&&&&             
        else
            WriteInLogWindow('Real measurements has not been loaded',handles_listbox_log);
            warndlg('Real measurements has not been loaded','Warning','modal')             
        end
    end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@    
    if strcmp(CalculType,'FeedForward')
        if ~isempty(Simulation.Input.PostProc_Real)
            IOtest = true;
            tic
            %Dlength:length of data(time step) 
            Dlength=length(Simulation.Input.PostProc_Real.Measurements.IMU);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab = zeros(1,4);
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %error states
            dX1=(zeros(1,7))';%column vector
            Simulation.Output.PostProc_Real.ESKF.dX=zeros(Dlength,size(dX1,1));
            Simulation.Output.PostProc_Real.ESKF.dX(1,:)=dX1';        
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %O_corrected:corrected ouyput(position,veloccity and euler angles)
            Simulation.Output.PostProc_Real.ESKF.O_corrected=zeros(Dlength,7);
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.kalman
                [ Simulation ] = Qc_setting( Simulation );
                [ Simulation ] = R_setting( Simulation );
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
            h = waitbar(0,[CalculType ' computations is running ... ']);  
            
            [ Simulation ] = Initialization( Simulation ,select_navsim_mode ,InitPosm , InitPosdeg , fs , CalculType);            
            for I=2:Dlength% Main loop of the system    
                   
                [Simulation]=RH_calcul(Simulation,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch,I);                
                [Simulation]=SDINS(Simulation,1,I,select_navsim_mode,fs,InitPosdeg,include_heading,include_rollpitch,CalculType);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation]=ESKF(Simulation,I,select_navsim_mode,include_depthmeter,include_dvl,include_heading,include_rollpitch);  
                Simulation.Output.PostProc_Real.ESKF.O_corrected(I,1:7)  = Simulation.Output.PostProc_Real.INS.X_INS(I,3:9)-Simulation.Output.PostProc_Real.ESKF.dX(I,1:7);%corrected height,Eulers angles and velocity              
                Simulation.Output.PostProc_Real.INS.Cbn_corrected(:,:,I) = InCBN(Simulation.Output.PostProc_Real.ESKF.O_corrected(I,5:7),select_navsim_mode);%corrected transformation matrix  
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [Simulation] = Pos_calcul(Simulation,I,select_navsim_mode,fs,CalculType);                    
                if include_depthmeter                    
                    [Simulation]=comp_filter(Simulation,I,select_navsim_mode,K );
                    x=[Simulation.Output.PostProc_Real.ESKF.P_rad(I,1:2),Simulation.Output.PostProc_Real.ESKF.z_c(I),Simulation.Output.PostProc_Real.ESKF.O_corrected(I,2:4),Simulation.Output.PostProc_Real.INS.X_INS(I,10:12)];                         
                else
                    x=[Simulation.Output.PostProc_Real.ESKF.P_rad(I,1:3),Simulation.Output.PostProc_Real.ESKF.O_corrected(I,2:4),Simulation.Output.PostProc_Real.INS.X_INS(I,10:12)]; 
                end
                C=Simulation.Output.PostProc_Real.INS.Cbn_corrected(:,:,I); 
                [Simulation]=AQ_calcul(x,C,Simulation,select_navsim_mode,fs);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if Simulation.Input.PostProc_Real.TempSig.Depth_Counter < length(Simulation.Input.PostProc_Real.Measurements.Depth)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,1))  
                        
                        Simulation.Input.PostProc_Real.TempSig.Depth_Counter = Simulation.Input.PostProc_Real.TempSig.Depth_Counter + 1;                    
                        Simulation.Input.PostProc_Real.TempSig.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:) = Simulation.Input.PostProc_Real.Measurements.Depth(Simulation.Input.PostProc_Real.TempSig.Depth_Counter,:);
                        
                    end
                end
                if Simulation.Input.PostProc_Real.TempSig.DVL_Counter < length (Simulation.Input.PostProc_Real.Measurements.DVL)
                    if isequal(Simulation.Input.PostProc_Real.Measurements.IMU(I-1,1),Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,1)) 
                        
                        Simulation.Input.PostProc_Real.TempSig.DVL_Counter = Simulation.Input.PostProc_Real.TempSig.DVL_Counter + 1;
                        Simulation.Input.PostProc_Real.TempSig.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:) = Simulation.Input.PostProc_Real.Measurements.DVL(Simulation.Input.PostProc_Real.TempSig.DVL_Counter,:);
                        
                    end
                end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if rem(I,1000)==0
                    waitbar(I/Dlength,h);
                end                
            end
            delete(h)            
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            a=toc;
            a_min=fix(a)/60;
            a_sec=(a_min-fix(a_min))*60;
            WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
            WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
            if select_func.conversion
                [Simulation]=conversion(Simulation , CalculType ,include_depthmeter);
            end         
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.distance_cacul
                [ Simulation ] = distance_cacul( Simulation );
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.Navigate_Error
                [Simulation]=Navigate_Error(Simulation , CalculType);
            end
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_output
                [Simulation]=m2deg_output(Simulation , CalculType);
            end
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if select_func.m2deg_input
                [Simulation]=m2deg_input(Simulation);
            end                        
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&  
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,1) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.relative_error(end);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,2) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.absolute_error(end);
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,3) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.RMSE;
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.Tab (1,4) = Simulation.Output.PostProc_Real.ESKF.Pos_Error.Relative_RMSE;
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.titles = {'Relative error' 'Absolute error' 'Average RMSE' 'Relative average RMSE'};
            Simulation.Output.PostProc_Real.ESKF.Scan_Result.units  = {'%' 'meter' 'meter' '%'};
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&            
            WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
            WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
            WriteInLogWindow(['RMSE: ' num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.RMSE) 'meters'],handles_listbox_log);                
            WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.PostProc_Real.ESKF.Pos_Error.Relative_RMSE) '%'],handles_listbox_log);             
            %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            %%%%%%%%%       Saving the simulation result       %%%%%%%%            
            try
                [nom,rep] = SaveSimulationMAT(Simulation,Simulation.SaveOptions,option);
            catch
                IOtest = false;         
            end
            %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
            if IOtest&&~isequal('nosave',option)
                WriteInLogWindow(['Resuls save in : ' nom '.mat'],handles_listbox_log);        
                WriteInLogWindow(['       under   : ' rep],handles_listbox_log);            
            elseif ~isequal('nosave',option)
                WriteInLogWindow('Saving aborted',handles_listbox_log);            
            end
            WriteInLogWindow('',handles_listbox_log); 
            %&&&&&&&&&                                             &&&&&&&&             
        else
            WriteInLogWindow('Real measurements has not been loaded',handles_listbox_log);
            warndlg('Real measurements has not been loaded','Warning','modal')             
        end
    end    
end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   
end