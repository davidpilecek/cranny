bode(tfPend)

filter = tf([1,0.272,46.24], [1,1.36,46.24])
figure
bode(filter)
%%
c2d(filter, Ts, 'tustin')