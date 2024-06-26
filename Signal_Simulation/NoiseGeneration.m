%Generation of noise sources
function [Simulation]=NoiseGeneration(Simulation,i)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %The number of simulations
    N                 = GetParam(Simulation.Init_Value ,'simulation_number');
    Init_Pos          = GetParam(Simulation.Init_Value ,'Initial_m_Position');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Constant Parameters of The Earth
R=6378137;%Radius of the earth    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    [ Simulation,GyroError,AccelError ] = Sigma_Calcul( Simulation , i );
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timestep=length(Simulation.Input.User_Def_Sim.DVL.Velocity);
        %Computation of of Gyro Errors        
    
        %%Modelling of fixed bias with a turn_on bias(in radian)
        biasx=GyroError.fixed_biasx_sigma * randn(1);
        biasy=GyroError.fixed_biasy_sigma * randn(1);
        biasz=GyroError.fixed_biasz_sigma * randn(1);
        
        %%Modelling of ARW with a Gaussian white noise sequence
        G_Nx=GyroError.ARW_sigmax*randn(timestep,1);
        G_Ny=GyroError.ARW_sigmay*randn(timestep,1);
        G_Nz=GyroError.ARW_sigmaz*randn(timestep,1);
    
        %Underlying white noise(UWN) sequence    
        G_UWN_sequencex=GyroError.gyro_BS_sigmax*randn(timestep,1);
        G_UWN_sequencey=GyroError.gyro_BS_sigmay*randn(timestep,1); 
        G_UWN_sequencez=GyroError.gyro_BS_sigmaz*randn(timestep,1);
    
        %Modelling of bias instability with a random walk sequence
        G_RW_sequencex=cumsum(G_UWN_sequencex);
        G_RW_sequencey=cumsum(G_UWN_sequencey);
        G_RW_sequencez=cumsum(G_UWN_sequencez);
    
        %Computation of total additive noise
        TotNoisex=G_Nx+G_RW_sequencex+biasx ;
        TotNoisey=G_Ny+G_RW_sequencey+biasy ;
        TotNoisez=G_Nz+G_RW_sequencez+biasz ;
    
        if i==1        
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz=zeros(timestep,N);        
        end
    
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wx(:,i)=(TotNoisex+(1+GyroError.sfe_x).*Simulation.Input.User_Def_Sim.IMUer.WWib_b(:,1));
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wy(:,i)=(TotNoisey+(1+GyroError.sfe_y).*Simulation.Input.User_Def_Sim.IMUer.WWib_b(:,2));
        Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.wz(:,i)=(TotNoisez+(1+GyroError.sfe_z).*Simulation.Input.User_Def_Sim.IMUer.WWib_b(:,3));    
    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Computation of of Accel Errors
    
        %%modelling of fixed bias with a turn_on bias
        biasx=AccelError.fixed_biasx_sigma * randn(1);
        biasy=AccelError.fixed_biasy_sigma * randn(1);
        biasz=AccelError.fixed_biasz_sigma * randn(1);
    
        %Modelling of VRW with a Gaussian white noise sequence
        A_Nx=AccelError.VRW_sigmax*randn(timestep,1);
        A_Ny=AccelError.VRW_sigmay*randn(timestep,1);
        A_Nz=AccelError.VRW_sigmaz*randn(timestep,1);
  
        %Underlying white noise(UWN) sequence        
        A_UWN_sequencex=AccelError.accel_BS_sigmax*randn(timestep,1);
        A_UWN_sequencey=AccelError.accel_BS_sigmay*randn(timestep,1);
        A_UWN_sequencez=AccelError.accel_BS_sigmaz*randn(timestep,1);
    
        %modelling of bias instability with a random walk sequence
        A_RW_sequencex=cumsum(A_UWN_sequencex);
        A_RW_sequencey=cumsum(A_UWN_sequencey);
        A_RW_sequencez=cumsum(A_UWN_sequencez);

        %Computation of total additive noise
        TotNoisex=A_Nx+A_RW_sequencex+biasx ;
        TotNoisey=A_Ny+A_RW_sequencey+biasy ;
        TotNoisez=A_Nz+A_RW_sequencez+biasz ;
    
        if i==1  
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az=zeros(timestep,N);
        end
    
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ax(:,i)=(TotNoisex+(1+AccelError.sfe_x).*Simulation.Input.User_Def_Sim.IMUer.ffb(:,1));
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.ay(:,i)=(TotNoisey+(1+AccelError.sfe_y).*Simulation.Input.User_Def_Sim.IMUer.ffb(:,2));
        Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.az(:,i)=(TotNoisez+(1+AccelError.sfe_z).*Simulation.Input.User_Def_Sim.IMUer.ffb(:,3));  
    
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Computation of DVL Errors
    
        DVL_bias_sigmax   = GetParam(Simulation.Parameters_DVL ,'bias_x');
        DVL_bias_sigmay   = GetParam(Simulation.Parameters_DVL ,'bias_y');
        DVL_bias_sigmaz   = GetParam(Simulation.Parameters_DVL ,'bias_z');
    
        DVL_rnoise_sigmax = GetParam(Simulation.Parameters_DVL ,'random_noise_x');
        DVL_rnoise_sigmay = GetParam(Simulation.Parameters_DVL ,'random_noise_y');
        DVL_rnoise_sigmaz = GetParam(Simulation.Parameters_DVL ,'random_noise_z');
    
        DVL_Sf_sigmax     = GetParam(Simulation.Parameters_DVL ,'sfe_x')/100;
        DVL_Sf_sigmay     = GetParam(Simulation.Parameters_DVL ,'sfe_y')/100;
        DVL_Sf_sigmaz     = GetParam(Simulation.Parameters_DVL ,'sfe_z')/100;

        %White noise
        DVL_Nx=DVL_rnoise_sigmax*randn(timestep,1);
        DVL_Ny=DVL_rnoise_sigmay*randn(timestep,1);
        DVL_Nz=DVL_rnoise_sigmaz*randn(timestep,1);

        %Fixed Bias
        DVL_biasx=DVL_bias_sigmax*randn(1);
        DVL_biasy=DVL_bias_sigmay*randn(1); 
        DVL_biasz=DVL_bias_sigmaz*randn(1);

        %Scale factor error
        DVL_Sfx=DVL_Sf_sigmax;
        DVL_Sfy=DVL_Sf_sigmay;
        DVL_Sfz=DVL_Sf_sigmaz;
    
        %%Computation of total additive noise
        DVL_TotNoisex=DVL_Nx+DVL_biasx;
        DVL_TotNoisey=DVL_Ny+DVL_biasy;
        DVL_TotNoisez=DVL_Nz+DVL_biasz;
    
    if i==1
            Simulation.Output.User_Def_Sim.Noise.DVL1.Vx=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.DVL1.Vy=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.DVL1.Vz=zeros(timestep,N);
    end

        Simulation.Output.User_Def_Sim.Noise.DVL1.Vx(:,i)=DVL_TotNoisex+(1+DVL_Sfx).*Simulation.Input.User_Def_Sim.DVL.Velocity(:,1);
        Simulation.Output.User_Def_Sim.Noise.DVL1.Vy(:,i)=DVL_TotNoisey+(1+DVL_Sfy).*Simulation.Input.User_Def_Sim.DVL.Velocity(:,2);
        Simulation.Output.User_Def_Sim.Noise.DVL1.Vz(:,i)=DVL_TotNoisez+(1+DVL_Sfz).*Simulation.Input.User_Def_Sim.DVL.Velocity(:,3);
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Computation of GPS Errors
    
        %Fixed bias 
        Lat_bias_sigma   = GetParam(Simulation.Parameters_GPS ,'latitude_bias');
        lon_bias_sigma   = GetParam(Simulation.Parameters_GPS ,'longitude_bias');
        %White noise
        Lat_rnoise_sigma = GetParam(Simulation.Parameters_GPS ,'latitude_random_noise');
        lon_rnoise_sigma = GetParam(Simulation.Parameters_GPS ,'longitude_random_noise');
    
        Lat_N=Lat_rnoise_sigma*randn(timestep,1);
        lon_N=lon_rnoise_sigma*randn(timestep,1);
        
        Lat_bias=Lat_bias_sigma*randn(1);
        lon_bias=lon_bias_sigma*randn(1);
        
        %%Computation of total additive noise
        Lat_TotNoise=Lat_N+Lat_bias;
        lon_TotNoise=lon_N+lon_bias;

        X_Lat=[];
        X_lon=[];
        
        X_Lat(:,1)=Lat_TotNoise+Simulation.Input.User_Def_Sim.Path.P_ned(:,1);
        X_lon(:,1)=lon_TotNoise+Simulation.Input.User_Def_Sim.Path.P_ned(:,2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        InitPosdeg         = GetParam(Simulation.Init_Value ,'initial_geo_position');%Initial position in degree        
        %P0_geo:initial position in geographic frame (rad)
        P0_rad=zeros(timestep,2);
        P0_rad(:,1)=InitPosdeg(1)*pi/180*ones(timestep,1);
        P0_rad(:,2)=InitPosdeg(2)*pi/180*ones(timestep,1);
        
        %P_geo:Real path in geographic frame in rad
        P_rad=zeros(timestep,4);
        P_rad(:,1)=(X_Lat/R)+P0_rad(:,1);
        P_rad(:,2)=(X_lon./(cos(P_rad(:,1))*R))+P0_rad(:,2) ; 
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if i==1
            Simulation.Output.User_Def_Sim.Noise.GPS1.Lat(:,i)=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.GPS1.lon(:,i)=zeros(timestep,N);
        end
        
        Simulation.Output.User_Def_Sim.Noise.GPS1.Lat(:,i)=P_rad(:,1)*(180/pi);
        Simulation.Output.User_Def_Sim.Noise.GPS1.lon(:,i)=P_rad(:,2)*(180/pi);
    
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@        
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Computation of Depthmeter Errors
    
        %Fixed bias 
        Depth_bias_sigma   = GetParam(Simulation.Parameters_DepthMeter ,'bias');
        %White noise
        Depth_rnoise_sigma = GetParam(Simulation.Parameters_DepthMeter ,'random_noise');
    
        Depth_N=Depth_rnoise_sigma*randn(timestep,1);
        Depth_bias=Depth_bias_sigma*randn(1);

        %%Computation of total additive noise
        Z_TotNoise=Depth_N+Depth_bias;

    if i==1
        Simulation.Output.User_Def_Sim.Noise.Depthmeter1.Z=zeros(timestep,N);
    end

        Simulation.Output.User_Def_Sim.Noise.Depthmeter1.Z(:,i)=Z_TotNoise+Simulation.Input.User_Def_Sim.Depthmeter.Z+Init_Pos(3);
    
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
        %Computation of Orintation sensor Error(Roll_Pitch_Heading(Yaw)

        %Standard deviation of Dynamic Accuracy(from datasheet)
        RP_Dyn_accur_sigma = GetParam(Simulation.Parameters_GyroCompass ,'rp_dynamic_accuracy')*pi/180;
        Y_Dyn_accur_sigma  = GetParam(Simulation.Parameters_GyroCompass ,'y_dynamic_accuracy') *pi/180;
    
        %Standard deviation of Dynamic Accuracy(from datasheet)
        RP_Sta_accur_sigma = GetParam(Simulation.Parameters_GyroCompass ,'rp_static_accuracy')*pi/180;
        Y_Sta_accur_sigma  = GetParam(Simulation.Parameters_GyroCompass ,'y_static_accuracy') *pi/180;
    
        %%Modelling of Dynamic Accuracy with a Gaussian white noise sequence
        RP_RandomNoise = RP_Dyn_accur_sigma *randn(timestep,1);
        Y_RandomNoise  = Y_Dyn_accur_sigma  *randn(timestep,1);
    
        %%Modelling of Resolution with fixed bias
        Roll_Bias  = RP_Sta_accur_sigma*randn(1);
        Pitch_Bias = RP_Sta_accur_sigma*randn(1);
        Yaw_Bias   = Y_Sta_accur_sigma *randn(1);
    
        if i==1
            Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NRoll=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NPitch=zeros(timestep,N);
            Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NYaw=zeros(timestep,N);
        end

        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NRoll(:,i)  = Roll_Bias  + RP_RandomNoise + Simulation.Input.User_Def_Sim.Gyro_Compass.R;
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NPitch(:,i) = Pitch_Bias + RP_RandomNoise + Simulation.Input.User_Def_Sim.Gyro_Compass.P;
        Simulation.Output.User_Def_Sim.Noise.Gyro_Compass1.NYaw(:,i)   = Yaw_Bias   + Y_RandomNoise  + Simulation.Input.User_Def_Sim.Gyro_Compass.Y;   
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@