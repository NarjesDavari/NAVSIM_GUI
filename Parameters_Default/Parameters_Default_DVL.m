function Parameters = Parameters_Default_DVL()

I = 1;
Parametres(I).title    = 'bias x';
Parametres(I).val      = 0;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Fixed Bias (X-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bias_x';

I                      = I + 1;
Parametres(I).title    = 'bias y';
Parametres(I).val      = 0;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Fixed Bias (Y-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bias_y';

I                      = I + 1;
Parametres(I).title    = 'bias z';
Parametres(I).val      = 0;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Fixed Bias (Z-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bias_z';

I                      = I + 1;
Parametres(I).title    = 'Random noise x';
Parametres(I).val      = 0.002;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Random Noise (X-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'random_noise_x';

I                      = I + 1;
Parametres(I).title    = 'Random noise y';
Parametres(I).val      = 0.002;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Random Noise (Y-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'random_noise_y';

I                      = I + 1;
Parametres(I).title    = 'Random noise z';
Parametres(I).val      = 0.002;
Parametres(I).units    = 'm/s';
Parametres(I).tooltipstring = 'Value of the Random Noise (Z-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'random_noise_z';

I                      = I + 1;
Parametres(I).title    = 'SFe x';
Parametres(I).val      = 1;
Parametres(I).units    = '%';
Parametres(I).tooltipstring = 'Scale Factor Error (X-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_x';

I                      = I + 1;
Parametres(I).title    = 'SFe y';
Parametres(I).val      = 1;
Parametres(I).units    = '%';
Parametres(I).tooltipstring = 'Scale Factor Error (Y-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_y';

I                      = I + 1;
Parametres(I).title    = 'SFe z';
Parametres(I).val      = 1;
Parametres(I).units    = '%';
Parametres(I).tooltipstring = 'Scale Factor Error (Z-DVL)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'sfe_z';

I                      = I + 1;
Parametres(I).title    = 'DVL Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The Sampling frequency of the DVL';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'dvl_frequency';

I                      =I+1;
Parametres(I).title    = 'Include DVL';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of DVL';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_dvl';

Parameters.Param = Parametres;
Parameters.name  = 'Doppler Velocity Log Parameters';
Parameters.text  = 'Parameters required for DVL';
end