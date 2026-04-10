clc;clear;

MaxMissedTicks = 99^100;
SampleTime = 0.01;





%% Calibrate distance
counts1 = 54523;
counts2 = 54542;
counts3 = 54446;
counts4 = 54535;

avg = (counts1 + counts2 + counts3 + counts4)/4;

ratio = floor(avg / 1.145)   % counts per cm



%% Calibrate pendulum


MaxMissedTicks = 99^100;
SampleTime = 0.01;


sledge_calib = out.sledge_calibrate;
pendulum_calib = out.pendulum_calibrate;

plot(pendulum_calib)

pendulum_zero = mean(pendulum_calib);


%%

MaxMissedTicks = 99^100;
SampleTime = 0.01;
base = "mass_measurement/new/"

empty = load(base + "empty2.mat").ans;
l1 = load(base + "loaded2.mat").ans;
% l2 = load(base + "loaded2.mat").ans;

plot(empty)
hold on
plot(l1)
legend("E", "Loaded")

figure

empty = load(base + "empty3.mat").ans;
l1 = load(base + "loaded3.mat").ans;
% l2 = load(base + "loaded2.mat").ans;

plot(empty)
hold on
plot(l1)
legend("E", "Loaded")


%%

% Speed1 and 2 are unloaded
% bucket and nuts = 176.3 g
% red thing = 660.3 g 

% speed 3 and 4 = 836.6 g

% speed 5 and 6 = 1637.2 g
%speed_2464_l

clc;clear;

% no_load1 = load('mass_measurement\speedL.mat').ans.Data;
% no_load2 = load('mass_measurement\speedR.mat').ans.Data;
% 
% no_load1_t = load('mass_measurement\speedL.mat').ans.Time;
% no_load2_t = load('mass_measurement\speedR.mat').ans.Time;
% 
% lighter_load1 = load('mass_measurement\speed836L.mat').ans.Data;
% lighter_load2 = load('mass_measurement\speed836R.mat').ans.Data;
% lighter_load1_t = load('mass_measurement\speed836L.mat').ans.Time;
% lighter_load2_t = load('mass_measurement\speed836R.mat').ans.Time;
% 
% heaviest_load1 = load('mass_measurement\speed2464L.mat').ans.Data;
% heaviest_load1_t = load('mass_measurement\speed2464L.mat').ans.Time;
% 
% heaviest_load2 = load('mass_measurement\speed2464R.mat').ans.Data;
% heaviest_load2_t = load('mass_measurement\speed2464R.mat').ans.Time;
% 
% figure
% plot(no_load1);
% hold on
% plot(lighter_load1);
% hold on
% plot(heaviest_load1)
% legend("NL", "LL", "HL")

% figure
% plot(no_load2);
% hold on
% plot(lighter_load2);
% hold on
% plot(heaviest_load2)
% legend("NL", "LL", "HL")


