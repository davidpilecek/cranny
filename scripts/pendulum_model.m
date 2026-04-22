function [A,B,C,D] = pendulum_model(par, Ts, varargin)

Jp = par(1);
Dp = par(2);

% Known constants
Lp = 0.205;
ml = 0.272;
mr = 0.135;
g  = 9.82;


K = Lp*ml + 0.5*Lp*mr;

A = [0 1;
    -K*g/Jp   -Dp/Jp];

B = [0;
     1/Jp];

% IMPORTANT: correct output equation
C = [-K^2*g/Jp   -K*Dp/Jp];
D = K/Jp;