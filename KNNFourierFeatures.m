function [model] = KNNFourierFeatures(polyDescriptors, labels, numDescriptors)

    %NEED TO TRAIN ON EQUAL NUMBERS OF LABELED DATA
    %NEED TO SAMPLE ORIGINAL CONTOUR FOR EDGES AT FIXED LENGTHS

    if length(polyDescriptors) < numDescriptors
        numDescriptors = length(polyDescriptors);
    end
    
    descriptors = zeros(length(labels),numDescriptors);
    newLabels = zeros(1, length(labels));
    for k = 1:length(labels)
        newLabels(k) = labels{k};
        for n = 2:1+numDescriptors
            %descriptors(k, n-1) = abs(polyDescriptors{k}(n)/polyDescriptors{k}(1));
            descriptors(k, n-1) = polyDescriptors{k}(n);
        end
    end

    trainData = descriptors(1:end, :);
    trainLabels = newLabels(1:end);

    model = fitcknn(trainData, trainLabels);
    %cvmodel = crossval(model);
    %result(k) = kfoldLoss(cvmodel);

end