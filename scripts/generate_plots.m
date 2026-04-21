
base = "plots/";

% 1. Data
x = data_prbs_sledge.SamplingInstants;
y1 = data_prbs_sledge.InputData;
y2 = data_prbs_sledge.OutputData;
y3 = data_prbs_pendulum.OutputData;

% 2. Figure Setup
figWidth = 35; 
figHeight = 15;

fig = figure('Units', 'centimeters', 'Position', [5, 5, figWidth, figHeight]);
hold on; grid on;

% 3. Plotting with Style
% Use distinct colors and thicker lines
p1 = plot(x, y1, 'LineWidth', 1.3, 'Color', [0 0 0], 'DisplayName', 'Signal $A$');
% p1 = plot(x, y2, 'LineWidth', 1.3, 'Color', "b", 'DisplayName', 'Signal $A$');
% p1 = plot(x, y3, 'LineWidth', 1.3, 'Color', "r", 'DisplayName', 'Signal $A$');

% 4. LaTeX Formatting & Axes properties
set(gca, ...
    'TickLabelInterpreter', 'latex', ...
    'FontSize', 18, ...
    'FontName', 'Times New Roman', ... % Standard for academic journals
    'Box', 'on', ...
    'LineWidth', 1.2);

% Labels with LaTeX syntax
xlabel('\textbf{Time (s)}', 'Interpreter', 'latex', 'FontSize', 22);
ylabel('\textbf{Voltage (V)}', 'Interpreter', 'latex', 'FontSize', 22);
% ylabel('\textbf{Position (m)}', 'Interpreter', 'latex', 'FontSize', 22);
% ylabel('\textbf{Angle (rad)}', 'Interpreter', 'latex', 'FontSize', 22);
% title('\textbf{Input Signal}', 'Interpreter', 'latex', 'FontSize', 14);

% Legend
% lgd = legend('show', 'Location', 'northeast', 'Interpreter', 'latex');
% lgd.FontSize = 10;

% 5. Exporting (High Resolution)

exportgraphics(fig, base + 'PRBS_input.pdf', 'ContentType', 'vector');

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

%% 1. Data Generation
x = data_pulse_sledge.SamplingInstants;
y_left = data_pulse_sledge.InputData; % Primary data
y_right = data_pulse_sledge.OutputData;                % Secondary data with different scale


% 2. Figure Setup
figWidth = 35; 
figHeight = 15;
fig = figure('Units', 'centimeters', 'Position', [5, 5, figWidth, figHeight]);
hold on; 

% 3. Left Axis (Primary)
yyaxis left
p1 = plot(x, y_left, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
ylabel('Oscillation [$\mu$V]', 'Interpreter', 'latex', 'FontSize', 12);
ax = gca;
ax.YColor = [0, 0.4470, 0.7410]; % Match axis color to the line

% 4. Right Axis (Secondary)
yyaxis right
p2 = plot(x, y_right, '-', 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
ylabel('Power Growth [$W$]', 'Interpreter', 'latex', 'FontSize', 12);
ax.YColor = [0.6350, 0.0780, 0.1840]; % Match axis color to the line

% 5. Global Styling & Labels
grid on;
xlabel('Time [$s$]', 'Interpreter', 'latex', 'FontSize', 12);
title('\textbf{Dual-Scale Analysis}', 'Interpreter', 'latex', 'FontSize', 14);

% Universal Axis settings (apply to both sides)
set(gca, ...
    'TickLabelInterpreter', 'latex', ...
    'FontSize', 11, ...
    'FontName', 'Times New Roman', ...
    'Box', 'on');

% Legend - Using handles ensures labels match the correct lines
legend([p1, p2], {'Signal $A$', 'Growth $B$'}, ...
    'Interpreter', 'latex', 'Location', 'northwest');

%% 6. Export
exportgraphics(fig, 'DualAxisPlot.pdf', 'ContentType', 'vector');