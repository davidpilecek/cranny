
Ts = 0.01;
fs = 1/Ts;

prbs_input  = load("responses_crane2/prbs2_input.mat").ans.Data;
x = load("responses_crane2/prbs2_pendulum_deg.mat").ans.Data;
% x = load("responses_crane2/prbs_pendulum_deg.mat").ans.Data;

N = length(x);

xdft = fft(x);
xdft = xdft(1:N/2+1);
psdx = (1/(fs*N)) * abs(xdft).^2;
psdx(2:end-1) = 2*psdx(2:end-1);
freq = 0:fs/length(x):fs/2;

plot(freq,pow2db(psdx))
grid on
title("Periodogram Using FFT")
xlabel("Frequency (Hz)")
ylabel("Power/Frequency (dB/Hz)")