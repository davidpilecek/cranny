%% Grey-Box Sledge Identification
% Physical DC motor model

clear; clc;
%%
% 1. Load Multi-Experiment Data

data_all = merge( ...
    data_sine_sledge, ...
    data_bang_sledge, ...
    data_pulse_sledge);

% 2. Optimization Variables
% p = [Kt, Jm, Dm, Ds, ms]

nVars = 5;

% 3. Parameter Bounds

lb = [ ...
    0.01,...    % Kt
    1e-7, ...   % Jm
    0, ...    % Dm
    1,  ...    % Ds
    0.1        % ms
];

ub = [ ...
    1,...    % Kt
    0.1, ...   % Jm
    1e-3, ...   % Dm
    100.0, ...    % Ds
    10
];

% 4. PSO Settings

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

% 5. Fitness Function

fitness = @(p) sledge_fitness_multi( ...
    p, ...
    data_all);

% 6. Run Optimization

rng default

[p_best, best_cost] = particleswarm( ...
    fitness, ...
    nVars, ...
    lb, ...
    ub, ...
    options);

%% 7. Results

Kt = p_best(1);
Jm = p_best(2);
Dm = p_best(3);
Ds = p_best(4);
ms = p_best(5);

fprintf('\n===== IDENTIFIED PARAMETERS =====\n');

fprintf('Kt = %.6e kg*m^2\n', Kt);
fprintf('Jm = %.6e kg*m^2\n', Jm);
fprintf('Dm = %.6e Nm/(rad/s)\n', Dm);
fprintf('Ds = %.6f N*s/m\n', Ds);
fprintf('ms = %.6f kg\n', ms);

fprintf('\nFinal Cost = %.8e\n', best_cost);

rm = 0.007;      % [m]
% ms = 0.93;       % [kg]
Ra = 0.368;      % [Ohm]
Ke = Kt;

%% 8. Validation Plot

exp_data = data_ramp_sledge;

t_data = exp_data.SamplingInstants(:);
u_data = exp_data.InputData(:);
x_measured = exp_data.OutputData(:);

y0 = [0;0];

num = Kt/(rm*Ra);
den = [(ms + Jm/(rm^2)) (Kt*Ke/(Ra*rm^2) + Dm/(rm^2) + Ds) 0];

tf_sledge = tf(num, den)
tf_sledge_j = tf(4886, [2011 23820 0])

opt = compareOptions('InitialCondition','z');

input = u_data*5/24;

test = lsim(tf_sledge_j, input, exp_data.SamplingInstants);
test2 = lsim(tf_sledge, u_data, exp_data.SamplingInstants);

% [~, y_sim] = ode45( ...
%     @(t,y) sledge_ode( ...
%         t, y, p_best, ...
%         t_data, u_data), ...
%     t_data, ...
%     y0);

% 9. Plot

figure('Color','w');

plot( ...
    t_data, ...
    x_measured, ...
    'k', ...
    'LineWidth',1.5, ...
    'DisplayName','Measured');

hold on;

plot( ...
    t_data, ...
    test2, ...
    'r--', ...
    'LineWidth',1.5, ...
    'DisplayName','Model');

hold on;

plot(  ...
    t_data, ...
    test,...
    'b--', ...
    'LineWidth',1.5, ...
    'DisplayName','Model theirs');

xlabel('Time [s]');
ylabel('Position [m]');

title('Validation');

legend('Location','best');

grid on;