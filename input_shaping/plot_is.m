clc; clear; close all;

plot_format();   % apply styling

%%

close all;
plot_format();   % apply styling
pendulum_noIS = load("input_shaping\simulation\pendulum_noIS.mat").ans;
pendulum_ZV = load("input_shaping\simulation\pendulum_ZV.mat").ans;
pendulum_ZVD = load("input_shaping\simulation\pendulum_ZVD.mat").ans;
pendulum_ZVDD = load("input_shaping\simulation\pendulum_ZVDD.mat").ans;

figure; hold on;

% f.Units = 'centimeters';
% f.Position = [2 2 25 12];

plot(pendulum_noIS.Time(idx), pendulum_noIS.Data(idx), 'LineWidth', 1, 'Color',[0.5 0.5 0.5]); hold on;
plot(pendulum_ZV.Time(idx),pendulum_ZV.Data(idx),'r-', 'LineWidth', 2); hold on;
plot(pendulum_ZVD.Time(idx),pendulum_ZVD.Data(idx),'g-', 'LineWidth', 2); hold on;
plot(pendulum_ZVDD.Time(idx),pendulum_ZVDD.Data(idx),'b-', 'LineWidth', 2); hold on;

legend('Unshaped','ZV','ZVD','ZVDD');
% title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Angle [rad]')
grid on
box on
% Tight layout
axis([0 18 -0.2 0.2])

%%

exportgraphics(gcf, 'IS_compare_pend_sim.pdf', 'ContentType','vector');
%%

sledge_noIS = load("input_shaping\simulation\sledge_noIS.mat").ans;
sledge_ZV = load("input_shaping\simulation\sledge_ZV.mat").ans;
sledge_ZVD = load("input_shaping\simulation\sledge_ZVD.mat").ans;
sledge_ZVDD = load("input_shaping\simulation\sledge_ZVDD.mat").ans;

idx = sledge_noIS.Time <= 18;
data = sledge_noIS.Data(idx);
f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 12];
plot(sledge_noIS.Time(idx), sledge_noIS.Data(idx), 'LineWidth', 2, 'Color',[0.2 0.2 0.2]); hold on;
plot(sledge_ZV.Time(idx),sledge_ZV.Data(idx),'r-', 'LineWidth', 2); hold on;
plot(sledge_ZVD.Time(idx),sledge_ZVD.Data(idx),'g-', 'LineWidth', 2); hold on;
plot(sledge_ZVDD.Time(idx),sledge_ZVDD.Data(idx),'b-', 'LineWidth', 2); hold on;

legend('Unshaped','ZV','ZVD','ZVDD');
% title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Position [m]')
grid on
box on
% Tight layout
% axis([0 18 -0.2 0.2])
%%

exportgraphics(gcf, 'IS_compare_sledge_sim.pdf', 'ContentType','vector');

%%
close all;
plot_format();   % apply styling

sledge_noIS = load("input_shaping\is_lab\lab_sledge_noIS.mat").ans;
sledge_ZV = load("input_shaping\is_lab\lab_sledge_ZV.mat").ans;
sledge_ZVD = load("input_shaping\is_lab\lab_sledge_ZVD.mat").ans;
sledge_ZVDD = load("input_shaping\is_lab\lab_sledge_ZVDD.mat").ans;

idx = sledge_noIS.Time <= 18;
data = sledge_noIS.Data(idx);

f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 12];
plot(sledge_noIS.Time(idx), sledge_noIS.Data(idx), 'LineWidth', 2, 'Color',[0.2 0.2 0.2]); hold on;
plot(sledge_ZV.Time(idx),sledge_ZV.Data(idx),'r-', 'LineWidth', 2); hold on;
plot(sledge_ZVD.Time(idx),sledge_ZVD.Data(idx),'g-', 'LineWidth', 2); hold on;
plot(sledge_ZVDD.Time(idx),sledge_ZVDD.Data(idx),'b-', 'LineWidth', 2); hold on;

legend('Unshaped','ZV','ZVD','ZVDD');
% title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Position [m]')
grid on
box on
% Tight layout
% axis([0 18 -0.2 0.2])
%%

exportgraphics(gcf, 'IS_compare_sledge_lab.pdf', 'ContentType','vector');

%%
close all;
plot_format();   % apply styling

pend_noIS = load("input_shaping\is_lab\lab_pend_noIS.mat").ans;
pend_ZV = load("input_shaping\is_lab\lab_pend_ZV.mat").ans;
pend_ZVD = load("input_shaping\is_lab\lab_pend_ZVD.mat").ans;
pend_ZVDD = load("input_shaping\is_lab\lab_pend_ZVDD.mat").ans;

idx = pend_noIS.Time <= 18;
data = pend_noIS.Data(idx);

f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 12];
plot(pend_noIS.Time(idx), pend_noIS.Data(idx), 'LineWidth', 1, 'Color',[0.5 0.5 0.5]); hold on;
plot(pend_ZV.Time(idx),pend_ZV.Data(idx),'r-', 'LineWidth', 2); hold on;
plot(pend_ZVD.Time(idx),pend_ZVD.Data(idx),'g-', 'LineWidth', 2); hold on;
plot(pend_ZVDD.Time(idx),pend_ZVDD.Data(idx),'b-', 'LineWidth', 2); hold on;

legend('Unshaped','ZV','ZVD','ZVDD');
% title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Angle [rad]')
grid on
box on
% Tight layout
% axis([0 18 -0.2 0.2])
%%

exportgraphics(gcf, 'IS_compare_pend_lab.pdf', 'ContentType','vector');

%%
close all;

plot_format();
input_noIS = load("input_shaping\simulation\input_IS.mat").ans;
input_ZV = load("input_shaping\simulation\input_ZV.mat").ans;
input_ZVD = load("input_shaping\simulation\input_ZVD.mat").ans;
input_ZVDD = load("input_shaping\simulation\input_ZVDD.mat").ans;

idx = input_noIS.Time <= 18;
data = input_noIS.Data(idx);

f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 25 12];

plot(input_noIS.Time(idx), input_noIS.Data(idx), 'LineWidth', 2, 'Color',[0 0 0]); hold on;
plot(input_ZV.Time(idx),input_ZV.Data(idx),'r-', 'LineWidth', 2); hold on;
plot(input_ZVD.Time(idx),input_ZVD.Data(idx),'g-', 'LineWidth', 2); hold on;
plot(input_ZVDD.Time(idx),input_ZVDD.Data(idx),'b-', 'LineWidth', 2); hold on;

legend('Unshaped','ZV','ZVD','ZVDD');
% title('Comparison of Input Shaping Methods')
xlabel('Time [s]')
ylabel('Voltage [V]')
grid on
box on
% Tight layout
axis([0 18 0 4.2])
%%

exportgraphics(gcf, 'IS_compare_input.pdf', 'ContentType','vector');