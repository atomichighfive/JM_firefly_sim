%% Save results
name = datetime;

clear Q G states flashes top bottom pivot
clear flockDensity flockDensityIndex flockRadius flockRadiusIndex
clear frequencySpread frequencySpreadIndex iteration zeta zetaIndex
clear thau thayIndex connectionThreshold connectionThresholdIndex

mkdir output simulations;
save(['output/simulations/', char(name)]);
%% Batch simulate

% Parameters
clear all;
name='beta(0.3,0.6,6)';  % Name of simulation

%Make dir+dir for plots, stop if simulation exist
dir_save= ['output/simulations/', name,'/'];
dir_pics=[dir_save,'pics'];
if exist(dir_save,'dir')==7
    error('A simulation with that name already exist');  
end
mkdir('output/simulations', name);
mkdir(dir_pics);


%Simulation variables
dt = 1*10^-3;
time = 10;
findTrueSynchronyLevel = 1; % Use slow binary search to find actual synchronization level
synchronyLimit = 0.85;
timeTolerance = [-0.01, 0.01];
numberOfIterations = 1;

% Variables
    
    %Responsecurve
    alphas = 0.5;
    betas = linspace(0.3,0.6,6);
    gammas = 0.05; 
    as = 0.25;
    bs = 0.25;    

    
    
    %flies
    frequencySpreads = 0.5; %base freq + frequency spread
    phaseSpreads = 1;  % phase spread [0,1]
    flockRadi = 4; % Radius of spherical flock
    flockDensities = 0.3; % Density of generated flock
    connectionThresholds = 2.5; % Distance flys can see eachother

    % fly
    baseFrequency = 1; % base frequency of a oscillator
    deltas = [0];
    zetas = 0.05; % fraction of period to go blind after seeing a flash
    thaus = [0]; % fraction of period to go blind after flashing

%legend=frequencySpreads;

synchronyTime = zeros([ ...
    size(frequencySpreads, 2), ...
    size(phaseSpreads, 2), ...
    size(flockRadi, 2), ...
    size(flockDensities, 2), ...
    numberOfIterations, ... % ammount of simulations to average when stochastic variables are present
    size(connectionThresholds, 2), ...
    size(zetas, 2), ...
    size(thaus, 2), ...
    size(deltas, 2), ...
    size(alphas, 2), ...
    size(betas, 2), ...
    size(gammas, 2), ...
    size(as, 2), ...
    size(bs, 2), ...
    ]);

avgFlashesToSync = synchronyTime; % Make a copy of the empty matrix
averageSynchronyLevel = synchronyTime; % Again
averageConnections = synchronyTime; % Again
finalAverageFrequency = synchronyTime; % Again
numberOfFlies = synchronyTime; % Again

if findTrueSynchronyLevel
    trueSynchronyLevelResult = synchronyTime; % Again
end

%Number of simulations
evaluations = numel(synchronyTime);
counter = 0;    % Keep track of calculations done
progressBar = waitbar(0, [num2str(counter), '/', num2str(evaluations)]);
tic; % Initialize update timer

%Simulation
for frequencySpreadIndex = 1:size(frequencySpreads, 2)
    frequencySpread = frequencySpreads(frequencySpreadIndex);
    for phaseSpreadIndex = 1:size(phaseSpreads, 2)
        phaseSpread = phaseSpreads(phaseSpreadIndex);
        for flockRadiusIndex = 1:size(flockRadi, 2)
            flockRadius = flockRadi(flockRadiusIndex);
            for flockDensityIndex = 1:size(flockDensities,2)
                flockDensity = flockDensities(flockDensityIndex);
                for alphaIndex = 1:size(alphas,2)
                   alpha = alphas(alphaIndex);
                   for betaIndex = 1:size(betas,2)
                       beta=betas(betaIndex);
                       for gammaIndex = 1:size(gammas,2)
                           gamma=gammas(gammaIndex);
                           for aIndex = 1:size(as,2)
                               a=as(aIndex);
                               for bIndex = 1:size(bs,2)
                                   b=bs(bIndex);
                                   %klistra in h?r
                                   for iteration = 1:numberOfIterations
                                       % Generate flock
                                       Qinit = sphereFlock(flockRadius, flockDensity);
                                       N = size(Qinit, 1);
                                       Qinit(:,5) = phaseSpread*rand(N,1);
                                       Qinit(:,6) = baseFrequency+frequencySpread*rand(N,1);
                                       Qinit(:,7) = zeros(N,1);
                                       
                                       for connectionThresholdIndex = 1:size(connectionThresholds,2)
                                           connectionThreshold = connectionThresholds(connectionThresholdIndex);
                                           
                                           [Q, G] = calculateGraph(Qinit, connectionThreshold);
                                           
                                           for zetaIndex = 1:size(zetas, 2)
                                               zeta = zetas(zetaIndex);
                                               for thauIndex = 1:size(thaus, 2)
                                                   thau = thaus(thauIndex);
                                                   for deltaIndex = 1:size(deltas, 2)
                                                       delta = deltas(deltaIndex);
                                                       
                                                       % Simulate
                                                       
                                                       clear states; clear flashes; % Free up some memory
                                                       [states, flashes] = simulateFlock(Q, G, time, dt, thau, zeta, delta, alpha, beta, gamma, a, b);
                                                       
                                                       %save
                                                       save([dir_save,[name,num2str(counter,'%03d') '.mat'] ],'states');
                                                       
                                                       % evaluate
                                                       
                                                       if findTrueSynchronyLevel
                                                           % Determine best level of synchrony
                                                           
                                                           level = trueSynchronyLevel(states, flashes, dt, timeTolerance, 10);
                                                           
                                                           trueSynchronyLevelResult( ...
                                                               frequencySpreadIndex, ...
                                                               phaseSpreadIndex, ...
                                                               flockRadiusIndex, ...
                                                               flockDensityIndex, ...
                                                               iteration, ...
                                                               connectionThresholdIndex, ...
                                                               zetaIndex, ...
                                                               thauIndex, ...
                                                               deltaIndex ...
                                                               ) = level;
                                                           
                                                           [synchronyTimeData, avgFlashesToSyncData, averageSynchronyLevelData ] = ...
                                                               evaluateSynchrony( states, flashes, dt, level, timeTolerance );
                                                           
                                                       else
                                                           [synchronyTimeData, avgFlashesToSyncData, averageSynchronyLevelData ] = ...
                                                               evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );
                                                       end
                                                       % save result
                                                       synchronyTime( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = synchronyTimeData;
                                                       
                                                       avgFlashesToSync( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = avgFlashesToSyncData;
                                                       
                                                       averageSynchronyLevel( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = averageSynchronyLevelData;
                                                       
                                                       averageConnections( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = mean(degree(G));
                                                       
                                                       finalAverageFrequency( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = mean(states(end,:,6));
                                                       
                                                       numberOfFlies( ...
                                                           frequencySpreadIndex, ...
                                                           phaseSpreadIndex, ...
                                                           flockRadiusIndex, ...
                                                           flockDensityIndex, ...
                                                           iteration, ...
                                                           connectionThresholdIndex, ...
                                                           zetaIndex, ...
                                                           thauIndex, ...
                                                           deltaIndex ...
                                                           ) = size(states, 2);
                                                       
                                                       counter = counter + 1;
                                                       
                                                       if toc >= 1 % Update progress bar every second.
                                                           waitbar(counter/evaluations, progressBar, [num2str(counter), '/', num2str(evaluations)]);
                                                           tic;
                                                       end
                                                   end
                                               end
                                           end
                                       end
                                   end
                                   
                                   
                               end
                           end
                       end
                   end
                end
                
            end
        end
    end
end
close(progressBar);




%% varying connection thresholds, 2 thaus, any number of iterations
avgTrueSynchronyLevelResult = squeeze(mean(trueSynchronyLevelResult,5));
avgNumberOfFlies = squeeze(mean(numberOfFlies, 5));

f1 = figure()
yyaxis('right')
plot(connectionThresholds, avgNumberOfFlies(:,1), ':'); hold on;
ylabel('antal')
yyaxis('left')
plot(connectionThresholds, avgTrueSynchronyLevelResult(:, 1));
plot(connectionThresholds, avgTrueSynchronyLevelResult(:, 2), '--'); grid on;
ylabel('synkroniseringsgrad')
xlabel('kopplingsavst??nd')
legend('\xi = 0','\xi = 0.1','medelantal flugor', 'Location', 'southeast');
title('Synkroniseringsgrad m.a.p kopplingsavst??nd');

f2 = figure()
A = averageConnections(:,:,:,:,:,:,:,1);
B = trueSynchronyLevelResult(:,:,:,:,:,:,:,1);
scatter(reshape(A, 1, prod(size(A))),reshape(B, 1, prod(size(B))),'.'); hold on;
C = averageConnections(:,:,:,:,:,:,:,2);
D = trueSynchronyLevelResult(:,:,:,:,:,:,:,2);
scatter(reshape(C, 1, prod(size(C))),reshape(D, 1, prod(size(D))),'.'); grid on;
xlabel('medelantal kopplingar per oscillator');
ylabel('synkroniseringsgrad');
legend('\xi = 0', '\xi = 0.1', 'Location', 'southeast');
title('Utfall av synkronisering m.a.p antal kopplingar');
ylim([0,1.05]);

f3 = figure()
E = averageConnections(:,:,:,:,:,:,:,1);
F = finalAverageFrequency(:,:,:,:,:,:,:,1);
scatter(reshape(E, 1, prod(size(E))),reshape(F, 1, prod(size(F))),'.'); hold on;
G = averageConnections(:,:,:,:,:,:,:,2);
H = finalAverageFrequency(:,:,:,:,:,:,:,2);
scatter(reshape(G, 1, prod(size(G))),reshape(H, 1, prod(size(H))),'.'); grid on;

a = mean(reshape(F, 1, prod(size(F))));
b = mean(reshape(H, 1, prod(size(H))));
lim = xlim;
plot(lim, [a, a], 'blue--');
plot(lim, [b, b], 'red--');
xlabel('medelantal kopplingar per oscillator');
ylabel('slutgiltig medelfrekvens');
legend('\xi = 0', '\xi = 0.1', 'medel f??r \xi = 0', 'medel f??r \xi = 0.1', 'Location', 'southeast');
title('Utfall av slutfrekvens m.a.p antal kopplingar');
%% Percent success with 20 connection thresholds, 2 thaus and 25 iterations

numberOfOk = zeros(2, 20);
for i=1:20
    for j=1:2
        numberOfOk(j, i) = nnz(averageSynchronyLevel(1,1,1,1,:,i,1,j));
    end
end

percentSuccess = numberOfOk/25;

plot(connectionThresholds, percentSuccess(1,:)); hold on;
plot(connectionThresholds, percentSuccess(2,:), '--'); grid on;



 
%% funkar bara f?r mig
close all
%colors=['b', 'r', 'y', 'k', 'g', 'm', 'c', 'w'];
plotFreqVariableParam('beta(0.3,0.6,6)')