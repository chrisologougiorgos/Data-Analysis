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

%percentage of training set 
trainRatio = 0.5;

%% Full model 
fprintf("Full model\n")
X = [Setup, Stimuli, Intensity, Frequency, CoilCode];
Y = data.EDduration(data.TMS == 1);

[X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio);

full_mdl = fitlm(X_train, Y_train);
disp(full_mdl.Coefficients)

test_predictions = predict(full_mdl, X_test);
MSE_test = mean ((Y_test - test_predictions).^2);

disp(['Mean Squared Error in test (MSE): ', num2str(MSE_test)]);

%% Stepwise model with variables chosen from Exe 6
%The variables used from the stepwise model are Setup, Stimuli, Frequency
%and the product of Setup * Frequency
fprintf("\nStepwise model with variables chosen from Exe 6\n")
X = [Setup, Stimuli, Frequency, Setup .* Frequency];
Y = data.EDduration(data.TMS == 1);

[X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio);

stepwise_mdl = fitlm(X_train, Y_train);
disp(stepwise_mdl.Coefficients)

test_predictions = predict(stepwise_mdl, X_test);
MSE_test = mean ((Y_test - test_predictions).^2);

disp(['Mean Squared Error in test (MSE): ', num2str(MSE_test)]);

%% Lasso model with variables chosen from Exe 6
%The variables used from the lasso model are Setup, Stimuli, Intensity and
%Frequency.
fprintf("\nLasso model with variables chosen from Exe 6\n")
X = [Setup, Stimuli, Intensity, Frequency];
Y = data.EDduration(data.TMS == 1);

[X_train, Y_train, X_test, Y_test] = Group44Exe7Fun2(X, Y, trainRatio);

lasso_mdl = fitlm(X_train, Y_train);
disp(lasso_mdl.Coefficients)

test_predictions = predict(lasso_mdl, X_test);
MSE_test = mean ((Y_test - test_predictions).^2);

disp(['Mean Squared Error in test (MSE): ', num2str(MSE_test)]);

%% Comments on results, Conclusions
% 1) The model with the lowest value of MSE is the stepwise model. Thus, it
% provides, overall, the most accurate predictions.
% 2) The full model and the Lasso model provide the same MSE value. As a
% conclusion, the CoilCode ,which is the only variable used in the full
% model but not in the Lasso model, does not have any influence regarding 
% the predictions of the full model. This is expected, considering that the
% CoilCode and Intensity variables are linearly dependant.












