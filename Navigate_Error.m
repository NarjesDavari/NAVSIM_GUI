%computation of distance of P(j+1) from P(j) in Reference(designed) Path & 
%Travelled distance on the timestep j with respect to initial point &
%distance between Point in Reference(real) path and travelled(computed) path and
%navigation error at every timestep
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ Simulation] = Navigate_Error( Simulation , CalculType, ave_sample )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    select_navsim_mode = Simulation.Input.NAVSIM_Mode;
    N                  = GetParam(Simulation.Init_Value ,'simulation_number');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

     if strcmp(CalculType,'EKF')
     end
    %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
      if strcmp(CalculType,'UKF')
      end
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     if strcmp(CalculType,'DR') 
         Dlength            = length(Simulation.Input.Measurements.IMU)-1;
         if strcmp(select_navsim_mode,'User Defined Path Simulation')
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XN=zeros(Dlength,1); 
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XE=zeros(Dlength,1);
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XD=zeros(Dlength,1);
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VN=zeros(Dlength,1);
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VE=zeros(Dlength,1);
            Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VD=zeros(Dlength,1);
         end
            %Creation of space in memory for relative and absolute error
            Simulation.Output.DR.Pos_Error.relative_error_i=zeros(Dlength-1,N);
            Simulation.Output.DR.Pos_Error.absolute_error_i=zeros(Dlength,N); 
            Simulation.Output.DR.Pos_Error.RMSE_i=zeros(N,1);
            Simulation.Output.DR.Pos_Error.RMSEx_i=zeros(N,1);
            Simulation.Output.DR.Pos_Error.RMSEy_i=zeros(N,1);
            Simulation.Output.DR.Pos_Error.RMSEz_i=zeros(N,1);            
            
            %inserting of travelled time and distance in memory
            Simulation.Output.DR.Pos_Error.travelled_time     = Simulation.Input.Measurements.IMU(Dlength,1,1) ; 
            Simulation.Output.DR.Pos_Error.travelled_distance = Simulation.Input.Path.s_i(end); 
            
            Simulation.Output.DR.Pos_Error.travelled_distancex=Simulation.Input.Path.sx_i(end);
            Simulation.Output.DR.Pos_Error.travelled_distancey=Simulation.Input.Path.sy_i(end);
            Simulation.Output.DR.Pos_Error.travelled_distancez=Simulation.Input.Path.sz_i(end);
            %computation of the difference of Points in designed(Reference) path and
            %estimated(computed) path  at every timestep
            for i=1:N
                diff_P_Pos      =Simulation.Input.Measurements.Ref_Pos(1:Dlength,2:4)-Simulation.Output.DR.Pos_m(:,:,i);%(:,3) 
                
                sqr_diff_P_XPos =diff_P_Pos.^2;%(:,3)
                
                Simulation.Output.DR.Pos_Error.RMSE_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos,2)));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                diff_P_Posx=Simulation.Input.Measurements.Ref_Pos(1:Dlength,2)-Simulation.Output.DR.Pos_m(:,1,i);
                diff_P_Posy=Simulation.Input.Measurements.Ref_Pos(1:Dlength,3)-Simulation.Output.DR.Pos_m(:,2,i);
                diff_P_Posz=Simulation.Input.Measurements.Ref_Pos(1:Dlength,4)-Simulation.Output.DR.Pos_m(:,3,i);
                
                sqr_diff_P_XPos_x=diff_P_Posx.^2;
                sqr_diff_P_XPos_y=diff_P_Posy.^2;
                sqr_diff_P_XPos_z=diff_P_Posz.^2;
                
                Simulation.Output.DR.Pos_Error.RMSEx_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_x,2)));
                Simulation.Output.DR.Pos_Error.RMSEy_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_y,2)));
                Simulation.Output.DR.Pos_Error.RMSEz_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_z,2)));
                
                Simulation.Output.DR.Pos_Error.RMSEx_ave=mean(Simulation.Output.DR.Pos_Error.RMSEx_i);
                Simulation.Output.DR.Pos_Error.RMSEy_ave=mean(Simulation.Output.DR.Pos_Error.RMSEy_i);
                Simulation.Output.DR.Pos_Error.RMSEz_ave=mean(Simulation.Output.DR.Pos_Error.RMSEz_i);
                
                Simulation.Output.DR.Pos_Error.Relative_RMSEx_ave=Simulation.Output.DR.Pos_Error.RMSEx_ave*100/...
                                                                                 Simulation.Output.DR.Pos_Error.travelled_distancex;
                Simulation.Output.DR.Pos_Error.Relative_RMSEy_ave=Simulation.Output.DR.Pos_Error.RMSEy_ave*100/...
                                                                                 Simulation.Output.DR.Pos_Error.travelled_distancey;
                Simulation.Output.DR.Pos_Error.Relative_RMSEz_ave=Simulation.Output.DR.Pos_Error.RMSEz_ave*100/...
                                                                                 Simulation.Output.DR.Pos_Error.travelled_distancez;                                                                            
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                %absolute error between Points in designed(real) path and estimated(computed) path at every timestep
                absolute_error_i=sqrt(sum(sqr_diff_P_XPos,2));
                
                %computation of navigation error at every timestep
                relative_error_i=(absolute_error_i(1:Dlength-1)./Simulation.Input.Path.s_i((1:Dlength-1)))*100;                 
                Simulation.Output.DR.Pos_Error.relative_error_i(:,i)=relative_error_i;
                Simulation.Output.DR.Pos_Error.absolute_error_i(:,i)=absolute_error_i;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(select_navsim_mode,'User Defined Path Simulation')
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XN = abs(Simulation.Output.DR.X(:,1)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(1:Dlength,1)*(pi/180)); 
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XE = abs(Simulation.Output.DR.X(:,2)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(1:Dlength,2)*(pi/180)); 
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_XD = abs(Simulation.Output.DR.X(:,3)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(1:Dlength,3)); 
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VN = abs(Simulation.Output.DR.X(:,4)-... 
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(:,1));
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VE = abs(Simulation.Output.DR.X(:,5)-...
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(:,2));
                    Simulation.Output.User_Def_Sim.DR.Pos_Error.diff_VD = abs(Simulation.Output.DR.X(:,6)-...
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(:,3));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                    
                end                              
            end
            RMSE_ave=mean(Simulation.Output.DR.Pos_Error.RMSE_i);        
            Simulation.Output.DR.Pos_Error.RMSE_ave=RMSE_ave;
            Simulation.Output.DR.Pos_Error.Relative_RMSE_ave=RMSE_ave*100/Simulation.Output.DR.Pos_Error.travelled_distance;
            
            Simulation.Output.DR.Pos_Error.ave_relative_error_i=mean(Simulation.Output.DR.Pos_Error.relative_error_i,2);
            Simulation.Output.DR.Pos_Error.ave_absolute_error_i=mean(Simulation.Output.DR.Pos_Error.absolute_error_i,2);
            
            Simulation.Output.DR.Pos_Error.ave_absolute_error_end=Simulation.Output.DR.Pos_Error.absolute_error_i(end,1);
            Simulation.Output.DR.Pos_Error.ave_relative_error_end=Simulation.Output.DR.Pos_Error.relative_error_i(end,1);
     end      
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     if strcmp(CalculType,'FeedBack') 
         Dlength            = length(Simulation.Input.Measurements.IMU);
         if strcmp(select_navsim_mode,'User Defined Path Simulation')
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XN=zeros(Dlength-ave_sample+1,1); 
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XE=zeros(Dlength-ave_sample+1,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XD=zeros(Dlength-ave_sample+1,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VN=zeros(Dlength-ave_sample,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VE=zeros(Dlength-ave_sample,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VD=zeros(Dlength-ave_sample,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_R=zeros(Dlength-ave_sample+1,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_P=zeros(Dlength-ave_sample+1,1);
            Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y=zeros(Dlength-ave_sample+1,1);
         end
            %Creation of space in memory for relative and absolute error
            Simulation.Output.ESKF.Pos_Error.relative_error_i=zeros(Dlength- ave_sample,N);
            Simulation.Output.ESKF.Pos_Error.absolute_error_i=zeros(Dlength- ave_sample+1,N); 
            Simulation.Output.ESKF.Pos_Error.RMSE_i=zeros(N,1);
            Simulation.Output.ESKF.Pos_Error.RMSEx_i=zeros(N,1);
            Simulation.Output.ESKF.Pos_Error.RMSEy_i=zeros(N,1);
            Simulation.Output.ESKF.Pos_Error.RMSEz_i=zeros(N,1);            
            
            %inserting of travelled time and distance in memory
            Simulation.Output.ESKF.Pos_Error.travelled_time     = Simulation.Input.Measurements.IMU(end,1) - Simulation.Input.Measurements.IMU(ave_sample,1);
            Simulation.Output.ESKF.Pos_Error.travelled_distance = Simulation.Input.Path.s_i(end); 
            
            Simulation.Output.ESKF.Pos_Error.travelled_distancex=Simulation.Input.Path.sx_i(end);
            Simulation.Output.ESKF.Pos_Error.travelled_distancey=Simulation.Input.Path.sy_i(end);
            Simulation.Output.ESKF.Pos_Error.travelled_distancez=Simulation.Input.Path.sz_i(end);
            %computation of the difference of Points in designed(Reference) path and
            %estimated(computed) path  at every timestep
            for i=1:N
                diff_P_Pos      =Simulation.Input.Measurements.Ref_Pos(ave_sample:end,2:4)-Simulation.Output.ESKF.Pos_m(:,:,i);%(:,3) 
                
                sqr_diff_P_XPos =diff_P_Pos.^2;%(:,3)
                
                Simulation.Output.ESKF.Pos_Error.RMSE_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos,2)));
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                diff_P_Posx=Simulation.Input.Measurements.Ref_Pos(ave_sample:end,2)-Simulation.Output.ESKF.Pos_m(:,1,i);
                diff_P_Posy=Simulation.Input.Measurements.Ref_Pos(ave_sample:end,3)-Simulation.Output.ESKF.Pos_m(:,2,i);
                diff_P_Posz=Simulation.Input.Measurements.Ref_Pos(ave_sample:end,4)-Simulation.Output.ESKF.Pos_m(:,3,i);
                
                sqr_diff_P_XPos_x=diff_P_Posx.^2;
                sqr_diff_P_XPos_y=diff_P_Posy.^2;
                sqr_diff_P_XPos_z=diff_P_Posz.^2;
                
                Simulation.Output.ESKF.Pos_Error.RMSEx_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_x,2)));
                Simulation.Output.ESKF.Pos_Error.RMSEy_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_y,2)));
                Simulation.Output.ESKF.Pos_Error.RMSEz_i(i,:)=sqrt(mean(sum(sqr_diff_P_XPos_z,2)));
                
                Simulation.Output.ESKF.Pos_Error.RMSEx_ave=mean(Simulation.Output.ESKF.Pos_Error.RMSEx_i);
                Simulation.Output.ESKF.Pos_Error.RMSEy_ave=mean(Simulation.Output.ESKF.Pos_Error.RMSEy_i);
                Simulation.Output.ESKF.Pos_Error.RMSEz_ave=mean(Simulation.Output.ESKF.Pos_Error.RMSEz_i);
                
                Simulation.Output.ESKF.Pos_Error.Relative_RMSEx_ave=Simulation.Output.ESKF.Pos_Error.RMSEx_ave*100/...
                                                                                 Simulation.Output.ESKF.Pos_Error.travelled_distancex;
                Simulation.Output.ESKF.Pos_Error.Relative_RMSEy_ave=Simulation.Output.ESKF.Pos_Error.RMSEy_ave*100/...
                                                                                 Simulation.Output.ESKF.Pos_Error.travelled_distancey;
                Simulation.Output.ESKF.Pos_Error.Relative_RMSEz_ave=Simulation.Output.ESKF.Pos_Error.RMSEz_ave*100/...
                                                                                 Simulation.Output.ESKF.Pos_Error.travelled_distancez;                                                                            
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%               
                %absolute error between Points in designed(real) path and estimated(computed) path at every timestep
                absolute_error_i=sqrt(sum(sqr_diff_P_XPos,2));
                
                %computation of navigation error at every timestep
                relative_error_i=(absolute_error_i(1:Dlength-ave_sample)./Simulation.Input.Path.s_i)*100;                 
                Simulation.Output.ESKF.Pos_Error.relative_error_i(:,i)=relative_error_i;
                Simulation.Output.ESKF.Pos_Error.absolute_error_i(:,i)=absolute_error_i;
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                if strcmp(select_navsim_mode,'User Defined Path Simulation')
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XN = abs(Simulation.Output.INS.X_INS(:,1)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(ave_sample:end,1)*(pi/180)); 
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XE = abs(Simulation.Output.INS.X_INS(:,2)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(ave_sample:end,2)*(pi/180)); 
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_XD = abs(Simulation.Output.INS.X_INS(:,3)-...
                                                                                Simulation.Input.User_Def_Sim.Path.P_deg(ave_sample:end,3)); 
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VN = abs(Simulation.Output.INS.X_INS(1:end-1,4)-... 
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(ave_sample:end,1));
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VE = abs(Simulation.Output.INS.X_INS(1:end-1,5)-...
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(ave_sample:end,2));
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_VD = abs(Simulation.Output.INS.X_INS(1:end-1,6)-...
                                                                                Simulation.Input.User_Def_Sim.Path.velocity(ave_sample:end,3));
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    diff_roll_o  = Simulation.Output.INS.X_INS(:,7) - Simulation.Input.User_Def_Sim.Gyro_Compass.R(ave_sample:end,1);
                    diff_pitch_o = Simulation.Output.INS.X_INS(:,8) - Simulation.Input.User_Def_Sim.Gyro_Compass.P(ave_sample:end,1);
                    diff_Yaw_o   = Simulation.Output.INS.X_INS(:,9) - Simulation.Input.User_Def_Sim.Gyro_Compass.Y(ave_sample:end,1);
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_R  = abs(diff_roll_o);
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_P  = abs(diff_pitch_o);
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.diff_Y  = abs(diff_Yaw_o);   
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.sigma_R  = std(diff_roll_o)*180/pi;
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.sigma_P  = std(diff_pitch_o)*180/pi;  
    
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.max_R  = max(diff_roll_o)*180/pi;
                    Simulation.Output.User_Def_Sim.ESKF.Pos_Error.max_P  = max(diff_pitch_o)*180/pi; 
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                     diff_pitch = Simulation.Output.Alignment.theta(1:Simulation.Output.Alignment.RP_counter,:)-...
%                                  Simulation.Output.User_Def_Sim.INS.Alignment.true_pitch(ave_sample:Simulation.Output.Alignment.RP_counter,:) ;
%                              
%                     diff_roll  = Simulation.Output.Alignment.phi(1:Simulation.Output.Alignment.RP_counter)-...
%                                  Simulation.Output.User_Def_Sim.INS.Alignment.true_roll(ave_sample:Simulation.Output.Alignment.RP_counter,:);
%                              
%                     Simulation.Output.User_Def_Sim.INS.Alignment.diff_P = abs(diff_pitch)*180/pi; 
%                     Simulation.Output.User_Def_Sim.INS.Alignment.diff_R = abs(diff_roll)*180/pi;
%     
%                     Simulation.Output.User_Def_Sim.INS.Alignment.sigma_P = std(diff_pitch)*180/pi;
%                     Simulation.Output.User_Def_Sim.INS.Alignment.sigma_R = std(diff_roll)*180/pi;
%     
%                     Simulation.Output.User_Def_Sim.INS.Alignment.max_P = max(diff_pitch)*180/pi;
%                     Simulation.Output.User_Def_Sim.INS.Alignment.max_R = max(diff_roll)*180/pi; 
                    
                    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    Simulation.Output.ESKF.Bias_Error.RMSE_Bax=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,10)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Bax(ave_sample:end,1)).^2,2)));
                   
                     Simulation.Output.ESKF.Bias_Error.RMSE_Bay=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,11)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Bay(ave_sample:end,1)).^2,2)));
                              
                     Simulation.Output.ESKF.Bias_Error.RMSE_Baz=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,12)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Accelerometer.Baz(ave_sample:end,1)).^2,2)));  
                                                  
                     Simulation.Output.ESKF.Bias_Error.RMSE_Bgx=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,13)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgx(ave_sample:end,1)).^2,2)));                             
                     
                     Simulation.Output.ESKF.Bias_Error.RMSE_Bgy=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,14)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgy(ave_sample:end,1)).^2,2)));                              
                     
                     Simulation.Output.ESKF.Bias_Error.RMSE_Bgz=sqrt(mean(sum((Simulation.Output.INS.X_INS(:,15)-...
                                                      Simulation.Output.User_Def_Sim.Noise.IMUer.Gyro.Bgz(ave_sample:end,1)).^2,2))); 
                    
                end                              
            end
            RMSE_ave=mean(Simulation.Output.ESKF.Pos_Error.RMSE_i);        
            Simulation.Output.ESKF.Pos_Error.RMSE_ave=RMSE_ave;
            Simulation.Output.ESKF.Pos_Error.Relative_RMSE_ave=RMSE_ave*100/Simulation.Output.ESKF.Pos_Error.travelled_distance;
            
            Simulation.Output.ESKF.Pos_Error.ave_relative_error_i=mean(Simulation.Output.ESKF.Pos_Error.relative_error_i,2);
            Simulation.Output.ESKF.Pos_Error.ave_absolute_error_i=mean(Simulation.Output.ESKF.Pos_Error.absolute_error_i,2);
            
            Simulation.Output.ESKF.Pos_Error.ave_absolute_error_end=Simulation.Output.ESKF.Pos_Error.absolute_error_i(end,1);
            Simulation.Output.ESKF.Pos_Error.ave_relative_error_end=Simulation.Output.ESKF.Pos_Error.relative_error_i(end,1);
     end      
     %@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
     if strcmp(CalculType,'FeedForward')

     end     
     
end