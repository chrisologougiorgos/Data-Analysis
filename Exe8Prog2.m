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
preTMS = data.preTMS(data.TMS == 1);
postTMS = data.postTMS(data.TMS == 1);

% Transformation from cell to double
Stimuli = str2double(Stimuli); 
Intensity = str2double(Intensity);
Frequency = str2double(Frequency);
CoilCode = str2double(CoilCode);

X = [Setup, Stimuli, Intensity, Frequency, CoilCode, preTMS, postTMS];
Y = data.EDduration(data.TMS == 1);

%% Stepwise model for 7 indepentant variables (NO SPIKE)
fprintf("Stepwise model for 7 indepentant variables \n")

stepwise_mdl = stepwiselm(X, Y);
% Printing of model coefficients and intercept
disp('Selected Coefficients and Intercept:');
disp(stepwise_mdl.Coefficients);

R2_adj = stepwise_mdl.Rsquared.Adjusted;

Y_estimated = predict(stepwise_mdl, X);
MSE = mean((Y - Y_estimated).^2);

%Results
fprintf('Adjusted R^2: %.4f\n', R2_adj);
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);

%% Lasso model for 7 indepentant variables (NO SPIKE)
fprintf("\nLASSO model for 7 indepentant variables \n")

% This function searches for the lambda value which results in the highest
% R2adjusted value and lowest MSE value.
%lambda_fixed = 0.01;
lambda_fixed = Group44Exe8Fun1(X, Y) 

[B, FitInfo] = lasso(X, Y, 'Lambda', lambda_fixed);

% Printing of model coefficients and intercept
disp('Selected Coefficients:');
disp(B);
disp('Intercept:');
disp(FitInfo.Intercept);

% Calculation of model's predictions for EDduration
Y_estimated = FitInfo.Intercept + X * B;


SS_res = sum((Y - Y_estimated).^2);
SS_tot = sum((Y - mean(Y)).^2);
R2 = 1 - (SS_res / SS_tot);

n = length(Y);
m = sum(B ~= 0);
if m == 0
    fprintf('Warning: No predictors selected by LASSO.\n');
end
R2_adj = 1 - (1 - R2) * ((n - 1) / (n - m - 1));

MSE = mean((Y - Y_estimated).^2);

%Results
fprintf('Adjusted R^2: %.4f\n', R2_adj);
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);

%% PCR model for 7 indepentant variables (NO SPIKE)
fprintf("\nPCR model for 7 indepentant variables \n")

X_mean = mean(X);
X_std = std(X);
X_normalized = (X - X_mean) ./ X_std;

%PCA
[coeff, score, latent, ~, explained] = pca(X_normalized);

disp('Cumulative Explained Variance by Principal Components:');
disp(cumsum(explained));

% The minimum number of principal components required to explain at least 
% 90% of the variance is chosen.
numComponents = find(cumsum(explained) >= 90, 1);

X_reduced = score(:, 1:numComponents);
Pcr_mdl = fitlm(X_reduced, Y);
R2_adj = Pcr_mdl.Rsquared.Adjusted;
MSE = Pcr_mdl.MSE;

%Results
disp('PCR Model Performance:');
disp(['Number of Components: ', num2str(numComponents)]);
disp(['Explained Variance: ', num2str(sum(explained(1:numComponents))), '%']);
disp(['Adjusted R^2: ', num2str(R2_adj)]);
disp(['MSE: ', num2str(MSE)]);

%% Comments on results, Conclusions
% 1) With the addition of the postTMS variable, all three dimension reduction
% models provide significantly better fit to the EDduration data.
% The stepwise model achieves perfect fit, the Lasso model has a
% R2adj = 1 value and MSE = 0.02 (which is close to zero) and the PCR model
% has a high R2adj value and a low MSE value, too.
% 2)These results are reasonable, considering that for each observation, 
% the EDduration value occurs from the addition of the preTMS and postTMS 
% variables. This is the reason why the stepwise and the lasso model
% coefficients are zero (or nearly zero) for all variables, except 
% preTMS and postTMS variables. The coefficients for the last two have a
% value of one (or nearly one).