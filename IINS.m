%Integrated Navigation System using EKF and UKF
function [Simulation]=IINS(Simulation,handles_listbox_log,option,CalculType)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Simulation                = NAVSIM_Evaluate_Parameters(Simulation);

%number of runs(simulations) in virtual mode
N                      = GetParam(Simulation.Init_Value ,'simulation_number');
fs                     = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
InitPosdeg             = GetParam(Simulation.Init_Value ,'initial_geo_position');
InitPosm               = GetParam(Simulation.Init_Value ,'Initial_m_Position');
include_GPS            = GetParam(Simulation.Parameters_GPS ,'include_gps');
include_DataLose_GPS =  GetParam(Simulation.Parameters_GPS ,'include_DataLose of GPS');
include_depthmeter     = GetParam(Simulation.Parameters_DepthMeter ,'include_depthmeter');
include_dvl            = GetParam(Simulation.Parameters_DVL ,'include_dvl');
include_heading        = GetParam(Simulation.Parameters_GyroCompass ,'include_heading');
include_rollpitch      = GetParam(Simulation.Parameters_GyroCompass ,'include_roll&pitch');
include_accelrollpitch = GetParam(Simulation.Parameters_Inclenometer ,'include_accel_roll&pitch');
Include_R_adaptive= GetParam(Simulation.Parameters_AuxSnsrNoiseVar ,'Include R_adaptive');
Include_Q_adaptive= GetParam(Simulation.Parameters_IMUNoisePSD ,'Include Q_adaptive');
fc_f_RP                  = GetParam(Simulation.Parameters_Inclenometer ,'cutoff_frequency');
fc_f_accel               = GetParam(Simulation.Parameters_Accel ,'cutoff_frequency');
fc_f_gyro                = GetParam(Simulation.Parameters_Gyro ,'cutoff_frequency');
mu                     = GetParam(Simulation.Parameters_Inclenometer ,'detection_signal');
signal_simulation      = GetParam(Simulation.Init_Value ,'signal_simulation');
gg   =GetParam(Simulation.Init_Value ,'earth_gravity_constant');       
filtered_accel = GetParam(Simulation.Parameters_Accel ,'filter');
filtered_gyro  = GetParam(Simulation.Parameters_Gyro ,'filter'); 

Initialbiasg    = GetParam(Simulation.Init_Value ,'initial_bias_gyro');
Initialbiasa    = GetParam(Simulation.Init_Value ,'initial_bias_accel');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global frp;
global Accel_Count;
global Attitude_Valid;
global Roll_Sum;
global Pitch_Sum;
frp           = 1;
Accel_Count   = 0;
Attitude_Valid= 0;
Roll_Sum      = 0;
Pitch_Sum     = 0;
dt=1/fs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
global Cbn_det;
global calib_num ;
global GPS_calib_count ;
global depth_calib_count ;
global DVL_calib_count ;
global Hdng_calib_count ;
calib_num = 100 / 20;
GPS_calib_count = 0;
depth_calib_count = 0;
DVL_calib_count = 0;
Hdng_calib_count = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Misalignment_phins_DVL=[-2,0.5,-0.5];
Misalignment_IMU_phins=[0.0258,-0.3223,0];
C_imu_phins=InCBN(Misalignment_IMU_phins*pi/180);
C_phins_DVL=InCBN(Misalignment_phins_DVL*pi/180);
C_DVL_IMU=C_imu_phins*C_phins_DVL;
SF=[5 5 5];
ave_sample=3000;
calib_sample=6000;
Simulation.Output.ESKF.ave_sample=ave_sample;
Simulation.Output.ESKF.calib_sample=calib_sample;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% calculate the time of data loos
        if include_DataLose_GPS 
            Number_dataLose= GetParam(Simulation.Parameters_GPS ,'Number of Data Lose');
            time_outage  = GetParam(Simulation.Parameters_GPS ,'outage time');
            Start_Time_out  = GetParam(Simulation.Parameters_GPS ,'Time of outage start');
            [Simulation,t1,t2]=Data_Lose(Simulation,Number_dataLose,time_outage,Start_Time_out);
             Simulation.Output.ESKF.Pos_Error.GPS_Outage.t1=t1;
             Simulation.Output.ESKF.Pos_Error.GPS_Outage.t2=t2;
        end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%parameter of guass markov
%                tau_ax = 6e5; 
%                tau_ay = 7e5;
%                tau_az = 8e5;
%                tau_gx = 6e5;
%                tau_gy = 3.5e5;
%                tau_gz = 5e5; 
%                tau_ax = 3.6e5; 
%                tau_ay = 2.8e5;
%                tau_az = 5e5;
%                tau_gx = 1.5e6;
%                tau_gy = 3e5;
%                tau_gz = 8.5e5; 
 taux = GetParam(Simulation.Parameters_Accel ,'accel_correlation_time');
 tauy = GetParam(Simulation.Parameters_Gyro ,'gyro_correlation_time');             
tau=[taux tauy];%tau=[tau_ax,tau_ay,tau_az,tau_gx,tau_gy,tau_gz];
Simulation.Output.parameter_Bias_tauStation=tau;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

dt=1/fs;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~isempty(Simulation.Input)
    select_navsim_mode                       = Simulation.Input.NAVSIM_Mode;
    Simulation.Input.InitialParam.InitPosdeg = InitPosdeg;
else
    WriteInLogWindow('The User-Defined Path has not been loaded',handles_listbox_log);
    warndlg('The User-Defined Path has not been loaded','Warning','modal')     
end

% try
    if strcmp(Simulation.Input.NAVSIM_Mode,'User Defined Path Simulation')
        IOtest = true;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if signal_simulation
            select_func.Path_Design     = 1;
            select_func.extract_data    = 1;
            select_func.m2deg_input     = 1;
            select_func.Add_Erotation   = 1;
            select_func.CNB_Data        = 1;
            select_func.NoiseGeneration = 1;
            select_func.Sampling        = 1;
            select_func.kalman          = 1;
            select_func.PositionCalcul  = 1;    
            select_func.conversion      = 1;
            select_func.distance_cacul  = 1;
            select_func.Navigate_Error  = 1;  
            select_func.Navigate_Error_Datalose=1;
            h = waitbar(0,'Signal simulation is running...');
            WriteInLogWindow( 'Signal simulation is running... ',handles_listbox_log);            
        else
            select_func.Path_Design     = 0;
            select_func.extract_data    = 0;
            select_func.m2deg_input     = 0;
            select_func.Add_Erotation   = 0;
            select_func.CNB_Data        = 0;
            select_func.NoiseGeneration = 0;
            select_func.Sampling        = 1;
            select_func.kalman          = 1;
            select_func.PositionCalcul  = 1;
            select_func.conversion      = 1;
            select_func.distance_cacul  = 1;
            select_func.Navigate_Error  = 1;  
            select_func.Navigate_Error_Datalose=1;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                 
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&                
                if select_func.Path_Design==1 
                    J=1;
                    [Simulation]=Path_Design(Simulation , handles_listbox_log,ave_sample);
                    waitbar(J/7,h);
                end                
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if strcmp(CalculType,'DR')
                    Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned)-1;
                    Simulation.Output.DR.X_i=zeros(Dlength,3,N);
                end                
                if strcmp(CalculType,'FeedBack')
                    Dlength=length(Simulation.Input.User_Def_Sim.Path.P_ned);
                    Simulation.Output.ESKF.X_i=zeros(Dlength-ave_sample+1,3,N);
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.extract_data==1
                    J=2;
                    [Simulation]=extract_data3(Simulation , handles_listbox_log);
                    waitbar(J/7,h);
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.m2deg_input==1
                    J=3;
                    [ Simulation ] = m2deg_input( Simulation );
                    waitbar(J/7,h);
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.Add_Erotation==1
                    J=4;
                    [ Simulation ] =Add_Erotation( Simulation,select_navsim_mode );
                    waitbar(J/7,h);
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.CNB_Data==1
                    J=5;
                    [Simulation]=CNB_Data(Simulation);
                    waitbar(J/7,h);
                    delete(h)
                end               
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
    C_DVL_IMU = eye(3);
    end
    if strcmp(Simulation.Input.NAVSIM_Mode,'Processing of Real Measurments')
        IOtest = true;
        select_func.NoiseGeneration = 0;
        select_func.Sampling        = 0;    
        select_func.kalman          = 1;
        select_func.PositionCalcul  = 1;
        select_func.conversion      = 1;
        select_func.distance_cacul  = 1;
        select_func.Navigate_Error  = 1;  
        select_func.Navigate_Error_Datalose=1;
               %DVL's Pitch bias:0 deg
%         C_DVL_IMU                = [0.998719106724740,-0.046662874119792,0.019563283002053;...
%                                     0.046409666996533,0.998835228498588,0.013203375304973;...
%                                     -0.020156603687350,-0.012278537740850,0.999721435620312];
%         %DVL's Pitch bias:-3.9 deg                        
%         C_DVL_IMU                = [0.997630454398583,-0.048690647721799,-0.048607584602691;...
%                                     0.049225006706443,0.998739076540445,0.009856759401083;...
%                                     0.048066362159277,-0.012226112038251,0.998769316215312];
        %DVL's Pitch bias:-4 deg
%         C_DVL_IMU                = [0.997541609568174,-0.048742414639543,-0.050347931389912;...
%                                     0.049293954121070,0.998736520358432,0.009770823375788;...
%                                     0.049808064279254,-0.012228651497115,0.998683942403860];
%  C_DVL_IMU = eye(3);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
        if strcmp(CalculType,'EKF') || strcmp(CalculType,'UKF')

        end     
       %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
       %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
       if strcmp(CalculType,'DR')
           if ~isempty(Simulation.Input)
            for i=1:N
                if select_func.NoiseGeneration==1
                        [Simulation]=NoiseGeneration2(Simulation , i,tau);
                        [Simulation]=gauss_Markov(Simulation,i,tau);
                end   
                if select_func.Sampling==1
                        Simulation = Sampling2( Simulation , i );
                end                    
                WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
                h = waitbar(0,[CalculType ' computations is runing ... ,Simulation No. ' num2str(i)]);
                tic    
                [ Simulation ] = Initialization( Simulation , InitPosdeg , fs , CalculType);
                Dlength=length(Simulation.Input.Measurements.DVL(:,1));
                for I=2:Dlength 
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                    [ Simulation ] = DeadReckoning( Simulation , I , i , fs );                                              
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    if rem(I,1000)==0
                        waitbar(I/Dlength,h);
                    end
                end
                Simulation.Output.DR.X_i(:,:,i)=Simulation.Output.DR.X(:,1:3);
                delete(h)                    
            end                
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                a=toc;
                a_min=fix(a)/60;
                a_sec=(a_min-fix(a_min))*60;
                WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
                WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.conversion
                    [Simulation]=conversion(Simulation , CalculType);
                end         
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.distance_cacul
                    [ Simulation ] = distance_cacul( Simulation,1 );
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.Navigate_Error
                    [Simulation]=Navigate_Error(Simulation , CalculType,1);
                end
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.DR.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.DR.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in x direction : ' num2str(Simulation.Output.DR.Pos_Error.travelled_distancex) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in y direction : ' num2str(Simulation.Output.DR.Pos_Error.travelled_distancey) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in z direction : ' num2str(Simulation.Output.DR.Pos_Error.travelled_distancez) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.DR.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.DR.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);
                WriteInLogWindow(['RMSE in x direction : ' num2str(Simulation.Output.DR.Pos_Error.RMSEx_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['RMSE in y direction : ' num2str(Simulation.Output.DR.Pos_Error.RMSEy_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['RMSE in z direction : ' num2str(Simulation.Output.DR.Pos_Error.RMSEz_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE in x direction : '  num2str(Simulation.Output.DR.Pos_Error.Relative_RMSEx_ave) '%'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE in y direction : '  num2str(Simulation.Output.DR.Pos_Error.Relative_RMSEy_ave) '%'],handles_listbox_log);               
                WriteInLogWindow(['Relative RMSE in z direction : '  num2str(Simulation.Output.DR.Pos_Error.Relative_RMSEz_ave) '%'],handles_listbox_log);
                
                WriteInLogWindow(['Absolute error in end of path : ' num2str(Simulation.Output.DR.Pos_Error.ave_absolute_error_end) 'meters'],handles_listbox_log);
                WriteInLogWindow(['Relative error in end of path : '  num2str(Simulation.Output.DR.Pos_Error.ave_relative_error_end) '%'],handles_listbox_log);                
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
       if strcmp(CalculType,'FeedBack')
            if ~isempty(Simulation.Input)
                                  
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.kalman
                     [ Simulation ] = Qc_setting( Simulation );
% [Simulation,tau]= Qc_Diff_Bias(Simulation,1);
                    [ Simulation ] = R_setting( Simulation, gg );%%
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                tic
                for i=1:N
                    if select_func.NoiseGeneration==1
                        [Simulation]=NoiseGeneration2(Simulation , i,tau); 
                        [Simulation]=gauss_Markov(Simulation,i,tau);
                    end   
                    if select_func.Sampling==1
                        Simulation = Sampling2( Simulation , i );
                    end
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    %Dlength:length of data(time step) 
                    Dlength=length(Simulation.Input.Measurements.IMU);      
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    WriteInLogWindow([CalculType ' computations ... '],handles_listbox_log);
                    h = waitbar(0,[CalculType ' computations is runing ... ,Simulation No. ' num2str(i)]);
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    Number_adaptive=20;
                    Simulation.Output.Kalman_mtx.WindowSize_adaptive= Number_adaptive;
                    landa_P=1;
                    [ Simulation,flag_Qadapt ] = Initialization( Simulation,InitPosdeg,fs,CalculType,tau,dt,Include_Q_adaptive,ave_sample,Misalignment_IMU_phins);
                    Simulation.Output.Kalman_mtx.Number_adaptive= Number_adaptive;
                    Selection_Param1 ={include_GPS,include_depthmeter,include_dvl,include_heading,include_rollpitch,include_accelrollpitch ,mu };
                   
                    for I=ave_sample+1:Dlength 
                        IMU_Time   = num2str(Simulation.Input.Measurements.IMU(I,1,1));
                         if Simulation.Input.Measurements.GPS_Counter < length(Simulation.Input.Measurements.GPS)
                            GPS_Time   = num2str(Simulation.Input.Measurements.GPS(Simulation.Input.Measurements.GPS_Counter,1,1));
                        end
                        if Simulation.Input.Measurements.Depth_Counter < length(Simulation.Input.Measurements.Depth)
                            depth_Time = num2str(Simulation.Input.Measurements.Depth(Simulation.Input.Measurements.Depth_Counter,1,1));
                        end
                        if Simulation.Input.Measurements.DVL_Counter < length(Simulation.Input.Measurements.DVL)
                            DVL_Time   = num2str(Simulation.Input.Measurements.DVL(Simulation.Input.Measurements.DVL_Counter,1,1));
                        end
                        if Simulation.Input.Measurements.incln_Counter < length(Simulation.Input.Measurements.RollPitch)
                            incln_Time = num2str(Simulation.Input.Measurements.RollPitch(Simulation.Input.Measurements.incln_Counter,1,1));
                        end
                        if Simulation.Input.Measurements.hdng_Counter < length(Simulation.Input.Measurements.Heading)
                            hdng_Time  = num2str(Simulation.Input.Measurements.Heading(Simulation.Input.Measurements.hdng_Counter,1,1));
                        end                    
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
                         [Simulation]=SDINS(Simulation , i , I , dt , fc_f_RP , mu , fc_f_accel , fc_f_gyro , CalculType , include_dvl , IMU_Time , DVL_Time , C_DVL_IMU ...
                                            , gg ,  filtered_accel , filtered_gyro , Initialbiasg,tau, ave_sample); 
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%        
                        Sensors_Time = {IMU_Time , GPS_Time , depth_Time , DVL_Time ,incln_Time, hdng_Time}; 
                        Selection_Param =[Sensors_Time,Selection_Param1 ];
                                          
%                         [Simulation]=Correction_Param(Simulation,IMU_Time,GPS_Time,depth_Time,DVL_Time,incln_Time,hdng_Time,...
%                                                       include_GPS,include_depthmeter,include_dvl,include_heading,include_rollpitch,include_accelrollpitch,mu,I,i,C_DVL_IMU);
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        [Simulation,flag_Qadapt] = ESKF(Simulation,I,i,CalculType,Selection_Param,C_DVL_IMU,landa_P,Include_R_adaptive,Include_Q_adaptive,flag_Qadapt,Misalignment_IMU_phins,ave_sample,calib_sample,SF);
                        [Simulation] = State_Correction( Simulation , I, ave_sample )  ;                      
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        x = [Simulation.Output.INS.X_INS(I-ave_sample,1:3),Simulation.Output.INS.X_INS(I-ave_sample,4:6),Simulation.Output.INS.fnn(I-ave_sample,:)]; 
                        C = Simulation.Output.INS.Cbn(:,:,I-ave_sample);
                        [Simulation,flag_Qadapt]=AQ_calcul(x,C,Simulation,fs,I,gg,tau,dt,Include_Q_adaptive,flag_Qadapt,ave_sample); 

                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        
                         if I== calib_sample
% %                             [ Simulation ] = R_Moving( Simulation );
                             [  Simulation , include_GPS , include_depthmeter , include_dvl , include_heading , include_accelrollpitch ] = Moving_Selection(Simulation);
%                           
                             Selection_Param1 = {include_GPS , include_depthmeter , include_dvl , include_heading ,include_rollpitch, include_accelrollpitch , mu };
%                    
                         end
                        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                        if rem(I-ave_sample+1,1000)==0
                            waitbar((I-ave_sample+1)/Dlength,h);
                        end                        
                    end
                     Simulation.Output.ESKF.X_i(:,:,i)=Simulation.Output.INS.X_INS(:,1:3);
               end
               
               delete(h)                    
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                a=toc;
                a_min=fix(a)/60;
                a_sec=(a_min-fix(a_min))*60;
                WriteInLogWindow([CalculType ' computations successfully terminated'],handles_listbox_log,1);
                WriteInLogWindow(['Elapsed time : ' num2str(fix(a_min)) 'min' num2str(a_sec) 'sec'],handles_listbox_log);                  
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.conversion
                    [Simulation]=conversion(Simulation , CalculType, ave_sample);
                end         
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.distance_cacul
                    [ Simulation ] = distance_cacul( Simulation, ave_sample );
                end
                %&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                if select_func.Navigate_Error
                    [Simulation]=Navigate_Error(Simulation , CalculType, ave_sample);
                end
                if select_func.Navigate_Error_Datalose && include_DataLose_GPS 
                   [ Simulation] = Navigate_Error_Datalose ( Simulation, ave_sample );
                end
                %%&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
                WriteInLogWindow(['Travelled time : ' num2str(Simulation.Output.ESKF.Pos_Error.travelled_time/60) 'min'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance : ' num2str(Simulation.Output.ESKF.Pos_Error.travelled_distance) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in x direction : ' num2str(Simulation.Output.ESKF.Pos_Error.travelled_distancex) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in y direction : ' num2str(Simulation.Output.ESKF.Pos_Error.travelled_distancey) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['Travelled distance in z direction : ' num2str(Simulation.Output.ESKF.Pos_Error.travelled_distancez) 'meters'],handles_listbox_log); 
                WriteInLogWindow(['RMSE : ' num2str(Simulation.Output.ESKF.Pos_Error.RMSE_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE: '  num2str(Simulation.Output.ESKF.Pos_Error.Relative_RMSE_ave) '%'],handles_listbox_log);
                WriteInLogWindow(['RMSE in x direction : ' num2str(Simulation.Output.ESKF.Pos_Error.RMSEx_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['RMSE in y direction : ' num2str(Simulation.Output.ESKF.Pos_Error.RMSEy_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['RMSE in z direction : ' num2str(Simulation.Output.ESKF.Pos_Error.RMSEz_ave) 'meters'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE in x direction : '  num2str(Simulation.Output.ESKF.Pos_Error.Relative_RMSEx_ave) '%'],handles_listbox_log);                
                WriteInLogWindow(['Relative RMSE in y direction : '  num2str(Simulation.Output.ESKF.Pos_Error.Relative_RMSEy_ave) '%'],handles_listbox_log);               
                WriteInLogWindow(['Relative RMSE in z direction : '  num2str(Simulation.Output.ESKF.Pos_Error.Relative_RMSEz_ave) '%'],handles_listbox_log);
                
                WriteInLogWindow(['Absolute error in end of path : ' num2str(Simulation.Output.ESKF.Pos_Error.ave_absolute_error_end) 'meters'],handles_listbox_log);
                WriteInLogWindow(['Relative error in end of path : '  num2str(Simulation.Output.ESKF.Pos_Error.ave_relative_error_end) '%'],handles_listbox_log);   
                
                if strcmp(select_navsim_mode,'User Defined Path Simulation')
                    WriteInLogWindow(['RMSE in Bias_ax : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Bax) 'm/s^2'],handles_listbox_log);
                    WriteInLogWindow(['RMSE in Bias_ay : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Bay) 'm/s^2'],handles_listbox_log);
                    WriteInLogWindow(['RMSE in Bias_az : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Baz) 'm/s^2'],handles_listbox_log);
                    WriteInLogWindow(['RMSE in Bias_gx : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Bgx) 'rad/s'],handles_listbox_log);
                    WriteInLogWindow(['RMSE in Bias_gy : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Bgy) 'rad/s'],handles_listbox_log);
                    WriteInLogWindow(['RMSE in Bias_gz : '  num2str(Simulation.Output.ESKF.Bias_Error.RMSE_Bgz) 'rad/s'],handles_listbox_log);
                end
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
    
       

% catch
%     WriteInLogWindow('User-Defined Path have not been loaded',handles_listbox_log); 
%     warndlg('User-Defined Path have not been loaded','Warning','modal')
% end
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        if strcmp(CalculType,'FeedForward')
        end




end
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   
