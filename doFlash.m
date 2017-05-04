function [ Qn, flashes ] = doFlash( t, i, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b )
    Qn(i,5) = 0;
    
    N = numnodes(G);
    flashes(end + 1,:) = [zeros(1,N), i, t];
    
    if delaysteps == 0
        neig = neighbors(G, i);
        for j=1:size(neig, 1)
            flyIndex = neig(j);
            [p, f, listening] = calcResponse(Qn(flyIndex,5), Qn(flyIndex,6), thau, alpha, beta, gamma, a, b);
            if Qn(flyIndex, 7) <= 0                    
                Qn(flyIndex,5) = p;
                Qn(flyIndex,6) = f;
                if listening == 1
                    Qn(flyIndex, 7) = zeta;
                    flashes(end, flyIndex) = 1;
                else
                    flashes(end, flyIndex) = -1;
                end
            else
                flashes(end, flyIndex) = -1;
            end
            if Qn(j,5) >= 1
                [Qn, flashes] = doFlash(t, j, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b);
            end
        end
    end
end

