function WriteInLogWindow(Text,varargin)

if isempty(varargin)
    disp(Text);
else
    handles_listbox_log = varargin{1};
    LogText_temp = get(handles_listbox_log,'String');
    if ~iscell(LogText_temp)
        if ~isempty(LogText_temp)
            LogText{1} = LogText_temp;
        else
            LogText = {};
        end
    else
        LogText = LogText_temp;
    end
    if length(varargin)==1
        LogText{end+1} = Text;
    else
        LogText{end+1-varargin{2}} = Text;
    end
    set(handles_listbox_log,'String',LogText);
    if iscell(LogText)
        set(handles_listbox_log,'value',length(LogText));
    else
        set(handles_listbox_log,'value',1);
    end
end
drawnow