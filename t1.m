
A1 = load("1_input.mat")
P1 = load("1_pendulum.mat")
I2 = load("2_input.mat")
I7 = load("7_input.mat")
P7 = load("7_pendulum.mat")

I6 = load("6_input.mat")
P6 = load("6_pendulum.mat")

plot(I6.ans)
grid on
hold on
plot(P6.ans)
