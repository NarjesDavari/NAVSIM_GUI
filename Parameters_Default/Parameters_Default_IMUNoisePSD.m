%Inertial Sensor Noise PSD (Qc Elements)
function Parameters = Parameters_Default_IMUNoisePSD(Simulation)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Bias Stability of the Accelerometer
    Accel_BS_x      = GetParam(Simulation.Parameters_Accel ,'bs_x');
    Accel_BS_y      = GetParam(Simulation.Parameters_Accel ,'bs_y');
    Accel_BS_z      = GetParam(Simulation.Parameters_Accel ,'bs_z');
    %The unit of the Bias Stability
    Accel_BS_Unit   = GetParam(Simulation.Parameters_Accel ,'bs_unit');
    %The bandwidth of the Accelerometer
    Accel_Bandwidth = GetParam(Simulation.Parameters_Accel ,'bandwidth');       
        
    %Bias Stability of the gyroscope
    gyro_BS_x       = GetParam(Simulation.Parameters_Gyro ,'bs_x');
    gyro_BS_y       = GetParam(Simulation.Parameters_Gyro ,'bs_y');
    gyro_BS_z       = GetParam(Simulation.Parameters_Gyro ,'bs_z'); 
    %The unit of the Bias Stability
    gyro_BS_Unit    = GetParam(Simulation.Parameters_Gyro ,'bs_unit');
    %The bandwidth of the gyroscope
    gyro_Bandwidth  = GetParam(Simulation.Parameters_Gyro ,'bandwidth');
    
    
%       [ Simulation,GyroError,AccelError ] = Sigma_Calcul( Simulation , 1 );
        %sigmaFixed bias of the gyro
%         sigma_biasgx=std(GyroError.fixed_biasx_sigma *(-1+2* rand(1000,1)));
%         sigma_biasgy=std(GyroError.fixed_biasy_sigma *(-1+2* rand(1000,1)));
%         sigma_biasgz=std(GyroError.fixed_biasz_sigma *(-1+2* rand(1000,1)));
%       %sigmaFixed bias of the Accelerometer  
%        sigma_biasax=std(AccelError.fixed_biasx_sigma *(-1+2* rand(1000,1)));
%        sigma_biasay=std(AccelError.fixed_biasy_sigma *(-1+2* rand(1000,1)));
%        sigma_biasaz=std(AccelError.fixed_biasz_sigma *(-1+2* rand(1000,1)));
%     
%       var_biasax=(AccelError.fixed_biasx_sigma)^2;
%       var_biasay=(AccelError.fixed_biasy_sigma)^2;
%       var_biasaz=(AccelError.fixed_biasz_sigma)^2;
%       var_biasgx=(GyroError.fixed_biasx_sigma)^2;
%       var_biasgy=(GyroError.fixed_biasy_sigma)^2;
%       var_biasgz=(GyroError.fixed_biasz_sigma)^2;
    
    

    switch Accel_BS_Unit
        %Converting to m/s^2
        case 'm/s^2'
            accel_BS_sigmax = Accel_BS_x ;
            accel_BS_sigmay = Accel_BS_y ;
            accel_BS_sigmaz = Accel_BS_z ;
        %Converting to m/s^2
        case 'mg'
            accel_BS_sigmax = Accel_BS_x *(9.8e-3);
            accel_BS_sigmay = Accel_BS_y *(9.8e-3);
            accel_BS_sigmaz = Accel_BS_z *(9.8e-3);            
    end    
    switch gyro_BS_Unit
        %Converting to rad/s
        case 'deg/s'
            gyro_BS_sigmax = gyro_BS_x *(pi/180);
            gyro_BS_sigmay = gyro_BS_y *(pi/180);
            gyro_BS_sigmaz = gyro_BS_z *(pi/180);
        %Converting to rad/s
        case 'deg/hr'
            gyro_BS_sigmax = gyro_BS_x *(pi/180/3600);
            gyro_BS_sigmay = gyro_BS_y *(pi/180/3600);
            gyro_BS_sigmaz = gyro_BS_z *(pi/180/3600);            
    end  
[ GyroError,AccelError,DVLError,DepthError,GCmps ] = WNSigma_Calcul( Simulation );
Var_Accx = (AccelError.VRW_sigmax^2);    
Var_Accy = (AccelError.VRW_sigmay^2);    
Var_Accz = (AccelError.VRW_sigmaz^2);  

Var_BAccx = (accel_BS_sigmax^2);    
Var_BAccy = (accel_BS_sigmay^2);    
Var_BAccz = (accel_BS_sigmaz^2); 


Var_Gyrox = (GyroError.ARW_sigmax^2);    
Var_Gyroy = (GyroError.ARW_sigmay^2); 
Var_Gyroz = (GyroError.ARW_sigmaz^2);  

Var_BGyrox = (gyro_BS_sigmax^2);    
Var_BGyroy = (gyro_BS_sigmay^2); 
Var_BGyroz = (gyro_BS_sigmaz^2); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = 1;
Parametres(I).title    = 'PSD Accx Value';
Parametres(I).val      = Var_Accx/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the x-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AxV';

I                      = I + 1;
Parametres(I).title    = 'PSD Accx TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the x-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AxT';

I                      = I + 1;
Parametres(I).title    = 'PSD Accy Value';
Parametres(I).val      = Var_Accy/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the y-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AyV';

I                      = I + 1;
Parametres(I).title    = 'PSD Accy TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the y-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AyT';

I                      = I + 1;
Parametres(I).title    = 'PSD Accz Value';
Parametres(I).val      = Var_Accz/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the z-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AzV';

I                      = I + 1;
Parametres(I).title    = 'PSD Accz TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the z-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_AzT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'PSD Gyrox Value';
Parametres(I).val      = Var_Gyrox/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the x-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GxV';

I                      = I + 1;
Parametres(I).title    = 'PSD Gyrox TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the x-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GxT';

I                      = I + 1;
Parametres(I).title    = 'PSD Gyroy Value';
Parametres(I).val      = Var_Gyroy/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the y-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GyV';

I                      = I + 1;
Parametres(I).title    = 'PSD Gyroy TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the y-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GyT';

I                      = I + 1;
Parametres(I).title    = 'PSD Gyroz Value';
Parametres(I).val      = Var_Gyroz/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the z-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GzV';

I                      = I + 1;
Parametres(I).title    = 'PSD Gyroz TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the z-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_GzT';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%bias
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'PSD BAccx Value';
Parametres(I).val      = Var_BAccx/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the x-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAxV';

I                      = I + 1;
Parametres(I).title    = 'PSD BAccx TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the x-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAxT';

I                      = I + 1;
Parametres(I).title    = 'PSD BAccy Value';
Parametres(I).val      = Var_BAccy/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the y-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAyV';

I                      = I + 1;
Parametres(I).title    = 'PSD Accy TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the y-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAyT';

I                      = I + 1;
Parametres(I).title    = 'PSD BAccz Value';
Parametres(I).val      = Var_BAccz/Accel_Bandwidth;
Parametres(I).units    = '(m/s^2)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the z-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAzV';

I                      = I + 1;
Parametres(I).title    = 'PSD BAccz TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the z-axis accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BAzT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'PSD BGyrox Value';
Parametres(I).val      = Var_BGyrox/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the x-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGxV';

I                      = I + 1;
Parametres(I).title    = 'PSD BGyrox TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the x-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGxT';

I                      = I + 1;
Parametres(I).title    = 'PSD BGyroy Value';
Parametres(I).val      = Var_BGyroy/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the y-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGyV';

I                      = I + 1;
Parametres(I).title    = 'PSD BGyroy TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the y-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGyT';

I                      = I + 1;
Parametres(I).title    = 'PSD BGyroz Value';
Parametres(I).val      = Var_BGyroz/gyro_Bandwidth;
Parametres(I).units    = '(rad/s)^2/Hz';
Parametres(I).tooltipstring = 'Power Spectral Density of the z-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGzV';

I                      = I + 1;
Parametres(I).title    = 'PSD BGyroz TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the Power Spectral Density of the z-axis gyroscope';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_PSD_BGzT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      =I+1;
Parametres(I).title    = 'Use of Q adaptive';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of Q_IMU';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Include Q_adaptive';

Parameters.Param = Parametres;
Parameters.name  = 'Qc''s elements of the accelerometers';
Parameters.text  = 'Parameters required for Accelerometers'' noise PSD';
end

