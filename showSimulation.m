function [ fig ] = showSimulation2( states, flashes, dt, arrows, render )
%SHOWSIMULATION Summary of this function goes here
%   Detailed explanation goes here
    flash_display_time = 0.15;
    az = 45; el = 45;

    run = 1;
    fig = figure();
    outline_handle = gobjects(1);
    scatter_handles = gobjects(size(states,2),1);
    if arrows
        arrow_handles = gobjects(size(states,2));
    end
        scatter_times = zeros(size(scatter_handles));
    
    outline_handle = scatter3(states(1,:,2), states(1,:,3), states(1,:,4));
    hold on; axis equal; view(az,el);
    
    for i = 1:size(scatter_handles, 1)
        if ~ishandle(fig)
            run = 0;
            break;
        end
        scatter_handles(i) = scatter3(states(1,i,2), states(1,i,3), states(1,i,4), 'blue', 'fill');
        set(scatter_handles(i),'Visible', 'off');
        if arrows
            for j = 1:size(scatter_handles, 1)
                x = states(1,i,2);
                y = states(1,i,3);
                z = states(1,i,4);
                u = states(1,j,2)-x;
                v = states(1,j,3)-y;
                w = states(1,j,4)-z;
                arrow_handles(i,j) = quiver3(x,y,z,u,v,w, 'k');
                set(arrow_handles(i,j), 'Visible', 'off');
            end
        end
        title(['loading ', num2str(100*i/size(scatter_handles,1), 2), '%']);
        drawnow;
    end
    
    if run == 1
        title('loading 100%');
        drawnow;
    end
    
    if run == 1
        flashPointer = 1;
        for t=1:size(states,1)
            while flashes(flashPointer, end) <= t & flashPointer < size(flashes,1)
                point = squeeze(states(t,flashes(t, end-1),1:4));
                set(scatter_handles(flashes(flashPointer, end-1)), 'Visible', 'on');
                scatter_times(flashes(flashPointer, end-1)) = flash_display_time;
                if arrows
                    for j = 1:size(states,2)
                        if flashes(flashPointer,j) > 0
                            set(arrow_handles(point(1),j), 'Visible', 'on');
                        else
                            set(arrow_handles(point(1),j), 'Visible', 'off');
                        end
                    end
                end
                flashPointer = flashPointer + 1;
            end

            for i=1:size(scatter_times,1);
                if scatter_times(i) <= 0
                    set(scatter_handles(i), 'Visible', 'off');
                    if arrows
                        for j = 1:size(arrow_handles, 2)
                            set(arrow_handles(i,j), 'Visible', 'off');
                        end
                    end
                end
            end

            scatter_times = scatter_times - dt;


            view(az,el);
            title(['t=',num2str(t*dt)]);
            if render
                drawnow;
                print(['output/showSimulation/',num2str(t)], '-djpeg');
            else
                pause(dt);
            end
            if ~ishandle(fig)
                break
            end
            [az,el] = view;
        end
    end          
end
