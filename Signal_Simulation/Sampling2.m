%Determination of the sampling frequency of the auxiliary sensors
function Simulation = Sampling2( Simulation , i )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N        = GetParam(Simulation.Init_Value ,'simulation_number');
    fs       = GetParam(Simulation.Init_Value ,'Sampling_Frequency');%Sampling frequency of the IMU
    fs_gps   = GetParam(Simulation.Parameters_GPS ,'gps_frequency');
    fs_dvl   = GetParam(Simulation.Parameters_DVL ,'dvl_frequency');
    fs_depth = GetParam(Simulation.Parameters_DepthMeter ,'depthmeter_frequency');
    fs_hdng  = GetParam(Simulation.Parameters_GyroCompass ,'gyrocompass_frequency');
    fs_incln = GetParam(Simulation.Parameters_GyroCompass ,'inclinometer_frequency');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    GPS1(:,1)=Simulation.Output.User_Def_Sim.Noise.GPS1.Lat(:,i);
    GPS1(:,2)=Simulation.Output.User_Def_Sim.Noise.GPS1.lon(:,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DVL signal with 100 Hz frequency
    DVL1(:,1) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vx(:,i);
    DVL1(:,2) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vy(:,i);
    DVL1(:,3) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vz(:,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Depth or altitude signal with 100 Hz frequency  
    Z1        = Simulation.Output.User_Def_Sim.Noise.Depthmeter1.Z(:,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Orientation signals with 100 Hz frequency 
    Roll1     = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NRoll(:,i);
    Pitch1    = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NPitch(:,i);
    Yaw1      = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NYaw(:,i);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Time1      = Simulation.Input.User_Def_Sim.Path.P_ned(:,4);
    IMU_length = length(Simulation.Input.User_Def_Sim.Path.P_ned);

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %GPS
    dt_gps=round((1/fs_gps)*100)./100;
    max_Time_gps=(IMU_length-1)/fs;
    Timei_gps=(0:dt_gps:max_Time_gps)';
    GPS2 = [];
    
    GPS2(:,1) =interp1(Time1,GPS1(:,1),Timei_gps,'linear');
    GPS2(:,2) =interp1(Time1,GPS1(:,2),Timei_gps,'linear');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DVL
    dt_dvl=round((1/fs_dvl)*100)./100;
    max_Time_dvl=(IMU_length-1)/fs;
    Timei_dvl=(0:dt_dvl:max_Time_dvl)';
    DVL2 = [];
    
    DVL2(:,1) =interp1(Time1,DVL1(:,1),Timei_dvl,'linear');
    DVL2(:,2) =interp1(Time1,DVL1(:,2),Timei_dvl,'linear');
    DVL2(:,3) =interp1(Time1,DVL1(:,3),Timei_dvl,'linear');        
        
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Depth
    dt_depth=round((1/fs_depth)*100)./100;
    max_Time_depth=(IMU_length-1)/fs;
    Timei_depth=(0:dt_depth:max_Time_depth)';
    Z2 = [];
    
    Z2(:,1) =interp1(Time1,Z1,Timei_depth,'linear');

  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Inclinometer
    dt_incln=round((1/fs_incln)*100)./100;
    max_Time_incln=(IMU_length-1)/fs;
    Timei_incln=(0:dt_incln:max_Time_incln)';
    Roll2 = [];
    Pitch2 = [];
    Roll2(:,1)  =interp1(Time1,Roll1,Timei_incln,'linear');
    Pitch2(:,1) =interp1(Time1,Pitch1,Timei_incln,'linear');
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Compass
    dt_hdng       =round((1/fs_hdng)*100)./100;
    max_Time_hdng =(IMU_length-1)/fs;
    Timei_hdng    =(0:dt_hdng:max_Time_hdng)';
    Yaw2 = [];
    
    Yaw2(:,1) =interp1(Time1,Yaw1,Timei_hdng,'linear');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Simulation.Input.Measurements.Ref_Pos        = zeros(IMU_length,4);
    Simulation.Input.Measurements.Ref_Pos(:,1)   = Simulation.Input.User_Def_Sim.Path.P_ned(:,4);
    Simulation.Input.Measurements.Ref_Pos(:,2:4) = Simulation.Input.User_Def_Sim.Path.P_ned(:,1:3);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %GPS signal with frequency defined by user
    if i==1
        Simulation.Input.Measurements.GPS = zeros(length(Timei_gps)-1,3,N);
    end
    Simulation.Input.Measurements.GPS(:,1,i) = Timei_gps(2:end);
    Simulation.Input.Measurements.GPS(:,2,i) = GPS2(2:end,1);
    Simulation.Input.Measurements.GPS(:,3,i) = GPS2(2:end,2);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %DVL signal with frequency defined by user
    if i==1
        Simulation.Input.Measurements.DVL = zeros(length(Timei_dvl)-1,4,N);
    end
    Simulation.Input.Measurements.DVL(:,1,i) = Timei_dvl(2:end);
    Simulation.Input.Measurements.DVL(:,2,i) = DVL2(2:end,1);
    Simulation.Input.Measurements.DVL(:,3,i) = DVL2(2:end,2);
    Simulation.Input.Measurements.DVL(:,4,i) = DVL2(2:end,3);  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Depth or altitude signal with frequency defined by user
    if i==1
        Simulation.Input.Measurements.Depth = zeros(length(Timei_depth)-1,2,N);
    end
    
    Simulation.Input.Measurements.Depth(:,1,i) = Timei_depth(2:end,1);
    Simulation.Input.Measurements.Depth(:,2,i) = Z2(2:end,1);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %tiit signals (roll and pitch) with frequency defined by user
    if i==1
        Simulation.Input.Measurements.RollPitch = zeros(length(Timei_incln)-1,3,N);
    end
    Simulation.Input.Measurements.RollPitch(:,1,i) = Timei_incln(2:end,1);
    Simulation.Input.Measurements.RollPitch(:,2,i) = Roll2(2:end,1)*180/pi;
    Simulation.Input.Measurements.RollPitch(:,3,i) = Pitch2(2:end,1)*180/pi;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     %Yaw (Heading) signal with frequency defined by user      
    if i==1
        Simulation.Input.Measurements.Heading = zeros(length(Timei_hdng)-1,2,N);
    end
    Simulation.Input.Measurements.Heading(:,1,i) = Timei_hdng(2:end,1);
    Simulation.Input.Measurements.Heading(:,2,i) = Yaw2(2:end,1)*180/pi;    
end
