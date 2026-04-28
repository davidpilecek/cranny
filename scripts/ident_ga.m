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

    % Initial conditions: [initial_angle, initial_angular_velocity]
    % If unknown, you can add these to 'p' for the GA to find!
    y0 = [0; 0]; 
    
    try
        % Pass t_data and a_data into the ODE function
        [~, y_sim] = ode45(@(t, y) pendulum_ode(t, y, p, t_data, a_data), t_data, y0);
        
        % Calculate error (Residual Sum of Squares)
        error = measured_theta - y_sim(:,1);
        score = sum(error.^2); 
    catch
        score = 1e8; % Penalty for unstable parameters
    end
end

%%
% --- 1. LOAD YOUR DATA ---
% Replace these with your actual measured vectors

source = data_prbs_pendulum;
t_data = source.SamplingInstants;
x_data = source.InputData;
measured_theta = source.OutputData;

% Assuming 't_data' and 'x_data' are your measured vectors
dt = t_data(2) - t_data(1); 
v_data = gradient(x_data, dt);      % Velocity
a_data = gradient(v_data, dt);     % Acceleration (x_ddot)

% plot(t_data, v_data)
% hold on 
% plot(t_data, x_data)

%% GA

% --- 3. GA CONFIGURATION ---
% Parameters: [Jp, Dp]
nVars = 2;
lb = [0.001, 0.0001]; % Lower bounds
ub = [0.1,   0.05];   % Upper bounds (adjust based on your system scale)

options = optimoptions('ga', ...
    'Display', 'iter', ...
    'PlotFcn', @gaplotbestf, ... % Shows the "Evolution" progress
    'PopulationSize', 50, ...
    'MaxGenerations', 200);

% --- 4. RUN OPTIMIZATION ---
% We pass the data into the fitness function using an anonymous function
fitness_handle = @(p) my_fitness(p, t_data, a_data, measured_theta);

fprintf('Starting GA... this may take a minute.\n');
[best_params, min_error] = ga(fitness_handle, nVars, [], [], [], [], lb, ub, [], options);

% --- 5. SHOW RESULTS ---
fprintf('\nBest Jp: %.6f\n', best_params(1));
fprintf('Best Dp: %.6f\n', best_params(2));

% Run one last simulation with best params to plot
y0 = [measured_theta(1); 0];
[~, y_best] = ode45(@(t, y) pendulum_ode(t, y, best_params, t_data, a_data), t_data, y0);

figure;
plot(t_data, measured_theta, 'k', 'DisplayName', 'Measured'); hold on;
plot(t_data, y_best(:,1), 'r--', 'LineWidth', 2, 'DisplayName', 'GA Optimized Model');
title('Comparison: Measured vs. GA Model');
legend; grid on;

