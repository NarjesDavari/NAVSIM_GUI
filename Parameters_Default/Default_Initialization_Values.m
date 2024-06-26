function Parameters = Default_Initialization_Values()

I = 1;
Parametres(I).title    = 'Initial metric Position';
Parametres(I).val      = [0 0 0];
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Initial value of the Vehicle Position in meter (X,Y,Z)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Initial_m_Position';

I                      = I + 1;
Parametres(I).title    = 'Initial Geographic Position';
Parametres(I).val      = [32.718726516666700,51.528789163333300,0];
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Initial value of the Vehicle Position in degree (Lat,lon,alt)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'initial_geo_position';

I                      = I + 1;
Parametres(I).title    = 'Initial Velocity';
Parametres(I).val      = [0 0 0];
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Initial value of the Vehicle Velocity in meter over second (Vx,Vy,Vz)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Initial_Velocity';

I                      = I + 1;
Parametres(I).title    = 'Initial Orientation';
Parametres(I).val      = [0 0 0];
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Initial value of the Euler Angles in Radian (Psi,Theta,Phi)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Initial_Orientation';

I                      = I + 1;
Parametres(I).title    = 'g';
Parametres(I).val      = 9.782421625992459;
Parametres(I).units    = 'm/s^2';
Parametres(I).tooltipstring = 'the Earth gravity constant.';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'earth_gravity_constant';

I                      = I + 1;
Parametres(I).title    = 'Sampling Frequency';
Parametres(I).val      = 100;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The frequency at which the designed path is sampled';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Sampling_Frequency';

I                      = I + 1;
Parametres(I).title    = 'Number of Simulation Iterations';
Parametres(I).val      = 1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Number of times that a simulation is repeated';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'simulation_number';

I                      = I + 1;
Parametres(I).title    = 'Signal Simulation';
Parametres(I).val      = true;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'Running of signal simulation';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'signal_simulation';

Parameters.Param = Parametres;
Parameters.name  = 'Initialization Values';
Parameters.text  = 'Values required for initializing in Virtual computations';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      = I + 1;
Parametres(I).title    = 'Initial Bias Accel';
Parametres(I).val      = [0,0,0];
Parametres(I).units    = 'm/s^2';
Parametres(I).tooltipstring = 'Initial value of the Accelerometer''s bias in m/s^2';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'initial_bias_accel';

I                      = I + 1;
Parametres(I).title    = 'Initial Bias Gyro';
Parametres(I).val      = [0,0,0];
Parametres(I).units    = 'rad/s';
Parametres(I).tooltipstring = 'Initial value of the gyroscope''s bias in rad/s';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'initial_bias_gyro';

Parameters.Param = Parametres;
Parameters.name  = 'Initialization Values';
Parameters.text  = 'Values required for initializing in Virtual computations';

end

