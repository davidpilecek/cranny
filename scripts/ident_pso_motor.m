%% Sledge Parameter Estimation using PSO (v0 = 0)

% 1. Load PRBS Data
% Ensure source object is in your workspace
source = data_prbs_sledge; 
t_data = source.SamplingInstants;
v_data = source.InputData;       
measured_x = source.OutputData;  

% 2. Optimization Setup
% Parameters: [Kt, Ke, Jm, Dm, Ds]
nVars = 5;

% Search Boundaries (Normalized)
% [Kt, Ke, Jm, Dm, Ds]
lb = [0.1, 0.1, 0.01, 0.01, 0.1]; 
ub = [5.0, 5.0, 5.0,  5.0,  5.0];

% 3. Configure PSO Options
hybridOptions = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');

options = optimoptions('particleswarm', ...
    'SwarmSize', 50, ...
    'MaxIterations', 100, ...
    'HybridFcn', {@fmincon, hybridOptions}, ... 
    'PlotFcn', 'pswplotbestf', ...
    'Display', 'iter');

% 4. Run Optimization
fprintf('Starting PSO Optimization (5 Parameters)...\n');
fitness_handle = @(p) sledge_fitness(p, t_data, v_data, measured_x);
rng default; 
[p_best_norm, min_mse] = particleswarm(fitness_handle, nVars, lb, ub, options);

% 5. De-normalize Best Parameters for Results
final_params = denormalize_params(p_best_norm);
Kt = final_params(1); Ke = final_params(2); Jm = final_params(3);
Dm = final_params(4); Ds = final_params(5);

fprintf('\n--- Optimized Physical Parameters ---\n');
fprintf('Kt: %.6f [Nm/A]\n', Kt);
fprintf('Ke: %.6f [V/(rad/s)]\n', Ke);
fprintf('Jm: %.6e [kg*m^2]\n', Jm);
fprintf('Dm: %.6e [Nm/(rad/s)]\n', Dm);
fprintf('Ds: %.6f [N/(m/s)]\n', Ds);

% 6. Final Validation Plot
y0 = [measured_x(1); 0]; % Hardcoded v0 = 0
opts_ode = odeset('RelTol', 1e-6, 'AbsTol', 1e-8);
[~, y_sim] = ode45(@(t, y) sledge_ode(t, y, [Kt, Ke, Jm, Dm, Ds], t_data, v_data), t_data, y0, opts_ode);

figure('Color', 'w');
plot(t_data, measured_x, 'k', 'LineWidth', 1.2, 'DisplayName', 'Measured $x(t)$'); hold on;
plot(t_data, y_sim(:,1), 'r--', 'LineWidth', 1.5, 'DisplayName', 'PSO Model');
set(gca, 'TickLabelInterpreter', 'latex');
xlabel('Time $t$ [s]', 'Interpreter', 'latex', 'FontSize', 14);
ylabel('Displacement $x$ [m]', 'Interpreter', 'latex', 'FontSize', 14);
title('\textbf{Sledge Identification: Standstill Start ($v_0 = 0$)}', 'Interpreter', 'latex', 'FontSize', 16);
legend('Interpreter', 'latex', 'Location', 'best');
grid on;

%% --- SUPPORT FUNCTIONS ---

function score = sledge_fitness(p_norm, t_data, v_data, measured_x)
    p_phys = denormalize_params(p_norm);
    
    % Hardcode initial velocity to 0
    y0 = [measured_x(1); 0];
    
    try
        opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-5);
        [~, y_sim] = ode45(@(t, y) sledge_ode(t, y, p_phys, t_data, v_data), t_data, y0, opts);
        
        if size(y_sim, 1) ~= length(measured_x) || any(isnan(y_sim(:)))
            score = 1e12;
        else
            score = mean((measured_x - y_sim(:,1)).^2);
        end
    catch
        score = 1e12;
    end
end

function p_phys = denormalize_params(p_norm)
    p_phys = zeros(1, 5);
    p_phys(1) = p_norm(1) * 1.0;    % Kt
    p_phys(2) = p_norm(2) * 1.0;    % Ke
    p_phys(3) = p_norm(3) * 1e-5;   % Jm
    p_phys(4) = p_norm(4) * 1e-4;   % Dm
    p_phys(5) = p_norm(5) * 1.0;    % Ds
end

function ddx = sledge_ode(t, y, p, t_data, v_data)
    % y(1) = x, y(2) = x_dot
    Kt = p(1); Ke = p(2); Jm = p(3); Dm = p(4); Ds = p(5);
    ms = 0.93; rm = 0.007; Ra = 0.368;
    
    Va = interp1(t_data, v_data, t, 'linear', 'extrap');
    
    M_eq = ms + Jm/(rm^2);
    D_eq = (Kt*Ke)/(rm^2*Ra) + Dm/(rm^2) + Ds;
    F_in = Va * (Kt/(rm*Ra));
    
    x_ddot = (F_in - D_eq * y(2)) / M_eq;
    ddx = [y(2); x_ddot];
end