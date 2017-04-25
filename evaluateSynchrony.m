function [ synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance )
%EVALUATESYNCHRONY Summary of this function goes here
%   Detailed explanation goes here
    
    S = calculateSynchrony(states, flashes, dt, timeTolerance);

    %% Time before synchrony is reached
    
    candidates = find(S < synchronyLimit);
    if isempty(candidates)
        synchronyPoint = size(S,2);
    else
        synchronyPoint = candidates(end);
    end
    synchronyTime = synchronyPoint*dt;
    
    %% Determine average flashes until synchrony is reached
    
    flashesBeforeSync = flashes(flashes(:,end) <= synchronyPoint,:);
    numerOfFlies = size(flashes, 2) - 2;
    avgFlashesToSync = size(flashesBeforeSync, 1)/numerOfFlies;
    
    
    %% Determine average synchrony level after synchrony limit is reached
    
    if synchronyPoint < size(S,2)
        averageSynchronyLevel = mean(S(synchronyPoint:end));
    else
        averageSynchronyLevel = 0;
    end
    
    
end

