clc;
clear;

s = tf('s');

% Transfer functions

Gx = (50.29)/(63.71*s^2 + 990.1*s);      % U -> X
Ga = (4.725*s^2 * 180/pi)/(s^2 + 0.06627*s + 46.4);      % X -> Alpha

% References

x = load("input_tuning.mat").Scenario{1}; % desired cart position
t = 0:0.01:x.TimeInfo.End;
t = t(:);
xd = [t, x];
xd = xd.Data;
ad = zeros(size(t));    % desired pendulum angle

% Optimization bounds

lb = [0 0 0];
ub = [100 100 2];

% Run optimization

hybridOptions = optimoptions( ...
    'fmincon', ...
    'Display', 'none', ...
    'Algorithm', 'sqp');

options = optimoptions( ...
    'particleswarm', ...
    'SwarmSize', 50, ...
    'MaxIterations', 100, ...
    'HybridFcn', {@fmincon, hybridOptions}, ...
    'Display', 'iter', ...
    'PlotFcn', 'pswplotbestf');

% 6. Run Optimization

rng default

[xbest,Jbest] = particleswarm( ...
    @(p) costFun(p,Gx,Ga,t,xd,ad), ...
    3,lb,ub, options);

disp('Optimal gains:')
disp(xbest)

disp('Cost:')
disp(Jbest)

%%
clc;
clear;

s = tf('s');

set_param('gantryModel','FastRestart','on')

% Optimization bounds

lb = [0 0 0];
ub = [100 100 2];

% Run optimization
options = optimoptions( ...
    'particleswarm', ...
    'SwarmSize', 50, ...
    'MaxIterations', 200, ...
    'Display', 'iter', ...
    'PlotFcn', 'pswplotbestf');

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