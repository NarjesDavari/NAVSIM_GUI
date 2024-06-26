function [Param,sortie] = DynGUI_Parameters(Param)


handles  = DynGUI_BuildGUIParam(Param);

Param    = handles.Param;
try
    sortie   = handles.output{2};
end