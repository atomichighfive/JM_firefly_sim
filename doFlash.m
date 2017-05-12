function [ Qn, flashes ] = doFlash( t, i, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b, rdepth )
    % Triggers a flash and if no delay is present, also handle triggering
    % of neighbours that will trigger from the stimulation.
    Qn(i,5) = 0;
    
    N = numnodes(G); % Record that a flash happened
    flashes(end + 1,:) = [zeros(1,N), i, t];
    
    if delaysteps == 0
        % If we are not simulating signal delay the pulses can traverse the
        % graph within one timestep. Handle this recursively.
        neig = neighbors(G, i);
        for j=1:size(neig, 1)
            flyIndex = neig(j);
            % Calculate and apply new state to all neighbours
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
            if Qn(j,5) >= 1 && rdepth < 100
                % If a fly is set to flash due to receiving a flash with
                % zero delay, trigger a flash from that fly to. This is the
                % recursive step.
                [Qn, flashes] = doFlash(t, j, Qn, states, flashes, G, thau, zeta, delaysteps, alpha, beta, gamma, a, b, rdepth+1);
            end
        end
    end
end

