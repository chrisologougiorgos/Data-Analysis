%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%% Data import
clc, clearvars, close all;
% Reading of the table
filename = 'TMS.xlsx';
data = readtable(filename, 'ReadVariableNames', true);

%% Analysis without TMS
Y = data.EDduration(data.TMS == 0);
X = data.Setup(data.TMS == 0);
fprintf("Model without TMS\n")
Group44Exe5Fun1(X, Y, 1, 'without TMS');


%% Analysis with TMS
Y = data.EDduration(data.TMS == 1);
X = data.Setup(data.TMS == 1);
fprintf("\n\nModel with TMS \n")
Group44Exe5Fun1(X, Y, 4, 'with TMS');

%% Comments on results, Conclusions
% 1)The results of the two analyses do not seem to differ greatly. The
% estimated values for R2 and R2_adj are close to zero for both analyses.

% 2)The model of linear regression for the analysis with TMS is better.
% This conclusion results from the higher value of both R2 and R2_adj,
% meaning that the linear model explains a slightly larger proportion of 
% the variability in EDduration compared to the model without TMS. 
% Additionally, the residuals of the model with TMS exhibit a slightly more 
% uniform dispersion around zero. However, the R2 values are still very low 
% , indicating that the linear regression model is not a strong fit for the
% data in either case.

% 3)In the diagnostic scatter plots of both models, there are outliers,
% which further indicate that the models do not fit the data well enough.

% 4)The diagonistic scatter plots of the residuals for both analyses do not 
% show a potential pattern of curvature. This suggests that polynomial 
% regression will not capture the relationship of EDduration and Setup 
% variables more successfully, compared to linear regression.