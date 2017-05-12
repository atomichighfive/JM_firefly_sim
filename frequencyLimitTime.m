function [ tF, diffF ] = frequencyLimitTime( states, flashes, dt, lim )
%FREQUENCYLIMITTIME Summary of this function goes here
%   Detailed explanation goes here
    F = squeeze(states(:,:,6));
    diffF = max(F,[],2)-min(F,[],2);

    candidate = size(diffF,1)-find(flip(diffF) > lim, 1, 'first');
    if isempty(candidate)
        candidate = size(diffF,1);
    end

    tF = candidate*dt;
end

