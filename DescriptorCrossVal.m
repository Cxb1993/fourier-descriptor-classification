%Perform cross-validation with Matlab's built-in KNN function. As part of
%the validation process, the number of neighbors in the model, and the
%number of descriptors provided to the model are varied in an attempt to
%arrive at a classification error-minimizing pair of constraints (K, N).

%NOTE THIS WILL TAKE FOREVER TO RUN IF YOU SPECIFY RANGES >= 5 FOR THE
%NUMBER OF DESCRIPTORS OR NEIGHBORS. (range = max-min)

function [CVloss, CVuncert] = DescriptorCrossVal(descriptors, labels, minDescriptors, maxDescriptors, minNeighbors, maxNeighbors)
    
    %The 'CV' variables are matrices that contain cross-validation loss
    %values for the various values of N and K that are specified in the
    %function header.
    CVuncert = zeros(maxNeighbors-minNeighbors+1, maxDescriptors-minDescriptors+1);
    CVloss = zeros(maxNeighbors-minNeighbors+1, maxDescriptors-minDescriptors+1);
    for n = minDescriptors:maxDescriptors
        model = KNNFourierFeatures(descriptors, labels, n);
        for k = minNeighbors:maxNeighbors
            model.NumNeighbors = k;
            %disp(sprintf('n = %d, k = %d', n, k));
            result = zeros(1,10);
            %Perform k-fold cross validation on the model that has already
            %been trained.
            for l = 1:10
                cvmodel = crossval(model);
                result(l) = kfoldLoss(cvmodel);
            end
            CVloss(k-minNeighbors+1,n-minDescriptors+1) = mean(result);
            CVuncert(k-minNeighbors+1,n-minDescriptors+1) = std(result);
        end
    end
    
end