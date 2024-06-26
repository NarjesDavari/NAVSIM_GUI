function Tab = NAVSIM_GenTab_Param(Param)

Tab{1,1} = Param.text;

for I=1:length(Param.Param)
    Tab{2+I,1} = Param.Param(I).title;
    Tab{2+I,2} = Param.Param(I).units;
    Tab{2+I,3} = GetParamStr(Param,Param.Param(I).tag);
    %Tab{2+I,2} = Param.Param(I).val;
    Tab{2+I,4} = Param.Param(I).tooltipstring;
end