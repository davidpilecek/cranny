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


%% === sine =========================================
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


%% Estimate tf sledge

data_estimate_sledge = merge(data_bang_sledge, data_saw_sledge, data_pulse_sledge, data_ramp_sledge, data_prbs_sledge);
source = data_estimate_sledge;

Opt = tfestOptions('Display','on');
Opt.InitialCondition = 'zero';
Opt.SearchOptions.MaxIterations = 40;

np = 2;
ioDelay = delayest(source) * Ts;

tfSledge = tfest(source, np, 0, ioDelay, Opt)

%%

tfSledge_j = tf([4.88], [20.11 238.20 0])

%% Validate sledge
source_val = data_step_sledge;
figure
compare(source_val, tfSledge)
t = (0:length(source_val.InputData)-1)' * Ts;

y_sim = lsim(tfSledge, source_val.InputData, t);
figure
plot(y_sim)
hold on
plot(source_val.OutputData)

%%
y_sim = lsim(tfSledge, source_val.InputData, t, x0);
figure
plot(y_sim)
hold on
plot(source_val.OutputData)

%%
figure
compare(data_prbs_sledge, tfSledge2)
figure
compare(data_step_sledge, tfSledge2)
figure
compare(data_bang_sledge, tfSledge2)
figure
compare(data_pulse_sledge, tfSledge2)
figure
compare(data_saw_sledge, tfSledge2)

%%

figure
compare(data_prbs2_sledge, tfSledge)
figure
compare(data_step_sledge, tfSledge)
figure
compare(data_bang_sledge, tfSledge)
figure
compare(data_pulse_sledge, tfSledge)
figure
compare(data_saw_sledge, tfSledge)
figure
compare(data_sine_sledge, tfSledge)

%%

sledge_resp = lsim(tfSledge, out.input_sim.Data, out.input_sim.Time);
pend_resp = lsim(tfPend2, out.sledge.Data, out.sledge.Time);

figure
plot(out.sledge.Time, sledge_resp)
hold on
plot(out.sledge)
legend("simulated", "real")

figure
plot(out.input_sim)

figure
plot(out.pend.Time, pend_resp)
hold on
plot(out.pend.Time, out.pend.Data*180/pi)
legend("simulated", "real")

%% GREYBOX PENDULUM

% data_estimate_pendulum = merge(data_bang_pendulum, data_saw_pendulum, data_ramp_pendulum, data_pulse_pendulum, data_prbs_pendulum);
data_estimate_pendulum = merge(data_bang_pendulum, data_saw_pendulum, data_pulse_pendulum, data_step_pendulum, data_sine2_pendulum, data_ramp_pendulum, data_prbs_pendulum);

% Initial guesses
Jp0 = 0.016;
Dp0 = 0.008;

par0 = [Jp0; Dp0];

sys = idgrey('pendulum_model', par0, 'c');
sys.Structure.Parameters(1).Minimum = 0; % Jp > 0
sys.Structure.Parameters(2).Minimum = 0; % Dp > 0

opt = greyestOptions;
opt.Display = "on";
opt.InitialState = 'zero';

sys_est = greyest(data_estimate_pendulum, sys, opt);
tfPend = tf(sys_est)

%% Validate pendulum
source_val_pend = data_step_pendulum;
figure
compare(source_val_pend, tfPend)
t = (0:length(source_val_pend.InputData)-1)' * Ts;

y_sim = lsim(tfPend, source_val_pend.InputData, t);
figure
plot(y_sim)
hold on
plot(source_val_pend.OutputData)

%% Estimate tf pendulum
% source = data_prbs_pendulum;

Opt = tfestOptions('Display','on');
np = 2;
nz = 2;

source = merge(data_prbs_pendulum, data_bang_pendulum, data_saw_pendulum, data_sine2_pendulum);
% source = data_prbs_pendulum;
ioDelay = delayest(source) * Ts
tfPend = tfest(source, np, nz, ioDelay, Opt)

%% Validate pendulum
% source_val = data_prbs_pendulum;

figure
compare(data_prbs2_pendulum, tfPend)
figure
compare(data_sine2_pendulum, tfPend)
figure
compare(data_step_pendulum, tfPend)
plot(ls)

%%
figure
compare(data_prbs2_pendulum, tf_jakob)
figure
compare(data_sine2_pendulum, tf_jakob)
figure
compare(data_step_pendulum, tf_jakob)

%% Validate pendulum
% source_val = data_prbs_pendulum;

figure
compare(data_bang_pendulum, tfPend)
% figure
% compare(data_step_pendulum, tfPend)
% figure
% compare(data_bang_pendulum, tfPend)
% figure
% compare(data_pulse_pendulum, tfPend)
% figure
% compare(data_saw_pendulum, tfPend)

%%

figure
compare(data_prbs2_pendulum, tfPend2)
figure
compare(data_rgs_pendulum, tfPend2)
figure
compare(data_step2_pendulum, tfPend2)
figure
compare(data_bang_pendulum, tfPend2)
figure
compare(data_pulse_pendulum, tfPend2)
figure
compare(data_saw_pendulum, tfPend2)