function Parameters = NewPath()

I = 1;
Parametres(I).title    = 'Constituent points of the path:';
Parametres(I).val      = [];
Parametres(I).units    = 'm,m,m,s';
Parametres(I).tooltipstring = 'The constituent points of the path in meter and times corresponding with them in second (a n*4 vector, n: Number of Points)';
Parametres(I).style    = 'edit';
Parametres(I).choix    = '';
Parametres(I).tag      = 'points';


Parameters.Param = Parametres;
Parameters.name  = 'New Path';
Parameters.text  = 'Importing a new path for virtual computations';
end

