%RTS_SMOOTH  Rauch-Tung-Striebel smoother
%
% Syntax:
%   [M,P,S] = RTS_SMOOTH(M,P,A,Q)
%
% In:
%   M - NxK matrix of K mean estimates from Kalman filter
%   P - NxNxK matrix of K state covariances from Kalman Filter
%   A - NxN state transition matrix or NxNxK matrix of K state
%       transition matrices for each step.
%   Q - NxN process noise covariance matrix or NxNxK matrix
%       of K state process noise covariance matrices for each step.
%
% Out:
%   M - Smoothed state mean sequence
%   P - Smoothed state covariance sequence
%   S - Smoother gain sequence
%   
% Description:
%   Rauch-Tung-Striebel smoother algorithm. Calculate "smoothed"
%   sequence from given Kalman filter output sequence
%   by conditioning all steps to all measurements.
%
% Example:
%   m = m0;
%   P = P0;
%   MM = zeros(size(m,1),size(Y,2));
%   PP = zeros(size(m,1),size(m,1),size(Y,2));
%   for k=1:size(Y,2)
%     [m,P] = kf_predict(m,P,A,Q);
%     [m,P] = kf_update(m,P,Y(:,k),H,R);
%     MM(:,k) = m;
%     PP(:,:,k) = P;
%   end
%   [SM,SP] = rts_smooth(MM,PP,A,Q);

function [M,P,S] = rts_smooth(M,P,A,Q)

  %
  % Check which arguments are there
  %
  if nargin < 4
    error('Too few arguments');
  end

  %
  % Extend A and Q if they are NxN matrices
  %
  if size(A,3)==1
    A = repmat(A,[1 1 size(M,1)]);
  end
  if size(Q,3)==1
    Q = repmat(Q,[1 1 size(M,1)]);
  end

  %
  % Run the smoother
  %
  S = zeros(size(M,2),size(M,2),size(M,1));
  for k=(size(M,1)-1):-1:1
    P_pred   = A(:,:,k) * P(:,:,k) * A(:,:,k)' + Q(:,:,k);
    S(:,:,k) = P(:,:,k) * A(:,:,k)' / P_pred;
    M(k,:)   = (M(k,:)' + S(:,:,k) * (M(k+1,:)' - A(:,:,k) * M(k,:)'))';
    P(:,:,k) = P(:,:,k) + S(:,:,k) * (P(:,:,k+1) - P_pred) * S(:,:,k)';
  end

