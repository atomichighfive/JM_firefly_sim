function [ Q, G ] = sphereFlock( radius, density, connectionThreshold )
    N = floor(density*(2*radius)^3);    % Ammount to generate
    Q = zeros(N,4); % Preallocate for speed
    discarded = []; % For remembering which rows are unused
    for n=1:N
        x = -radius+2*radius*rand();
        y = -radius+2*radius*rand();
        z = -radius+2*radius*rand();
        if x^2+y^2+z^2 <= radius^2
            Q(n,:) = [0, x, y, z];  % Create oscilator
        else
            discarded(end+1) = n;   % Point outside sphere
        end
    end
    Q(discarded,:) = [];    % Remove unused rows
    Q(:,1) = [1:size(Q,1)]; % Assign IDs
    
    A = adjacencyFromPositions(Q(:,2:4),connectionThreshold);
    G = graph(A);
end

