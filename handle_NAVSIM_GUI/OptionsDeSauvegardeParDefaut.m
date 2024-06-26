function options = OptionsDeSauvegardeParDefaut

options.repertoire     = [pwd '\Reports\'];
options.nom_simulation = 'untitled';

options.choix_signal   = {'Save All Signsl' 'Don''t save any signal' 'Save IMU Signals Only' 'Save Auxiliary Signals Only' ...
                          'Save IMU and Auxiliary Signals' 'Save Results only' 'Save Signals and Results only'};
options.choix_signal_value = 1 ;
