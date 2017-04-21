function [ Qn, G ] = calculateGraph( Q, connectionThreshold )
%RECALCULATEGRAPH Summary of this function goes here
%   Detailed explanation goes here
    Qn = Q;

    A = adjacencyFromPositions(Qn(:,2:4),connectionThreshold);
    G = graph(A);
    
    %remove flies with no neighbours
    toRemove = [];
    for q=1:size(Qn(:,1),1)
        if size(neighbors(G, q), 1) < 1
            toRemove(end+1) = q;
        end
    end
    Qn(toRemove, :) = [];
    
    A = adjacencyFromPositions(Qn(:,2:4),connectionThreshold);
    G = graph(A);

end

