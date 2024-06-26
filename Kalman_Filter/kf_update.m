%KF_UPDATE  Kalman Filter update step
% In:
%   X - Nx1 mean state estimate after prediction step
%   P - NxN state covariance after prediction step
%   y - Dx1 measurement vector.
%   H - Measurement matrix.
%   R - Measurement noise covariance.
% Out:
%   X  - Updated state mean
%   P  - Updated state covariance
%   K  - Computed Kalman gain
%   IM - Mean of predictive distribution of y
%   IS - Covariance or predictive mean of y
% Description:
%   Kalman filter measurement update step. Kalman Filter
%Reference: My thesis pages 60-63
function [X,P,K] = kf_update(X,P,y,H,R)

  % update step  
  IM = H*X;                 
  IS = (R + H*P*H');       
  K = P*H'/IS;              
  X = X + K * (y-IM);       
%   P = P - K*IS*K';  
    P = P - K*H*P; 
end