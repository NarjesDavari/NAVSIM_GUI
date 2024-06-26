function [nom,rep] = SaveSimulationMAT(Simulation,SaveOptions,varargin)
rep = SaveOptions.repertoire;
if isempty(dir(SaveOptions.repertoire))
    mkdir(SaveOptions.repertoire);
end
nom0          = [SaveOptions.nom_simulation];
[nom1,answer] = TrouveNomFichier(nom0,SaveOptions.repertoire);
if isempty(varargin)||isequal(varargin{1},'ask')
    if answer
        ButtonName    = questdlg('Do you want to overwrite ?','Question','Yes','No','No');
        if isequal(ButtonName,'Yes')
            nom = nom0;
        else
            [filename, pathname] = uiputfile('*.mat', 'Pick an M-file');
            if filename
                SaveOptions.repertoire     = pathname;
                SaveOptions.nom_simulation = filename(1:end-4);
                [nom,rep] = SaveSimulationMAT(Simulation,SaveOptions,varargin{1});
            else
                nom = nom1;
            end
        end
    else
        nom = nom0;
    end
else
    if isequal(varargin{1},'overwrite')
        nom = nom0;
    elseif isequal(varargin{1},'increment')
        if isequal(nom0,nom1)
            nom = [nom0 '_0000'];
        else
            nom = nom1;
        end
    else
        nom = nom1;
    end
end
if ~isequal(varargin{1},'nosave')
    Simulation = ReduitSimulation(Simulation);
    save(fullfile(rep,nom),'Simulation');
end

function [nom,answer] = TrouveNomFichier(nom_in,rep)

nom = nom_in;
I   = 1;
answer = false;
while exist([fullfile(rep,nom) '.mat'])||exist([fullfile(rep,nom) '_0000.mat'])
    answer = true;
    if I<10
        nom = [nom_in '_000' num2str(I)];
    elseif I<100
        nom = [nom_in '_00' num2str(I)];
    elseif I<1000
        nom = [nom_in '_0' num2str(I)];
    else
        nom = [nom_in '_' num2str(I)];        
    end
    I   = I + 1;
end