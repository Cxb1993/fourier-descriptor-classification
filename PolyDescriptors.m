
function [descriptors, fourierCoefficients1, fourierCoefficients2] = PolyDescriptors(contourPoints)


    %YOU CAN GET THE GENERAL CONTOUR FROM A GIVEN INPUT, BUT YOU HAVE TO
    %DELETE THE LAST POINT IN THE CELLS. IF YOU DON'T, YOU'LL GET A
    %POLYSIDEVECTOR VALUE OF '0 + i0' WHICH'LL THROW NANS ON YOUR OUTPUTS.
    L = 0;
    NUMCOEFF = 100;

    imagContourPoints = zeros(1, length(contourPoints));
    for k = 1:length(contourPoints)
        imagContourPoints(k) = contourPoints{k}(1) + 1i*contourPoints{k}(2);
    end
    
    polySideVectors = zeros(1, length(contourPoints)+1);
    for k = 2:length(contourPoints)
        polySideVectors(k-1) = imagContourPoints(k) - imagContourPoints(k-1);
    end
    polySideVectors(k) = imagContourPoints(1) - imagContourPoints(k);
    polySideVectors(k+1) = polySideVectors(1);
    
    for k = 1:length(contourPoints)
        L = L + abs(polySideVectors(k));
    end
    %disp(sprintf('contour length: %d', L));
    
    polyVelocityVectors = zeros(1, length(contourPoints)+1);
    for k = 1:length(contourPoints)+1
        polyVelocityVectors(k) = L*polySideVectors(k)/(2*pi*abs(polySideVectors(k)));
    end
    %polyVelocityVectors(k) = L*polySideVectors(1)/(2*pi);
    %polyVelocityVectors(k) = polyVelocityVectors(1);
    %polyVelocityVectors(k+1)
    
    timePoints = zeros(1,length(contourPoints)+1);
    for k = 2:length(contourPoints)+1
        timePoints(k) = 2*pi*abs(polySideVectors(k-1))/L + timePoints(k-1);
    end
    
    fourierCoefficients1 = zeros(1, NUMCOEFF);
    for n = 1:length(fourierCoefficients1)
        for k = 2:length(contourPoints)+1
            fourierCoefficients1(n) = fourierCoefficients1(n) + (polyVelocityVectors(k-1)-polyVelocityVectors(k))*exp(-i*timePoints(k)*n)*(1/(2*pi*n^2));
        end
    end
    
    fourierCoefficients2 = zeros(1, NUMCOEFF);
    for n = 1:length(fourierCoefficients2)
        for k = 2:length(contourPoints)+1
            fourierCoefficients2(n) = fourierCoefficients2(n) + (polyVelocityVectors(k-1)-polyVelocityVectors(k))*exp(-i*timePoints(k)*-n)*(1/(2*pi*n^2));
        end
    end
    

        
    descriptors = zeros(1, NUMCOEFF);
    for n = 2:length(descriptors)
        descriptors(n) = abs(fourierCoefficients1(n)*fourierCoefficients2(n)/(fourierCoefficients1(1)*fourierCoefficients2(1)));
    end
    
    %EXACTLY REPRODUCES THE POLYGON, BUT IT'S TRANSLATED SLIGHTLY, WHICH IS
    %PERFECTLY FINE BECAUSE YOU'VE OMITTED THE DC TERM.
end

