%% Generate initial state
clear all;

flockRadius = 4;
flockDensity = 0.1;
connectionThreshold = 2.6;

[Q, G] = sphereFlock(flockRadius, flockDensity, connectionThreshold);
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.5*rand(N,1);

graphMetrics(G);

%% Simulate
dt = 0.01;
time = 10;

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
I = ([-1;1]*linspace(5*dt,dt,5))'; % Set up intervals to evaluate for
legendStrings = strings(size(I,1),1); % Prepare for creating a plot legend
t = dt:dt:time;
for i=1:size(I,1)
    S = calculateSynchrony(states, flashes, dt, I(i,:)); % Calculate for every interval
    legendStrings(i,:) = ['tol = ??', sprintf('%0.3f', diff(I(i,:))/2), 's']; % Append legend entry
    plot(t,S); hold on; % Plot
end
ylim([0,1.05]);
grid on;
title('Godhetstal');
xlabel('tid');
ylabel('synkroniseringsgrad');
legend(legendStrings, 'Location', 'southeast'); % Draw legend
%% Tillst??ndsevolution
showStateEvolution(states, dt, 1, true);

%% Cirkul???r tillst???ndsevolution
showCircularStateEvolution(states, dt, 0.25, false);

%% Visa simulering
showSimulation(states, flashes, dt, false, false);

%% Visa en flugas detalierade tillst???nd
figure()
fly = 4;
plotFlyDetailed(states, flashes, dt, fly, true);
grid on;
xlabel('time');