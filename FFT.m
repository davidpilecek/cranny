clc
clear
pendulum_raw = load("5_pendulum.mat");
pendulum_data = pendulum_raw.ans;
x = pendulum_data.Data;

x = x - mean(x);   % remove DC component

L = numel(x);% Length of signal
N = L;
Fs = 1/0.01;
Fn = Fs/2;
t = pendulum_data.Time;

X = fft(x);              % complex FFT
P = abs(X)/N;            % magnitude spectrum

P_half = P(1:floor(N/2));

figure
plot(t(1:floor(N/2)), P_half);

lim = 0.0002;

% find coefficients below threshold
mask = P < lim;
mask_symmetric = mask | flip(mask);

% remove them
X_filtered = X;
X_filtered(mask) = 0;

% reconstruct signal
x_filtered = real(ifft(X_filtered));

% plot
figure
plot(t, x, 'r')

hold on
plot(t, x_filtered, 'b')
legend('Original','Filtered')
grid on






