function [Simulation,t1,t2]=Data_Lose(Simulation,N,time_outage,Start_Time_out)

timeinterval_gps=Simulation.Input.Measurements.GPS(2,1)-Simulation.Input.Measurements.GPS(1,1);

interval_lose=round(time_outage/timeinterval_gps);
t1=zeros(1,N);
t2=zeros(1,N);
init=round(Start_Time_out*60/timeinterval_gps);   %%1.0655e4 fir test 3; %%%init_timeStep
gps1=Simulation.Input.Measurements.GPS;

Dlength=length(Simulation.Input.Measurements.GPS(:,1));
% gps=zeros(Dlength,4);
L_G=Dlength;
distance_data=round((L_G-init-N*interval_lose-N)/N);
gps(1:init,:)=gps1(1:init,:);
for i=1:N
    gps(init+1+(i-1)*distance_data:init+i*distance_data,:)=gps1(init+i*interval_lose+(i-1)*distance_data+1:init+i*(interval_lose+distance_data),:);
    t11(i)=gps1(init+(i-1)*(interval_lose+distance_data)+1,1);
    t22(i)=gps1(init+i*(interval_lose)+(i-1)*distance_data,1);
end
 t1=((round(t11*1e4))/100)+1; %%time step in IMU 

t2=((round(t22*1e4))/100)+1;   %%time step in IMU


Simulation.Input.Measurements.GPS   = gps;
