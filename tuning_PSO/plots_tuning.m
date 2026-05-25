close all;
plot_format();
gains = readtable('logs/cascade_cart_inner_abs.csv');

gens = [1, 2, 5, 10, 20, 70];

f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 30 15];

colors = turbo(length(gens));

for i = 1:length(gens)

id_gain = gens(i);

% Gains
Kpx = gains.Kpx(id_gain)
Kpa = gains.Kpa(id_gain)
Kda = gains.Kda(id_gain)

% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation
simOut = sim( ...
    'gantryModel', ...
    'StopTime','18');
    % 'FastRestart','on');

% Extract logged signals
x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;
% ref = [xd, t]
ref = linspace(xd, xd, length(t));

plot(t, alpha, ...
    'LineWidth',2, ...
    'Color',colors(i,:))
hold on
end

% title("Pendulum sway across genera")
xlabel("Time (s)")
ylabel("Angle (deg)")
lgd = legend( ...
    'Generation 1', ...
    'Generation 2', ...
    'Generation 5', ...
    'Generation 10', ...
    'Generation 20', ...
    'Final Generation');

lgd.Position(3) = lgd.Position(3) + 0.02;

%%
exportgraphics(gcf, "pendulum_tuning_progression.pdf")

%%

close all;

gains = readtable('logs/cascade_cart_inner_abs.csv');

gens = [1, 2, 5, 10, 20, 70];

f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 30 15];

colors = turbo(length(gens));

for i = 1:length(gens)

id_gain = gens(i);

% Gains
Kpx = gains.Kpx(id_gain)
Kpa = gains.Kpa(id_gain)
Kda = gains.Kda(id_gain)

% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation
simOut = sim( ...
    'gantryModel', ...
    'StopTime','18');
    % 'FastRestart','on');

% Extract logged signals
x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;
% ref = [xd, t]
ref = linspace(xd, xd, length(t));

plot(t, x, ...
    'LineWidth',2, ...
    'Color',colors(i,:))
hold on
end

xlabel("Time (s)")
ylabel("Position (m)")
lgd = legend( ...
    'Generation 1', ...
    'Generation 2', ...
    'Generation 5', ...
    'Generation 10', ...
    'Generation 20', ...
    'Final Generation');

lgd.Position(3) = lgd.Position(3) + 0.02;

%%
exportgraphics(gcf, "cart_tuning_progression.pdf")


%% Plot the responses of each optimised controller

clc; clear; close all;
plot_format();
base = "tuning_PSO/data/";
x = load(base + "parallel_sim_step.mat").x;
a = load(base + "parallel_sim_step.mat").angle;

% Time vector

t = 0:0.01:17;
t = t(:);

xd = 0.8;
ref = xd * ones(length(t),1);

% Figure setup

f = figure;

f.Units = 'centimeters';
f.Position = [2 2 38 12];

tiledlayout(1,2,'TileSpacing','compact','Padding','compact');

% Cart position subplot

nexttile

plot(t, x, ...
    'LineWidth', 2)
hold on

plot(t, ref, '--', ...
    'LineWidth', 1.5)

grid on
xlim([0 18])
xlabel('Time (s)')
ylabel('Position (m)')

lgd = legend('Cart Position', 'Reference', ...
    'Location','best');

lgd.Position(3) = lgd.Position(3) + 0.02;
% Pendulum sway subplot

nexttile

plot(t, a, ...
    'LineWidth', 2)

grid on
xlim([0 18])
xlabel('Time (s)')
ylabel('Angle (deg)')

lgd = legend('Pendulum Sway', ...
    'Location','best');

lgd.Position(3) = lgd.Position(3) + 0.02;

colormap(turbo)


%%
exportgraphics(f, "parallel.pdf")

%%
close all;

gains = readtable('logs/cascade_cart_inner_abs.csv');

id_gain = height(gains);

% Gains
Kpx = gains.Kpx(id_gain)
Kpa = gains.Kpa(id_gain)
Kda = gains.Kda(id_gain)

% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation
simOut = sim( ...
    'gantryModel', ...
    'StopTime','17');
    % 'FastRestart','on');

% Extract logged signals
x = simOut.logsout.get('x').Values.Data;
angle = simOut.logsout.get('alpha').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

ref = linspace(xd, xd, length(t));

figure
plot(t, ref, "b--", LineWidth=2)
hold on
plot(t, x, LineWidth=2)
legend("reference", "cart position")

figure
plot(t, angle)

save("cart_cascade_cart_inner_step.mat", "x");

save("pend_cascade_cart_inner_step.mat", "angle");

%%
close all;

gains = readtable('logs/cascade_pend_inner_abs.csv');

id_gain = height(gains);

% Gains
Kpx = gains.Kpx(id_gain)
Kpa = gains.Kpa(id_gain)
Kda = gains.Kda(id_gain)

% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation
simOut = sim( ...
    'gantryModel', ...
    'StopTime','17');
    % 'FastRestart','on');

% Extract logged signals
x = simOut.logsout.get('x').Values.Data;
angle = simOut.logsout.get('alpha').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

ref = linspace(xd, xd, length(t));

figure
plot(t, ref, "b--", LineWidth=2)
hold on
plot(t, x, LineWidth=2)
legend("reference", "cart position")

figure
plot(t, angle)

save("cart_cascade_pend_inner_step.mat", "x");

save("pend_cascade_pend_inner_step.mat", "angle");

%%

a3 = load("C:\Users\David\Documents\MATLAB\cranny\tuning_PSO\responses_real\pend_cascade_cart_in_PSO_seq.mat").ans.Data;
a4 = load("C:\Users\David\Documents\MATLAB\cranny\tuning_PSO\responses_real\pend_cascade_cart_in_PSO.mat").ans.Data;
a5 = load("C:\Users\David\Documents\MATLAB\cranny\tuning_PSO\responses_real\pend_cascade_pend_in_PSO_seq.mat").ans.Data;
a6 = load("C:\Users\David\Documents\MATLAB\cranny\tuning_PSO\responses_real\pend_cascade_pend_in_PSO.mat").ans.Data;

%%
% clc;clear;close all;
S = load("responses_real/pend_parallel_PSO_sequence.mat");

ts = S.ans;

% Create new uniform time vector
Ts = 0.01;
t_new = ts.Time(1):Ts:ts.Time(end);

% Resample timeseries
ts_uniform = resample(ts, t_new);

real_resp_angle = squeeze(ts_uniform.Data);

%%
clc;clear;close all;

gains = readtable('logs/cascade_cart_inner_abs.csv');

source = "cascade_cart_in_PSO_seq.mat";
source_cart = "responses_real/cart_" + source;
source_pend = "responses_real/pend_" + source;

real_resp_x = load(source_cart).ans.Data;
real_resp_angle = squeeze(load(source_pend).ans.Data);
time_real = load(source_cart).ans.Time;

real_resp_x = abs(real_resp_x);

id_gain = height(gains);

% Gains
Kpx = gains.Kpx(id_gain);
Kpa = gains.Kpa(id_gain);
Kda = gains.Kda(id_gain);

%%
% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation
simOut = sim( ...
    'gantryModel', ...
    'StopTime','50');
    % 'FastRestart','on');

% Extract logged signals
x = simOut.logsout.get('x').Values.Data;
angle = simOut.logsout.get('alpha').Values.Data;
ref = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

% ref = linspace(xd, xd, length(t));

figure
plot(t, ref, "b--", LineWidth=2)
hold on
plot(t, x, LineWidth=2)
hold on
plot(t, real_resp_x, LineWidth=2)

legend("reference", "cart position")

figure
plot(t, angle, LineWidth=2)
hold on
plot(t, real_resp_angle, LineWidth=2)

base_save = "tuning_PSO/responses_sim/cascade_cart_in_";

save(base_save + "real_sequence.mat", "real_resp_x", "real_resp_angle");
save(base_save + "sim_sequence.mat", "x", "angle");