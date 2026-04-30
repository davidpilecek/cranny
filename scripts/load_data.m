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

% === COMPENSATED =========================================
u  = load("hidden/compensated/prbs_comp_input.mat").ans;
ys = load("hidden/compensated/prbs_comp_sledge.mat").ans;
yp = load("hidden/compensated/prbs_comp_pendulum.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_comp_sledge   = iddata(ys_i, u_i, Ts);
data_comp_pendulum = iddata(y_p_f, ys_i, Ts);


