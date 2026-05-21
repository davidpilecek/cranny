function J = costFun(p)

%% Gains

Kpx = p(1);
Kpa = p(2);
Kda = p(3);

%% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

%% Run simulation

simOut = sim( ...
    'gantryModel', ...
    'StopTime','40',...
    'FastRestart','on',...
    'FixedStep','0.01');

%% Extract logged signals

x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
u = simOut.logsout.get('u').Values.Data;

t = simOut.tout;

%% Errors

xd = 1;
ad = 0;

ex = xd - x;
ea = ad - alpha;

%% Cost

J = 30*trapz(t,ex.^2) ...
  + trapz(t,ea.^2);

%% Constraint on voltage

if max(abs(u)) > 16
    J = 1e12;
    return;
end
%% Constraint on angle

if max(abs(alpha)) > 8
    J = 1e12;
    return;
end

%% Reject NaNs

if any(isnan(x)) || any(isnan(alpha))
    J = 1e12;
end

% fprintf('Kpx=%.2f  Kpa=%.2f  Kda=%.2f  MaxAngle=%.1f J=%.2f\n ', ...
    % Kpx,Kpa,Kda,max(abs(alpha)), J);

end