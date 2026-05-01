%% Estimate tf sledge

data_estimate_sledge = merge(data_bang_sledge, data_saw_sledge, data_sine_sledge, data_step_sledge, data_pulse_sledge, data_ramp_sledge, data_prbs_sledge);
source = data_comp_sledge;

Opt = tfestOptions('Display','on');
Opt.InitialCondition = 'zero';
Opt.SearchOptions.MaxIterations = 100;

np = 2;
ioDelay = delayest(source) * Ts;

tfSledge = tfest(source, np, 0, ioDelay, Opt)
%%
compare(data_rgsc_sledge, tfSledge)
%%
rltool(tfSledge)
%%

tfSledge_j = tf([4.88], [20.11 238.20 0])

%% Validate sledge
source_val = data_prbs_sledge;
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
tfPend2 = tf([4.739 0 0], [1 0.09515 46.54])

Lp = 0.205;
ml = 0.272;
mr = 0.135;
g  = 9.82;

% Jp = 0.014659;
% Dp = 0.001211;

Jp = 0.0147;
Dp = 0.0013;

num = [0.0696 0 0]
den = [0.0147 0.0013 0.6834]

tfPend = tf(num, den)
[wn, zeta] = damp(tfPend)

rltool(tfPend)
% rlocus(tfPend_ga)
%%
rltool(tfPend2)
%%
source = data_step_pendulum
close all;

plot(lsim(tfPend_ga, source.InputData, source.SamplingInstants))
hold on
plot(source.OutputData)

%%
figure
compare(data_prbs_pendulum, tfPend2)
figure
compare(data_prbs_pendulum, tfPend_ga)
figure
compare(data_step_pendulum, tfPend2)
figure
compare(data_step_pendulum, tfPend_ga)
figure
compare(data_pulse_pendulum, tfPend2)
figure
compare(data_pulse_pendulum, tfPend_ga)
figure
compare(data_saw_pendulum, tfPend2)
figure
compare(data_saw_pendulum, tfPend_ga)