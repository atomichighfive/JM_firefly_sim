function [ states, flashes ] = simulateFlock( Q, G, time, dt, zeta )
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
            if Qn(i,5) >= 1;
                [Qn, flashes] = doFlash(t, i, Qn, states, flashes, G, zeta);
            end
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt;
            Qn(i,7) = Qn(i,7)-Qn(i,6)*dt;
        end
        states(t,:,:) = Qn;
    end
end

