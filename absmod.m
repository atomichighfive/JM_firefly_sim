function [ c ] = absmod( a,b )
    [n,m] = size(a);
    c = [zeros(n,m)];
    for i=1:n
        for j=1:m
            c(i,j) = min([abs(a(i,j)-b(i,j)), 1-abs(a(i,j)-b(i,j))]);
        end
    end
end

