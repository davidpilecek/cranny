clc;
clear;
% Optimization bounds

lb = [0 0 0];
ub = [100 100 2];

% Run optimization
options = optimoptions( ...
    'particleswarm', ...
    'SwarmSize', 70, ...
    'MaxIterations', 200, ...
    'Display', 'iter');

% 6. Run Optimization

rng default

[xbest,Jbest] = particleswarm( ...
    @costFun,...
    3,...
    lb,...
    ub, options);

disp('Optimal gains:')
disp(xbest)

disp('Cost:')
disp(Jbest)

%%

Kpx = 9.3453

Kpa =  0.3292
Kda = 0.0020

%% Gains

Kpx = p(1);
Kpa = p(2);
Kda = p(3);

%% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

%% Run simulation

simOut = sim( ...
    'gantryModel', ...
    'StopTime','15',...
    'FastRestart','on');

% Extract logged signals

x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
u = simOut.logsout.get('u').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

% Errors
ad = 0;

ex = xd - x;
ea = ad - alpha;

maxAngle = max(abs(alpha));
% Cost
overshoot = (max(x) - xd(end))/xd(end) * 100;
if overshoot < 0
    overshoot = 0;
end

%
J = 20*trapz(t,ex.^2) ...
  + trapz(t,ea.^2);