function [ fig ] = oldPlotBlob( states, flashes, dt )
%OLDPLOTBLOB Summary of this function goes here
%   Detailed explanation goes here
    Q = squeeze(states(1,:,:));
    
    phaseRange = [];
    timeAxis = [];
    T = size(states,1);
    N = size(states, 2);
    
    for t=1:T
        state = squeeze(states(t,:,:));
        avg = 0;
        for i=1:N
            for j=1:N
                avg = avg+absmod(state(i,5),state(j,5));
            end
        end
        avg = avg/(N^2);
        phaseRange = [phaseRange, avg];
        timeAxis = [timeAxis, t*dt];
    end
    
    fig = figure()
    
    subplot(2,1,1); hold off;
    plot(timeAxis, phaseRange);
    axis([0,T*dt,0,0.5])
    
    handles = gobjects(N);
    scatterHandle = gobjects(1);
    textHandle = gobjects(1);
    for t=1:T
        state = squeeze(states(t,:,:));
        flash = flashes(t);
        color = [heaviside(state(:,5)-0.96), zeros(N,1), zeros(N,1)];
        %subplot(2,2,2);
        %hold off
        %plot([t*dt, t*dt],[0, 1]); hold on;
        %plot(timeAxis, phaseRange);
        %axis([0,T*dt,0,0.5])
        subplot(2,1,2);
        [az,el] = view;
        delete(scatterHandle);
        delete(textHandle);
        scatterHandle = scatter3(state(:,2), state(:,3), state(:,4), 50*ones(N,1), color, 'filled');
        textHandle = text(Q(:,2),Q(:,3),Q(:,4)+0.3, num2str(Q(:,1)));
        hold on
        for i=1:0%N
            if sum(flashes(t,i,:)) > 0
                delete(handles(i,:));
            end
            for j=1:N
                if flashes(t,i,j) == 1
                    x = state(i,2);
                    y = state(i,3);
                    z = state(i,4);
                    u = state(j,2)-state(i,2);
                    v = state(j,3)-state(i,3);
                    w = state(j,4)-state(i,4);
                    handles(i,j) = quiver3(x,y,z,u,v,w, 'k', 'MaxHeadSize', 0.75);
                end
            end
        end
        title(t*dt);
        axis equal;
        view(az,el);
        pause(dt);
        if ~ishandle(fig)
            break;
        end
    end

end

