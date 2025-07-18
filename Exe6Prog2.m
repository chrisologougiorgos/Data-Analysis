%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%%The 3 multiple regression models with the exclusion of the Spike variable.

%% Data Import
clc, clearvars, close all;
% Reading of the table
filename = 'TMS.xlsx';
data = readtable(filename, 'ReadVariableNames', true); 

Setup = data.Setup(data.TMS == 1);
Stimuli = data.Stimuli(data.TMS == 1);
Intensity = data.Intensity(data.TMS == 1);
% Spike is not included
Frequency = data.Frequency(data.TMS == 1);
CoilCode = data.CoilCode(data.TMS == 1);

% Transformation from cell to double
Stimuli = str2double(Stimuli); 
Intensity = str2double(Intensity);
Frequency = str2double(Frequency);
CoilCode = str2double(CoilCode);

X = [Setup, Stimuli, Intensity, Frequency, CoilCode];
Y = data.EDduration(data.TMS == 1);

%% Full model without Spike
fprintf("\nFull model without Spike\n")

full_mdl = fitlm(X, Y);

%results
disp(['Adjusted R^2: ', num2str(full_mdl.Rsquared.Adjusted)]);
disp(['Mean Squared Error (MSE): ', num2str(full_mdl.MSE)]);

%% Stepwise model without Spike
fprintf("\nStepwise model without Spike\n")

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

%% LASSO model without Spike
fprintf("\nLASSO model without Spike\n")

% This function searches for the lambda value which results in the highest
% R2adjusted value and lowest MSE value.
%lambda_fixed = 0.01;
lambda_fixed = Group44Exe6Fun1(X, Y)

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

%% Comments on results, Conclusions
% 1) With the exclusion of the Spike variable, the results change greatly. 
% For all three models, the value of R2adj is increased significantly. 
% However, the value of MSE is increased too. 
% 2) The Stepwise model provides the best fit to the EDduration data,
% having the higher R2adj value and the lower MSE value.
% 3) In the case of the Full model and the Lasso model, the R2adj value is 
% 6 times greater without Spike compared to the value with Spike, while the 
% MSE value is doubled. The R2adj in the Stepwise model is more than 10 
% times greater without Spike while its MSE value does not increase that
% significantly. With these comparisons in mind, it is decided that the  
% exclusion Spike varibale results in a better, overall, fit for all 3
% models. Thus, for the next two exercises, the Spike variable is not
% included.
