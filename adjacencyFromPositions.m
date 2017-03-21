function [ A ] = adjacencyFromPositions( Q, thresh )
    [N, D] = size(Q);
    A = zeros(N,N);
    for i=1:N
        for j=1:N
            A(i,j) = 1-heaviside(pdist([Q(i,:);Q(j,:)])-thresh);
        end
    end
    A = A-diag(diag(A)); % Not ajacent to self
end

