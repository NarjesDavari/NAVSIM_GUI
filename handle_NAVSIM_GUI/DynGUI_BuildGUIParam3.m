function handles = DynGUI_BuildGUIParam2(Param)

%% Parametres:
% Param{1} = GenererParamTest01;
% Param{2} = GenererParamTest02;

%% Creation de la figure et de la structure handle:
scrsz = get(0,'ScreenSize');
%figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2])
fig     = figure('menubar','none','numbertitle','off','Resize','off','Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]);
handles = guihandles(fig);
handles.fig = fig;
handles.htxt_title        = [];
handles.htxt_units        = [];
handles.h                 = [];
handles.Param             = Param;
handles.Paramold          = Param;
handles.output{1}         = Param;

%% Ajout du navigateur de parametres:
posfig  = get(fig,'position');
posfig(4) = posfig(4)+30+80;
posfig(2) = posfig(4)+30-100;
posfig  = get(fig,'position');
scrsz = get(0,'ScreenSize');
posfig  = [10 length(Param{1}.Param)*25+160 posfig(3) length(Param{1}.Param)*25+160];
set(fig,'Position',posfig);

width   = 160;
height  = 20;
spacing = 5;
% start   = 15;

for I=1:length(Param)
    Liste{I} = Param{I}.name;
end
I       = 1;
handles.Param                 = Param;
[htxt_title,htxt_units,h]     = updateIHM(I,handles.fig,handles.Param{I}.Param,70);
handles.htxt_title            = htxt_title;
handles.htxt_units            = htxt_units;
handles.h                     = h;
handles.Iold                  = 1;

%% Ajout des boutons OK / Cancel
handles.pushbutton_OK     = uicontrol('Parent',handles.fig,'tag','pushbutton_OK','Style','pushbutton','string','OK','value',1,'Position', [spacing spacing width height],'TooltipString','Quit & Update','Callback',@pushbutton_OK_callback);
handles.pushbutton_Cancel = uicontrol('Parent',handles.fig,'tag','pushbutton_Cancel','Style','pushbutton','string','Cancel','value',1,'Position', [posfig(3)-spacing-width spacing width height],'TooltipString','Quit without saving','Callback',@pushbutton_Cancel_callback);

% handles = guidata(handles.fig,handles);
uiwait(handles.fig);
try
    delete(handles.fig);
end
%% Ajout des boutons OK/Cancel
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function menu_choix_callback(hObject,eventdata)


        I = get(hObject,'value');
        handles.Param{handles.Iold }.Param    = Read(handles.Param{handles.Iold }.Param);
        handles.Iold = I;
        delete(handles.htxt_title);
        delete(handles.htxt_units);
        delete(handles.h);

        [htxt_title,htxt_units,h] = updateIHM(I,handles.fig,handles.Param{I}.Param,70);
        handles.htxt_title        = htxt_title;
        handles.htxt_units        = htxt_units;
        handles.h                 = h;

        guidata(hObject, handles);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pushbutton_OK_callback(hObject,eventdata)
        uiresume(handles.fig);
        I = get(handles.popupmenu_choix,'value');
        handles.Param{I}.Param    = Read(handles.Param{I}.Param);

        handles.output{1} = handles.Param;
        handles.output{2} = 'OK';
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pushbutton_Cancel_callback(hObject,eventdata)
        uiresume(handles.fig);
        handles.output{1} = handles.Paramold;
        handles.output{2} = 'Cancel';        
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function pushbutton_reset_callback(hObject,eventdata)
        
        I = get(handles.popupmenu_choix,'value');
        handles.Param{I} = handles.Paramold{I};
        delete(handles.htxt_title);
        delete(handles.htxt_units);
        delete(handles.h);
        [htxt_title,htxt_units,h] = updateIHM(I,handles.fig,handles.Param{I}.Param,70);
        handles.htxt_title        = htxt_title;
        handles.htxt_units        = htxt_units;
        handles.h                 = h;

        guidata(hObject, handles);
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    function Param = Read(Param)
        for J=1:length(Param)
            if strcmp(Param(J).style,'edit')
                Param(J).val = get(handles.h(J),'string');
            elseif strcmp(Param(J).style,'popupmenu')
                Param(J).val = get(handles.h(J),'value');
            elseif strcmp(Param(J).style,'checkbox')
                Param(J).val = get(handles.h(J),'value');
            end
        end
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [htxt_title,htxt_units,h] = updateIHM(PP,fig,Param,start)

    scrsz = get(0,'ScreenSize');
    posfig  = get(fig,'position');
    posfig  = [round(scrsz(3)/10)+1 scrsz(4)-(length(Param)*25+120) posfig(3) length(Param)*25+80];
    % posfig(4) = posfig(4)+30;
    set(fig,'Position',posfig);
    P = 1;
    if isfield(handles,'text_choix')
        set(handles.text_choix,'Parent',fig,'Style','text','string','Choose Parameters:','Position', [spacing posfig(4)-P*height width height],'TooltipString','Choose the parameters you want to edit');
    else
        handles.text_choix            = uicontrol('Parent',fig,'Style','text','string','Choose Parameters:','Position', [spacing posfig(4)-P*height width height],'TooltipString','Choose the parameters you want to edit');
    end
    if isfield(handles,'popupmenu_choix')
        set(handles.popupmenu_choix,'Parent',fig,'tag','menu_choix','Style','popupmenu','string',Liste,'value',PP,'Position', [2*spacing+width posfig(4)-P*height width height],'TooltipString','Choose the parameters you want to edit','Callback',@menu_choix_callback);
    else
        handles.popupmenu_choix       = uicontrol('Parent',fig,'tag','menu_choix','Style','popupmenu','string',Liste,'value',1,'Position', [2*spacing+width posfig(4)-P*height width height],'TooltipString','Choose the parameters you want to edit','Callback',@menu_choix_callback);
    end
    if isfield(handles,'pushbutton_reset')
        set(handles.pushbutton_reset,'Parent',fig,'tag','menu_choix','Style','pushbutton','string','reset','Position', [3*spacing+2*width posfig(4)-P*height width height],'TooltipString','Reset Default Parameters','Callback',@pushbutton_reset_callback);
    else
        handles.pushbutton_reset      = uicontrol('Parent',fig,'tag','menu_choix','Style','pushbutton','string','reset','Position', [3*spacing+2*width posfig(4)-P*height width height],'TooltipString','Reset Default Parameters','Callback',@pushbutton_reset_callback);
    end

    width   = 160;
    height  = 20;
    spacing = 5;
    % start   = 60;

    I       = 1;
    for I = 1:length(Param)
        if strcmp(Param(I).style,'checkbox')
            h(I) = uicontrol('Parent',fig,'Style','checkbox','string',Param(I).title,'value',Param(I).val,'Position', [spacing posfig(4)-spacing-start-(I-1)*(spacing+height) width*3+2*spacing height],'TooltipString',Param(I).tooltipstring);
        else
            htxt_title(I) = uicontrol('Parent',fig,'Style','text','string',Param(I).title,'Position', [spacing posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString',Param(I).tooltipstring);
            if strcmp(Param(I).style,'edit')
                htxt_units(I) = uicontrol('Parent',fig,'Style','text','string',Param(I).units,'Position', [3*spacing+2*width posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString',Param(I).tooltipstring);            
                if ischar(Param(I).val)
                    h(I) = uicontrol('Parent',fig,'Style','edit','string',Param(I).val,'Max',2,'Position', [2*spacing+width posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString','Points placed within square bracket and separated with a semi-colons (Ex: [x1,y1,z1,t1];[x2,y2,z2,t2];...;[xn,yn,zn,tn])');
                else
                    h(I) = uicontrol('Parent',fig,'Style','edit','string',num2str(Param(I).val),'Max',2,'Position', [2*spacing+width posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString','Points placed within square bracket and separated with a semi-colons (Ex: [x1,y1,z1,t1];[x2,y2,z2,t2];...;[xn,yn,zn,tn])');
                end 
            elseif strcmp(Param(I).style,'popupmenu')  
                htxt_units(I) = uicontrol('Parent',fig,'Style','text','string',Param(I).units,'Position', [3*spacing+2*width posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString',Param(I).tooltipstring);            
                h(I) = uicontrol('Parent',fig,'Style','popupmenu','string',Param(I).choix,'value',Param(I).val,'Position', [2*spacing+width posfig(4)-spacing-start-(I-1)*(spacing+height) width height],'TooltipString',Param(I).tooltipstring);          
            end
        end
    end

end
end