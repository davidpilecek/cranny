%%
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

%%
clc; clear;

Ts = 0.01;
fc = 10;
fc_sledge = 8;
[b,a] = butter(4, fc * 2 * Ts);  % normalized frequency, 2nd order, butterworth filter
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

figure
y_s_f = filtfilt(b2,a2,ys_i);
plot(ys_i)
hold on
plot(y_s_f)

% Filter
y_p_f = filtfilt(b,a,yp_i);

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


% Filter
y_p_f = filtfilt(b,a,yp_i);

figure
y_s_f = filtfilt(b2,a2,ys_i);
plot(ys_i)
hold on
plot(y_s_f)


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

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_rgs_sledge   = iddata(ys_i, u_i, Ts);
data_rgs_pendulum = iddata(y_p_f, ys_i, Ts);

% === SINE =========================================
u  = load(base + "sine_input.mat").ans;
ys = load(base + "sine_sledge_cm.mat").ans;
yp = load(base + "sine_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);
u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

y_clean = sgolayfilt(ys_i, 3, 11);
figure
plot(ys_i)
hold on
plot(y_clean)


data_sine_sledge   = iddata(ys_i, u_i, Ts);
data_sine_pendulum = iddata(y_p_f, ys_i, Ts);

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

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_step2_sledge   = iddata(ys_i, u_i, Ts);
data_step2_pendulum = iddata(y_p_f, ys_i, Ts);


data_estimate = merge(data_prbs2_sledge, data_step2_sledge, data_ramp_sledge);


% === COMPENSATED PRBS =========================================
u  = load("hidden/compensated/prbs_comp_input.mat").ans;
ys = load("hidden/compensated/prbs_comp_sledge_cm.mat").ans;
yp = load("hidden/compensated/prbs_comp_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_prbs_c_sledge   = iddata(ys_i, u_i, Ts);
data_prbs_c_pendulum = iddata(y_p_f, ys_i, Ts);

% === COMPENSATED RGS =========================================
u  = load("hidden/compensated/rgs_c_input.mat").ans;
ys = load("hidden/compensated/rgs_c_sledge_cm.mat").ans;
yp = load("hidden/compensated/rgs_c_pendulum_deg.mat").ans;

tmin = max([u.Time(1), ys.Time(1), yp.Time(1)]);
tmax = min([u.Time(end), ys.Time(end), yp.Time(end)]);
t = (tmin:Ts:tmax)';
yp.Data = yp.Data - mean(yp.Data);

u_i  = interp1(u.Time,  u.Data,  t);
ys_i = interp1(ys.Time, ys.Data, t);
yp_i = interp1(yp.Time, yp.Data, t);

% Filter
y_p_f = filtfilt(b,a,yp_i);

data_rgs_c_sledge   = iddata(ys_i, u_i, Ts);
data_rgs_c_pendulum = iddata(y_p_f, ys_i, Ts);




%% Estimate tf sledge

source = data_estimate;

Opt = tfestOptions('Display','on');
np = 2;
ioDelay = delayest(source) * Ts;

tfModel = tfest(source, np, 0, ioDelay, Opt);

%% Estimate tf pendulum

source = data_prbs_pendulum;

Opt = tfestOptions('Display','on');
np = 2;
nz = 2;
ioDelay = delayest(source) * Ts;

tfModel = tfest(source, np, nz, ioDelay, Opt)

%% Validate sledge
source_val = data_sine_sledge;

figure
compare(source_val, tfModel)
sim = lsim(tfModel, source_val.InputData, source_val.SamplingInstants);

figure
plot(sim)
hold on
plot(source_val.OutputData)

%% Validate pendulum
source_val = data_ramp_pendulum;

figure
compare(source_val, tfModel)
sim = lsim(tfModel, source_val.InputData, source_val.SamplingInstants);

figure
plot(sim)
hold on
plot(source_val.OutputData)


%% Resids

resid(data_prbs_sledge, tfModel)

%% Estimate process model sledge

% Specify model structure
sourc_e_sl = data_prbs_sledge;
init_sys = idproc("P2ZD");

init_sys.Structure.Td.Value = delayest(source) * Ts;
init_sys.Structure.Tp1.Value = NaN;
init_sys.Structure.Tp2.Value = NaN;
init_sys.Structure.Kp.Value = NaN;

modproc = procest(source, init_sys);
present(modproc)
%% Validate process model sledge
figure
compare(data_prbs2_sledge, modproc)
figure
compare(data_prbs2_sledge, tfModel)

%% Estimate noise model
Opt = procestOptions;
Opt.DisturbanceModel = 'ARMA1';
modproc2 = procest(data_bang_sledge,modproc,Opt);

figure
compare(data_bang_sledge,modproc)
figure
compare(data_bang_sledge,modproc2)

%% Estimate arx model
delay_s = delayest(data_prbs2_sledge)
marx= oe(data_prbs2_sledge, [2 2 2]);

present(marx)

compare(data_sine_sledge, marx)

%%
clc; clear;

dataFolder = "responses_crane2";
files = dir(fullfile(dataFolder, "*_input.mat"));

datasets = [];
length(files)
for k = 1:length(files)

    baseName = erase(files(k).name, "_input.mat");

    inputFile    = fullfile(dataFolder, baseName + "_input.mat");
    sledgeFile   = fullfile(dataFolder, baseName + "_sledge_cm.mat");
    pendulumFile = fullfile(dataFolder, baseName + "_pendulum_deg.mat");

    data = processDataset(inputFile, sledgeFile, pendulumFile);

    if isempty(datasets)
        datasets = data;
    else
        datasets = merge(datasets, data);
    end

end

%% validation dataset
dataFolder = "validation";
files = dir(fullfile(dataFolder, "*_input.mat"));

val_datasets = [];
length(files)
for k = 1:length(files)


    baseName = erase(files(k).name, "_input.mat");

    inputFile    = fullfile(dataFolder, baseName + "_input.mat");
    sledgeFile   = fullfile(dataFolder, baseName + "_sledge_cm.mat");
    pendulumFile = fullfile(dataFolder, baseName + "_pendulum_deg.mat");

    data = processDataset(inputFile, sledgeFile, pendulumFile);

    if isempty(val_datasets)
        val_datasets = data;
    else
        val_datasets = merge(val_datasets, data);
    end

end
