function [p,f,listening] = calcResponse(phase,freq, thau)
% CALCRESPONSE
% Calculates new phase and frequency if event triggers. If recently
% triggered, no calculation will occur.
% Returns:       p (new phase)
%                f (new frequency)
%                listening: 0 if false, 1 if true
% Parameters:    phase: current phase
%                freq: current frequenc
    alpha = 0.5;
    beta = 0.5;
    if thau < phase & phase < 1
        f = freq*calcFreq(phase);
        p = calcPhase(phase);
        listening = 1;
    else
        listening = 0;
        f = freq;
        p = phase;
    end
    
    function [p] = calcPhase(phase)
        if phase <= beta
            p = phase*alpha;
        else %phase > beta
            p = 1;
        end
    end

    function [f] = calcFreq(phase)
        if phase <= thau
           f = 1;
        elseif phase <= (thau+beta/2)
           f = 1+alpha*thau-alpha*phase;
        elseif phase <= beta
           f = 1;
        else %phase > beta
           f = 1.25-0.5*(phase-beta);
        end
    end

end