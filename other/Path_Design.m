% function [ output_args ] = Path_Design( input_args )
t1=0:0.1:50;
x1=zeros(501,1);
y1=zeros(501,1);
z1=(10+(.000001*(t1-t1)))';
r1=zeros(501,1);
t2=50.1:.1:300;
x2=-(1*sin(pi*(t2-50.1)/100))';
y2=(1*(t2-50.1))';
z2=(10+(.000001*(t2-t2)))';
r2=(1*sin(pi*(t2-50.1)/100))*pi/180;
% plot3(x2,y2,z2,'.')
% Path=[x2,y2,z2,t2',r2'];

Path=[];
x=[x1;x2];
y=[y1;y2];
z=[z1;z2];
t=[t1';t2'];
r=[r1;r2'];
plot(x,'.')
plot3(x,y,z,'.')
Path=[x,y,z,t,r];
% end

