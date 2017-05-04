%% Generate spherical flock
clear all;

flockRadius = 5; % Radius of spherical flock
flockDensity = 0.2; % Density of generated flock
connectionThreshold = 2; % Distance flys can see eachother
zeta = 0.05; % fraction of period to go blind after seeing a flash
thau = 0.051; % fraction of period to go blind after flashing
delta = 0.025; % Delay for a pulse to transmit to its neighbours
alpha = 0.5;
beta = 0.5;
gamma = 0.05;
a = 0.25;
b = 0.25;
Qinit = sphereFlock(flockRadius, flockDensity);
[Q, G] = calculateGraph(Qinit, connectionThreshold);

N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+0.3*rand(N,1);
Q(:,7) = zeros(N,1);

graphMetrics(G);


%% Generate four flies test-case
clear all;

zeta = 0.05; % fraction of period to go blind after seeing a flash
thau = 0.05; % fraction of period to go blind after flashing

[Q, G] = fourFlies();
N = size(Q, 1);
Q(:,5) = 1*rand(N,1);
Q(:,6) = 1+1*rand(N,1);
Q(:,7) = zeros(N,1);

graphMetrics(G);
%% Simulate
clear states
clear flashes

dt = 1*10^-3;
time = 3;

[states, flashes] = simulateFlock(Q, G, time, dt, thau, zeta, delta, alpha, beta, gamma, a, b);

% print results
synchronyLimit = 0.85;
timeTolerance = [-0.01, 0.01];

[ synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );

disp(['Time of synchrony: ', num2str(synchronyTime)]);
disp(['Average flashes before synchrony: ', num2str(avgFlashesToSync)]);
disp(['Level of synchrony reached: ', num2str(averageSynchronyLevel)]);

%% Show graph metrics
graphMetrics(G);

%% Visa flugor
plotFlock(Q, G);

%% Show response curves
showResponseCurves(thau,alpha,beta,gamma,a,b);

%% Tidsserie
showTimeSeries(states, flashes, dt);

%% Godhetstal
synchronyWithin = [0.05, 0.005]; %Error tolerance in seconds
I = ([-1;1]*linspace(synchronyWithin(1),synchronyWithin(2),2))'; % Set up intervals to evaluate for
legendStrings = strings(size(I,1),1); % Prepare for creating a plot legend
t = dt:dt:time;
for i=1:size(I,1)
    [S, scores] = calculateSynchrony(states, flashes, dt, I(i,:)); % Calculate for every interval
    legendStrings(i,:) = ['tol = ??', sprintf('%0.3f', diff(I(i,:))/2), 's']; % Append legend entry
    plot(t(1:size(S,2)), S); hold on;
end
ylim([0,1.05]);
xlim([0,time]);
grid on;
title('Godhetstal');
xlabel('tid');
ylabel('synkroniseringsgrad');
legend(legendStrings, 'Location', 'southeast'); % Draw legend


%% Utv??rdera resultat
synchronyLimit = 0.95;
timeTolerance = [-0.05, 0.05];

[ synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );


bestSynchronyLevel = trueSynchronyLevel(states, flashes, dt, timeTolerance, 20);


disp(['Time of synchrony: ', num2str(synchronyTime)]);
disp(['Average flashes before synchrony: ', num2str(avgFlashesToSync)]);
disp(['Level of synchrony reached: ', num2str(averageSynchronyLevel)]);
disp(['Best synchrony level reached: ', num2str(bestSynchronyLevel)]);

%% Panelplot av frekvenser
for i=1:N
    plot(states(:,i,6)); hold on;
end
grid on    

%% Tillst??ndsevolution
showStateEvolution(states, dt, 1, false);

%% Cirkul??r tillst??ndsevolution
showCircularStateEvolution(states, dt, 0.25, false);

%% Visa simulering
showSimulation(states, flashes, dt, 0.1, false, false);

%% Visa en flugas detalierade tillst??nd
figure()
fly = 5;
plotFlyDetailed(states, flashes, dt, fly, true);
grid on;
xlabel('tid');