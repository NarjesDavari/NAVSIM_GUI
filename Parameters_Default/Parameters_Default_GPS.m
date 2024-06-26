function Parameters = Parameters_Default_GPS()

I = 1;
Parametres(I).title    = 'Latitude bias';
Parametres(I).val      = 0;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the Latitude''s fixed Bias';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'latitude_bias';

I                      = I + 1;
Parametres(I).title    = 'Latitude random noise';
Parametres(I).val      = 1;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the latitude''s random Noise';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'latitude_random_noise';

I                      = I + 1;
Parametres(I).title    = 'longitude bias';
Parametres(I).val      = 0;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the longitude''s fixed Bias';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'longitude_bias';

I                      = I + 1;
Parametres(I).title    = 'longitude random noise';
Parametres(I).val      = 1;
Parametres(I).units    = 'm';
Parametres(I).tooltipstring = 'Value of the longitude''s random Noise';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'longitude_random_noise';

I                      = I + 1;
Parametres(I).title    = 'GPS Frequency';
Parametres(I).val      = 5;
Parametres(I).units    = 'Hz';
Parametres(I).tooltipstring = 'The Sampling frequency of the GPS';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'gps_frequency';

I                      =I+1;
Parametres(I).title    = 'Include GPS';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of GPS';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_gps';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
I                      =I+1;
Parametres(I).title    = 'Include Data_Lose of GPS';
Parametres(I).val      = false;
Parametres(I).units    = '-';
Parametres(I).tooltipstring = 'inclusion of GPS';
Parametres(I).style    = 'checkbox';
Parametres(I).choix    = '';
Parametres(I).tag      = 'include_DataLose of GPS';

I                      = I + 1;
Parametres(I).title    = 'Time of outage start';
Parametres(I).val      = 10;
Parametres(I).units    = 'Minute';
Parametres(I).tooltipstring = 'Value of the Time of outage start of GPS';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Time of outage start';

I                      = I + 1;
Parametres(I).title    = 'Number of Data Lose';
Parametres(I).val      = 50;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Value of the Data_Lose of GPS';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Number of Data Lose';

I                      = I + 1;
Parametres(I).title    = 'Outage time';
Parametres(I).val      = 20;
Parametres(I).units    = 'Sec';
Parametres(I).tooltipstring = 'Value of the outage time of GPS';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'Outage time';



Parameters.Param = Parametres;
Parameters.name  = 'GPS Parameters';
Parameters.text  = 'Parameters required for GPS';
end

