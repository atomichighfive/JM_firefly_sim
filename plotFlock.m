function [ scatter, lines, texts ] = plotFlock( Q, G )
%PLOTFLOCK Summary of this function goes here
%   Detailed explanation goes here
    scatter = gobjects(1);
    lines = gobjects(numedges(G));
    texts = gobjects(numnodes(G));
    
    scatter = scatter3(Q(:,2),Q(:,3),Q(:,4), 'filled');
    axis equal, grid on; hold on;
    
    A = adjacency(G);
    lineindex = 1;
    textindex = 1;
    for i=1:size(Q,1)
        for j=1:size(Q,1)
            if A(i,j) == 1
                lines(lineindex) = plot3([Q(i,2);Q(j,2)],[Q(i,3);Q(j,3)],[Q(i,4);Q(j,4)], 'k:');
                lineindex = lineindex + 1;
            end
        end
        texts(textindex) = text(Q(i,2),Q(i,3),Q(i,4)+0.3, num2str(Q(i,1)));
        textindex = textindex + 1;
    end

end

