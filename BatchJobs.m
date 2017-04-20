% Parameters
clear all;

% immutable
dt = 1*10^-4;
time = 6;
baseFrequency = 1;

synchronyLimit = 0.95;
timeTolerance = [-0.01, 0.01];

% variable
    % flock
numberOfIterations = 20;
frequencySpreads = 1;
phaseSpreads = 1;
flockRadi = 5; % Radius of spherical flock
flockDensities = 0.2; % Density of generated flock

    % flies
connectionThresholds = linspace(1,2.5,5); % Distance flys can see eachother

    % fly
zetas = 0.05; % fraction of period to go blind after seeing a flash
thaus = 0.05; % fraction of period to go blind after flashing


results = zeros([ ...
    size(frequencySpreads, 2), ...
    size(phaseSpreads, 2), ...
    size(flockRadi, 2), ...
    size(flockDensities, 2), ...
    size(connectionThresholds, 2), ...
    numberOfIterations, ... % ammount of simulations to average when stochastic variables are present
    size(zetas, 2), ...
    size(thaus, 2), ...
    3 ...  % Size of results vector
    ]);


for frequencySpreadIndex = 1:size(frequencySpreads, 2)
    frequencySpread = frequencySpreads(frequencySpreadIndex);
    for phaseSpreadIndex = 1:size(phaseSpreads, 2)
        phaseSpread = phaseSpreads(phaseSpreadIndex);
        for flockRadiusIndex = 1:size(flockRadi, 2)
            flockRadius = flockRadi(flockRadiusIndex);
            for flockDensityIndex = 1:size(flockDensities,2)
                flockDensity = flockDensities(flockDensityIndex);
                for connectionThresholdIndex = 1:size(connectionThresholds,2)
                    connectionThreshold = connectionThresholds(connectionThresholdIndex);
                    for iteration = 1:numberOfIterations
                        % Generate flock
                        [Q, G] = sphereFlock(flockRadius, flockDensity, connectionThreshold);
                        N = size(Q, 1);
                        Q(:,5) = phaseSpread*rand(N,1);
                        Q(:,6) = baseFrequency+frequencySpread*rand(N,1);
                        Q(:,7) = zeros(N,1);
                        
                        for zetaIndex = 1:size(zetas, 2)
                            zeta = zetas(zetaIndex);
                            for thauIndex = 1:size(thaus, 2)
                                thau = thaus(thauIndex);
                                
                                % Simulate
                                clear states; clear flashes; % Free up some memory
                                [states, flashes] = simulateFlock(Q, G, time, dt, thau, zeta);
                                
                                % evaluate
                                [synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = ...
                                evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance );
                            
                                results( ...
                                    frequencySpreadIndex, ...
                                    phaseSpreadIndex, ...
                                    flockRadiusIndex, ...
                                    flockDensityIndex, ...
                                    connectionThresholdIndex, ...
                                    iteration, ...
                                    zetaIndex, ...
                                    thauIndex, ...
                                    1:3) = [synchronyTime, avgFlashesToSync, averageSynchronyLevel];
                                    
                            end
                        end
                    end
                end
            end
        end
    end
end

                                