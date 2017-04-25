function [ fig ] = showTimeSeries( states, flashes, dt );
%SHOWMETRICS Summary of this function goes here
%   Detailed explanation goes here
    fig = figure();
    
    T = flashes(:,end)*dt;
    F = flashes(:,end-1);
    
    scatter(T,F,'.');
    grid on; xlim([0, time]);
end
    
