%%Auxliary Sensors Variance (R Elements)
function Parameters = Parameters_Default_AuxSnsrNoiseVar(Simulation)
gg   =9.782421625992459;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bias Stability of the Accelerometer

    Accel_BS_x      = GetParam(Simulation.Parameters_Accel ,'bs_x');
    Accel_BS_y      = GetParam(Simulation.Parameters_Accel ,'bs_y');
    Accel_BS_z      = GetParam(Simulation.Parameters_Accel ,'bs_z');
    
    %The unit of the Bias Stability
    
    Accel_BS_Unit   = GetParam(Simulation.Parameters_Accel ,'bs_unit');
       
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
    
[ GyroError,AccelError,GPSError,DVLError,DepthError,GCmps ] = WNSigma_Calcul( Simulation );

Var_Accx  = (AccelError.VRW_sigmax^2+accel_BS_sigmax^2);    
Var_Accy  = (AccelError.VRW_sigmay^2+accel_BS_sigmay^2);    
Var_Accz  = (AccelError.VRW_sigmaz^2+accel_BS_sigmaz^2);  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = 1;
Parametres(I).title    = 'Var Latitude Value';
Parametres(I).val      = GPSError.rnoise_sigmaLat^2;%LatError.rnoise_sigma^2;
Parametres(I).units    = '(m^2)';
Parametres(I).tooltipstring = 'Variance of the Latitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_LatV';

I                      = I + 1;
Parametres(I).title    = 'Var Latitude TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the Latitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_LatT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I+1;
Parametres(I).title    = 'Var longitude Value';
Parametres(I).val      = GPSError.rnoise_sigmalon^2;%lonError.rnoise_sigma^2;
Parametres(I).units    = '(m^2)';
Parametres(I).tooltipstring = 'Variance of the longitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_lonV';

I                      = I + 1;
Parametres(I).title    = 'Var longitude TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the longitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_lonT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I+1;
Parametres(I).title    = 'Var Depth\Altitude Value';
Parametres(I).val      = DepthError.rnoise_sigma^2;
Parametres(I).units    = '(m^2)';
Parametres(I).tooltipstring = 'Variance of the Depth or altitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_DV';

I                      = I + 1;
Parametres(I).title    = 'Var Depth\Altitude TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the Depth or altitude';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_DT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'Var Vx Value';
Parametres(I).val      = DVLError.rnoise_sigmax^2;
Parametres(I).units    = '((m/s)^2)';
Parametres(I).tooltipstring = 'Variance of the x-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VxV';

I                      = I + 1;
Parametres(I).title    = 'Var Vx TC';
Parametres(I).val      = 1;
Parametres(I).units    = ' ';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the x-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VxT';

I                      = I + 1;
Parametres(I).title    = 'Var Vy Value';
Parametres(I).val      = DVLError.rnoise_sigmay^2;
Parametres(I).units    = '((m/s)^2)';
Parametres(I).tooltipstring = 'Variance of the y-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VyV';

I                      = I + 1;
Parametres(I).title    = 'Var Vy TC';
Parametres(I).val      = 1;
Parametres(I).units    = ' ';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the y-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VyT';

I                      = I + 1;
Parametres(I).title    = 'Var Vz Value';
Parametres(I).val      = DVLError.rnoise_sigmaz^2;
Parametres(I).units    = '((m/s)^2)';
Parametres(I).tooltipstring = 'Variance of the z-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VzV';

I                      = I + 1;
Parametres(I).title    = 'Var Vz TC';
Parametres(I).val      = 1;
Parametres(I).units    = ' ';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the z-axis DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_VzT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'Var Roll Value';
Parametres(I).val      = GCmps.RP_rnoise_sigma^2;
Parametres(I).units    = '(rad^2)';
Parametres(I).tooltipstring = 'Variance of the Roll';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_RollV';

I                      = I + 1;
Parametres(I).title    = 'Var Roll TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the Roll';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_RollT';

I                      = I + 1;
Parametres(I).title    = 'Var Pitch Value';
Parametres(I).val      = GCmps.RP_rnoise_sigma^2;
Parametres(I).units    = '(rad^2)';
Parametres(I).tooltipstring = 'Variance of the Pitch';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_PitchV';


I                      = I + 1;
Parametres(I).title    = 'Var Pitch TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the Pitch';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_PitchT';

I                      = I + 1;
Parametres(I).title    = 'Var Yaw Value';
Parametres(I).val      = GCmps.Y_rnoise_sigma^2;
Parametres(I).units    = '(rad^2)';
Parametres(I).tooltipstring = 'Variance of the Yaw';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_YawV';

I                      = I + 1;
Parametres(I).title    = 'Var Yaw TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the Yaw';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_YawT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'Var A_Roll Value';
Parametres(I).val      = Var_Accy/gg;
Parametres(I).units    = '(rad^2)';
Parametres(I).tooltipstring = 'Variance of the roll computed by accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_ARollV';

I                      = I + 1;
Parametres(I).title    = 'Var A_Roll TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the roll computed by accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_ARollT';

I                      = I + 1;
Parametres(I).title    = 'Var A_Pitch Value';
Parametres(I).val      = Var_Accx/gg;
% Parametres(I).val      = Var_Accx;
Parametres(I).units    = '(rad^2)';
Parametres(I).tooltipstring = 'Variance of the pitch computed by accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_APitchV';


I                      = I + 1;
Parametres(I).title    = 'Var A_Pitch TC';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tuning Coefficient of the variance of the pitch computed by accelerometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_Var_APitchT';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      =I+1;
Parametres(I).title    = 'Use of R adaptive';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of R_AuxSensors';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Include R_adaptive';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters.Param = Parametres;
Parameters.name  = 'R''s elements of the auxiliary sensors';
Parameters.text  = 'Parameters required auxiliary sensors'' variance';
end

