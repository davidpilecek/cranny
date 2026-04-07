
% 
% % === COMPENSATED PRBS =========================================
% u  = load("hidden/compensated/prbs_comp_input.mat").ans;
% ys = load("hidden/compensated/prbs_comp_sledge_cm.mat").ans;
% yp = load("hidden/compensated/prbs_comp_pendulum_deg.mat").ans;
% 
% tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
% tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
% t = (tmin:Ts:tmax)';
% yp.Data = yp.Data - mean(yp.Data);
% 
% u_i  = interp1(u.Time,  u.Data,  t);
% ys_i = interp1(ys.Time, ys.Data, t);
% yp_i = interp1(yp.Time, yp.Data, t);
% 
% % Filter
% y_p_f = filtfilt(b,a,yp_i);
% 
% data_prbs_c_sledge   = iddata(ys_i, u_i, Ts);
% data_prbs_c_pendulum = iddata(y_p_f, ys_i, Ts);
% 
% % === COMPENSATED RGS =========================================
% u  = load("hidden/compensated/rgs_c_input.mat").ans;
% ys = load("hidden/compensated/rgs_c_sledge_cm.mat").ans;
% yp = load("hidden/compensated/rgs_c_pendulum_deg.mat").ans;
% 
% tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
% tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
% t = (tmin:Ts:tmax)';
% yp.Data = yp.Data - mean(yp.Data);
% 
% u_i  = interp1(u.Time,  u.Data,  t);
% ys_i = interp1(ys.Time, ys.Data, t);
% yp_i = interp1(yp.Time, yp.Data, t);
% 
% % Filter
% y_p_f = filtfilt(b,a,yp_i);
% 
% data_rgs_c_sledge   = iddata(ys_i, u_i, Ts);
% data_rgs_c_pendulum = iddata(y_p_f, ys_i, Ts);

%% Load Responses With Filter
clc;clear;

Ts = 0.01;
fc = 6;
fc_sledge = 2;
[b,a] = butter(2, fc * 2 * Ts);  % normalized frequency, 2nd order, butterworth filter
[b2,a2] = butter(2, fc_sledge * 2 * Ts);

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
plot(yp.Data)
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
y_s_f = filtfilt(b2,a2,ys_i);

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
%%
data_estimate_sledge = merge(data_step_sledge, data_ramp_sledge, data_bang_sledge, data_saw_sledge);

% plot(data_estimate_sledge)

%% SS sledge

par0 = [0.1; 0.01; 0.001; 5]; % initial guesses

sys = idgrey('sledge_model', par0, 'c');

sys.Structure.Parameters(1).Minimum = 0; % Kt
sys.Structure.Parameters(2).Minimum = 0; % Jm
sys.Structure.Parameters(3).Minimum = 0; % Dm
sys.Structure.Parameters(4).Minimum = 0; % Ds

opt = greyestOptions;
opt.Display = 'on';

sys_sledge = greyest(data_estimate_sledge, sys, opt);
tf_sledge_gb = tf(sys_sledge)
%%
compare(data_estimate_sledge, sys_est)
%% Estimate tf sledge

% source = merge(data_step_sledge, data_ramp_sledge, data_bang_sledge, data_saw_sledge);
source = data_prbs_sledge;

Opt = tfestOptions('Display','on');
np = 2;
ioDelay = delayest(source) * Ts;

tfSledge = tfest(source, np, 0, ioDelay, Opt)

%%

data_estimate_pendulum = merge(data_bang_pendulum, data_saw_pendulum, data_ramp_pendulum, data_pulse_pendulum);

% Initial guesses
Jp0 = 0.015;
Dp0 = 0.005;

par0 = [Jp0; Dp0];

sys = idgrey('pendulum_model', par0, 'c');
sys.Structure.Parameters(1).Minimum = 0; % Jp > 0
sys.Structure.Parameters(2).Minimum = 0; % Dp > 0
sys_est = greyest(data_estimate_pendulum, sys)

%%

tfPend = tf(sys_est)
zero(sys_tf);
%%
plot(data_step_pendulum)
%%
y_valid = lsim(tfSledge, data_sine_sledge.InputData, data_sine_sledge.SamplingInstants);

plot(data_sine_sledge.SamplingInstants, y_valid)
figure
plot(data_sine_sledge.SamplingInstants, data_sine_sledge.OutputData)


%% Validate sledge
source_val = data_ramp_sledge;
 
figure
compare(source_val, tfSledge)
t = (0:length(source_val.InputData)-1)' * Ts;

y_sim = lsim(tfSledge, source_val.InputData, t);
figure
plot(y_sim)
hold on
plot(source_val.OutputData)

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
compare(data_step_pendulum, tfPend)
figure
compare(data_sine2_pendulum, tfPend)
figure
compare(data_pulse_pendulum, tfPend)
figure
compare(data_saw_pendulum, tfPend)
% resid(data_bang_pendulum, tfPend)

%% Validate pendulum
% source_val = data_prbs_pendulum;

figure
compare(data_prbs_pendulum, tfPend)
figure
compare(data_step_pendulum, tfPend)
figure
compare(data_bang_pendulum, tfPend)
figure
compare(data_pulse_pendulum, tfPend)
figure
compare(data_saw_pendulum, tfPend)

%%
tfPend

% tfPend2 = tf([0.073 0 0], [0.015 0.002 0.7168])
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