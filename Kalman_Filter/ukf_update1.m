%UKF_UPDATE1 -  Additive form Unscented Kalman Filter update step
%
% Syntax:
%   [M,P,K,MU,S,LH] = UKF_UPDATE1(M,P,Y,h,R,param,alpha,beta,kappa,mat)
%
% In:
%   M  - Mean state estimate after prediction step
%   P  - State covariance after prediction step
%   Y  - Measurement vector.
%   h  - Measurement model function as a matrix H defining
%        linear function h(x) = H*x, inline function,
%        function handle or name of function in
%        form h(x,param)
%   R  - Measurement covariance.
%   param - Parameters of a               (optional, default empty)
%   alpha - Transformation parameter      (optional)
%   beta  - Transformation parameter      (optional)
%   kappa - Transformation parameter      (optional)
%   mat   - If 1 uses matrix form         (optional, default 0)
%
% Out:
%   M  - Updated state mean
%   P  - Updated state covariance
%   K  - Computed Kalman gain
%   MU - Predictive mean of Y
%   S  - Predictive covariance Y
%   LH - Predictive probability (likelihood) of measurement.
%   
% Description:
%   Perform additive form Discrete Unscented Kalman Filter (UKF)
%   measurement update step. Assumes additive measurement
%   noise.
%
%   Function h should be such that it can be given
%   DxN matrix of N sigma Dx1 points and it returns 
%   the corresponding measurements for each sigma
%   point. This function should also make sure that
%   the returned sigma points are compatible such that
%   there are no 2pi jumps in angles etc.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [M,P] = ukf_update1(M,P,Y,H,R,alpha,beta,kappa)

  %
  % Do transform and make the update
  %
  [MU,S,C] = ut_transform_updt(M,P,H,alpha,beta,kappa);
  S = S + R;
  K = C / S;
  M = M + K * (Y - MU);
  P = P - K * S * K';
