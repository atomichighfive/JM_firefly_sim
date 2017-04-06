function [ states, flashes ] = simulateFlock( Q, G, time, dt )
%SIMULATEFLOCK Summary of this function goes here
%   Detailed explanation goes here

    T = time/dt;
    N = size(Q,1);

    states = zeros([T, size(Q)]);
    flashes = [];

    states(1,:,:) = Q;
    for t=2:T;
        Q = squeeze(states(t-1,:,:));
        Qn = Q;
        for i=1:N;
            if Q(i,5) >= 1;
                flashes(end + 1,:) = [zeros(1,N), i, t];
                neig = neighbors(G, i);
                for j=1:size(neig, 1);
                    flyIndex = neig(j);
                    lookbehind = states(t, flyIndex, 7)/states(t, flyIndex, 6);
                    flashesBefore = flashes(flashes(:,end) >= t-lookbehind, :);
                    [p, f, listening] = calcResponse(Qn(flyIndex,5), Qn(flyIndex,6));
                    if ~any(flashesBefore(:,flyIndex) == 1)                    
                        Qn(flyIndex,5) = p;
                        Qn(flyIndex,6) = f;
                        if listening == 1;
                            flashes(end, flyIndex) = 1;
                        else
                            flashes(end, flyIndex) = -1;
                        end
                    else
                        flashes(end, flyIndex) = -1;
                    end
                end
                Qn(i,5) = 0;
            end
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt;
        end
        states(t,:,:) = Qn;
    end
end

