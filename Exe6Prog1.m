%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%The 3 multiple regression models with the inclusion of the Spike variable.

%% Data Import
clc, clearvars, close all;
% Reading of the table
filename = 'TMS.xlsx';
data = readtable(filename, 'ReadVariableNames', true); 

Setup = data.Setup(data.TMS == 1);
Stimuli = data.Stimuli(data.TMS == 1);
Intensity = data.Intensity(data.TMS == 1);
Spike = data.Spike(data.TMS == 1);
Frequency = data.Frequency(data.TMS == 1);
CoilCode = data.CoilCode(data.TMS == 1);

% Transformation from cell to double 
Stimuli = str2double(Stimuli); 
Intensity = str2double(Intensity);
Spike = str2double(Spike);
Frequency = str2double(Frequency);
CoilCode = str2double(CoilCode);

X = [Setup, Stimuli, Intensity, Spike, Frequency, CoilCode];
Y = data.EDduration(data.TMS == 1);

%Cleaning of the data due to the missing values of Spike
validRows = all(~isnan([X, Y]), 2); 
X_clean = X(validRows, :);
Y_clean = Y(validRows);

%% Full model with Spike
fprintf("Full model with Spike \n")

full_mdl = fitlm(X_clean, Y_clean);

%Results
disp(['Adjusted R^2: ', num2str(full_mdl.Rsquared.Adjusted)]);
disp(['Mean Squared Error (MSE): ', num2str(full_mdl.MSE)]);

%% Stepwise model with Spike
fprintf("\nStepwise model with Spike\n")

stepwise_mdl = stepwiselm(X_clean, Y_clean);
R2_adj = stepwise_mdl.Rsquared.Adjusted;

% Printing of model coefficients and intercept
disp('Selected Coefficients and Intercept:');
disp(stepwise_mdl.Coefficients);

Y_estimated = predict(stepwise_mdl, X_clean);
MSE = mean((Y_clean - Y_estimated).^2);

%Results
fprintf('Adjusted R^2: %.4f\n', R2_adj);
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);


%% LASSO model with Spike
fprintf("\nLASSO model with Spike\n")

% This function searches for the lambda value which results in the highest
% R2adjusted value and lowest MSE value.
%lambda = 0.1389
lambda = Group44Exe6Fun1(X_clean, Y_clean);

[B, FitInfo] = lasso(X_clean, Y_clean, 'Lambda', lambda);

% Printing of model coefficients and intercept
disp('Selected Coefficients:');
disp(B);
disp('Intercept:');
disp(FitInfo.Intercept);

% Calculation of model's predictions for EDduration
Y_estimated = FitInfo.Intercept + X_clean * B;

SS_res = sum((Y_clean - Y_estimated).^2);
SS_tot = sum((Y_clean - mean(Y_clean)).^2);
R2 = 1 - (SS_res / SS_tot);

n = length(Y_clean);
m = sum(B ~= 0);
if m == 0
    fprintf('Warning: No predictors selected by LASSO.\n');
end
R2_adj = 1 - (1 - R2) * ((n - 1) / (n - m - 1));

MSE = mean((Y_clean - Y_estimated).^2);

%Results
fprintf('Adjusted R^2: %.4f\n', R2_adj);
fprintf('Mean Squared Error (MSE): %.4f\n', MSE);

%% Comments on results, Conclusions
% With the Spike variable included, the Lasso model provides the best
% fit to the EDduration data. This is due to the fact that the
% Lasso model presents the higher value of R2adj and the lower value of
% MSE. However, all 3 models achieve a relatively low value of R2adj,
% indicating that they do not achieve a good fit to the data.

