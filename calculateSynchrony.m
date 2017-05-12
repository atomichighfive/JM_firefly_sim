function [ S, scores ] = calculateSynchrony( states, flashes, dt, I )
%CALCULATESYNCHRONY Summary of this function goes here
%   Detailed explanation goes here

    % Determine how far ahead and behind to look for flashes
    lookbehind = floor(I(1)/dt);
    lookahead = ceil(I(2)/dt);
    
    T = size(states, 1);
    N = size(states, 2);
    scores = zeros(T,N); % Allocate score matrix.
    
    for t=1-lookbehind:T-lookahead
        % Identify flashes around the current time and what flies are
        % flashing right now
       flashesAround = flashes(flashes(:,end) > t+lookbehind & flashes(:,end) < t+lookahead,:);
       flashesNow = flashesAround(flashesAround(:,end) == t,:);
       for i=1:size(flashesNow,1)
           % Calculate and apply score for flies that are flashing right
           % now.
           fly = flashesNow(i, end-1);
           flyPeriod = 1/(states(t,fly,6)*dt);
           % Apply score to fly for it's period*1.5. The extra 50% is to
           % make sure that a change in frequency doesn't give a false
           % negative on the score at a later point. The reason we do this
           % at all is so that we don't count flies that fall to super low
           % frequencies and don't flash for very often at all.
           scores(t:t+ceil(flyPeriod*1.5), fly) = size(flashesAround,1)-1; 
       end
    end
    % Don't keep the last values. Since the end of the simulation is
    % within the lookahead this gives a worse value than if the simulation
    % kept running for longer.
    simulationStump = 1/mean(states(end,:,6));
    stumpSize = ceil(simulationStump/dt);
    
    S = sum(scores,2)./(N*(N-1));
    S = S(1:T-stumpSize)';
end

