%% ZVD Input Shaper Design for Gantry Crane Pendulum
clear; clc;

%% =========================
% 1) USER INPUT (CHOOSE ONE)
% ==========================

mode = "manual";  
% "manual"  -> you enter wn and zeta
% "data"    -> estimate from measured signal

%% =========================
% 2) PARAMETERS
% ==========================

% ---- MANUAL INPUT ----
wn = 6.822;        % natural frequency [rad/s]
zeta = 0.0069;     % damping ratio [-]

wd = wn * sqrt(1 - zeta^2);

K = exp(-zeta * pi / sqrt(1 - zeta^2))

%% =========================
% 4) ZVD SHAPER COEFFICIENTS
% ==========================

A1 = 1 / (1 + K)^2;
A2 = 2*K / (1 + K)^2;
A3 = K^2 / (1 + K)^2;

t1 = 0;
t2 = pi / wd;
t3 = 2*pi / wd;

%% =========================
% 5) VALIDATION CHECKS
% ==========================

fprintf('--- ZVD SHAPER ---\n');
fprintf('wn   = %.4f rad/s\n', wn);
fprintf('zeta = %.4f\n', zeta);
fprintf('wd   = %.4f rad/s\n\n', wd);

fprintf('Amplitudes:\n');
fprintf('A1 = %.4f\n', A1);
fprintf('A2 = %.4f\n', A2);
fprintf('A3 = %.4f\n', A3);

fprintf('\nTimes:\n');
fprintf('t1 = %.4f s\n', t1);
fprintf('t2 = %.4f s\n', t2);
fprintf('t3 = %.4f s\n', t3);

fprintf('\nSum of amplitudes = %.4f\n', A1 + A2 + A3);

%% ZVDD

A1 = 1 / (1 + K)^3;
A2 = 3*K / (1 + K)^3;
A3 = 3*K^2 / (1 + K)^3;
A4 = K^3 / (1 + K)^3;

t1 = 0;
t2 = pi / wd;
t3 = 2*pi / wd;
t4 = 3*pi / wd;

% =========================
% ZVDD VALIDATION CHECKS
% ==========================

fprintf('--- ZVDD SHAPER ---\n');
fprintf('wn   = %.4f rad/s\n', wn);
fprintf('zeta = %.4f\n', zeta);
fprintf('wd   = %.4f rad/s\n\n', wd);

fprintf('Amplitudes:\n');
fprintf('A1 = %.4f\n', A1);
fprintf('A2 = %.4f\n', A2);
fprintf('A3 = %.4f\n', A3);
fprintf('A4 = %.4f\n', A4);

fprintf('\nTimes:\n');
fprintf('t1 = %.4f s\n', t1);
fprintf('t2 = %.4f s\n', t2);
fprintf('t3 = %.4f s\n', t3);
fprintf('t4 = %.4f s\n', t4);


fprintf('\nSum of amplitudes = %.4f\n', A1 + A2 + A3 + A4);

%% =========================
% 6) CREATE DISCRETE SHAPER
% ==========================

% Define time vector for visualization
t_sim = 0:0.001:(t3 + 1);

% Create impulse-like signal
u = zeros(size(t_sim));
[~, idx1] = min(abs(t_sim - t1));
[~, idx2] = min(abs(t_sim - t2));
[~, idx3] = min(abs(t_sim - t3));

u(idx1) = A1;
u(idx2) = A2;
u(idx3) = A3;

%% =========================
% 7) PLOT SHAPER
% ==========================

figure;
stem(t_sim, u, 'filled');
xlabel('Time [s]');
ylabel('Amplitude');
title('ZVD Input Shaper');
grid on;

%% =========================
% 8) OPTIONAL: APPLY SHAPER
% ==========================

% Example: shaping a step input
r = ones(size(t_sim));

% Convolution (discrete approximation)
r_shaped = conv(r, u, 'same');

figure;
plot(t_sim, r, '--', 'DisplayName', 'Original');
hold on;
plot(t_sim, r_shaped, 'LineWidth', 1.5, 'DisplayName', 'Shaped');
legend;
xlabel('Time [s]');
ylabel('Signal');
title('Input Shaping Effect');
grid on;