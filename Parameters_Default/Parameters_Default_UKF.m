function Parameters = Parameters_Default_UKF()
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      
I                      = 1;
Parametres(I).title    = 'Alpha';
Parametres(I).val      = 3.1;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Primary scaling factor 0 < Alpha';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_alpha';

I                      = I + 1;
Parametres(I).title    = 'Beta';
Parametres(I).val      = 0.5;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Secondary scaling factor';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_beta';

I                      = I + 1;
Parametres(I).title    = 'Kappa';
Parametres(I).val      = 0;
Parametres(I).units    = '';
Parametres(I).tooltipstring = 'Tertiary scaling factor';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'edit_kappa';

Parameters.Param = Parametres;
Parameters.name  = 'UKF Scaling Parameters';
Parameters.text  = 'Parameters required for tuning the UKF';
end

