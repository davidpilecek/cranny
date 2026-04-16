
Ts = 0.01;
fs = 1/Ts;

prbs_input  = load("PC2/responses/step_in.mat").ans.Data;
x = load("PC2/responses/step_pend.mat").ans.Data;

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


%% 1. Design and Apply the Notch Filter
% Identify the peak frequency from your current plot (e.g., 1.2 Hz)
f_notch = 1.08; 
Q = 1; % Quality factor: higher = narrower notch
w0 = f_notch/(fs/2);   % normalized frequency
bw = w0 / Q;

[num, den] = iirnotch(w0, bw);

% Filter the time-domain data
x_filtered = filter(num, den, x);

H = tf(num, den, 1/fs)
bodeplot(H, {0.1, 100})
%% 2. Calculate PSD for the Filtered Signal
xdft_filt = fft(x_filtered);
xdft_filt = xdft_filt(1:floor(N/2)+1);
psdx_filt = (1/(fs*N)) * abs(xdft_filt).^2;
psdx_filt(2:end-1) = 2*psdx_filt(2:end-1);

% 3. Visualization
figure;
hold on;
plot(freq, pow2db(psdx), 'LineWidth', 1, 'DisplayName', 'Original Signal');
plot(freq, pow2db(psdx_filt), 'r', 'LineWidth', 1.5, 'DisplayName', 'Notch Filtered');
grid on;
title("Impact of Notch Filter on Pendulum Power Spectrum");
xlabel("Frequency (Hz)");
ylabel("Power/Frequency (dB/Hz)");
legend('Location', 'northeast');
xlim([0 5]); % Focus on the pendulum resonance area
hold off;