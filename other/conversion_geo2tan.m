function [xn,xe,h]=conversion_geo2tan(Real_Measurement,kalman_filter)

    a=6378137;%Equatorial radius
    e=0.081819190842621;%eccentricity

%     Time=Real_Measurement.GPS(:,1);
%     lat=Real_Measurement.GPS(:,2);
%     lon=Real_Measurement.GPS(:,3);
%     alt=Real_Measurement.GPS(:,4);

    Time=Real_Measurement.GPS(:,1);
    lat=kalman_filter.L_s;
    lon=kalman_filter.l_s;
    alt=kalman_filter.h_s;
    Dlength=length(lat);
    
    RN=zeros(Dlength,1);
    RE=zeros(Dlength,1);    
    for i=1:Dlength
        RN(i)=a*(1-e^2)/(1-e^2*(sin(lat(i)*pi/180))^2)^1.5;
        RE(i)=a/(1-e^2*(sin(lat(i)*pi/180))^2)^0.5;
    end  
    
    xn=zeros(Dlength,2);
    xe=zeros(Dlength,2);
    h=zeros(Dlength,2);
    
    lat0=lat(1)*ones(Dlength,1);
    lon0=lon(1)*ones(Dlength,1); 
    
    xn(:,2)=(lat-lat0)*(pi/180).*RN;
    xe(:,2)=(lon-lon0)*(pi/180).*cos(lat*pi/180).*RE;
    h(:,2)=alt;
    
    xn(:,1)=Time;
    xe(:,1)=Time;
    h(:,1)=Time;    
    
end