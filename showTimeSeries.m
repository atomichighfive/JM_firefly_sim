function [ fig ] = showTimeSeries( states, flashes, dt );
%SHOWMETRICS Summary of this function goes here
%   Detailed explanation goes here
    
    T = flashes(:,end)*dt;
    F = flashes(:,end-1);
    
    scatter(T,F,'.');
    xaxis = xlim;
    grid on; xlim([0, xaxis(2)]);
end
    
