function [ phi,theta,psi ] = Corrected_Euler( C_bton )

    phi   = atan2(C_bton(3,2),C_bton(3,3));
    
    theta = -atan(C_bton(3,1)/sqrt(1-C_bton(3,1)^2));
    
    psi   = atan2(C_bton(2,1),C_bton(1,1));


end

