function Tab = NAVSIM_GenTab_DesignedPath(Path)

Tab{1,1} = 'Designed path';

Tab{2,1} = 'The constituent points of the path:';
Tab{3,1} = 't (s)';
Tab{3,2} = 'x (m)';
Tab{3,3} = 'y (m)';
Tab{3,4} = 'z (m)';
for I=1:length(Path.Points)
    Tab{3+I,1} = Path.Points(I,1);    
    Tab{3+I,2} = Path.Points(I,2);
    Tab{3+I,3} = Path.Points(I,3);  
    Tab{3+I,4} = Path.Points(I,4);      
end
Tab{2,6} = 'Designed path in meter:';
Tab{3,6} = 't (s)';
Tab{3,7} = 'x (m)';
Tab{3,8} = 'y (m)';
Tab{3,9} = 'z (m)';
Tab{2,11} = 'Designed path in degree:';
Tab{3,11} = 'Lat (deg)';
Tab{3,12} = 'lon (deg)';
Tab{3,13} = 'alt (m)';
h = waitbar(0,'Designed path is loading ...');
for I=1:length(Path.P_ned)     
    Tab{3+I,6} = Path.P_ned(I,4); 
    Tab{3+I,7} = Path.P_ned(I,1);    
    Tab{3+I,8} = Path.P_ned(I,2);
    Tab{3+I,9} = Path.P_ned(I,3);    

    Tab{3+I,11} = Path.P_geo(I,1);    
    Tab{3+I,12} = Path.P_geo(I,2);
    Tab{3+I,13} = Path.P_geo(I,3);    
    if rem(I,10000)
        waitbar(I/(length(Path.P_ned)/10),h);
    end     
end
delete(h)