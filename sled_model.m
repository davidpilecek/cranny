function [A,B,C,D] = sled_model(par, Ts)

M = par(1);   % mass
Bf = par(2);  % friction
K = par(3);   % gain

A = [0 1;
     0 -Bf/M];

B = [0;
     K/M];

C = [1 0];
D = 0;

end