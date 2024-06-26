function Parameters = Parameters_Default_DepthMeter()

I = 1;
Parametres(I).title    = 'bias';
Parametres(I).val      = 0;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the Fixed Bias';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'bias';

I                      = I + 1;
Parametres(I).title    = 'Random noise';
Parametres(I).val      = 1;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the Random Noise';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'random_noise';

I                      = I + 1;
Parametres(I).title    = 'Depthmeter Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The Sampling frequency of the Depthmeter';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'depthmeter_frequency';

I                      =I+1;
Parametres(I).title    = 'Include Depth-Meter';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of Depth-Meter';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_depthmeter';

Parameters.Param = Parametres;
Parameters.name  = 'DepthMeter Parameters';
Parameters.text  = 'Parameters required for DepthMeter';
end

