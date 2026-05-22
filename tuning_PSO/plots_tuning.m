close all;

gains = readtable('logs/cascade_cart_inner_abs.csv');

gens = [1, 2, 5, 10, 20, 70];

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

% % Errors
% ad = 0;
% ex = xd - x;
% ea = ad - alpha;

% figure
% plot(t, ref, "b--", LineWidth=2)
% hold on
% plot(t, x, LineWidth=2)
% legend("reference", "cart position")

% figure
plot(t, alpha)
hold on
end


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