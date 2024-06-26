function [ heading_G] = remove_GPSHeading_jump( Simulation )
    x=Simulation.Output.ESKF.O_corrected(:,9)*180/pi;
    Dlength=length(x);
    dH   = diff(x);
    heading1=x;     
    for i=1:Dlength-1
        if dH(i)<-200
            heading1(i+1:end,:)=heading1(i+1:end,:)+360;
        end
        if dH(i)>200
            heading1(i+1:end,:)=heading1(i+1:end,:)-360;
        end        
    end
    heading_G=heading1;
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
