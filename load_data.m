%% Load without processing
clc;clear;
Ts = 0.01;

input = load("hidden/compensated/prbs_comp_input.mat").ans.Data;
sledge = load("hidden/compensated/prbs_comp_sledge_cm.mat").ans.Data;
data = iddata(sledge, input, Ts);

input2 = load("hidden/compensated/rgs_c_input.mat").ans.Data;
sledge2 = load("hidden/compensated/rgs_c_sledge_cm.mat").ans.Data;
data2 = iddata(sledge2, input2, Ts);

bang_input  = load("responses_crane2/bang_input.mat").ans.Data;
bang_sledge = load("responses_crane2/bang_sledge_cm.mat").ans.Data;
data_bang   = iddata(bang_sledge, bang_input, Ts);

prbs_input  = load("responses_crane2/prbs_input.mat").ans.Data;
prbs_sledge = load("responses_crane2/prbs_sledge_cm.mat").ans.Data;
data_prbs   = iddata(prbs_sledge, prbs_input, Ts);

prbs2_input  = load("responses_crane2/prbs2_input.mat").ans.Data;
prbs2_sledge = load("responses_crane2/prbs2_sledge_cm.mat").ans.Data;
data_prbs2   = iddata(prbs2_sledge, prbs2_input, Ts);

ramp_input  = load("responses_crane2/ramp_input.mat").ans.Data;
ramp_sledge = load("responses_crane2/ramp_sledge_cm.mat").ans.Data;
data_ramp   = iddata(ramp_sledge, ramp_input, Ts);

rgs_input  = load("responses_crane2/rgs_input.mat").ans.Data;
rgs_sledge = load("responses_crane2/rgs_sledge_cm.mat").ans.Data;
data_rgs   = iddata(rgs_sledge, rgs_input, Ts);

sine_input  = load("responses_crane2/sine_input.mat").ans.Data;
sine_sledge = load("responses_crane2/sine_sledge_cm.mat").ans.Data;
data_sine   = iddata(sine_sledge, sine_input, Ts);

step2_input  = load("responses_crane2/step2_input.mat").ans.Data;
step2_sledge = load("responses_crane2/step2_sledge_cm.mat").ans.Data;
data_step2   = iddata(step2_sledge, step2_input, Ts);

%% Load

clc;clear;
Ts = 0.001;

impulse_in = load('responses2/impulse_input.mat').ans;
impulse_p = load('responses2/impulse_pendulum.mat').ans;
impulse_s = load('responses2/impulse_sledge.mat').ans;

pulse_in = load('responses2/pulse_input.mat').ans;
pulse_p = load('responses2/pulse_pendulum.mat').ans;
pulse_s = load('responses2/pulse_sledge.mat').ans;

ramp_in = load('responses2/ramp_input.mat').ans;
ramp_p = load('responses2/ramp_pendulum.mat').ans;
ramp_s = load('responses2/ramp_sledge.mat').ans;

sine_in = load('responses2/sine_input.mat').ans;
sine_p = load('responses2/sine_pendulum.mat').ans;
sine_s = load('responses2/sine_sledge.mat').ans;

step2_in = load('responses2/step2_input.mat').ans;
step2_p = load('responses2/step2_pendulum.mat').ans;
step2_s = load('responses2/step2_sledge.mat').ans;


gauss1_in = load('responses_25_3/1_sim_input.mat').ans;
gauss1_p = load('responses_25_3/1_sim_pendulum.mat').ans;
gauss1_s = load('responses_25_3/1_sim_sledge.mat').ans;


% gauss2_in = load('responses_25_3/2_sim_input.mat').ans.Data;
% gauss2_p = load('responses_25_3/2_sim_pendulum.mat').ans.Data;
% gauss2_s = load('responses_25_3/2_sim_sledge.mat').ans.Data;
% 
% 
% gauss2_p_id = iddata(gauss2_p, gauss2_s, Ts);
% gauss2_s_id = iddata(gauss2_s, gauss2_in, Ts);

%% Interpolate gauss data

gauss1_t_new = 0:Ts:max(impulse_in.Time);

gauss1_in_interp = interp1(gauss1_in.Time, gauss1_in.Data, gauss1_t_new, "spline");
gauss1_p_interp  = interp1(gauss1_p.Time,  gauss1_p.Data,  gauss1_t_new, "spline");
gauss1_p_interp = gauss1_p_interp - mean(gauss1_p_interp);
gauss1_s_interp  = interp1(gauss1_s.Time,  gauss1_s.Data,  gauss1_t_new, "spline");

gauss1_in_interp = gauss1_in_interp(:);
gauss1_p_interp  = gauss1_p_interp(:);
gauss1_s_interp  = gauss1_s_interp(:);

gauss1_p_id = iddata(gauss1_p_interp, gauss1_s_interp, Ts);
gauss1_s_id = iddata(gauss1_s_interp, gauss1_in_interp, Ts);

%% Interpolate impulse data

imp_t_new = 0:Ts:max(impulse_in.Time);

imp_in_interp = interp1(impulse_in.Time, impulse_in.Data, imp_t_new, "spline");
imp_p_interp  = interp1(impulse_p.Time,  impulse_p.Data,  imp_t_new, "spline");
imp_s_interp  = interp1(impulse_s.Time,  impulse_s.Data,  imp_t_new, "spline");

imp_in_interp = imp_in_interp(:);
imp_p_interp  = imp_p_interp(:);
imp_s_interp  = imp_s_interp(:);

imp_p_id = iddata(imp_p_interp, imp_in_interp, Ts);
imp_s_id = iddata(imp_s_interp, imp_in_interp, Ts);

%% Interpolate pulse data

pulse_t_new = 0:Ts:max(pulse_in.Time);

pulse_in_interp = interp1(pulse_in.Time, pulse_in.Data, pulse_t_new, "spline");
pulse_p_interp  = interp1(pulse_p.Time,  pulse_p.Data,  pulse_t_new, "spline");
pulse_s_interp  = interp1(pulse_s.Time,  pulse_s.Data,  pulse_t_new, "spline");

pulse_in_interp = pulse_in_interp(:);
pulse_p_interp  = pulse_p_interp(:);
pulse_s_interp  = pulse_s_interp(:);

pulse_p_id = iddata(pulse_p_interp, pulse_in_interp, Ts);
pulse_s_id = iddata(pulse_s_interp, pulse_in_interp, Ts);

%% Interpolate ramp data

ramp_t_new = 0:Ts:max(ramp_in.Time);

ramp_in_interp = interp1(ramp_in.Time, ramp_in.Data, ramp_t_new, "spline");
ramp_p_interp  = interp1(ramp_p.Time,  ramp_p.Data,  ramp_t_new, "spline");
ramp_s_interp  = interp1(ramp_s.Time,  ramp_s.Data,  ramp_t_new, "spline");

ramp_in_interp = ramp_in_interp(:);
ramp_p_interp  = ramp_p_interp(:);
ramp_s_interp  = ramp_s_interp(:);

ramp_p_id = iddata(ramp_p_interp, ramp_in_interp, Ts);
ramp_s_id = iddata(ramp_s_interp, ramp_in_interp, Ts);

%% Interpolate sine data

sine_t_new = 0:Ts:max(sine_in.Time);

sine_in_interp = interp1(sine_in.Time, sine_in.Data, sine_t_new, "spline");
sine_p_interp  = interp1(sine_p.Time,  sine_p.Data,  sine_t_new, "spline");
sine_s_interp  = interp1(sine_s.Time,  sine_s.Data,  sine_t_new, "spline");

sine_in_interp = sine_in_interp(:);
sine_p_interp  = sine_p_interp(:);
sine_s_interp  = sine_s_interp(:);

sine_p_id = iddata(sine_p_interp, sine_in_interp, Ts);
sine_s_id = iddata(sine_s_interp, sine_in_interp, Ts);

%% Interpolate step2 data

step2_t_new = 0:Ts:max(step2_in.Time);

step2_in_interp = interp1(step2_in.Time, step2_in.Data, step2_t_new, "spline");
step2_p_interp  = interp1(step2_p.Time,  step2_p.Data,  step2_t_new, "spline");
step2_s_interp  = interp1(step2_s.Time,  step2_s.Data,  step2_t_new, "spline");

step2_in_interp = step2_in_interp(:);
step2_p_interp  = step2_p_interp(:);
step2_s_interp  = step2_s_interp(:);

step2_p_id = iddata(step2_p_interp, step2_in_interp, Ts);
step2_s_id = iddata(step2_s_interp, step2_in_interp, Ts);