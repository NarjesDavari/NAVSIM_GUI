function Parameters = Parameters_Default_GyroCompass()

I                      = 1;
Parametres(I).title    = 'R&P Dynamic Accuracy';
Parametres(I).val      = 1;
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Dynamic Accuracy (Roll&Pitch)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'rp_dynamic_accuracy';

I                      = I + 1;
Parametres(I).title    = 'Y Dynamic accuracy';
Parametres(I).val      = 1;
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Dynamic Accuracy (Yaw)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'y_dynamic_accuracy';

I                      = I + 1;
Parametres(I).title    = 'R&P Static Accuracy';
Parametres(I).val      = 0;
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Static Accuracy (Roll&Pitch)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'rp_static_accuracy';

I                      = I + 1;
Parametres(I).title    = 'Y Static accuracy';
Parametres(I).val      = 0;
Parametres(I).units    = 'deg';
Parametres(I).tooltipstring = 'Static Accuracy (Yaw)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'y_static_accuracy';

I                      = I + 1;
Parametres(I).title    = 'Inclinometer Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The Sampling frequency of the Inclinometer';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'inclinometer_frequency';

I                      = I + 1;
Parametres(I).title    = 'Gyrocompass Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The Sampling frequency of the Gyrocompass';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'gyrocompass_frequency';

I                      =I+1;
Parametres(I).title    = 'Include Heading';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of Heading';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_heading';

I                      =I+1;
Parametres(I).title    = 'Include Roll&Pitch';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of Roll&Pitch';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_roll&pitch';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters.Param = Parametres;
Parameters.name  = 'Gyro Compass Parameters';
Parameters.text  = 'Parameters required for Gyro Compass';
end

