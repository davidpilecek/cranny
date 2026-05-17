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

idx = 3;
% Create figure
f = figure; hold on;

f.Units = 'centimeters';
f.Position = [2 2 18 10];

plot('black', 'LineWidth', 2); hold on;
plot(); hold on;
axis tight; grid on;
title("Sledge Position", "FontSize",14)
xlabel("Time (s)")
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


%% Export (vector for report)
exportgraphics(gcf, 'sine.pdf', 'ContentType','vector');