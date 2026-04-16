function [A,B,C,D] = sledge_model(par, Ts, varargin)

% Parameters to estimate
Kt = par(1);
Ke = par(2);
Jm = par(3);
Dm = par(4);
Ds = par(5);

% Known constants (SET THESE CORRECTLY)
ms = 0.93;
rm = 0.007;
Ra = 0.368;

% Derived parameters
M = ms + Jm / rm^2;
Dtot = (Kt*Ke)/(rm^2 * Ra) + Ds + Dm / rm^2;
Btot = Kt / (rm * Ra);

% State-space
A = [0 1;
     0   -Dtot/M];

B = [0;
     Btot/M];

C = [1 0];
D = 0;