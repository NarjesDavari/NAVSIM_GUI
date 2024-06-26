%Computation of Q(error covariance matrix) from power spectral density(Qc)
%Reference : My thesis page 57
function [Q] = ekf_lti_disc(F,L,Qc,dt)

  %
  % Closed form integration of covariance
  % by matrix fraction decomposition
  %
%   n   = size(F,1);
%   Phi = [F L*Qc*L'; zeros(n,n) -F'];
%   AB  = expm(Phi*dt)*[zeros(n,n);eye(n)];
%   Q   = AB(1:n,:)/AB((n+1):(2*n),:);
%     Q=F*L*Qc*L'*F'*dt;
    Q=0.5*(F*L*Qc*L'*F'*dt+L*Qc*L'*dt);