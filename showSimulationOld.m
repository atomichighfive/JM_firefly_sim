function [ fig ] = showSimulation( states, flashes, dt )
%SHOWSIMULATION Summary of this function goes here
%   Detailed explanation goes here
    flash_display_time = 0.15;
    az = 45; el = 45;

    fig = figure();
    scatter_handle = scatter3(states(1,:,2), states(1,:,3), states(1,:,4));
    hold on; axis equal; 
    handles = [];
    handleIdCounter = 1;
    
    flashPointer = 1;
    for t=1:size(states,1)
        while flashes(flashPointer, end) <= t & flashPointer < size(flashes,1)
            point = squeeze(states(t,flashes(t, end-1),1:4));
            if ~isempty(handles)
                rowsToRemove = find(handles(:,2)==point(1)); % Find rows created by this fly
                for k=1:size(rowsToRemove,1)
                    delete(findobj('Tag', num2str(handles(rowsToRemove(k), 1)))); % Remove old arrows
                end
                handles(rowsToRemove,:) = []; % Remove those rows
            end
            h = scatter3(point(2),point(3),point(4), 'fill', 'red');
            handles(end+1,:) = [handleIdCounter, 0, flash_display_time];
            h.Tag = num2str(handleIdCounter);
            hadnleIdCounter = handleIdCounter + 1;
            for i=1:size(states,2)
                if flashes(flashPointer, i) == 1;
                    point2 = squeeze(states(t, i, 1:4));
                    x = point(2);
                    y = point(3);
                    z = point(4);
                    u = point2(2)-point(2);
                    v = point2(3)-point(3);
                    w = point2(4)-point(4);
                    h = quiver3(x,y,z,u,v,w, ':k');
                    h.Tag = num2str(handleIdCounter);
                    handles(end+1,:) = [handleIdCounter, point(1), 0];
                    handleIdCounter = handleIdCounter + 1;
                end
            end
            flashPointer = flashPointer + 1;
        end
        rowsToRemove = [];
        for i=1:size(handles,1)
            if handles(i,end-1) == 0 & handles(i, end) <= 0
                delete(findobj('Tag', num2str(handles(i, 1))));
                rowsToRemove(end+1) = i;
            elseif handles(i, end-1) == 0
                handles(i, end) = handles(i, end)-dt;
            end
        end
        handles(rowsToRemove,:) = [];
        view(az,el);
        title(t*dt);
        pause(dt);
        if ~ishandle(fig)
            break
        end
        [az,el] = view;
    end
               
end
