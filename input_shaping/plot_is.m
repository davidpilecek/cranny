

clc; clear; close all;

plot_format();   % apply styling


%%
pendulum_noIS = load("input_shaping\simulation\pendulum_noIS.mat").ans;
pendulum_ZV = load("input_shaping\simulation\pendulum_ZV.mat").ans;
pendulum_ZVD = load("input_shaping\simulation\pendulum_ZVD.mat").ans;
pendulum_ZVDD = load("input_shaping\simulation\pendulum_ZVDD.mat").ans;

idx = pendulum_noIS.Time <= 20;
data = pendulum_noIS.Data(idx);


figure; hold on;
plot(pendulum_noIS.Time(idx), pendulum_noIS.Data(idx), 'LineWidth', 1); hold on;
plot(pendulum_ZV.Time(idx),pendulum_ZV.Data(idx),'r-', 'LineWidth', 3); hold on;
plot(pendulum_ZVD.Time(idx),pendulum_ZVD.Data(idx),'g-', 'LineWidth', 3); hold on;
plot(pendulum_ZVDD.Time(idx),pendulum_ZVDD.Data(idx),'b-', 'LineWidth', 3); hold on;


legend('Unshaped','ZV','ZVD','ZVDD');
title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Angle [rad]')
grid on
% Tight layout
% axis tight;

%%

exportgraphics(gcf, 'IS_compare_pend.pdf', 'ContentType','vector');


%% Example data

% System parameters
wn = 2*pi*0.7;

zeta = 0.05;
wd = wn*sqrt(1 - zeta^2);

% Time
t = linspace(0, 3, 1000);

% ZV shaper parameters
K = exp(-zeta*pi / sqrt(1 - zeta^2));

A1 = 1/(1 + K);
A2 = K/(1 + K);
t2 = pi / wd;

% Impulse response
h = @(tau) (1/wd) * exp(-zeta*wn*tau) .* sin(wd*tau) .* (tau >= 0);

% Responses
y1 = A1 * h(t);
y2 = A2 * h(t - t2);
y_total = y1 + y2;


%% Create figure
figure; hold on;


subplot(3,1,1)
plot(t, y1, 'b--', 'LineWidth', 2); hold on;
stem(0, A1, 'k', 'filled');
title('(a) Response to $A_1$'); grid on
xlabel('Time [s]')
ylabel('Position')

subplot(3,1,2)
plot(t, y2, 'r--', 'LineWidth', 2); hold on;
stem(t2, A2, 'k', 'filled');
title('(b) Response to $A_2$'); grid on
xlabel('Time [s]')
ylabel('Position')

subplot(3,1,3)
plot(t, y1, 'b--', 'LineWidth', 2); hold on;
plot(t, y2, 'r--', 'LineWidth', 2);
plot(t, y_total, 'k', 'LineWidth', 3);
stem([0 t2], [A1 A2], 'k', 'filled');

legend('$A_1$ Response','$A_2$ Response','Total Response\,');
title('(c) Superposition (ZV - zero residual vibration)')
xlabel('Time [s]')
ylabel('Position')
grid on
% Tight layout
axis tight;

%% Export (vector for report)
exportgraphics(gcf, 'figure_test2.pdf', 'ContentType','vector');