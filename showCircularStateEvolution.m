function [ fig ] = showCircularStateEvolution( states, dt, timescale, render )
%SHOWSTATEEVOLUTION Summary of this function goes here
%   Detailed explanation goes here
    T = size(states,1);
    
    fig = figure();
    figure(fig);
    
    maxF = max(max(states(:,:,6)));
    minF = min(min(states(:,:,6)));
    meanF = mean(mean(states(:,:,6)));
    
    maxPlotRadius = 1+meanF-minF;
    for t=1:T
        polarplot([2*pi, 2*pi],[0,maxPlotRadius],'k'); hold on;
        polarplot(2*pi*states(t,:,5),1+meanF-states(t,:,6), '.'); hold off;
        rlim([0,maxPlotRadius]);
        title(['T = ', num2str(t*dt,2)]);
        if render
            drawnow;
            print(['output/showCircularStateEvolution/',num2str(t)], '-djpeg');
        else
            pause(dt/timescale);
        end
        if ~ishandle(fig)
            break;
        end
    end
end

