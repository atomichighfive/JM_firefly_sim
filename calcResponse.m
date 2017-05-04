function [p,f,listening] = calcResponse(phase,freq, thau, alpha, beta, gamma, a, b)
% CALCRESPONSE
% Calculates new phase and frequency if event triggers. If recently
% triggered, no calculation will occur.
% Returns:       p (new phase)
%                f (new frequency)
%                listening: 0 if false, 1 if true
% Parameters:    phase: current phase
%                freq: current frequenc
   % alpha = 0.5;
   % beta = 0.5;
   % gamma = 0.05; 
  %  a = 0.25;
 %   b = 0.25;
    
    
    if thau < phase && phase < 1
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
        elseif phase <= (beta-gamma/2)
           f = 1-(a/((beta-gamma/2)-thau))*(phase-thau);
        elseif phase <= (beta-gamma/2)
            f = 1;
        elseif phase <= beta+gamma/2
           f = 1;
        else %phase > beta
           f = 1+b-(b/(1-(beta+gamma/2)))*(phase-(beta+gamma/2));
        end
    end

end