function Parameters = EvaluateParameters(Parameters)

% 1) on evalue les parametres des variables
try
    for I=1:length(Parameters.Param)
        if strcmp(Parameters.Param(I).style,'edit')
            Parameters.Param(I).val = num2str(eval(['[' num2str(Parameters.Param(I).val) ']' ]));
        end
    end
catch
    warndlg(['An error occur during evaluation of ' Parameters.Param(I).title ' (' Parameters.name ')'], 'My Warn Dialog', 'modal');
end


