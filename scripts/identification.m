%% Estimate tf sledge

data_estimate_sledge = merge(data_bang_sledge, data_saw_sledge, data_sine_sledge, data_step_sledge, data_pulse_sledge, data_ramp_sledge, data_prbs_sledge);
source = data_prbs_sledge;

Opt = tfestOptions('Display','on');
Opt.InitialCondition = 'zero';
Opt.SearchOptions.MaxIterations = 100;

np = 2;
ioDelay = delayest(source) * Ts;

tfSledge = tfest(source, np, 0, ioDelay, Opt)

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

%%

data = {data_pulse_pendulum, data_bang_pendulum, data_sine_pendulum, data_step_pendulum};
total_rmse = 0;
total_r2 = 0;
total_fit = 0;


opt = compareOptions('InitialCondition','z');
figure
compare(data{1}, tf_pend, opt);
figure
compare(data{2}, tf_pend, opt);
figure
compare(data{3}, tf_pend, opt);
figure
compare(data{4}, tf_pend, opt);

%%

for d = 1:numel(data)
    source = data{d};
    [y_hat, fit, ~] = compare(source, tf_pend, opt);
    y = source.y;
    rmse = sqrt(mean((y - y_hat.OutputData).^2));
   
    y_sim = lsim(tf_pend, source.InputData, source.SamplingInstants);
    y_sim = y_sim(:);
    y_meas = source.OutputData;
    R2 = 1 - sum((y_meas - y_sim).^2) / ...
             sum((y_meas - mean(y_meas)).^2);

    total_rmse = total_rmse + rmse;
    total_fit = total_fit + fit;
    total_r2 = total_r2 + R2;
end
disp("RMSE = " + total_rmse/numel(data))
disp("fit = " + total_fit/numel(data))
disp("Rsq = " + total_r2/numel(data))


%% Sledge
rm = 0.007;      % [m]
ms = 0.93;       % [kg]
Ra = 0.368;      % [Ohm]

Kt = 1.295458e-01;
Jm = 3.076092e-03;
Dm = 4.550832e-04;
Ds = 50.150339;
Ke = Kt;

num = Kt/(rm*Ra);
den = [(ms + Jm/(rm^2)) (Kt*Ke/(Ra*rm^2) + Dm/(rm^2) + Ds) 0];

tf_sledge = tf(num, den)

frd_est = spa(data_prbs_sledge);
bode(frd_est, tf_sledge)

%%
data = {data_pulse_sledge, data_bang_sledge, data_sine_sledge, data_step_sledge};
total_rmse = 0;
total_r2 = 0;
total_fit = 0;

%
opt = compareOptions('InitialCondition','z');
figure
compare(data{1}, tf_sledge, opt);
figure
compare(data{2}, tf_sledge, opt);
figure
compare(data{3}, tf_sledge, opt);
figure
compare(data{4}, tf_sledge, opt);

%

for d = 1:numel(data)
    source = data{d};
    [y_hat, fit, ~] = compare(source, tf_sledge, opt);
    y = source.y;
    rmse = sqrt(mean((y - y_hat.OutputData).^2));
   
    y_sim = lsim(tf_sledge, source.InputData, source.SamplingInstants);
    y_sim = y_sim(:);
    y_meas = source.OutputData;
    R2 = 1 - sum((y_meas - y_sim).^2) / ...
             sum((y_meas - mean(y_meas)).^2);

    total_rmse = total_rmse + rmse;
    total_fit = total_fit + fit;
    total_r2 = total_r2 + R2;
end
disp("RMSE = " + total_rmse/numel(data))
disp("fit = " + total_fit/numel(data))
disp("Rsq = " + total_r2/numel(data))

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
