%% Load data
clc;clear;
% data = load("old_responses\2_sledge.mat");
% u = load("old_responses\2_input.mat").ans.Data;

data = load('responses_25_3/1prbssledge.mat');
y_data = load('responses_25_3/1prbspendulum.mat').ans;

% Extract signals
t_u = data.ans.Time;
u = data.ans.Data;

t_y = y_data.Time;
y = y_data.Data;

% Remove bias
y = y - mean(y);

% Resample y → match u time base (Ts = 0.01)
u_resampled = interp1(t_u, u, t_y, 'linear');

% Now everything aligned
t = t_y;
u = u_resampled;

%% Parameters
s = tf('s');

D_p = 0;
J_p = 0;

theta = [D_p, J_p];

function y = model_output(theta, t, u)
   
    %Pendulum parameters
    L        = 0.225;               %length of the rod     0.245
    m_p      = 0.191;                %mass of the load      originally 0.184
    m_r      = 0.087;                %mass of the rod     0.085
    g        = 9.80665;                 %gravitational constant    9.82

    D_p = theta(1);
    J_p = theta(2);

    s = tf('s');

    k4 = L*m_p + 0.5*L*m_r;
    
    G_pendulum = k4*s^2 / (J_p*s^2 + D_p*s + k4*g);


    y = lsim(G_pendulum, u, t);
end

function err = cost_function(theta, t, u, y_meas)
    y_model = model_output(theta, t, u);

    % residuals (IMPORTANT: return vector, not scalar)
    err = y_meas - y_model;
end
    
theta0 = [0.008, 0.016]; % initial guess

options = optimoptions('lsqnonlin', ...
    'Display', 'iter', ...
    'MaxFunctionEvaluations', 500);

theta_est = lsqnonlin(@(theta) cost_function(theta, t, u, y), ...
                      theta0, [], [], options);

disp(theta_est)


%%

y_valid = load('responses_25_3/impulse_pendulum.mat');
u_valid = load('responses_25_3/impulse_sledge.mat');

t_y = y_valid.ans.Time;
t_u = u_valid.ans.Time;

yval = y_valid.ans.Data;
yval = yval - mean(yval);

uval = u_valid.ans.Data;

u_resampled = interp1(t_u, uval, t_y, 'linear');
u_validate = u_resampled;


y_model = model_output(theta_est, t_y, u_validate);


figure
plot(y_model)
hold on
plot(yval)
legend("sim", "measured")