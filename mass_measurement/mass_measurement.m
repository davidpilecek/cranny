%%
clc;clear;

M_ex = 1637; % grams of extra mass

empty = load("empty2.mat").ans;
l2    = load("loaded2.mat").ans;

objs = [empty, l2];

taus = zeros(1, length(objs));

for i = 1:length(objs)
    
    y = objs(i).Data;
    t = objs(i).Time;

    y_final = y(end);

    y_tau = 0.63 * y_final;


    [~, idx] = min(abs(y - y_tau));


    taus(i) = t(idx);

end

tau_empty = taus(1);
tau_loaded = taus(2);

M_s = floor(M_ex*tau_empty/(tau_loaded - tau_empty));

disp("Mass of sledge is calculated as " + M_s + " grams")

plot(empty)
hold on
plot(l2)

legend("Empty", "Loaded")

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


