clc
clear
pendulum_raw = load("3_pendulum.mat");
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
% figure
% plot(t, x, 'r')
% 
% hold on
% plot(t, x_filtered, 'b')
% legend('Original','Filtered')
% grid on


%%
clc
clear
Ts = 0.01;

y = load("2_pendulum.mat").ans.Data;
y = y - mean(y);

%y = x_filtered;
u = load("2_sledge.mat").ans.Data;


data = iddata(y, u, Ts);
plot(data)
delay_samples = 18;
delay_time = delay_samples*Ts


Gest = tfest(data, 6, 3, delay_time)

resid(Gest, data)


y_val = load("3_pendulum.mat").ans.Data;
y_val = y_val - mean(y_val);

u_val= load("3_sledge.mat").ans.Data;

validation_data = iddata(y_val, u_val, Ts);

opt = compareOptions;
opt.initialCondition = 'z';

compare(validation_data, Gest, opt)

%%
clc
clear
Ts = 0.01;

y = load("2_pendulum.mat").ans.Data;
y = y - mean(y);

%y = x_filtered;
u = load("2_sledge.mat").ans.Data;


data = iddata(y, u, Ts);
plot(data)
delay_samples = delayest(data);
delay_time = delay_samples*Ts

%%
clc
clear
Ts = 0.01;

y = load("2_pendulum.mat").ans.Data;
y = y - mean(y);

%y = x_filtered;
u = load("2_sledge.mat").ans.Data;


data = iddata(y, u, Ts);
plot(data)
delay_samples = delayest(data);
delay_time = delay_samples*Ts

sys = oe(data, [3 4 delay_samples])


y_val = load("3_pendulum.mat").ans.Data;
y_val = y_val - mean(y_val);

u_val= load("3_sledge.mat").ans.Data;

validation_data = iddata(y_val, u_val, Ts);

opt = compareOptions;
opt.initialCondition = 'z';

compare(validation_data, sys, opt)