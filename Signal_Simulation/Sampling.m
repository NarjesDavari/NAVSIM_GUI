%Determination of the sampling frequency of the auxiliary sensors
function Simulation = Sampling( Simulation , i )

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    N        = GetParam(Simulation.Init_Value ,'simulation_number');
    fs       = GetParam(Simulation.Init_Value ,'Sampling_Frequency');%Sampling frequency of the IMU
    fs_dvl   = GetParam(Simulation.Parameters_DVL ,'dvl_frequency');
    fs_depth = GetParam(Simulation.Parameters_DepthMeter ,'depthmeter_frequency');
    fs_hdng  = GetParam(Simulation.Parameters_GyroCompass ,'gyrocompass_frequency');
    fs_incln = GetParam(Simulation.Parameters_GyroCompass ,'inclinometer_frequency');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %DVL signal with 100 Hz frequency
    DVL1(:,1) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vx;
    DVL1(:,2) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vy;
    DVL1(:,3) = Simulation.Output.User_Def_Sim.Noise.DVL1.Vz;
    %Depth or altitude signal with 100 Hz frequency  
    Z1        = Simulation.Output.User_Def_Sim.Noise.Depthmeter1.Z;
    %Orientation signals with 100 Hz frequency 

    Roll1     = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NRoll;
    Pitch1    = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NPitch;
    Yaw1      = Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NYaw;
    
    Time1      = Simulation.Input.User_Def_Sim.Path.P_ned(:,4);
    IMU_length = length(Simulation.Input.User_Def_Sim.Path.P_ned);
    Dlength    = length(Simulation.Input.User_Def_Sim.Path.P_ned(:,4));
    
    Smpl_dvl   = fix(fs/fs_dvl);
    Smpl_depth = fix(fs/fs_depth);
    Smpl_hdng  = fix(fs/fs_hdng);
    Smpl_incln = fix(fs/fs_incln);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~(Smpl_dvl==1)
        DVL2 = zeros(fix(IMU_length/Smpl_dvl),4);
        J=0;
        for I=1:Dlength
            if I*Smpl_dvl+1<=Dlength
                if I==1
                    J=J+1;
                    DVL2(J,1)   = Time1(1,1);
                    DVL2(J,2:4) = DVL1(1,:);
                else
                    J=J+1;
                    DVL2(J,1)   = Time1((I-1)*Smpl_dvl+1,1);
                    DVL2(J,2:4) = DVL1((I-1)*Smpl_dvl+1,:);                    
                end            
            end    
        end        
    else
        DVL2 = zeros(fix(IMU_length/Smpl_dvl),4);
        J=0;
        for I=1:Dlength
            if I*Smpl_dvl<=Dlength
                if I==1
                    J=J+1;
                    DVL2(J,1)   = Time1(1,1);
                    DVL2(J,2:4) = DVL1(1,:);
                else
                    J=J+1;
                    DVL2(J,1)   = Time1(I*Smpl_dvl,1);
                    DVL2(J,2:4) = DVL1(I*Smpl_dvl,:);                    
                end            
            end    
        end        
    end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~(Smpl_depth==1)
        Z2 = zeros(fix(IMU_length/Smpl_depth),2);
        J=0;
        for I=1:Dlength
            if I*Smpl_depth+1<=Dlength
                if I==1
                    J=J+1;
                    Z2(J,1)   = Time1(1);
                    Z2(J,2) = Z1(1);
                else
                    J=J+1;
                    Z2(J,1) = Time1((I-1)*Smpl_depth+1,1);
                    Z2(J,2) = Z1((I-1)*Smpl_depth+1,:);                    
                end                        
            end    
        end        
    else
        Z2 = zeros(fix(IMU_length/Smpl_depth),2);
        J=0;
        for I=1:Dlength
            if I*Smpl_depth<=Dlength
                if I==1
                    J=J+1;
                    Z2(J,1)   = Time1(1);
                    Z2(J,2) = Z1(1);
                else
                    J=J+1;
                    Z2(J,1) = Time1(I*Smpl_depth,1);
                    Z2(J,2) = Z1(I*Smpl_depth,:);                     
                end           
            end    
        end         
    end
  
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~(Smpl_incln==1)
        Roll2  = zeros(fix(IMU_length/Smpl_incln),2);
        Pitch2 = zeros(fix(IMU_length/Smpl_incln),1);
        J=0;
        for I=1:Dlength
            if I*Smpl_incln+1<=Dlength
                if I==1
                    J=J+1;
                    Roll2(J,1) = Time1(1,1);
                    Roll2(J,2) = Roll1(1,:);
                    Pitch2(J,1) = Pitch1(1,:);      
                else
                    J=J+1;
                    Roll2(J,1) = Time1((I-1)*Smpl_incln+1,1);
                    Roll2(J,2) = Roll1((I-1)*Smpl_incln+1,:);                  
                    Pitch2(J,1) = Pitch1((I-1)*Smpl_incln+1,:);                     
                end            
            end    
        end        
    else
        Roll2  = zeros(fix(IMU_length/Smpl_incln),2);
        Pitch2 = zeros(fix(IMU_length/Smpl_incln),1);
        J=0;
        for I=1:Dlength
            if I*Smpl_incln<=Dlength
                if I==1
                    J=J+1;
                    Roll2(J,1) = Time1(1,1);
                    Roll2(J,2) = Roll1(1,:);
                    Pitch2(J,1) = Pitch1(1,:);     
                else
                    J=J+1;
                    Roll2(J,1) = Time1(I*Smpl_incln,1);
                    Roll2(J,2) = Roll1(I*Smpl_incln,:);                  
                    Pitch2(J,1) = Pitch1(I*Smpl_incln,:);                     
                end            
            end    
        end        
    end
   
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~(Smpl_hdng==1)
        Yaw2 = zeros(fix(IMU_length/Smpl_hdng),2);
        J=0;
        for I=1:Dlength
            if I*Smpl_hdng+1<=Dlength
                if I==1
                    J=J+1;
                    Yaw2(J,1)   = Time1(1,1);
                    Yaw2(J,2:4) = Yaw1(1,:);
                else
                    J=J+1;
                    Yaw2(J,1) = Time1((I-1)*Smpl_hdng+1,1);
                    Yaw2(J,2) = Yaw1((I-1)*Smpl_hdng+1,:);                      
                end                      
            end    
        end         
    else
        Yaw2 = zeros(fix(IMU_length/Smpl_hdng),2);
        J=0;
        for I=1:Dlength
            if I*Smpl_hdng<=Dlength
                if I==1
                    J=J+1;
                    Yaw2(J,1)   = Time1(1,1);
                    Yaw2(J,2:4) = Yaw1(1,:);
                else
                    J=J+1;
                    Yaw2(J,1) = Time1(I*Smpl_hdng,1);
                    Yaw2(J,2) = Yaw1(I*Smpl_hdng,:);                     
                end                       
            end    
        end         
    end
 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    %DVL signal with frequency defined by user
    if i==1
        Simulation.Output.User_Def_Sim.Noise.DVL.Time = zeros(length(DVL2),1);
        Simulation.Output.User_Def_Sim.Noise.DVL.Vx   = zeros(length(DVL2),N);
        Simulation.Output.User_Def_Sim.Noise.DVL.Vy   = zeros(length(DVL2),N);
        Simulation.Output.User_Def_Sim.Noise.DVL.Vz   = zeros(length(DVL2),N);
    end
    Simulation.Output.User_Def_Sim.Noise.DVL.Time = DVL2(:,1);
    Simulation.Output.User_Def_Sim.Noise.DVL.Vx(:,i)   = DVL2(:,2);
    Simulation.Output.User_Def_Sim.Noise.DVL.Vy(:,i)   = DVL2(:,3);
    Simulation.Output.User_Def_Sim.Noise.DVL.Vz(:,i)   = DVL2(:,4);    
    %Depth or altitude signal with frequency defined by user
    if i==1
        Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time = zeros(length(Z2),1);
        Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z    = zeros(length(Z2),N);
    end
    Simulation.Output.User_Def_Sim.Noise.Depthmeter.Time = Z2(:,1);
    Simulation.Output.User_Def_Sim.Noise.Depthmeter.Z(:,i)    = Z2(:,2);
    %tiit signals (roll and pitch) with frequency defined by user
    if i==1
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time = zeros(length(Roll2),1);
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll      = zeros(length(Roll2),N);
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch     = zeros(length(Pitch2),N);
    end
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.incln_Time = Roll2(:,1);
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NRoll(:,i)      = Roll2(:,2);
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NPitch(:,i)     = Pitch2(:,1);
     %Yaw (Heading) signal with frequency defined by user      
    if i==1
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time   = zeros(length(Yaw2),1);
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw        = zeros(length(Yaw2),1);
    end
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.hdng_Time   = Yaw2(:,1);
    Simulation.Output.User_Def_Sim.Noise.Gyro_Compass.NYaw(:,i)   = Yaw2(:,2);    
end
