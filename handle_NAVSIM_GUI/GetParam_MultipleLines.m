function val = GetParam_MultipleLines(Param,Property,varargin)

try
    Index = [];
    tabtag = cell(length(Param.Param),1);
    for I=1:length(Param.Param)
        tabtag{I} = lower(Param.Param(I).tag);
        if strcmp(lower(Property),lower(Param.Param(I).tag))
            Index = [Index I];
        end
    end

    index_semicolon=find(Param.Param.val==';');
    index_sb=find(Param.Param.val=='[');
    if length(Index)==1
        if ischar(Param.Param(Index).val)
            for I=1:length(index_semicolon)+1
                if I==1
                    val_str=Param.Param(Index).val(1:index_semicolon(1)-1);
                    val(I,:)=eval(['[' val_str ']']);
                else
                    if I~=length(index_sb)
                        val_str=Param.Param(Index).val(index_semicolon(I-1)+1:index_semicolon(I)-1);
                        val(I,:)=eval(['[' val_str ']']);
                    else
                        val_str=Param.Param(Index).val(index_semicolon(I-1)+1:end);
                        val(I,:)=eval(['[' val_str ']']);
                    end
                end
            end
        else
            for I=1:length(index_semicolon)+1
                if I==1
                    val(I,:)=Param.Param(Index).val(1:index_semicolon(1)+1);
                else
                    if I~=length(index_sb)
                        val(I,:)=Param.Param(Index).val(index_semicolon(I-1)+1:index_semicolon(I)-1);
                    else
                        val(I,:)=Param.Param(Index).val(index_semicolon(I-1)+1:end);
                    end
                end
            end
        end
    else
        val = [];
        disp(tabtag);
    end
catch 
    val = [];
    disp(tabtag);    
    errordlg('New path matrix not imported correctly','Error')
end