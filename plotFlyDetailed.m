function [ handles ] = plotFlyDetailed( states, flashes, dt, oscilator, useLegend )
%SHOW Summary of this function goes here
%   Detailed explanation goes here
    seenFlashes = squeeze(flashes(:,[oscilator, end-1, end]));
    seenFlashes = seenFlashes(find(seenFlashes(:,1)),:);
    
    selfFlashes = flashes(find(flashes(:,end-1) == oscilator),:);

        %toRemove = [];
        %seenTimestamps = [seenFlashes(1,end),1];
        %for i=1:size(seenFlashes,1)
        %    if any(seenTimestamps(:,1) == seenFlashes(i,end));
        %        toRemove(end+1) = i;
        %        indexOfKeeper = find(seenTimestamps(:,1) == seenFlashes(i,end));
        %        seenFlashes(indexOfKeeper,1) = seenFlashes(indexOfKeeper,1) | seenFlashes(i,1);
        %    else
        %        seenTimestamps(end+1,:) = [seenFlashes(i,end),i];
        %    end
        %end
        %
        %seenFlashes(toRemove,:) = [];
        %
    
    
    
        %y = zeros(1,size(x,2));
        %y(seenFlashes(:,end)) = seenFlashes(:,1);
        
    x = seenFlashes(:,end)*dt;
    y = seenFlashes(:,1);
    
    selfx = selfFlashes(:,end)*dt;
    selfy = ones(size(selfx,1),1);
    
    t = [1:size(states, 1)]*dt;
    p = squeeze(states(:,oscilator,5));
    f = squeeze(states(:,oscilator,6));
    
    handles = gobjects(4,1);
    yyaxis('left');
    handles(1) = stem(x,abs(y), 'Marker', 'none', 'Linewidth', 0.5, 'Color', 'black'); hold on;
    handles(2) = plot(selfx, selfy, 'k*');
    handles(3) = plot(t,p, '--');
    ylim([0,1.1]);
    yyaxis('right');
    handles(4) = plot(t,f, '-.'); hold off;
    yyaxis('left');
    if useLegend
        legend('input light','flashes','evolution','frequency', 'Location', 'southeast');
    end
end