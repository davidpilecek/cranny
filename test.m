Ts = 0.01;
filter = tf([1,0.272,46.24], [1,1.36,46.24])
tfSledge = tf([0.5705], [1 14.24 0.007704])
tfPend = tf([4.747 0 0], [1 0.0971 46.62])

plot(data_step_pendulum)
figure
plot(data_step_sledge)

%%
filter_dis = c2d(filter, Ts, 'tustin')
tfSledge_dis = c2d(tfSledge, Ts, 'tustin')
tfPend_dis = c2d(tfPend, Ts, 'tustin')