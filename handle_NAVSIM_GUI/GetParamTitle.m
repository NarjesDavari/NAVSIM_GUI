function val = GetParamTitle(Param,Property)

Index = [];
for I=1:length(Param.Param)
    if strcmp(lower(Property),lower(Param.Param(I).tag))
        Index = [Index I];
    end
end

if length(Index)==1
    val = Param.Param(Index).title;
else
    val = [];
end