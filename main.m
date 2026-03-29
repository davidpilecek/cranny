clc;clear
Ts = 0.01;

u = load("new_responses\prbs1_input.mat").ans.Data;
y = load("new_responses\prbs1_sledge.mat").ans.Data;
p = load("new_responses\prbs1_pendulum.mat").ans.Data;
p = p - mean(p);
pend1 = iddata(p, y, Ts);
sledge1 = iddata(y, u, Ts);

u2 = load("new_responses\prbs2_input.mat").ans.Data;
y2 = load("new_responses\prbs2_sledge.mat").ans.Data;
sledge2 = iddata(y2, u2, Ts);
p2 = load("new_responses\prbs2_pendulum.mat").ans.Data;
p2 = p2 - mean(p2);
pend2 = iddata(p2, y2, Ts);

u3 = load("new_responses\prbs3_input.mat").ans.Data;
y3 = load("new_responses\prbs3_sledge.mat").ans.Data;
sledge3 = iddata(y3, u3, Ts);
p3 = load("new_responses\prbs3_pendulum.mat").ans.Data;
p3 = p3 - mean(p3);
pend3 = iddata(p3, y3, Ts);


u4 = load("old_responses\2_input.mat").ans.Data;
y4 = load("old_responses\2_sledge.mat").ans.Data;
data4 = iddata(y4, u4, Ts);
p4 = load("old_responses\2_pendulum.mat").ans.Data;
p4 = p4 - mean(p4);
pend4 = iddata(p4, y4, Ts);


u5 = load("old_responses\4_input.mat").ans.Data;
y5 = load("old_responses\4_sledge.mat").ans.Data;
sledge5 = iddata(y5, u5, Ts);
p5 = load("old_responses\4_pendulum.mat").ans.Data;
p5 = p5-mean(p5);
pend5 = iddata(p5, y5, Ts);

data = load("old_responses\4_sledge.mat");

t = data.ans.Time;
y = abs(data.ans.Data);
u = u5
% t_new = 0:0.01:max(t);   % uniform time grid

% y_interp = interp1(t, y, t_new, 'linear');

%% Load data
clc;clear;
% data = load("old_responses\2_sledge.mat");
% u = load("old_responses\2_input.mat").ans.Data;

data = load("responses_25_3\impulse_sledge.mat");
u = load("responses_25_3\impulse_input.mat").ans.Data;

t = data.ans.Time;
y = data.ans.Data;

plot(data.ans)

%%
fs = 1 / mean(diff(data.ans.Time)); % Calculate sampling frequency [cite: 939]
fc = 5; % Cut-off frequency in Hz (Adjust based on your crane's speed)

% 2nd order butterworth filter
[b, a] = butter(2, fc/(fs/2), 'low');

% 2. Apply zero-phase filtering (filtfilt) to avoid phase shift [cite: 744]
% This is important so your time-domain peaks stay aligned for identification.
smoothed_position = filtfilt(b, a, data.ans.Data);

% 3. Subtract mean/offset as recommended by the text [cite: 966, 1020]
% Linear models are usually identified around an equilibrium point.
detrended_position = smoothed_position - mean(smoothed_position);

%% Plot Comparison
figure;
plot(t, data.ans.Data, 'r--', 'DisplayName', 'Raw Encoder Data');
hold on;
plot(t, smoothed_position, 'b', 'LineWidth', 1.5, 'DisplayName', 'Filtered Data');
title('Effect of Butterworth Filtering on Encoder Steps');
xlabel('Time (s)'); ylabel('Position (cm)');
legend; grid on;
%% Parameters
s = tf('s')

syms k_t m_s D_m J_m D_s

theta = [k_t, m_s, D_m, J_m, D_s];

function y = model_output(theta, t, u)
    
    R_a = 3.9;	    % armature winding resistance (Ohm) 4.27
    r_m = 0.007;		% belt wheel radius (m) 0.007

    k_t = theta(1);
    m_s = theta(2); 
    D_m = theta(3); 
    J_m = theta(4);
    D_s = theta(5);
    k_e = k_t;

    s = tf('s');

    k1 = k_t/(r_m*R_a);
    k2 = (m_s + J_m/r_m^2);
    k3 = k_t*k_e/r_m^2*R_a + D_m/r_m^2 + D_s;
    
    G_sledge = k1 / (k2*s^2 + k3*s);

    y = lsim(G_sledge, u, t);

end

function err = cost_function(theta, t, u, y_meas)
    y_model = model_output(theta, t, u);

    % residuals (IMPORTANT: return vector, not scalar)
    err = y_meas - y_model;
end
    
theta0 = [1, 1, 1, 1, 1]; % initial guess

options = optimoptions('lsqnonlin', ...
    'Display', 'iter', ...
    'MaxFunctionEvaluations', 500);

theta_est = lsqnonlin(@(theta) cost_function(theta, t, u, y), ...
                      theta0, [], [], options);

disp(theta_est)

% y_valid = load("new_responses\prbs3_sledge.mat").ans.Data;
% 
% u_valid = load("new_responses\prbs3_input.mat").ans.Data;
% t_valid = load("new_responses\prbs3_sledge.mat").ans.Time;

%%
y_valid = load("responses_25_3\sine_sledge.mat").ans.Data;
y_valid = y_valid - mean(y_valid)
u_valid = load("responses_25_3\sine_input.mat").ans.Data;
t_valid = load("responses_25_3\sine_sledge.mat").ans.Time;

y_model = model_output(theta_est, t_valid, u_valid);

y_model = y_model - mean(y_model)
plot(y_model)
hold on
plot(y_valid)

legend("simulated", "real")

%%

n = size(datasets);
n = n(4);

for i = 1:n
    u = datasets.u{i};
    % Scaling: Convert measured cm to m for SI consistency
    y_meas = datasets.y{i}(:,1) / 100; 
    t = (0:datasets.Ts{i}:(length(u)-1)*datasets.Ts{i})';
    plot(y_meas)
    hold on
end

