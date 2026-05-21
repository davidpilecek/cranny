function J = costFun2(p,Gx,Ga,t,xd,ad)

s = tf('s');

%% Gains

Kpx = p(1);

Kpa = p(2);
Kda = p(3);

%% Controllers

Cx = Kpx;

Ca = Kpa + Kda*s;

%% Combined dynamics

Gu_alpha = minreal(Ga*Gx);

%% Closed-loop denominator

Den = 1 + Cx*Gx + Ca*Gu_alpha;

%% Closed-loop transfer functions

Tx = (Cx*Gx)/Den;

Ta = (Cx*Gu_alpha)/Den;

%% Simulate

x = lsim(Tx,xd,t);

alpha = lsim(Ta,xd,t);

%% Errors

ex = xd(:) - x(:);

ea = ad(:) - alpha(:);

%% Cost function

J = trapz(t,ex.^2) ...
  + trapz(t,ea.^2);

%% Angle penalty

if max(abs(alpha)) > deg2rad(8)
    J = 1e12;
    return;
end
%% Stability penalty

if any(real(pole(Den)) > 0)
    J = 1e12;
    return;
end

%% Control effort estimation

Tu = (Cx + Ca*Ga*Gx)/(Den);

u = lsim(Tu,xd,t);

%% Saturation constraint

if max(abs(u)) > 10
    J = 1e12;
    return;
end

end