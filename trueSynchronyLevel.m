function [ SynchronyLevel ] = trueSynchronyLevel( states, flashes, dt, timeTolerance, maxSteps )
%BESTSYNCHRONYLEVEL Summary of this function goes here
%   Detailed explanation goes here
    % Determine best level of synchrony
    
    top = 1;
    bottom = 0;
    for i = 1:maxSteps
        pivot = (top+bottom)/2;
        [~, ~, upper] = evaluateSynchrony(states, flashes, dt, top, timeTolerance);
        [~, ~, lower] = evaluateSynchrony(states, flashes, dt, pivot, timeTolerance);
        if upper > 0
            bottom = pivot;
        elseif upper <= 0 && lower > 0
            bottom = pivot;
        else
            top = pivot;
        end
        if top-bottom <= timeTolerance(2)-timeTolerance(1)
            break;
        end
    end
    
    SynchronyLevel = (top+bottom)/2;
end

