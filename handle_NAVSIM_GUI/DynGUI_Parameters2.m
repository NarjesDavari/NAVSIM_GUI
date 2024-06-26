function [Param,sortie] = DynGUI_Parameters2(Param)


handles  = DynGUI_BuildGUIParam2(Param);

Param    = handles.Param;
try
    sortie   = handles.output{2};
end