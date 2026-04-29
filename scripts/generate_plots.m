base = "plots/";

% 2. Figure Setup
figWidth = 40; 
figHeight = 15;

fig = figure('Units', 'centimeters', 'Position', [5, 5, figWidth, figHeight]);
hold on; grid on;

% 3. Plot
p1 = plot(t_new, data, 'b', linewidth=1.5, DisplayName="Pendulum Angle"); hold on;

% Plot the peaks to show the fit
plot(locs, pks, 'o', 'MarkerFaceColor', [0 0.5 0], 'MarkeredgeColor', [0 0.5 0] , 'DisplayName', 'Measured Peaks'); hold on;
% yline(0, 'k--'); % Show the new zero center
grid on;

% Plot the envelopes
plot(t_new, upper_env, 'r--', 'LineWidth', 3, 'DisplayName', 'Exponential Envelope $\quad$');
plot(t_new, lower_env, 'r--', 'LineWidth', 3, 'HandleVisibility', 'off');

% 4. LaTeX Formatting & Axes properties
set(gca, ...
    'TickLabelInterpreter', 'latex', ...
    'FontSize', 10, ... ...
    'Box', 'on', ...
    'LineWidth', 1.2);

% Set the default interpreter for all text objects (titles, labels, etc.)
set(groot, 'DefaultTextInterpreter', 'latex');

% Set the default interpreter for axes tick labels
set(groot, 'DefaultAxesTickLabelInterpreter', 'latex');

% Set the default interpreter for legends
set(groot, 'DefaultLegendInterpreter', 'latex');
% Labels with LaTeX syntax
xlabel('\textbf{Time (s)}',  'FontSize', 18);
ylabel('\textbf{Angle (rad)}',  'FontSize', 18);

lgd = legend('show', 'Location', 'northeast');
lgd.FontSize = 12;

% 5. Exporting (High Resolution)

exportgraphics(fig, base + 'damping_ratio.pdf', 'ContentType', 'vector');

%%
base = "plots/";

% ===== ONLY EDIT THIS =====
signal = "step2";
% ==========================

% Load datasets dynamically
data_sledge   = eval("data_" + signal + "_sledge");
data_pendulum = eval("data_" + signal + "_pendulum");

% Common time vector
x = data_sledge.SamplingInstants;

% Define what to plot (systematic)
plots = {
    data_sledge.InputData,   "input",    '\textbf{Voltage (V)}',   [0 0 0];
    data_sledge.OutputData,  "sledge",   '\textbf{Position (m)}',  [0 0 1];
    data_pendulum.OutputData,"pendulum", '\textbf{Angle (rad)}',   [1 0 0];
};

% Loop
for i = 1:size(plots,1)

    y        = plots{i,1};
    suffix   = plots{i,2};
    ylabel_t = plots{i,3};
    color    = plots{i,4};

    fig = figure('Units', 'centimeters', 'Position', [5, 5, 35, 15]);
    hold on; grid on;

    plot(x, y, ...
        'LineWidth', 1.3, ...
        'Color', color);

    set(gca, ...
        'TickLabelInterpreter', 'latex', ...
        'FontSize', 18, ...
        'FontName', 'Times New Roman', ...
        'Box', 'on', ...
        'LineWidth', 1.2);

    xlabel('\textbf{Time (s)}', 'Interpreter', 'latex', 'FontSize', 22);
    ylabel(ylabel_t, 'Interpreter', 'latex', 'FontSize', 22);

    filename = base + signal + "_" + suffix + ".pdf";
    exportgraphics(fig, filename, 'ContentType', 'vector');

    close(fig);
end

%% Input shaper graph
clc; clear; close all;

% System parameters
wn = 2*pi*0.7;
zeta = 0.1;
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

% Plot
figure;

subplot(3,1,1)
plot(t, y1, 'b--', 'LineWidth', 1.5); hold on;
stem(0, A1, 'k', 'filled');
title('(a) Response to A_1'); grid on

subplot(3,1,2)
plot(t, y2, 'r--', 'LineWidth', 1.5); hold on;
stem(t2, A2, 'k', 'filled');
title('(b) Response to A_2'); grid on

subplot(3,1,3)
plot(t, y1, 'b--'); hold on;
plot(t, y2, 'r--');
plot(t, y_total, 'k', 'LineWidth', 2);
stem([0 t2], [A1 A2], 'k', 'filled');

legend('A_1 Response','A_2 Response','Total Response')
title('(c) Superposition (ZV - zero residual vibration)')
xlabel('Time [s]')
grid on