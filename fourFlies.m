function [ Q, G ] = sphereFlock( )
    N = 4;   % Ammount to generate
    Q = [0, 0, 0, 0;
         0, 1, 0, 0;
         0, 1, 1, 0;
         0, 0, 1, 0;];
    Q(:,1) = [1:size(Q,1)]; % Assign IDs
    
    A = adjacencyFromPositions(Q(:,2:4),2);
    G = graph(A);
end

