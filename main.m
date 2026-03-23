Ts = 0.01;

u = load("new_responses\prbs1_input.mat").ans.Data;

y = load("new_responses\prbs1_sledge.mat").ans.Data;

data1 = iddata(y, u, Ts);

u2 = load("new_responses\prbs2_input.mat").ans.Data;

y2 = load("new_responses\prbs2_sledge.mat").ans.Data;

data2 = iddata(y2, u2, Ts);

u3 = load("new_responses\prbs3_input.mat").ans.Data;

y3 = load("new_responses\prbs3_sledge.mat").ans.Data;

data3 = iddata(y3, u3, Ts);


u4 = load("old_responses\2_input.mat").ans.Data;

y4 = load("old_responses\2_sledge.mat").ans.Data;

data4 = iddata(y4, u4, Ts);


u5 = load("old_responses\4_input.mat").ans.Data;

y5 = load("old_responses\4_sledge.mat").ans.Data;

data5 = iddata(y5, u5, Ts);