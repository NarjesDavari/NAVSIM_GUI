%Computation of the sigma of the noise parameters (fixed bias, bias stability, white noise)
%Reference: My thesis : page 99-100
function [ Simulation,GyroError,AccelError ] = Sigma_Calcul( Simulation , i )
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if i==1
        %
        Simulation.Input.User_Def_Sim.IMU.fs                = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
        
        %Fixed bias of the gyroscope
        Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasx  = GetParam(Simulation.Parameters_Gyro ,'Bias_x');
        Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasy  = GetParam(Simulation.Parameters_Gyro ,'Bias_y');
        Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasz  = GetParam(Simulation.Parameters_Gyro ,'Bias_z');
        
        %Angle Random Walk of Gyro white noise 
        Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_x        = GetParam(Simulation.Parameters_Gyro ,'arw_x');
        Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_y        = GetParam(Simulation.Parameters_Gyro ,'arw_y');
        Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_z        = GetParam(Simulation.Parameters_Gyro ,'arw_z');
        
        %Bias Stability of the gyroscope
        Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_x    = GetParam(Simulation.Parameters_Gyro ,'bs_x');
        Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_y    = GetParam(Simulation.Parameters_Gyro ,'bs_y');
        Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_z    = GetParam(Simulation.Parameters_Gyro ,'bs_z'); 
        
        %The unit of the Fixed Bias
        Simulation.Input.User_Def_Sim.IMU.Gyro.Bias_Unit    = GetParam(Simulation.Parameters_Gyro ,'b_unit');    
        
        %The unit of the Angle Random Walk
        Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_Unit     = GetParam(Simulation.Parameters_Gyro ,'arw_unit');
        
        %The unit of the Bias Stability
        Simulation.Input.User_Def_Sim.IMU.Gyro.BS_Unit      = GetParam(Simulation.Parameters_Gyro ,'bs_unit');
        
        %The averaging time at which the Bias Stability measurement is made
        Simulation.Input.User_Def_Sim.IMU.Gyro.Ave_Time     = GetParam(Simulation.Parameters_Gyro ,'averaging_time');
        
        %The unit of the Scale factor error
        Simulation.Input.User_Def_Sim.IMU.Gyro.SFe_Unit    = GetParam(Simulation.Parameters_Gyro ,'sfe_unit');
        
        %Scale factor error
        Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_x       = GetParam(Simulation.Parameters_Gyro ,'sfe_x');
        Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_y       = GetParam(Simulation.Parameters_Gyro ,'sfe_y');
        Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_z       = GetParam(Simulation.Parameters_Gyro ,'sfe_z');         
        
        %The bandwidth of the gyroscope
        Simulation.Input.User_Def_Sim.IMU.Gyro.Bandwidth   = GetParam(Simulation.Parameters_Gyro ,'bandwidth');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %Fixed bias of the Accelerometer
        Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasx = GetParam(Simulation.Parameters_Accel ,'Bias_x');
        Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasy = GetParam(Simulation.Parameters_Accel ,'Bias_y');
        Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasz = GetParam(Simulation.Parameters_Accel ,'Bias_z');
        
        %Angle Random Walk of Accel white noise 
        Simulation.Input.User_Def_Sim.IMU.Accel.VRW_x       = GetParam(Simulation.Parameters_Accel ,'vrw_x');
        Simulation.Input.User_Def_Sim.IMU.Accel.VRW_y       = GetParam(Simulation.Parameters_Accel ,'vrw_y');
        Simulation.Input.User_Def_Sim.IMU.Accel.VRW_z       = GetParam(Simulation.Parameters_Accel ,'vrw_z');
        
        %Bias Stability of the Accelerometer
        Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_x  = GetParam(Simulation.Parameters_Accel ,'bs_x');
        Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_y  = GetParam(Simulation.Parameters_Accel ,'bs_y');
        Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_z  = GetParam(Simulation.Parameters_Accel ,'bs_z'); 
        
        %The unit of the Fixed Bias
        Simulation.Input.User_Def_Sim.IMU.Accel.Bias_Unit   = GetParam(Simulation.Parameters_Accel ,'b_unit');
        
        %The unit of the Angle Random Walk
        Simulation.Input.User_Def_Sim.IMU.Accel.VRW_Unit    = GetParam(Simulation.Parameters_Accel ,'vrw_unit');
        
        %The unit of the Bias Stability
        Simulation.Input.User_Def_Sim.IMU.Accel.BS_Unit     = GetParam(Simulation.Parameters_Accel ,'bs_unit');
        
        %The unit of the Scale factor error
        Simulation.Input.User_Def_Sim.IMU.Accel.SFe_Unit    = GetParam(Simulation.Parameters_Accel ,'sfe_unit');
        
        %Scale factor error
        Simulation.Input.User_Def_Sim.IMU.Accel.sfe_x       = GetParam(Simulation.Parameters_Accel ,'sfe_x');
        Simulation.Input.User_Def_Sim.IMU.Accel.sfe_y       = GetParam(Simulation.Parameters_Accel ,'sfe_y');
        Simulation.Input.User_Def_Sim.IMU.Accel.sfe_z       = GetParam(Simulation.Parameters_Accel ,'sfe_z');         
        %The averaging time at which the Bias Stability measurement is made
        Simulation.Input.User_Def_Sim.IMU.Accel.Ave_Time    = GetParam(Simulation.Parameters_Accel ,'averaging_time');
        
        %The bandwidth of the Accelerometer
        Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth   = GetParam(Simulation.Parameters_Accel ,'bandwidth');        
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dt = 1/Simulation.Input.User_Def_Sim.IMU.fs;
    %omputation of the sigma relating to fixed bias of the gyroscope
    switch Simulation.Input.User_Def_Sim.IMU.Gyro.Bias_Unit
        %Converting to rad/s
        case 'deg/s'
            GyroError.fixed_biasx_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasx *(pi/180);
            GyroError.fixed_biasy_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasy *(pi/180);
            GyroError.fixed_biasz_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasz *(pi/180);
        case 'deg/hr'
            GyroError.fixed_biasx_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasx *(pi/180/3600);
            GyroError.fixed_biasy_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasy *(pi/180/3600);
            GyroError.fixed_biasz_sigma = Simulation.Input.User_Def_Sim.IMU.Gyro.fixed_biasz *(pi/180/3600);            
    end
    %omputation of the sigma relating to Angle Random Walk of the gyroscope
    switch Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_Unit
        %Converting to rad/s
        case 'deg/s/rt Hz'
            GyroError.ARW_sigmax = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_x *(pi/180)*sqrt(Simulation.Input.User_Def_Sim.IMU.Gyro.Bandwidth*1.57);
            GyroError.ARW_sigmay = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_y *(pi/180)*sqrt(Simulation.Input.User_Def_Sim.IMU.Gyro.Bandwidth*1.57);
            GyroError.ARW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_z *(pi/180)*sqrt(Simulation.Input.User_Def_Sim.IMU.Gyro.Bandwidth*1.57);
        %Converting to rad/s
        case 'deg/rt hr'
            GyroError.ARW_sigmax = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_x *(pi/180/60/sqrt(dt));
            GyroError.ARW_sigmay = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_y *(pi/180/60/sqrt(dt));
            GyroError.ARW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_z *(pi/180/60/sqrt(dt));      
        %Converting to rad/s
        case 'deg/hr'
            GyroError.ARW_sigmax = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_x *(pi/180/3600);
            GyroError.ARW_sigmay = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_y *(pi/180/3600);
            GyroError.ARW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Gyro.ARW_z *(pi/180/3600);              
    end   
    %omputation of the sigma relating to Bias Stability of the gyroscope
    switch Simulation.Input.User_Def_Sim.IMU.Gyro.BS_Unit
        %Converting to rad/s
        case 'deg/s'
            GyroError.gyro_BS_sigmax = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_x *(pi/180);
            GyroError.gyro_BS_sigmay = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_y *(pi/180);
            GyroError.gyro_BS_sigmaz = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_z *(pi/180);
        %Converting to rad/s^2
        case 'deg/hr'
            GyroError.gyro_BS_sigmax = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_x *(pi/180/3600);
            GyroError.gyro_BS_sigmay = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_y *(pi/180/3600);
            GyroError.gyro_BS_sigmaz = Simulation.Input.User_Def_Sim.IMU.Gyro.gyro_BS_z *(pi/180/3600);            
    end
    %omputation of the scale factor error of the gyroscope
    switch Simulation.Input.User_Def_Sim.IMU.Gyro.SFe_Unit
        %Converting to 
        case 'PPM'
            GyroError.sfe_x = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_x/1e6 ;
            GyroError.sfe_y = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_y/1e6 ;
            GyroError.sfe_z = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_z/1e6 ;
        %Converting to 
        case '%'
            GyroError.sfe_x = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_x/100 ;
            GyroError.sfe_y = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_y/100 ;
            GyroError.sfe_z = Simulation.Input.User_Def_Sim.IMU.Gyro.sfe_z/100 ;           
    end    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %omputation of the sigma relating to fixed bias of the accelerometer
    switch Simulation.Input.User_Def_Sim.IMU.Accel.Bias_Unit
        %Converting to m/s^2
        case 'm/s^2'
            AccelError.fixed_biasx_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasx *1;
            AccelError.fixed_biasy_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasy *1;
            AccelError.fixed_biasz_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasz *1;
        %Converting to m/s^2
        case 'mg'
            AccelError.fixed_biasx_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasx *(9.8e-3);
            AccelError.fixed_biasy_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasy *(9.8e-3);
            AccelError.fixed_biasz_sigma = Simulation.Input.User_Def_Sim.IMU.Accel.fixed_biasz *(9.8e-3);            
    end
    %omputation of the sigma relating to Velocity Random Walk of the
    %accelerometer
    switch Simulation.Input.User_Def_Sim.IMU.Accel.VRW_Unit
        %Converting to m/s^2
        case 'mg'
            AccelError.VRW_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_x *(9.8e-3);
            AccelError.VRW_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_y *(9.8e-3);
            AccelError.VRW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_z *(9.8e-3);
        case 'ug/rt Hz'
            AccelError.VRW_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_x *(9.8e-6)*sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);
            AccelError.VRW_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_y *(9.8e-6)*sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);
            AccelError.VRW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_z *(9.8e-6)*sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);   
        case 'm/s^2/rt Hz'
            AccelError.VRW_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_x *sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);
            AccelError.VRW_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_y *sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);
            AccelError.VRW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_z *sqrt(Simulation.Input.User_Def_Sim.IMU.Accel.Bandwidth*1.57);   
        case 'm/s/rt hr'
            AccelError.VRW_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_x *(1/60/sqrt(dt));
            AccelError.VRW_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_y *(1/60/sqrt(dt));
            AccelError.VRW_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.VRW_z *(1/60/sqrt(dt));
    end   
    %omputation of the sigma relating to Bias Stability of the
    %accelerometer
    switch Simulation.Input.User_Def_Sim.IMU.Accel.BS_Unit
        %Converting to m/s^2
        case 'm/s^2'
            AccelError.accel_BS_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_x *1;
            AccelError.accel_BS_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_y *1;
            AccelError.accel_BS_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_z *1;
        %Converting to m/s^2
        case 'mg'
            AccelError.accel_BS_sigmax = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_x *(9.8e-3);
            AccelError.accel_BS_sigmay = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_y *(9.8e-3);
            AccelError.accel_BS_sigmaz = Simulation.Input.User_Def_Sim.IMU.Accel.Accel_BS_z *(9.8e-3);            
    end   
    %omputation of the scale factor error of the accelerometer
    switch Simulation.Input.User_Def_Sim.IMU.Gyro.SFe_Unit
        %Converting to 
        case 'PPM'
            AccelError.sfe_x = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_x/1e6 ;
            AccelError.sfe_y = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_y/1e6 ;
            AccelError.sfe_z = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_z/1e6 ;
        %Converting to 
        case '%'
            AccelError.sfe_x = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_x/100 ;
            AccelError.sfe_y = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_y/100 ;
            AccelError.sfe_z = Simulation.Input.User_Def_Sim.IMU.Accel.sfe_z/100 ;           
    end    
end

