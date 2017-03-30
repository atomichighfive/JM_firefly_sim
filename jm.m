%% Generate initial state
clear all;

flockRadius = 4;
flockDensity = 0.4;
connectionThreshold = 1.6;

[Q, G] = sphereFlock(flockRadius, flockDensity, connectionThreshold);
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.5*rand(N,1);

graphMetrics(G);

%% Simulate
dt = 0.0025;
time = 4;

[states, flashes] = simulateFlock(Q, G, time, dt);

%% Show graph metrics
graphMetrics(G);

%% Visa flugor
plotFlock(Q, G);

%% Show response curves
showResponseCurves();

%% Tidsserie
showTimeSeries(states, flashes, dt);

%% Godhetstal
I = ([-1;1]*[0.0075:0.0025:0.02])'; % Set up intervals to evaluate for
legendStrings = strings(size(I,1),3); % Prepare for creating a plot legend
for i=1:size(I,1)
    S = calculateSynchrony(states, flashes, dt, I(i,:)); % Calculate for every interval
    legendStrings(i,:) = ['tol = ', sprintf('%0.3f', diff(I(i,:))), 's']; % Append legend entry
    plot(S); hold on; % Plot
end
ylim([0,1.05]);
grid on;
legend(legendStrings, 'Location', 'southeast'); % Draw legend
%% TillstÃ¥ndsevolution
showStateEvolution(states, dt, 1, false);

%% Cirkulär tillståndsevolution
showCircularStateEvolution(states, dt, 0.25, false);

%% Visa simulering
showSimulation(states, flashes, dt, false, false);

%% Visa en flugas detalierade tillstånd
figure()
fly = 1;
plotFlyDetailed(states, flashes, dt, fly);
yyaxis('left');
ylim(1.1*ylim);
grid on;
