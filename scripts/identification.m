%% Estimate tf sledge

data_estimate_sledge = merge(data_bang_sledge, data_saw_sledge, data_sine_sledge, data_step_sledge, data_pulse_sledge, data_ramp_sledge, data_prbs_sledge);
source = data_prbs_sledge;

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

Lr = 0.205;
Lp = 0.2375;
ml = 0.272;
mr = 0.135;
g  = 9.82;
    
Jp = 0.0166;
Dp = 0.0011;

num = [(Lp*ml + 0.5*Lr*mr)/Jp 0 0]
den = [1 Dp/Jp (Lp*ml + 0.5*Lr*mr)*g/Jp]

tf_pend = tf(num, den)

% bode(tf_pend)
% pzmap(tf_pend)

% Sledge
rm = 0.007;      % [m]
ms = 0.93;       % [kg]
Ra = 9.9694e-04;      % [Ohm]

Kt = 0.0341 ;
Jm = 0.0985;
Dm = 1.0503e-04;
Ds = 16.3977 ;
Ke = Kt;

num = Kt/(rm*Ra);
den = [(ms + Jm/(rm^2)) (Kt*Ke/(Ra*rm^2) + Dm/(rm^2) + Ds) 0];
figure
tf_sledge = tf(num, den)

% bode(tf_sledge)
% pzmap(tf_sledge)

%%

data = {data_pulse_pendulum, data_bang_pendulum, data_sine_pendulum, data_sine2_pendulum, data_step_pendulum, data_saw_pendulum};
total_r2_pend = 0

for d = 1:numel(data)
    source = data{d}
    y_meas = source.OutputData(:);

    y_sim = lsim(tfPend, source.InputData, source.SamplingInstants);
    y_sim = y_sim(:);

    R2 = 1 - sum((y_meas - y_sim).^2) / ...
             sum((y_meas - mean(y_meas)).^2);
    total_r2_pend = total_r2_pend + R2;
end
disp(total_r2_pend/numel(data))

%%

%%
g = spa(data_step_pendulum);

bode(g, tfPend)

legend('Measured FRF','Model')
%%
opt = compareOptions('InitialCondition','z');
compare(data_bang_pendulum(1:2000), tfPend,'r--', opt)
figure
compare(data_pulse_pendulum, tfPend, opt)
figure
compare(data_ramp_pendulum, tfPend, opt)
figure
compare(data_saw_pendulum, tfPend, opt)
figure
compare(data_sine_pendulum, tfPend, opt)
figure
compare(data_sine2_pendulum, tfPend, opt)
figure
compare(data_step_pendulum, tfPend, opt)
figure
compare(data_prbs_pendulum, tfPend, opt)

%%
mean([60.7, 59.4, 52.5, 92.4, 89.2, 87.8, 70.23, 86])

%% Validate sledge
% rm = 0.007;      % [m]
% ms = 0.93;       % [kg]
% Ra = 0.368;      % [Ohm]
% 
% Kt = 1.295458e-01;
% Jm = 3.076092e-03;
% Dm = 4.550832e-04;
% Ds = 50.150339;
% Ke = Kt;

rm = 0.007;      % [m]
ms = 0.93;       % [kg]
Ra = 9.9694e-04;      % [Ohm]

Kt = 0.0341 ;
Jm = 0.0985;
Dm = 1.0503e-04;
Ds = 16.3977 ;
Ke = Kt;

num = Kt/(rm*Ra);
den = [(ms + Jm/(rm^2)) (Kt*Ke/(Ra*rm^2) + Dm/(rm^2) + Ds) 0];

tf_sledge = tf(num, den)

%% 
opt = compareOptions('InitialCondition','z');
compare(data_bang_sledge, tf_sledge)
figure
compare(data_pulse_sledge, tf_sledge)
figure
compare(data_ramp_sledge, tf_sledge)
figure
compare(data_saw_sledge, tf_sledge)
figure
compare(data_sine_sledge, tf_sledge)
figure
compare(data_sine2_sledge, tf_sledge)
figure
compare(data_step_sledge, tf_sledge)


%%
source = data_ramp_pendulum;
close all;

plot(lsim(tfPend, source.InputData, source.SamplingInstants))
hold on
plot(source.OutputData)

legend("sim", "real")
figure
compare(source, tfPend)

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
