
function dtheta = pendulum_ode(t, y, p, t_data, a_data)
    % y(1) = theta, y(2) = theta_dot
    % p(1) = Jp, p(2) = Dp
    
    Jp = p(1);
    Dp = p(2);
   
    % Known constants
    Lp = 0.205;
    ml = 0.272;
    mr = 0.135;
    g  = 9.82;
    
    % Interpolate the measured acceleration at time 't'
    x_ddot = interp1(t_data, a_data, t, 'linear', 'extrap');
    
    % Common term K
    K = (Lp * ml + 0.5 * Lp * mr);
    
    % The ODE solved for theta_ddot:
    % Jp*ddtheta = K*x_ddot - K*g*theta - Dp*dtheta
    theta_ddot = (K * x_ddot - K * g * y(1) - Dp * y(2)) / Jp;
    
    dtheta = [y(2); theta_ddot];
end

function score = my_fitness(p, t_data, a_data, measured_theta)
    % Use the actual starting angle from the data
    y0 = [measured_theta(1); 0]; 
    
    try
        % Using 'RelTol' and 'AbsTol' speeds up the PSO significantly
        opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-4);
        [~, y_sim] = ode45(@(t, y) pendulum_ode(t, y, p, t_data, a_data), t_data, y0, opts);
        
        % Calculate Mean Squared Error (MSE)
        % Ensure dimensions match (sometimes ode45 returns fewer points if it fails)
        if length(y_sim(:,1)) == length(measured_theta)
            score = mean((measured_theta - y_sim(:,1)).^2);
        else
            score = 1e8;
        end
    catch
        score = 1e8;
    end
end

%%
source = data_prbs_pendulum;
t_data = source.SamplingInstants;
x_data = source.InputData;
measured_theta = source.OutputData;

% Assuming 't_data' and 'x_data' are your measured vectors
dt = t_data(2) - t_data(1); 
v_data = gradient(x_data, dt);      % Velocity
a_data = gradient(v_data, dt);     % Acceleration (x_ddot)

nVars = 2;
lb = [0.001, 0.0001]; % Lower bounds
ub = [0.1,   0.05];   % Upper bounds (adjust based on your system scale)

fitness_handle = @(p) my_fitness(p, t_data, a_data, measured_theta);

rng default

hybrid_opts = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');
options = optimoptions('particleswarm', ...
    'SwarmSize', 60, ...
    'HybridFcn', @fmincon, ...
    'PlotFcn', 'pswplotbestf');

x = particleswarm(fitness_handle, nVars, lb, ub, options)

%%

% Run one last simulation with best params to plot
y0 = [measured_theta(1); 0];
[~, y_best] = ode45(@(t, y) pendulum_ode(t, y, x, t_data, a_data), t_data, y0);

figure;
plot(t_data, measured_theta, 'k', 'DisplayName', 'Measured'); hold on;
plot(t_data, y_best(:,1), 'r--', 'LineWidth', 2, 'DisplayName', 'PSO Optimized Model');
title('Comparison: Measured vs PSO Model');
legend; grid on;