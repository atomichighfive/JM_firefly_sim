function [ states, flashes ] = simulateFlock( Q, G, time, dt, thau, zeta, delta )
%SIMULATEFLOCK Summary of this function goes here
%   Detailed explanation goes here

    T = round(time/dt);
    N = size(Q,1);
    delaysteps = round(delta/dt);

    states = zeros([T, size(Q)]);
    flashes = zeros(0,N+2);

    states(1,:,:) = Q;
    for t=2:T
        flashesArrived = zeros(0,N+2);
        if delaysteps > 0 && t > delaysteps
            flashesArrived = flashes(flashes(:,end) == t-delaysteps,:);
        end
        Q = squeeze(states(t-1,:,:));
        Qn = Q;
        for i=1:N
            if Qn(i,5) >= 1
                [Qn, flashes] = doFlash(t, i, Qn, states, flashes, G, thau, zeta, delaysteps);
            end
            if delaysteps > 0
                neig = neighbors(G,i);
                for j = 1:size(neig,1)
                    flyIndex = neig(j);
                    flashesArrivedFromJ = flashesArrived(flashesArrived(:,end-1) == flyIndex, :);
                    for k = 1:size(flashesArrivedFromJ,1)
                        [p, f, listening] = calcResponse(Qn(i,5), Qn(i,6), thau);
                        if Qn(i, 7) <= 0;                    
                            Qn(i,5) = p;
                            Qn(i,6) = f;
                            if listening == 1;
                                Qn(i, 7) = zeta;
                            end
                        end
                    end
                end
            end
            Qn(i,5) = Qn(i,5)+Qn(i,6)*dt;
            Qn(i,7) = Qn(i,7)-Qn(i,6)*dt;
        end
        states(t,:,:) = Qn;
    end
end

