%% Genetic algorithm


function residuals = sledge_friction_loss(alpha, datasets, scales)
    % Scaling physical parameters
    Kt = alpha(1) * scales.Kt;
    Jm = alpha(2) * scales.Jm;
    D_total = alpha(3) * scales.D_total; 
    fc = alpha(4) * scales.fc; % New: Coulomb Friction Force (N)
    
    % Known constants
    Ra = 3.9; rm = 0.007; ms = 0.93; Ke = Kt; 
    
    n = size(datasets);
    n = n(4);

    residuals = [];
    for i = 1:n
        u = datasets.u{i};
        y_meas = datasets.y{i}(:,1) / 100; % cm to meters
        t = (0:datasets.Ts{i}:(length(u)-1)*datasets.Ts{i})';
        
        % ODE with Non-linear Friction
        sled_ode = @(t_v, x) [x(2); 
            ((Kt/(rm*Ra))*(interp1(t, u, t_v, 'linear', 'extrap') - (Ke/rm)*x(2)) ...
            - D_total*x(2) - fc*sign(x(2))) ... % Added sign() term
            / (ms + Jm/(rm^2))];
        
        [~, x_sim] = ode45(sled_ode, t, [y_meas(1); 0]);
        residuals = [residuals; (y_meas - x_sim(:,1))];
    end
end

% Scaling typicals
scales.Kt = 0.05;
scales.Jm = 1e-5;
scales.D_total = 0.5;
scales.fc = 0.1; % Typical friction force in Newtons

% 4 parameters to optimize: [Kt, Jm, D_total, fc]
alpha0 = [1.0, 1.0, 1.0, 1.0]; 
lb = [0.1, 0.01, 0.001, 0]; % Friction can be 0, but not negative
ub = [5.0, 10.0, 20.0, 10.0];

% Using GA to explore the non-linear space
options_ga = optimoptions('ga', 'Display', 'iter', 'PopulationSize', 50);

[best_alpha_ga] = ga(@(a) sum(sledge_friction_loss(a, datasets, scales).^2), ...
                     4, [], [], [], [], lb, ub, [], options_ga);

% Extracting the results
final_fc = best_alpha_ga(4) * scales.fc;
fprintf('Optimized Coulomb Friction: %.4f Newtons\n', final_fc);

%% 1. Validate
% best_alpha comes from your lsqnonlin output
Kt_final      = best_alpha_ga(1) * scales.Kt;
Jm_final      = best_alpha_ga(2) * scales.Jm;
D_total_final = best_alpha_ga(3) * scales.D_total;

% Known Constants
Ra = 3.9; rm = 0.007; ms = 0.93; Ke = Kt_final;

% Use a different experiment index (e.g., the last one in your merged set)
val_idx = 4;
u_val = val_datasets.u{val_idx};

y_val_m = (val_datasets.y{val_idx}(:,1)) / 100; % Convert cm to meters
t_val = (0:val_datasets.Ts{val_idx}:(length(u_val)-1)*val_datasets.Ts{val_idx})';

% 3. Simulate the Optimized ODE
% Re-define the ODE with the final physical values
val_ode = @(t, x) [x(2); 
    ((Kt_final/(rm*Ra))*(interp1(t_val, u_val, t, 'linear', 'extrap') - (Ke/rm)*x(2)) - D_total_final*x(2)) ...
    / (ms + Jm_final/(rm^2))];

% Use ode45 to generate the predicted output y_hat [cite: 71]
[~, x_sim] = ode45(val_ode, t_val, [y_val_m(1); 0]);
y_sim_m = x_sim(:,1);

% 4. Visualize Results (Validation Plot)
figure('Name', 'Model Cross-Validation');

% Comparison Plot [cite: 750, 1358]
subplot(2,1,1);
plot(t_val, y_val_m * 100, 'k', 'LineWidth', 1.2); hold on;
plot(t_val, y_sim_m * 100, 'r--', 'LineWidth', 1.5);
ylabel('Position (cm)'); title('Measured vs. Simulated Sledge Position');
legend('Measured (Fresh Data)', 'Optimized ODE Prediction'); grid on;

% Residual Analysis [cite: 752, 1370]
subplot(2,1,2);
residuals = (y_val_m - y_sim_m) * 100; % Error in cm
plot(t_val, residuals, 'b');
ylabel('Error (cm)'); xlabel('Time (s)'); title('Residuals (Prediction Errors)');
grid on;

% 5. Calculate Fit Metric [cite: 430]
fit_val = 100 * (1 - norm(y_val_m - y_sim_m) / norm(y_val_m - mean(y_val_m)));
fprintf('Validation Fit Percentage: %.2f%%\n', fit_val);



%%


function y = simulate_sled(theta, u, t)

    Kt = theta(1);
    Jm = theta(2);
    D  = theta(3);

    Ra = 3.9; rm = 0.007; ms = 0.93;
    Ke = Kt;

    M_eq = ms + Jm/(rm^2);

    num = Kt/(rm*Ra);
    den = [M_eq, D + (Kt*Ke)/(rm^2*Ra), 0];

    sys = tf(num, den);

    y = lsim(sys, u, t);
end

function err = cost(theta, datasets)

    n = length(datasets.u);
    err = [];

    for i = 1:n

        u = datasets.u{i};
        y_meas = datasets.y{i}(:,1);
        Ts = datasets.Ts{i};

        if isempty(u) || isempty(y_meas)
            continue;
        end

        t = (0:length(u)-1)*Ts;

        y_model = simulate_sled(theta, u, t);

        e = y_meas - y_model;

        err = [err; e / std(y_meas)]; % normalize

    end
end


% Scaling typicals
scales.Kt = 0.05;
scales.Jm = 1e-5;
scales.D_total = 0.5;
scales.fc = 0.1; % Typical friction force in Newtons

% 4 parameters to optimize: [Kt, Jm, D_total, fc]
theta0 = [0.3, 0.5, 0.1, 0.1]; 
lb = [0.1, 0.01, 0.001, 0]; % Friction can be 0, but not negative
ub = [5.0, 10.0, 20.0, 10.0];


best_theta = [];
best_cost = inf;

options = optimoptions('lsqnonlin',...
    'FunctionTolerance',1e-8,...
    'StepTolerance',1e-8,...
    'Display','iter');


for i = 1:10

    theta_init = theta0 .* (0.5 + rand(1,length(theta0)));

    theta = lsqnonlin(@(th) cost(th, datasets), theta_init, lb, ub, options);

    c = norm(cost(theta, datasets));
    
    disp(c)
    if c < best_cost
        best_cost = c;
        best_theta = theta;
    end
end

%%
i = 1;

u = datasets.u{i};
y_meas = datasets.y{i}(:,1);
Ts = datasets.Ts{i};

t = (0:length(u)-1)*Ts;

y_model = simulate_sled(theta_opt, u, t);

plot(t, y_meas, t, y_model)
legend('Measured','Model')
y_model = simulate_sled(theta_opt, u, t);
plot(t, y_meas, t, y_model)
legend('Measured','Model')