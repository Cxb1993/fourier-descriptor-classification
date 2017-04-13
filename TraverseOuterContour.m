%Given a bilevel image, I, of a single objectthis function attempts to put
%together an ordered list of points corresponding to the contour of the
%object in the image.

function [contourPixels, fail] = TraverseOuterContour(I)
    width = size(I,1);
    height = size(I,2);
    stopNeighborCheck = 0;
    firstLoop = 1;
    entryExists = 0;
    numIterations = 0;
    fail = 0;
    
    %CONSIDER ADDING A WAY TO DOWNSAMPLE THE TOTAL NUMBER OF POINTS YOU
    %OBTAINED. I.E. DO SOME INTERPOLATION TO FIGURE OUT WHERE 64 OR 32 EVENLY
    %SPACED (DISTANCE ALONG CONTOUR) POINTS WOULD OCCUR ALONG THE PERIMETER
    %TAKE THE PERIMETER AND DIVIDE IT BY THE TOTAL NUMBER OF POINTS YOU
    %WANT TO SAMPLE, THAT'S YOUR DISTANCE SEPARATION BETWEEN CONTOUR
    %POINTS.
    
    %Find a starting point
    for m = 1:width
        for n = 1:height
            if I(m,n) > 0
                contourPixels{1} = [m n];
                stopNeighborCheck = 1;
                break;
            end
        end
        if stopNeighborCheck == 1
            break;
        end
    end
    %disp(sprintf('starting location: %d %d', m, n))

    i = 2;
    stopNeighborCheck = 0;
    %while firstLoop || (m ~= contourPixels{1}(1) && n ~= contourPixels{1}(2))
    while (firstLoop || m ~= contourPixels{1}(1) || n ~= contourPixels{1}(2))
        %There are eight neighbor index patterns. This method ensures that the closest neighbors
        %(4-conn neighbors) are visited before diagonal neighbors.
        %If you do separate loops over r and c there are cases where a diagonal neighbor
        %will be visited before a 4-conn neighbor. 
        for pattern = 1:8
            switch pattern
                case 1
                    r = -1;
                    c = 0;
                case 2
                    r = 0;
                    c = -1;
                case 3
                    r = 1;
                    c = 0;
                case 4
                    r = 0;
                    c = 1;
                case 5
                    r = -1;
                    c = -1;
                case 6
                    r = -1;
                    c = 1;
                case 7
                    r = 1;
                    c = -1;
                case 8
                    r = 1;
                    c = 1;
            end
            if m+r > 0 && m+r <= width && n+c > 0 && n+c <= height
                %Now that you're looping over neighborhood patterns, you don't need to verify that 
                %the center pixel is included.
                if (I(m+r, n+c) > 0) 
                    nbd = Neighborhood8(I, [m+r, n+c]);
                    if (nbd(1,2) == 0) || (nbd(2,3) == 0) || (nbd(2,1) == 0) || (nbd(3,2) == 0)
                        %The assumption in the following for loop is that you won't encounter the same pixel within
                        %three neighbor visits.
                        %Put another way, the next pixel to visit can't be one of the last three pixels visited.
                        for k = max(1, i-3):length(contourPixels)
                            if contourPixels{k}(1) == m+r && contourPixels{k}(2) == n+c
                                %disp(sprintf('\t\tcandidate already visited'))
                                entryExists = 1;
                                %disp(sprintf('\tentry %d %d found in contourpixels at %d', m + r, n + c, k))
                                break;
                            end
                        end

                        if ~entryExists
                            %disp(sprintf('\t\tcandidate matched!'))
                            m = m + r;
                            n = n + c;
                            contourPixels{i} = [m, n];
                            i = i + 1;
                            stopNeighborCheck = 1;
                            break;
                        end
                        entryExists = 0;
                    end
                end
            end
            stopNeighborCheck = 0;
        end
        firstLoop = 0;
        numIterations = numIterations + 1;
        %If the number of neighborhood checks exceed the total number of pixels in the image, 
        %break the outer while loop.
        if numIterations > width*height
            %disp('Number of iterations exceeded number of pixels in the entire image')
            fail = 1;
            break;
        end
        %disp(sprintf('%d %d', m, n));
        %pause(1)
    end
    
end

