close all;
plot_format();   % apply styling

data_sledge = {data_bang_sledge, data_pulse_sledge, data_sine_sledge, data_sine2_sledge, data_step_sledge};
data_pend = {data_bang_pendulum, data_pulse_pendulum, data_sine_pendulum, data_sine2_pendulum, data_step_pendulum};

idx = 3;
% Create figure
f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 18 10];

subplot(2,1,1)

plot(data_sledge{idx}.SamplingInstants, data_sledge{idx}.OutputData, 'black', 'LineWidth', 2); hold on;
plot(data_sledge{idx}.SamplingInstants, lsim(tf_sledge, data_sledge{idx}.InputData, data_sledge{idx}.SamplingInstants), 'r--', 'LineWidth', 2)
axis tight; grid on;
title("Sledge Position", "FontSize",14)
% xlabel("Time (s)")
ylabel("Position (m)")
% legend('Measured', 'Simulated');

% Tight layout
subplot(2,1,2)
plot(data_pend{idx}.SamplingInstants, data_pend{idx}.OutputData, 'black', 'LineWidth', 2); hold on;
plot(data_pend{idx}.SamplingInstants, lsim(tf_pend, data_pend{idx}.InputData, data_pend{idx}.SamplingInstants), 'r--', 'LineWidth', 2)
axis tight; grid on;
title("Pendulum Angle", "FontSize",14)
xlabel("Time (s)")
ylabel("Angle (rad)")
% legend('Measured', 'Simulated');

% Export (vector for report)
exportgraphics(gcf, 'sine.pdf', 'ContentType','vector');

%% System parameters

close all;
plot_format();   % apply styling

wn = 2*pi*0.5;

zeta = 0.001;
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

% Create figure
f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 20];

subplot(3,1,1)
plot(t, y1, 'b--', 'LineWidth', 2); hold on;
stem(0, A1, 'k', 'filled');
title('(a) Response to $A_1$'); 
% xlabel('Time [s]')
ylabel('Angle [rad]')

subplot(3,1,2)
plot(t, y2, 'r--', 'LineWidth', 2); hold on;
stem(t2, A2, 'k', 'filled');
title('(b) Response to $A_2$'); 
% xlabel('Time [s]')
ylabel('Angle [rad]')

subplot(3,1,3)
plot(t, y1, 'b--', 'LineWidth', 2); hold on;
plot(t, y2, 'r--', 'LineWidth', 2);
plot(t, y_total, 'k', 'LineWidth', 3);
stem([0 t2], [A1 A2], 'k', 'filled');

legend('$A_1$ Response','$A_2$ Response','Total Response\,');
title('(c) Superposition (ZV - zero residual vibration)')
xlabel('Time [s]')
ylabel('Angle [rad]')
% Tight layout
axis tight;

%% Export (vector for report)
exportgraphics(gcf, 'input_shaping_report.pdf', 'ContentType','vector');

%%

close all;
plot_format();   % apply styling

data_sledge = {data_bang_sledge, data_pulse_sledge, data_sine_sledge, data_sine2_sledge, data_step_sledge};
data_pend = {data_bang_pendulum, data_pulse_pendulum, data_sine_pendulum, data_sine2_pendulum, data_step_pendulum};

idx = 5;
% Create figure
f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 10];

% plot('black', 'LineWidth', 2); hold on;
% plot(); hold on;
% axis tight; grid on;
% title("Sledge Position", "FontSize",14)
% xlabel("Time (s)")
% ylabel("Position (m)")
% % legend('Measured', 'Simulated');
% 

% Tight layout
% subplot(2,1,2)

plot(data_pend{idx}.SamplingInstants, data_pend{idx}.OutputData, 'black', 'LineWidth', 2); hold on;
plot(data_pend{idx}.SamplingInstants, lsim(tf_pend, data_pend{idx}.InputData, data_pend{idx}.SamplingInstants), 'r--', 'LineWidth', 2)
axis tight; grid on;
title("Pendulum Angle", "FontSize",20)
xlabel("Time (s)")
ylabel("Angle (rad)")


%% Export (vector for report)
exportgraphics(gcf, 'step_pend.pdf', 'ContentType','vector');

%%

base = "plots/";

% ===== ONLY EDIT THIS =====
signal = "pulse";

t_max = inf;   % set e.g. 5 to plot first 5 seconds, or inf for full signal
% ==========================

% Load datasets
data_sledge   = eval("data_" + signal + "_sledge");
data_pendulum = eval("data_" + signal + "_pendulum");

% Common time vector
x = data_sledge.SamplingInstants;

% Build time mask
if isfinite(t_max)
    idx = x <= t_max;
else
    idx = true(size(x));
end

% Optional safety check
assert(numel(x) == numel(data_pendulum.OutputData), ...
    'Time vector mismatch between sledge and pendulum');

% Define plots
plots = {
    data_sledge.InputData,    "input",    '\textbf{Voltage (V)}',   [0 0 0];
    data_sledge.OutputData,   "sledge",   '\textbf{Position (m)}',  [0 0 1];
    data_pendulum.OutputData, "pendulum", '\textbf{Angle (rad)}',   [1 0 0];
};

% Loop
for i = 1:size(plots,1)

    y_full   = plots{i,1};
    suffix   = plots{i,2};
    ylabel_t = plots{i,3};
    color    = plots{i,4};

    % Apply same time mask
    y = y_full(idx);
    x_plot = x(idx);

    fig = figure('Units', 'centimeters', 'Position', [5, 5, 35, 15]);
    hold on; grid on;

    plot(x_plot, y, ...
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