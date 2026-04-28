
data_array = {data_prbs_pendulum, data_step_pendulum, data_saw_pendulum};

datasets = cell(1, numel(data_array));

for i = 1:numel(data_array)
    source = data_array{i};
    
    t_data = source.SamplingInstants;
    x_data = source.InputData;
    theta = source.OutputData;

    dt = t_data(2) - t_data(1);
    v_data = gradient(x_data, dt);
    a_data = gradient(v_data, dt);

    datasets{i} = struct( ...
        't', t_data, ...
        'a', a_data, ...
        'theta', theta ...
    );
end



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

function score = my_fitness_multi(p, datasets)

    total_error = 0;

    for i = 1:length(datasets)
        t_data = datasets{i}.t;
        a_data = datasets{i}.a;
        measured_theta = datasets{i}.theta;

        y0 = [measured_theta(1); 0];

        try
            opts = odeset('RelTol', 1e-4, 'AbsTol', 1e-4);
            [~, y_sim] = ode45(@(t,y) pendulum_ode(t,y,p,t_data,a_data), ...
                               t_data, y0, opts);

            if length(y_sim(:,1)) == length(measured_theta)
                err = mean((measured_theta - y_sim(:,1)).^2);
            else
                err = 1e8;
            end

        catch
            err = 1e8;
        end

        total_error = total_error + err;
    end

    % Average (optional but recommended)
    score = total_error / length(datasets);
end

%%

nVars = 2;
lb = [0.001, 0.0001]; % Lower bounds
ub = [0.1,   0.05];   % Upper bounds (adjust based on your system scale)

fitness_handle = @(p) my_fitness_multi(p, datasets);

rng default

hybrid_opts = optimoptions('fmincon', 'Display', 'none', 'Algorithm', 'sqp');
options = optimoptions('particleswarm', ...
    'SwarmSize', 40, ...
    'HybridFcn', @fmincon, ...
    'PlotFcn', 'pswplotbestf');

x = particleswarm(fitness_handle, nVars, lb, ub, options);

%%
x
%%
% Run one last simulation with best params to plot
y0 = [measured_theta(1); 0];
[~, y_best] = ode45(@(t, y) pendulum_ode(t, y, x, t_data, a_data), t_data, y0);

figure;
plot(t_data, measured_theta, 'k', 'DisplayName', 'Measured'); hold on;
plot(t_data, y_best(:,1), 'r--', 'LineWidth', 2, 'DisplayName', 'PSO Optimized Model');
title('Comparison: Measured vs PSO Model');
legend; grid on;