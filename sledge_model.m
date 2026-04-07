function [A,B,C,D] = sledge_model(par, Ts, varargin)

% Parameters to estimate
Kt = par(1);
Jm = par(2);
Dm = par(3);
Ds = par(4);

% Known constants (SET THESE CORRECTLY)
ms = 1.0;
rm = 0.02;
Ra = 2.0;
Ke = 0.1;

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