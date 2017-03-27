function [ fig ] = showStateEvolution( states, dt, render )
%SHOWSTATEEVOLUTION Summary of this function goes here
%   Detailed explanation goes here
    T = size(states,1);
    
    fig = figure();
    figure(fig);
    
    subplot(1,2,1);
    title('Phase')
    subplot(1,2,2);
    title('Speed')
    
    for t=1:T
        suptitle(num2str(t*dt));
        figure(fig);
        subplot(1,2,1);
        plot(states(t,:,5),'.');
        ylim([0,1.1]);
        xlim([0,size(states,2)+1])
        subplot(1,2,2);
        plot(states(t,:,6),'.');
        ylim([0,3]);
        xlim([0,size(states,2)+1])
        if render
            drawnow;
            print(['output/showStateEvolution/',num2str(t)], '-djpeg');
        else
            pause(dt);
        end
        if ~ishandle(fig)
            break;
        end
    end
end

