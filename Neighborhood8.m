function [ Neighborhood ] = Neighborhood8(I, c)
%'c' is the center of the neighborhood; an array.
    height = size(I,1);
    width = size(I,2);
    
    Neighborhood = zeros(3,3);
    for m = -1:1
        for n = -1:1
            nx = c(1) + m;
            ny = c(2) + n;
            if nx > 0 && nx <=height && ny > 0 && ny <= width
                Neighborhood(m+2, n+2) = I(nx, ny);
            end
        end
    end

end

