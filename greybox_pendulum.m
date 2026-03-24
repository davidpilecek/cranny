%% Load data
clc;clear;
% data = load("old_responses\2_sledge.mat");
% u = load("old_responses\2_input.mat").ans.Data;

data = load("old_responses\2_sledge.mat");
u = load("old_responses\2_pendulum.mat").ans.Data;
u = u - mean(u);

t = data.ans.Time;
y = data.ans.Data;

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
    plot(y)
    hold on
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

y_valid = load("old_responses\4_pendulum.mat").ans.Data;
y_valid = y_valid - mean(y_valid)
u_valid = load("old_responses\4_sledge.mat").ans.Data;


t_valid = load("old_responses\4_pendulum.mat").ans.Time;

y_model = model_output(theta_est, t_valid, u_valid)/10000;
figure
plot(y_model)
hold on
plot(y_valid)
legend("sim", "measured")