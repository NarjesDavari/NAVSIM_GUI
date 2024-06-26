%First Order Digital Filter
function [ Real_Measurement_9h ] = Digital_Filter_IMU( Real_Measurement_9h)   
   dt=.01;
   fc=.1;
   Dlength=length(Real_Measurement_9h.IMU(:,1));
   Real_Measurement_9h.IMU_filted05Hz=zeros(Dlength,6);
   for I=2:1:Dlength
   
   Real_Measurement_9h.IMU_filted05Hz(I,1:6)= Real_Measurement_9h.IMU_filted05Hz(I-1,1:6)+2 * pi * fc * dt * ...
       (Real_Measurement_9h.IMU(I,2:7)-Real_Measurement_9h.IMU_filted05Hz(I-1,1:6));
   end



