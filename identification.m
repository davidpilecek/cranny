
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

base = "responses_crane2/";

% === BANG ======================================
u  = load(base + "bang_input.mat").ans;
ys = load(base + "bang_sledge_cm.mat").ans;
yp = load(base + "bang_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';

yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);


ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_bang_sledge = iddata(ys_i, u_i, Ts);
data_bang_pendulum = iddata(y_p_f, ys_i, Ts);

% ==================== PRBS ======================================
u  = load(base + "prbs_input.mat").ans;
ys = load(base + "prbs_sledge_cm.mat").ans;
yp = load(base + "prbs_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
plot(yp_i)
hold on
y_p_f = filtfilt(b,a,yp_i);
plot(y_p_f)
data_prbs_sledge    = iddata(ys_i, u_i, Ts);
data_prbs_pendulum  = iddata(y_p_f, ys_i, Ts);

% === PRBS2 ======================================
u  = load(base + "prbs2_input.mat").ans;
ys = load(base + "prbs2_sledge_cm.mat").ans;
yp = load(base + "prbs2_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);
y_s_f = filtfilt(b2,a2,ys_i);

data_prbs2_sledge   = iddata(ys_i, u_i, Ts);
data_prbs2_pendulum = iddata(y_p_f, ys_i, Ts);

% === RAMP =========================================
u  = load(base + "ramp_input.mat").ans;
ys = load(base + "ramp_sledge_cm.mat").ans;
yp = load(base + "ramp_pendulum_deg.mat").ans;


tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';

yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);

yp_i = interp1(yp.Time, yp.Data, t);
ys_i = interp1(ys.Time, ys.Data, t, 'linear');

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_ramp_sledge   = iddata(ys_i, u_i, Ts);
data_ramp_pendulum = iddata(y_p_f, ys_i, Ts);

% === RGS =========================================
u  = load(base + "rgs_input.mat").ans;
ys = load(base + "rgs_sledge_cm.mat").ans;
yp = load(base + "rgs_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_rgs_sledge   = iddata(ys_i, u_i, Ts);
data_rgs_pendulum = iddata(y_p_f, ys_i, Ts);

% === STEP2 =========================================
u  = load(base + "step2_input.mat").ans;
ys = load(base + "step2_sledge_cm.mat").ans;
yp = load(base + "step2_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);


ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_step2_sledge   = iddata(ys_i, u_i, Ts);
data_step2_pendulum = iddata(y_p_f, ys_i, Ts);

% === SAW =========================================
u  = load("validation\saw_input.mat").ans;
ys = load("validation\saw_sledge_cm.mat").ans;
yp = load("validation\saw_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_saw_sledge   = iddata(ys_i, u_i, Ts);
data_saw_pendulum = iddata(y_p_f, ys_i, Ts);

% === PULSE =========================================
u  = load("validation\pulse_input.mat").ans;
ys = load("validation\pulse_sledge_cm.mat").ans;
yp = load("validation\pulse_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);


u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter

y_p_f = filtfilt(b,a,yp_i);

data_pulse_sledge   = iddata(ys_i, u_i, Ts);
data_pulse_pendulum = iddata(y_p_f, ys_i, Ts);

% === sine2 =========================================
u  = load("validation\sine2_input.mat").ans;
ys = load("validation\sine2_sledge_cm.mat").ans;
yp = load("validation\sine2_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);


ys_i = ys_i / 100;          % cm → m
yp_i = yp_i * pi / 180;     % deg → rad
% Filter
y_p_f = filtfilt(b,a,yp_i);

data_sine2_sledge   = iddata(ys_i, u_i, Ts);
data_sine2_pendulum = iddata(y_p_f, ys_i, Ts);


data_estimate_sledge = merge(data_prbs2_sledge, data_step2_sledge, data_ramp_sledge, data_bang_sledge, data_saw_sledge);
% data_estimate_sledge = data_step2_sledge



%%

plot(data_prbs_sledge)


%% Estimate tf sledge

source = data_estimate_sledge;

Opt = tfestOptions('Display','on');
np = 2;
ioDelay = delayest(source) * Ts;

tfSledge = tfest(source, np, 0, ioDelay, Opt)


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
% source = data_prbs2_pendulum;

Opt = tfestOptions('Display','on');
np = 2;
nz = 2;

source = merge(data_bang_pendulum, data_prbs2_pendulum, data_saw_pendulum, data_sine2_pendulum);
ioDelay = delayest(source) * Ts
tfPend2 = tfest(source, np, nz, ioDelay, Opt)

%%
% source = merge(data_prbs2_pendulum, data_ramp_pendulum, data_bang_pendulum, data_step2_pendulum, data_rgs_pendulum);
source = data_ramp_pendulum;
tfPend = tfest(source, np, nz, ioDelay, Opt)

%% Validate pendulum
% source_val = data_prbs_pendulum;

figure
compare(data_prbs2_pendulum, tfPend)
figure
compare(data_rgs_pendulum, tfPend)
figure
compare(data_step2_pendulum, tfPend)
figure
compare(data_bang_pendulum, tfPend)
figure
compare(data_pulse_pendulum, tfPend)
figure
compare(data_saw_pendulum, tfPend)
% resid(data_bang_pendulum, tfPend)

%% Validate pendulum
% source_val = data_prbs_pendulum;

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