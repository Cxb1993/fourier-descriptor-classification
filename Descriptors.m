%Script to load all of the training data from the file specified by
%'dataLocation', perform dilation, build the descriptors, train the model
%on all but the last 100 of the training data (for both descriptor types),
%then perform class prediction on the remaining 100 data points on the
%respective models.

dataLocation = 'optdigits-orig-edited.tra';

trainingData = fopen(dataLocation);

fseek(trainingData, 0, 'eof');
fileSize = ftell(trainingData);
frewind(trainingData);
data = fread(trainingData, fileSize, 'uint8');
fclose(trainingData);

trainingData = fopen(dataLocation);
%Divide the number of lines by 33, 32 rows of data per input, plus one line
%to contain the label for that particular input.
numInputs = sum(data == 10)/33;

data = cell(1, numInputs);
labels = cell(1, numInputs);
i = 1;

for n = 1:length(data)
    data{n} = zeros(32, 32);
end

%Create the structuring element that'll dilate the input images. Images
%need to be dilated in order for the TraverseOuterContour method to work
%correctly.
se = zeros(3);
se(1,2) = 1;
se(2,:) = 1;
se(3,2) = 1;
j = 1;

disp(sprintf('Reading input data from %s', dataLocation))

tline = fgetl(trainingData);
while ischar(tline)
    %j = 1;
    if length(tline) > 4
        %length(tline)
        tempRow = zeros(1,32);
        for n = 1:length(tline)
            tempRow(n) = str2num(tline(n));
        end
        %data{i}(j,:) = [data{i}(n,:),str2num(tline(n))];
        data{i}(j,:) = tempRow;
        j = j + 1;
    end
    if length(tline) <= 4
        labels{i} = str2num(tline);
        %labels{i}
        %disp('label detected')
        data{i} = reshape(data{i}, 32, 32);
        i = i + 1;
        j = 1;
    end
    tline = fgetl(trainingData);
    %tline
    %floor(i*100/numInputs)
end

fclose(trainingData);
disp('Building ordered contours out of the training data.')

contours = {};
%Keep track of failures for the sake of future iterations.
failures = {};

%Traverse the outer contour using neighborhood based checking, return a
%cell of pixel locations where the contour exists.
for k = 1:length(data)
    [contours{k}, failures{k}] = TraverseOuterContour(imdilate(PadImage(data{k},5), se));
    if failures{k} ~= 0
        disp(sprintf('Failure retrieving the contour for data index %d', k))
    end
end

distDescriptors = cell(1, length(contours));
polyDescriptors = cell(1, length(contours));
for k = 1:length(data)
    %The contour by default has the same pixel value at the beginning of
    %the list and at the end of the list. Unfortunately, this causes
    %numerical instabilities when calculating the descriptors, so all
    %contour points except for the last have to be passed to the descriptor
    %functions.
    polyDescriptors{k} = PolyDescriptors(contours{k}(1:end-1));
    distDescriptors{k} = DistanceDescriptors(contours{k}(1:end-1));
end

disp(sprintf('Testing the last hundred data points with optimal classifier parameters.'))
result = TestLastHundred(polyDescriptors, labels, 12, 5);
disp(sprintf('Misclassifications of last hundred data points by polynomial approximation: '))
result
result = TestLastHundred(distDescriptors, labels, 14, 5);
disp(sprintf('Misclassifications of last hundred data points by centroid-distance functions: '))
result


%Only uncomment the following lines if you want to look at the contours one
%at a time with a half second pause between each rendering of a contour.
%{
x = input('display all images at half-second stride?\n');

if (x ~= 0)
    for k = 1:length(contours)
        thing = zeros(44,44);
        for l = 1:length(contours{k})
            thing(contours{k}{l}(1), contours{k}{l}(2)) = 1;
        end
        imshow(thing);
        pause(0.5);
    end
end
%}

