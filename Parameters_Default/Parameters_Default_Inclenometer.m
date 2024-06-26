function Parameters = Parameters_Default_Inclenometer()

I                      = 1;
Parametres(I).title    = 'CutOff Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The cut-off frequency of the lowpass filter';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'cutoff_frequency';

I                      = I+1;
Parametres(I).title    = 'Detection Signal';
Parametres(I).val      = 0.02;
Parametres(I).units    = 'm/s^2';
Parametres(I).tooltipstring = 'Detection Signal for selecting time instannts when the acceleration should be small';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'detection_signal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      =I+1;
Parametres(I).title    = 'Include Accel Roll&Pitch';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of Roll&Pitch computed by accelerometers';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_accel_roll&pitch';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Parameters.Param = Parametres;
Parameters.name  = 'Inclenometer Parameters';
Parameters.text  = 'Parameters required for Inclenometer';
end

