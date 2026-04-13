clc;clear;

M_ex = 1637; % grams of extra mass

empty = load("empty1.mat").ans;
l2    = load("loaded1.mat").ans;

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
