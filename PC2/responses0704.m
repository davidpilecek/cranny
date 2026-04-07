clc;clear;

MaxMissedTicks = 99^100;
SampleTime = 0.01;

input = load("responses_crane2\rgs_input.mat");

%%
y = load('C:\Users\labadmin\Desktop\aie4-26\cranny\PC2\responses_crane2\bang_sled.mat')
plot(y.ans)
