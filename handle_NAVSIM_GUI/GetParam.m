%Getting the parameters from GUI figure 
function val = GetParam(Param,Property,varargin)

if ~isempty(varargin)
    if ~isempty(varargin{1})
        Param = EvaluateParameters(Param,varargin{1});
    end
end


Index = [];
tabtag = cell(length(Param.Param),1);
for I=1:length(Param.Param)
    tabtag{I} = lower(Param.Param(I).tag);
    if strcmp(lower(Property),lower(Param.Param(I).tag))
        Index = [Index I];
    end
end

if length(Index)==1
    if strcmp(Param.Param(Index).style,'edit')||strcmp(Param.Param(Index).style,'checkbox')
        if ischar(Param.Param(Index).val)
            val = eval(['[' Param.Param(Index).val ']']);
        else
            val = Param.Param(Index).val;
        end
    elseif strcmp(Param.Param(Index).style,'popupmenu')
        val = Param.Param(Index).choix{Param.Param(Index).val};
    end
else
    val = [];
    disp(tabtag);
end