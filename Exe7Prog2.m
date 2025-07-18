%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

% Upon reviewing the results of Exercise 6, the Spike variable is not included.

%% Εισαγωγή δεδομένων
clc, clearvars, close all;
% Reading of the table
filename = 'TMS.xlsx';
data = readtable(filename, 'ReadVariableNames', true); 

Setup = data.Setup(data.TMS == 1);
Stimuli = data.Stimuli(data.TMS == 1);
Intensity = data.Intensity(data.TMS == 1);
%Spike is not included
Frequency = data.Frequency(data.TMS == 1);
CoilCode = data.CoilCode(data.TMS == 1);

% Transformation from cell to double 
Stimuli = str2double(Stimuli); 
Intensity = str2double(Intensity);
Frequency = str2double(Frequency);
CoilCode = str2double(CoilCode);

X = [Setup, Stimuli, Intensity, Frequency, CoilCode];
Y = data.EDduration(data.TMS == 1);

%percentage of training set 
trainRatio = 0.5;

%% Stepwise model with variables chosen for the training set
fprintf('Stepwise model with variables chosen for the training set\n')

[X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio);

stepwise_mdl = stepwiselm(X_train, Y_train);
% Printing of model coefficients and intercept
disp('Selected Coefficients and Intercept:');
disp(stepwise_mdl.Coefficients);


test_predictions = predict(stepwise_mdl, X_test);
MSE_test = mean((Y_test - test_predictions).^2);

fprintf('Mean Squared Error in test (MSE): %.4f\n', MSE_test);

%% Lasso model with variables chosen for the training set
fprintf("\nLasso model with variables chosen for the training set\n")

[X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio);

% This function searches for the lambda value which results in the highest
% R2adjusted value and lowest MSE value.
%lambda_fixed = 0.01;
lambda_fixed = Group44Exe7Fun1(X, Y);

[B, FitInfo] = lasso(X_train, Y_train, 'Lambda', lambda_fixed);

% Printing of model coefficients and intercept
disp('Selected Coefficients:');
disp(B);
disp('Intercept:');
disp(FitInfo.Intercept);

% Calculation of model's predictions for EDduration
test_predictions = FitInfo.Intercept + X_test * B;
MSE_test = mean((Y_test - test_predictions).^2);
fprintf('Mean Squared Error in test (MSE): %.4f\n', MSE_test);

%% Comments on results, Conclusions
% The results do not differ greatly compared to the ones of the Prog1. 
% Choosing the indepentant variables according to the training set results
% in a small increase of MSE for the stepwise model. For the case of the 
% Lasso model, the MSE is almost equal for both methods. As a conclusion, 
% it is understood that choosing the indepentant variables based on the  
% training set does not provide a better performance in the test set. 
% This is reasonable, considering that the full set includes the test set, 
% and for the models created according to the full set, the indepentant 
% variables chosen, their coefficients and  the intercept have been 
% determined based on all the data, with the test set included. Thus, they
% are made to fit both the training and the test set. This is not the case 
% for the models created based only on the training set, whose parameters
% (indepentant variables, coefficients, intercept) are chosen to fit only
% the training set. As a result, if the test set data show differences 
% compared to the training set data, the model will not achieve a good fit 
% to the test set data.