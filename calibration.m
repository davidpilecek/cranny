%% Calibrate distance
clc;clear;
MaxMissedTicks = 99^100;
SampleTime = 0.01;


counts1 = 54476;
counts2 = 54469;

avg = (counts1 + counts2)/2;

ratio = floor(avg / 114.5)   % counts per cm

frictionR = 0.835;
frictionL = -0.819;

pend0 = 1.865;
pend90 = 0.797;
pend_m90 = 2.91;

pend_ratio = ((abs(pend90 - pend0) + abs(pend_m90 - pend0))/2) / 90