%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%This function creates the training and the test set, according to the
%trainRatio input parameter 

function [X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio)
    n = size(X, 1); 
    rng('default');
    indices = randperm(n);
    
    nTrain = round(trainRatio * n);
    trainIdx = indices(1:nTrain);
    testIdx = indices(nTrain+1:end);
    
    X_train = X(trainIdx, :);
    Y_train = Y(trainIdx);
    
    X_test = X(testIdx, :);
    Y_test = Y(testIdx);
    
    fprintf('Training Set Size: %d samples\n', size(X_train, 1));
    fprintf('Testing Set Size: %d samples\n', size(X_test, 1));
end