%UKF_PREDICT1  Nonaugmented (Additive) UKF prediction step
%
% Syntax:
%   [M,P] = UKF_PREDICT1(M,P,[a,Q,param,alpha,beta,kappa,mat])
%
% In:
%   M - Nx1 mean state estimate of previous step
%   P - NxN state covariance of previous step
%   a - Dynamic model function as a matrix A defining
%       linear function a(x) = A*x, inline function,
%       function handle or name of function in
%       form a(x,param)                   (optional, default eye())
%   Q - Process noise of discrete model   (optional, default zero)
%   param - Parameters of a               (optional, default empty)
%   alpha - Transformation parameter      (optional)
%   beta  - Transformation parameter      (optional)
%   kappa - Transformation parameter      (optional)
%   mat   - If 1 uses matrix form         (optional, default 0)
%
% Out:
%   M - Updated state mean
%   P - Updated state covariance
%
% Description:
%   Perform additive form Unscented Kalman Filter prediction step.
%
%   Function a should be such that it can be given
%   DxN matrix of N sigma Dx1 points and it returns 
%   the corresponding predictions for each sigma
%   point. 


function [M,P] = ukf_predict1(M,P,Q,dt,alpha,beta,kappa)

  %
  % Do transform
  % and add process noise
  %
  [M,P] = ut_transform_pred(M,P,dt,alpha,beta,kappa);
  P = P + Q;

