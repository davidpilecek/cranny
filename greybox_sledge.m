clc;clear
Ts = 0.01;

u = load("new_responses\prbs1_input.mat").ans.Data;

y = load("new_responses\prbs1_sledge.mat").ans.Data;

p = load("new_responses\prbs1_pendulum.mat").ans.Data;
p = p - mean(p);

pend1 = iddata(p, y, Ts);
sledge1 = iddata(y, u, Ts);

u2 = load("new_responses\prbs2_input.mat").ans.Data;
y2 = load("new_responses\prbs2_sledge.mat").ans.Data;
sledge2 = iddata(y2, u2, Ts);
p2 = load("new_responses\prbs2_pendulum.mat").ans.Data;
p2 = p2 - mean(p2)
pend2 = iddata(p2, y2, Ts);

u3 = load("new_responses\prbs3_input.mat").ans.Data;
y3 = load("new_responses\prbs3_sledge.mat").ans.Data;
sledge3 = iddata(y3, u3, Ts);
p3 = load("new_responses\prbs3_pendulum.mat").ans.Data;
p3 = p3 - mean(p3)
pend3 = iddata(p3, y3, Ts);


u4 = load("old_responses\2_input.mat").ans.Data;
y4 = load("old_responses\2_sledge.mat").ans.Data;
sledge4 = iddata(y4, u4, Ts);
p4 = load("old_responses\2_pendulum.mat").ans.Data;
p4 = p4 - mean(p4);
pend4 = iddata(p4, y4, Ts);


u5 = load("old_responses\4_input.mat").ans.Data;
y5 = load("old_responses\4_sledge.mat").ans.Data;
sledge5 = iddata(y5, u5, Ts);
p5 = load("old_responses\4_pendulum.mat").ans.Data;
p5 = p5-mean(p5);
pend5 = iddata(p5, y5, Ts);

parameters = [1; 1; 1]; % initial guesses [M, B, K]



sys = idgrey('sled_model', parameters, 'c'); % 'c' = continuous

sys_est = greyest(sledge5, sys)
compare(sledge2, sys_est)