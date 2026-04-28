%% Load Responses With Filter
clc;clear;

Ts = 0.01;
fc = 8;
[b,a] = butter(2, fc * 2 * Ts);  % normalized frequency, 2nd order, butterworth filter

base = "PC2/responses/";

% === BANG ======================================
u  = load(base + "bang_in.mat").ans;
ys = load(base + "bang_sled.mat").ans;
yp = load(base + "bang_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';

yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_bang_sledge = iddata(ys_i, u_i, Ts);
data_bang_pendulum = iddata(y_p_f, ys_i, Ts);

% ==================== PRBS ======================================
u  = load(base + "prbs_in.mat").ans;
ys = load(base + "prbs_sled.mat").ans;
yp = load(base + "prbs_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
% plot(yp.Data)
% hold on
y_p_f = filtfilt(b,a,yp_i);

% plot(y_p_f)
data_prbs_sledge    = iddata(ys_i, u_i, Ts);
data_prbs_pendulum  = iddata(y_p_f, ys_i, Ts);

% === PRBS2 ======================================
u  = load(base + "prbs2_in.mat").ans;
ys = load(base + "prbs2_sled.mat").ans;
yp = load(base + "prbs2_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_prbs2_sledge   = iddata(ys_i, u_i, Ts);
data_prbs2_pendulum = iddata(y_p_f, ys_i, Ts);

% === RAMP =========================================
u  = load(base + "ramp_in.mat").ans;
ys = load(base + "ramp_sled.mat").ans;
yp = load(base + "ramp_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';

yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);

yp_i = interp1(yp.Time, yp.Data, t);
ys_i = interp1(ys.Time, ys.Data, t, 'linear');

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_ramp_sledge   = iddata(ys_i, u_i, Ts);
data_ramp_pendulum = iddata(y_p_f, ys_i, Ts);

% === STEP =========================================
u  = load(base + "step_in.mat").ans;
ys = load(base + "step_sled.mat").ans;
yp = load(base + "step_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_step_sledge   = iddata(ys_i, u_i, Ts);
data_step_pendulum = iddata(y_p_f, ys_i, Ts);

% === SAW =========================================
u  = load(base + "saw_in.mat").ans;
ys = load(base + "saw_sled.mat").ans;
yp = load(base + "saw_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_saw_sledge   = iddata(ys_i, u_i, Ts);
data_saw_pendulum = iddata(y_p_f, ys_i, Ts);

% === PULSE =========================================
u  = load(base + "pulse_in.mat").ans;
ys = load(base + "pulse_sled.mat").ans;
yp = load(base + "pulse_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter

y_p_f = filtfilt(b,a,yp_i);

data_pulse_sledge   = iddata(ys_i, u_i, Ts);
data_pulse_pendulum = iddata(y_p_f, ys_i, Ts);

% === sine2 =========================================
u  = load(base + "sine2_in.mat").ans;
ys = load(base + "sine2_sled.mat").ans;
yp = load(base + "sine2_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_sine2_sledge   = iddata(ys_i, u_i, Ts);
data_sine2_pendulum = iddata(y_p_f, ys_i, Ts);


% === sine =========================================
u  = load(base + "sine_in.mat").ans;
ys = load(base + "sine_sled.mat").ans;
yp = load(base + "sine_pend.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_sine_sledge   = iddata(ys_i, u_i, Ts);
data_sine_pendulum = iddata(y_p_f, ys_i, Ts);

%%
source = data_step_pendulum;
t = source.SamplingInstants;

t_start = 1.5;
t_end = 46.5;
idx = t >= t_start & t <= t_end;

% 1. Extract raw data
raw_data = source.OutputData(idx);
t_raw = t(idx); % This still starts at 1.5

% 2. --- THE SHIFT ---
% Subtract the first value so the vector starts at 0.000
t_zeroed = t_raw - t_raw(1); 

% 3. --- THE OFFSET REMOVAL ---
steady_state = mean(raw_data(end-50:end)); 
data = raw_data - steady_state; 

%% Pendulum Damping Calculation
t_new = t_zeroed;
fs = 1/mean(diff(t_new)); % Calculate actual sample rate from time vector

% 1. Find Peaks 
% We use abs(data) if you want to include troughs, 
% but standard log dec uses successive positive peaks.
[pks, locs] = findpeaks(data, t_new, 'MinPeakDistance', 0.8); 

% 2. Calculate Logarithmic Decrement (delta)
n = length(pks) - 1; 
x1 = pks(1);
xn_plus_1 = pks(end);

A_init = pks(1);
% Ensure we aren't taking the log of a negative number
delta = (1/n) * log(abs(x1) / abs(xn_plus_1));

% 3. Calculate Damping Ratio (zeta)
zeta_calc = delta / sqrt(4*pi^2 + delta^2);

% 4. Frequency Calculation
total_time = locs(end) - locs(1);
Td = total_time / n;            
fd_calc = 1 / Td;               
fn_calc = fd_calc / sqrt(1 - zeta_calc^2);

% 5. Results
fprintf('--- Results ---\n');
fprintf('Log Dec (delta): %.4f\n', delta);
fprintf('Damping (zeta):  %.4f\n', zeta_calc);
fprintf('Nat Freq (fn):   %.4f Hz\n', fn_calc);

T_avg = mean(diff(locs)); % Average period
fn_est = 1 / T_avg;       % Frequency in Hz
wn_est = 2 * pi * fn_est; % Frequency in rad/s

% Use locs(1) to find the exact time of the first peak
t_first_peak = locs(1); 
sigma = zeta_calc * wn_est;
% Calculate the envelope starting from the first peak's time
upper_env = A_init * exp(-sigma * (t_new - t_first_peak));
lower_env = -A_init * exp(-sigma * (t_new - t_first_peak));

% 6. Visualization
figure;
plot(t_new, data, 'b', linewidth=1.3); hold on;
% Plot the peaks to show the fit
plot(locs, pks, 'o', 'MarkerFaceColor', [0.5 0 0.8], 'DisplayName', 'Measured Peaks'); hold on;
yline(0, 'k--'); % Show the new zero center
grid on;

% % Plot the envelopes
plot(t_new, upper_env, 'r--', 'LineWidth', 3, 'DisplayName', 'Upper Envelope');
plot(t_new, lower_env, 'r--', 'LineWidth', 3, 'HandleVisibility', 'off');


%%

s = tf('s');

fn_rad = 2*pi*fn_calc;

tfPend = tf([fn_rad^2/9.18 0 0], [1 2*zeta_calc*fn_rad fn_rad^2])

% G = ((fn_rad^2/9.18)*s^2) / (s^2 + 2*zeta_calc*fn_rad*s + fn_rad^2
