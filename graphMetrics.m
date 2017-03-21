function [ ] = graphMetrics( G )
%GRAPHMETRICS Summary of this function goes here
%   Detailed explanation goes here
    deg = degree(G);
    nodes = numnodes(G);
    edges = numedges(G);
    
    disp('== Graph metrics ==');
    disp(['Oscilators: ', num2str(nodes)]);
    disp(['Connections: ', num2str(edges)]);
    disp(['Mean degree: ', num2str(mean(deg))]);
    disp(['Degree deviation: ', num2str(std(deg))]);
    disp(['Minimum degree: ', num2str(min(deg))]);
    disp(['Maximum degree: ', num2str(max(deg))]);
    fprintf('\n');
end

