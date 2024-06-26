function tabscan = EvaluateTabScan(tabscan)

% 1) on evalue les variables
% for I=1:length(ParametersVariables.Param)
%     tab{I} = ParametersVariables.Param(I).val;
%     var{I} = ParametersVariables.Param(I).title;
%     eval([var{I} '=' num2str(tab{I}) ';']);
% end

% 2) on evalue les parametres des variables
try
    for I=1:size(tabscan,1)
        tabscan{I,3} = ['[' num2str(eval([tabscan{I,3} ';'])) ']'] ;
    end
catch
    warndlg(['An error occur during evaluation of tabscan line ' num2str(I)], 'My Warn Dialog', 'modal');
end


