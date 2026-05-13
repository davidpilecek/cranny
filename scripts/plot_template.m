
plot_format();   % apply styling

%%

% Create figure
figure; hold on;

u  = load(base + "prbs_in.mat").ans;
ys = load(base + "prbs_sled.mat").ans;
yp = load(base + "prbs_pend.mat").ans;

new_data = yp.Data(idx) - mean(yp.Data(idx))
new_data2 = y_p_f(idx) - mean(y_p_f(idx))

plot(yp.Time(idx), new_data, Color='r', LineWidth=1.5)
hold on
plot(yp.Time(idx), new_data2, Color='b', LineWidth=1.5)


xlabel("Time (s)")
ylabel("Angle (rad)")

legend('Original','Filtered');

% Tight layout
% axis tight;

% Export (vector for report)
exportgraphics(gcf, 'filtered_pend.pdf', 'ContentType','vector');


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