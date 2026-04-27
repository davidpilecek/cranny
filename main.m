%% random stuff

wn = sqrt(46.54)

a2 = 0.09515;

zeta = 0.09515/(2*wn)



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
%%


G = tf([0.4857], [1, 13.79, 0.01658])
G2 = tf([4.739 0 0], [1 0.09515 46.54])

sys = G*G2
C_pid = pid(20, 0.01, 0, 10)
C = tf(C_pid)
L = C*sys


margin(L)

%%
P1 = 10;
P2 = 5;
I1 = 0;
I2 = 0;
D1 = 0.01;
D2 = 0;

N1 = 50;
N2 = 0;


G_angle = tf([4.739 0 0], [1 0.09515 46.54])
G_pos = tf([0.4857], [1, 13.79, 0.01658]);

C_inner = pid(P1, I1, D1, N1); % Pendulum Controller
C_outer = pid(P2, I2, D2, N2); % Sled Position Controller

% 2. Define your Plant Models (Linearized)
% G_angle: Force to Angle | G_pos: Force to Position
% (These come from your first-principles modelling)

% 3. Build the Inner Closed Loop
% This represents the "stabilized" pendulum
L_inner = C_inner * G_angle;
T_inner = feedback(L_inner, 1);

% 4. Build the Total Cascade Closed Loop
% The outer controller sees the inner loop as part of its "plant"
L_outer = C_outer * T_inner * G_pos;
T_total = feedback(L_outer, 1);

margin(T_total)

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

