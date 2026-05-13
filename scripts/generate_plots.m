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
signal = "step";

t_max = 50;   % set e.g. 5 to plot first 5 seconds, or inf for full signal
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
    if suffix == "input"
        axis([0 50 0 10])
    end
    filename = base + signal + "_" + suffix + ".pdf";
    exportgraphics(fig, filename, 'ContentType', 'vector');

    close(fig);
end