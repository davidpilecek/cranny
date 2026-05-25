clc;
clear;
% Optimization bounds

lb = [0 0 0];
ub = [100 100 2];

% Run optimization
options = optimoptions( ...
    'particleswarm', ...
    'SwarmSize', 70, ...
    'MaxIterations', 50, ...
    'Display', 'iter');

% 6. Run Optimization

rng default

[xbest,Jbest] = particleswarm( ...
    @costFun,...
    3,...
    lb,...
    ub, options);

disp('Optimal gains:')
disp(xbest)

disp('Cost:')
disp(Jbest)

%%
% clc;clear;close all;
% 
% Kpx = 2.53;
% Kpa = 0.483;
% Kda = 0.016;

Kpx = 3.96;
Kpa = 0.203;
Kda = 0.032;

% Send gains to Simulink

assignin('base','Kpx',Kpx);
assignin('base','Kpa',Kpa);
assignin('base','Kda',Kda);

% Run simulation

simOut = sim( ...
    'gantryModel', ...
    'StopTime','17');

% Extract logged signals

x = simOut.logsout.get('x').Values.Data;
alpha = simOut.logsout.get('alpha').Values.Data;
u = simOut.logsout.get('u').Values.Data;
xd = simOut.logsout.get('ref').Values.Data;

t = simOut.tout;

% Extract and plot the simulation results
% figure;
plot(t, x, 'DisplayName', 'Position', LineWidth=2);
hold on
% figure
% plot(t, alpha, 'DisplayName', 'Angle');

xlabel('Time (s)');
% ylabel('Position (m)');

ylabel('Angle (deg)');
title('ISE vs IAE as Evaluation Criteria');
legend('ISE', 'IAE');
grid on;
% hold off;

%%
exportgraphics(gcf, "criteria_comparison.pdf", "ContentType",'vector')
%% Heatmap
swarmSize = 70;

T = readtable('PSO_heatmap.csv');


Kpx = T.Kpx;
Kpa = T.Kpa;
Kda = T.Kda;

J = T.J;

% Optional: remove failed solutions

valid = J < 1e11;

Kpx = Kpx(valid);
Kpa = Kpa(valid);
Kda = Kda(valid);
J = J(valid);

% Log-scale cost for coloring

Jcolor = log10(J);

% Plot

figure

scatter3( ...
    Kpx,...
    Kpa,...
    Kda,...
    40./Jcolor,...
    Jcolor,...
    'filled')

set(gca,'XScale','log')
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('log$(K_{px})$','Interpreter','latex', 'FontWeight','bold')
ylabel('log$(K_{pa})$','Interpreter','latex')
zlabel('log$(K_{da})$','Interpreter','latex')

% title('PSO Parameter Space')

colormap(turbo)

cb = colorbar;
cb.Label.String = 'log_{10}(Cost)';

grid on

view(45,25)
%%
swarmSize = 70;

particlesToShow = 10;

T = readtable('PSO_heatmap.csv');

% Remove failed solutions

valid = T.J < 1e11;

T = T(valid,:);

% Add generation index

T.Generation = ceil((1:height(T))'/swarmSize);

gens = unique(T.Generation);

% Randomly pick particles from each generation

selectedRows = [];
Tcolor = log10(T);
for i = 1:length(gens)

    idx = find(T.Generation == gens(i));

    % Handle incomplete generations

    n = min(particlesToShow,length(idx));

    % Random subset

    pick = idx(randperm(length(idx),n));

    selectedRows = [selectedRows; pick];

end

% Selected subset

S = T(selectedRows,:);

% Plot

figure

scatter3( ...
    S.Kpx,...
    S.Kpa,...
    S.Kda,...
    40./Jcolor,...
    Jcolor,...
    'filled')


set(gca,'XScale','log')
set(gca,'YScale','log')
set(gca,'ZScale','log')
xlabel('log$(K_{px})$','Interpreter','latex', 'FontWeight','bold')
ylabel('log$(K_{pa})$','Interpreter','latex')
zlabel('log$(K_{da})$','Interpreter','latex')

% title('PSO Particle Evolution')

colormap(turbo)

cb = colorbar;
cb.Label.String = 'Generation';

grid on

view(50,30)

zlim([0 2])

alpha(0.8)
%%
% exportgraphics(gcf,...
%     'pso_particle_subset.pdf',...
%     'ContentType','vector')
%% Export

exportgraphics(gcf,...
    'pso_particle_generations.pdf',...
    'ContentType','vector')
%% Plot

figure

scatter3( ...
    Best.Kpx,...
    Best.Kpa,...
    Best.Kda,...
    80,...
    log10(Best.J),...
    'filled')

xlabel('K_{px}')
ylabel('K_{pa}')
zlabel('K_{da}')

title('Best Particle per Generation')

colormap(turbo)

cb = colorbar;
cb.Label.String = 'log_{10}(Cost)';

grid on

view(45,25)
