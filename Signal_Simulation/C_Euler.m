%Computation of direction cosine matrices due to three successive rotations
%about different axes
%C_psi:rotate about reference z-axis
%C_theta:rotate about new y-axis
%C_phi:rotate about new x-axis
%Reference : Strapdown inertial navigation system (Chapter 3 page 41)
function [ C_psi,C_theta,C_phi ] = C_Euler( psi,theta,phi )
    
    C_psi(1,1) =  cos(psi);
	C_psi(1,2) =  sin(psi);
	C_psi(1,3) =  0;
	C_psi(2,1) =  -sin(psi);
	C_psi(2,2) =  cos(psi);
	C_psi(2,3) =  0;
	C_psi(3,1) =  0;
	C_psi(3,2) =  0;
	C_psi(3,3) =  1;
   
    C_theta(1,1) =  cos(theta);
	C_theta(1,2) =  0;
	C_theta(1,3) =  -sin(theta);
	C_theta(2,1) =  0;
	C_theta(2,2) =  1;
	C_theta(2,3) =  0;
	C_theta(3,1) =  sin(theta);
	C_theta(3,2) =  0;
	C_theta(3,3) =  cos(theta);
    
    C_phi(1,1) =  1;
	C_phi(1,2) =  0;
	C_phi(1,3) =  0;
	C_phi(2,1) =  0;
	C_phi(2,2) =  cos(phi);
	C_phi(2,3) =  sin(phi);
	C_phi(3,1) =  0;
	C_phi(3,2) =  -sin(phi);
	C_phi(3,3) =  cos(phi);
end

