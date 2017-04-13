%Trains a KNN classifier on all (except for the last 100) of the
%descriptors and labels supplied in the function header using the specified
%number of descriptors and neighbors and runs that classifier against the 
%last hundred items in the 'inDescriptors' cell.
%The function returns a histogram of failed label classifications. E.g. if
%KNN fails to properly classify training label '7', the '7' slot of the
%histogram is incremented.

function [result] = TestLastHundred(inDescriptors, labels, numDescriptors, numNeighbors)

    if length(inDescriptors) < numDescriptors
        numDescriptors = length(inDescriptors);
    end
    
    descriptors = zeros(length(labels),numDescriptors);
    newLabels = zeros(1, length(labels));
    for k = 1:length(newLabels)
        newLabels(k) = labels{k};
        for n = 2:1+numDescriptors
            %descriptors(k, n-1) = abs(inDescriptors{k}(n)/inDescriptors{k}(1));
            descriptors(k, n-1) = inDescriptors{k}(n);
        end
    end
    num = 0;

    trainData = descriptors(1:end-100, :);
    trainLabels = newLabels(1:end-100);
    
    testData = descriptors(end-100:end, :);
    testLabels = newLabels(end-100:end);
    
    size(testData)

    model = fitcknn(trainData, trainLabels, 'NumNeighbors', numNeighbors);
    
    result = ones(1,10);
    for k = 1:100
        prediction = predict(model, testData(k,:));
        %prediction
        %testLabels(k)
        if prediction ~= testLabels(k)
            %disp(sprintf('prediction = %d, label = %d, index = %d', prediction, testLabels(k), length(labels)-100+k-1))
            result(testLabels(k)+1) = result(testLabels(k)+1)+1;
            num = num + 1;
        end
    end
    
    disp(sprintf('Number of misclassifications: %d', num))

end