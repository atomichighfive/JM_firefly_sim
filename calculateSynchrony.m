function [ S ] = calculateSynchrony( states, flashes, dt, I )
%CALCULATESYNCHRONY Summary of this function goes here
%   Detailed explanation goes here
    lookbehind = ceil(I(1)/dt);
    lookahead = floor(I(2)/dt);
    
    T = size(states, 1);
    N = size(states, 2);
    scores = zeros(T,N);
    
    for t=1-lookbehind:T-lookahead
       flashesAround = flashes(flashes(:,end) > t+lookbehind & flashes(:,end) < t+lookahead,:);
       flashesNow = flashesAround(flashesAround(:,end) == t,:);
       for i=1:size(flashesNow,1)
           fly = flashesNow(i, end-1);
           flyPeriod = 1/(states(t,fly,6)*dt);
           scores(t:t+round(flyPeriod), fly) = size(flashesAround,1)-1;
       end
    end
    %imagesc(scores);
    S = sum(scores,2)./(N*(N-1));
    S = S(1:T);
end

