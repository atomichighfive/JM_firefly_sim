function [ synchronyTime, avgFlashesToSync, averageSynchronyLevel ] = evaluateSynchrony( states, flashes, dt, synchronyLimit, timeTolerance )
%EVALUATESYNCHRONY Summary of this function goes here
%   Detailed explanation goes here
    
    S = calculateSynchrony(states, flashes, dt, timeTolerance);

    %% Time before synchrony is reached
    
    candidates = find(S < synchronyLimit);
    if isempty(candidates)
        synchronyPoint = -1;
        synchronyTime = -1;
    else
        synchronyPoint = candidates(end);
        synchronyTime = synchronyPoint*dt;
    end
    
    
    %% Determine average flashes until synchrony is reached
    
    if synchronyPoint >= 0
        flashesBeforeSync = flashes(flashes(:,end) <= synchronyPoint,:);
        numerOfFlies = size(flashes, 2) - 2;
        avgFlashesToSync = size(flashesBeforeSync, 1)/numerOfFlies;
    else
        avgFlashesToSync = -1;
    end
    
    
    %% Determine average synchrony level
    
    if synchronyPoint >= 0
        averageSynchronyLevel = mean(S(synchronyPoint:end));
    else
        averageSynchronyLevel = -1;
    end
    
end

