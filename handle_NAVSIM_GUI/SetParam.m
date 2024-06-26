function Param = SetParam(Param,Property,val)

Index = [];
for I=1:length(Param.Param)
    if strcmp(lower(Property),lower(Param.Param(I).tag))
        Index = [Index I];
    end
end

if length(Index)==1
    if strcmp(Param.Param(Index).style,'edit')||strcmp(Param.Param(Index).style,'checkbox')
        Param.Param(Index).val = val;
    elseif strcmp(Param.Param(Index).style,'popupmenu')
        if isnum(val)
            Param.Param(Index).val = val;
        else
            Index2 = [];
            for I=1:length(Param.Param(Index).choix)
                if strcmp(lower(val),lower(Param.Param(Index).choix{I}))
                    Index2 = [Index2 I];
                end
            end
            if length(Index2)==1
                Param.Param(Index).val = Index2;
            end
        end
    else
        val = [];
    end
end