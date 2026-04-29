
function ddx = sledge_ode(t, y, p, t_data, v_data)
    % y(1) = x, y(2) = x_dot
    
    % Parameters to estimate
    Kt = p(1);
    Ke = p(2);
    Jm = p(3);
    Dm = p(4);
    Ds = p(5);
    
    % Known constants (SET THESE CORRECTLY)
    ms = 0.93;
    rm = 0.007;
    Ra = 0.368;
    
    % Interpolate the measured voltage at time 't'
    Va = interp1(t_data, v_data, t, 'linear', 'extrap');
    
    % The ODE solved for x_ddot:

    x_ddot = ((-(Kt*Ke)/(rm^2*Ra) - Dm/(rm^2) - Ds) * y(2) + Va * (Kt/(rm*Ra)) )/ (ms + Jm/(rm^2));

    ddx = [y(2); x_ddot];
end

function score = sledge_fitness(p_norm, t_data, v_data, measured_x)
    % p_norm: Normalized parameters from PSO [0 to 1 range preferred]
    
    % 1. --- PARAMETER DENORMALIZATION ---
    % We scale the PSO inputs to their expected physical magnitudes.
    % Adjust these multipliers based on your system's approximate scale.
    Kt = p_norm(1) * 1.0;      % Expected ~0.1 - 0.5
    Ke = p_norm(2) * 1.0;      % Usually similar to Kt
    Jm = p_norm(3) * 1e-5;     % Motor inertia is usually very small
    Dm = p_norm(4) * 1e-3;     % Small damping
    Ds = p_norm(5) * 1.0;      % Sledge friction could be higher
    
    % 2. --- INITIAL CONDITIONS ---
    % We use the first measured point for position.
    % We let the PSO estimate the initial velocity (p_norm(6)) 
    % in case the PRBS started while the sledge was moving.
    x0  = measured_x(1);
    v0  = p_norm(6) * 0.1;     % Initial velocity (scaled)
    y0  = [x0; v0];
    
    % Bundle parameters for the ODE
    p_phys = [Kt, Ke, Jm, Dm, Ds];
    
    % 3. --- ODE SIMULATION ---
    try
        % Tighten tolerances for better gradient behavior in HybridFcn
        opts = odeset('RelTol', 1e-5, 'AbsTol', 1e-7);
        
        [~, y_sim] = ode45(@(t, y) sledge_ode(t, y, p_phys, t_data, v_data), ...
                           t_data, y0, opts);
        
        % 4. --- ROBUST ERROR CALCULATION ---
        % Check if the solver failed to reach the end or produced garbage
        if size(y_sim, 1) ~= length(measured_x) || any(isnan(y_sim(:))) || any(isinf(y_sim(:)))
            score = 1e12; % Massive penalty
            return;
        end
        
        % Extract simulated position
        x_sim = y_sim(:, 1);
        
        % Mean Squared Error (MSE)
        % J = (1/N) * sum( (x_meas - x_sim)^2 )
        score = mean((measured_x - x_sim).^2);
        
        % Optional: Add a penalty for physically impossible negative values
        if any(p_phys < 0)
            score = score + 1e10;
        end
        
    catch
        score = 1e12; % Penalty for crashes
    end
end

%%
source = data_prbs_sledge;
t_data = source.SamplingInstants;
v_data = source.InputData;
measured_x = source.OutputData;

% Number of variables: Kt, Ke, Jm, Dm, Ds, v0
nVars = 6;

% Define search boundaries (Normalized 0.01 to 2.0 to give PSO room to move)
lb = [0.01, 0.01, 0.01, 0.01, 0.01, -1.0]; 
ub = [2.0,  2.0,  2.0,  2.0,  2.0,   1.0];

fitness_handle = @(p) sledge_fitness(p, t_data, v_data, measured_x);

rng default

hybrid_opts = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');
options = optimoptions('particleswarm', ...
    'SwarmSize', 60, ...
    'HybridFcn', @fmincon, ...
    'PlotFcn', 'pswplotbestf');

[p_best_norm, min_mse] = particleswarm(fitness_handle, nVars, lb, ub, options);

    Kt = p_best_norm(1) * 1.0;      % Expected ~0.1 - 0.5
    Ke = p_best_norm(2) * 1.0;      % Usually similar to Kt
    Jm = p_best_norm(3) * 1e-5;     % Motor inertia is usually very small
    Dm = p_best_norm(4) * 1e-3;     % Small damping
    Ds = p_best_norm(5) * 1.0;     % Small damping

%%

% Run one last simulation with best params to plot
y0 = [measured_theta(1); 0];
[~, y_best] = ode45(@(t, y) pendulum_ode(t, y, x, t_data, a_data), t_data, y0);

figure;
plot(t_data, measured_theta, 'k', 'DisplayName', 'Measured'); hold on;
plot(t_data, y_best(:,1), 'r--', 'LineWidth', 2, 'DisplayName', 'PSO Optimized Model');
title('Comparison: Measured vs PSO Model');
legend; grid on;