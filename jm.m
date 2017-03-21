%% Generate initial state
clear all;

flockRadius = 4;
flockDensity = 0.4;
connectionThreshold = 1.7;

[Q, G] = sphereFlock(flockRadius, flockDensity, connectionThreshold);
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+1*rand(N,1);

graphMetrics(G);

%% Simulate
dt = 0.025;
time = 10;

[states, flashes] = simulateFlock(Q, G, time, dt);

%% Show graph metrics
graphMetrics(G);

%% Visa flugor
plotFlock(Q, G);

%% Tidsserie
showTimeSeries(states, flashes, dt);

%% Tillståndsevolution
showStateEvolution(states, dt);

%% Visa simulering
showSimulation(states, flashes, dt);

%% Visa gammal ful simulering
oldPlotBlob(states, flashes, dt);