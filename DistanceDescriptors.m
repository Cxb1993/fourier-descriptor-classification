%Build the function signature of the contour (centroid-distance function)
%by first computing the contour's centroid, then computing the distance
%between each ordered point on the contour and the centroid.
%Take the DFT of the discrete-time distance function, then perform some
%algrbra on the DFT coefficients to retrieve the descriptors.
function [descriptors, distances] = DistanceDescriptors(contourPoints)

    centroid = [0 0];
    for k = 1:length(contourPoints)
        centroid = centroid + contourPoints{k}/length(contourPoints);
    end
    
    for k = 1:length(contourPoints)
        distances(k) = sqrt((centroid(1)-contourPoints{k}(1))^2+(centroid(2)-contourPoints{k}(2))^2);
    end
    coefficients = fft(distances);
    %descriptors = coefficients;
    descriptors = abs(coefficients/coefficients(1));
end

