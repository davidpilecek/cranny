clc;clear;
Ts = 0.01;
fs = 1/Ts;

prbs_input  = load("PC2/responses/prbs_in.mat").ans.Data;
x = load("PC2/responses/prbs_pend.mat").ans.Data;

N = length(x);

xdft = fft(x);
xdft = xdft(1:floor(N/2)+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

plot(freq,pow2db(psdx))
grid on
title("Periodogram Using FFT")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")