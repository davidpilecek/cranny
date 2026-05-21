function J = costFun(p)


persistent bestJ

if isempty(bestJ)
    bestJ = inf;
end

persistent fid

if isempty(fid)

    fid = fopen('cascade_pend_inner_abs.csv','a');

    fprintf(fid,...
        'Kpx,Kpa,Kda,MaxAngle, Overshoot, J\n');

end


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
    'StopTime','15',...
    'FastRestart','on');

%% Extract logged signals

x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
u = simOut.logsout.get('u').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

%% Errors
ad = 0;

ex = xd - x;
ea = ad - alpha;

maxAngle = max(abs(alpha));
%% Cost
overshoot = (max(x) - xd(end))/xd(end) * 100;
if overshoot < 0
    overshoot = 0;
end

%%

% J = 30*trapz(t,ex.^2) ...
%   + trapz(t,ea.^2) + 5000*ex(end)^2;

J = 30*trapz(t,abs(ex)) ...
  + trapz(t,abs(ea)) + 5000*ex(end)^2;

% if max(x) < 0.95*xd(end)
% 
%     J = 1e12;
%     return;
% 
% end

%% Constraint on voltage

if max(abs(u)) > 16
    J = 1e12;
    return;
end
%% Constraint on angle

if maxAngle > 8
    J = 1e12;
    return;
end

%% Reject overshoot

if overshoot > 10
    J = 1e12;
    return;
end

%% Reject NaNs

if any(isnan(x)) || any(isnan(alpha))
    J = 1e12;
    endW
end
%%

if J < bestJ
    bestJ = J;

    fprintf(fid,...
        '%.6f,%.6f,%.6f,%.6f,%.6f,%.6f\n',...
        Kpx,Kpa,Kda,maxAngle,overshoot,J);
end
