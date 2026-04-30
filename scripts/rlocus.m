clc;clear;close all;

tfSledge = tf(0.6633, [1 17.78 0.01711]);
tfPend = tf([0.0696 0 0], [0.0147 0.0013 0.6834]);

%%

rlocus(tfSledge)
rltool(tfSledge)

%%
rlocus(tfPend)
help(rlocus)
%%
rltool(tfSledge)

%%

sys = tfPend * tfSledge;

rltool(sys)