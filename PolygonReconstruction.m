star = imread('startest.png');
ece = imread('ece532.png');

star = rgb2gray(star);
ece = rgb2gray(ece);

SE = zeros(3);
SE(1,2) = 1;
SE(2,:) = 1;
SE(3,2) = 1;

starContour = TraverseOuterContour(imdilate(star, SE));
eceContour = TraverseOuterContour(ece);

[junk, a, b] = PolyDescriptors(starContour(1:end-1));
[junk, c, d] = PolyDescriptors(eceContour(1:end-1));

PlotFourierSeries(a, b, 'Star');
Disp('Press Enter to continue')
pause()
PlotFourierSeries(c, d, 'ECE');