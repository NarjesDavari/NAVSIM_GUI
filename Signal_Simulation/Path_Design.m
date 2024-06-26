%Path Design
function [Simulation]=Path_Design(Simulation , handles_listbox_log,ave_sample)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Constant Parameters of the Earth
    %%R=6378137;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %Sampling frequency
	fs         = GetParam(Simulation.Init_Value ,'Sampling_Frequency');
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     try
        if isfield(Simulation.Input.User_Def_Sim,'Path')
            Path = Simulation.Input.User_Def_Sim.Path.Points;
            %Path:Points applied by user as the main path
            xx=Path(:,1);
            yy=Path(:,2);
            zz=Path(:,3);
            tt=Path(:,4);
            %roll in radian
            rr=Path(:,5);
            %dt:Time step
            dt=1/fs;
            tti=0:dt:max(tt);
            % interpolates the values of the points xx, yy, zz and roll at
            % the points tti
            
            xxi=interp1(tt,xx,tti,'pchip');
            yyi=interp1(tt,yy,tti,'pchip');
            zzi=interp1(tt,zz,tti,'pchip');
            rri=interp1(tt,rr,tti,'pchip');

            Plength=length(xxi);
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %P_ned:Designed (Reference) path with respect to the surface of the earth in meters
            Simulation.Input.User_Def_Sim.Path.P_ned=zeros(Plength,4);
            xxi=xxi';
            yyi=yyi';
            zzi=zzi';
            tti=tti';
%              Simulation.Input.User_Def_Sim.Path.P_ned=[xxi(ave_sample:end),yyi(ave_sample:end),zzi(ave_sample:end),tti(1:Plength-ave_sample+1)];   
              Simulation.Input.User_Def_Sim.Path.P_ned=[xxi,yyi,zzi,tti]; 
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            rri=rri';
            Simulation.Input.User_Def_Sim.Path.User_Roll=zeros(Plength,1);
            Simulation.Input.User_Def_Sim.Path.User_Roll=rri;
            
        else
            WriteInLogWindow('User-Defined Path have not been loaded',handles_listbox_log); 
            warndlg('User-Defined Path have not been loaded','Warning','modal')            
        end
%     catch
%         WriteInLogWindow('User-Defined Path have not been loaded',handles_listbox_log); 
%         warndlg('User-Defined Path have not been loaded','Warning','modal') 
%     end
