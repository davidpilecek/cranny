clc;clear;

sledge_tf = tf([0.4857], [1 13.79 0.01658])
pend_tf = tf([4.739 0 0], [1 0.09515 46.54])


%% PZ MAP

pzmap(sledge_tf)
pzmap(pend_tf)

%% ROOT LOCUS
rltool(sledge_tf)
rltool(pend_tf)

%%

rlocus(pend_tf)