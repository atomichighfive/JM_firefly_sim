function [ fig ] = showTimeSeries( states, flashes, dt );
%SHOWMETRICS Summary of this function goes here
%   Detailed explanation goes here
    fig = figure();
    data = zeros(size(states,2), size(states,1));
    for i=1:size(flashes,1)
        data(flashes(i,end-1), flashes(i,end)) = 1;
    end
    figure(fig);
    imagesc(data);
    
    caxis([0,3])
    colormap('hot');
    axis equal; grid on;
end
    
