%% Generate spherical flock
clear all;

flockRadius = 5; % Radius of spherical flock
flockDensity = 0.2; % Density of generated flock
connectionThreshold = 2.5; % Distance flys can see eachother
zeta = 0.05; % fraction of period to go blind after seeing a flash
thau = 0.05; % fraction of period to go blind after flashing

Qinit = sphereFlock(flockRadius, flockDensity);
[Q, G] = calculateGraph(Qinit, connectionThreshold);

N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.5*rand(N,1);
Q(:,7) = zeros(N,1);

graphMetrics(G);


%% Generate four flies test-case
clear all;

zeta = 0.05; % fraction of period to go blind after seeing a flash
thau = 0.05; % fraction of period to go blind after flashing

[Q, G] = fourFlies();
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.5*rand(N,1);
Q(:,7) = zeros(N,1);

graphMetrics(G);
%% Simulate
clear states
clear flashes

dt = 1*10^-4;
time = 7.5;

[states, flashes] = simulateFlock(Q, G, time, dt, thau, zeta);

%% Show graph metrics
graphMetrics(G);

%% Visa flugor
plotFlock(Q, G);

%% Show response curves
showResponseCurves();

%% Tidsserie
showTimeSeries(states, flashes, dt);

%% Godhetstal
synchronyWithin = [0.05, 0.01]; %Error tolerance in seconds
I = ([-1;1]*linspace(synchronyWithin(1),synchronyWithin(2),3))'; % Set up intervals to evaluate for
legendStrings = strings(size(I,1),1); % Prepare for creating a plot legend
t = dt:dt:time;
for i=1:size(I,1)
    S = calculateSynchrony(states, flashes, dt, I(i,:)); % Calculate for every interval
    legendStrings(i,:) = ['tol = ±', sprintf('%0.3f', diff(I(i,:))/2), 's']; % Append legend entry
    if size(t) ~= size(S)'
        plot([0,t], S); hold on;
    else
        plot(t,S); hold on; % Plot
    end
end
ylim([0,1.05]);
grid on;
title('Godhetstal');
xlabel('tid');
ylabel('synkroniseringsgrad');
legend(legendStrings, 'Location', 'southeast'); % Draw legend


%% Utvärdera resultat
synchronyLimit = 0.95;
timeTolerance = [-0.01, 0.01];

[ synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );

disp(['Time of synchrony: ', num2str(synchronyTime)]);
disp(['Average flashes before synchrony: ', num2str(avgFlashesToSync)]);
disp(['Level of synchrony reached: ', num2str(averageSynchronyLevel)]);

%% Tillståndsevolution
showStateEvolution(states, dt, 1, false);

%% Cirkulär tillståndsevolution
showCircularStateEvolution(states, dt, 0.25, false);

%% Visa simulering
showSimulation(states, flashes, dt, 0.1, false, false);

%% Visa en flugas detalierade tillstånd
figure()
fly = 4;
plotFlyDetailed(states, flashes, dt, fly, true);
grid on;
xlabel('tid');