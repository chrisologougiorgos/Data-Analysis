% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 2, Prog.1
clc; clearvars;


%%%%%%%%%  Compare Resampling with Parametric X^2 for Exponential %%%%%%%%%
%%%%%%%%%  distribution (Coil EIGHT and ROUND)                    %%%%%%%%%


% Load the data from 'TMS.xlsx'
data = readtable('TMS.xlsx');

% Access the second column (EDduration)
ed_duration = data.EDduration;

% Choose data of EDduration with Coil EIGHT(1) and ROUND(0)
ed_tms_eight = ed_duration(strcmp(data.CoilCode, '1'));
ed_tms_round = ed_duration(strcmp(data.CoilCode, '0'));

% Parameter λ of the Exponential distribution for each sample
lambda_eight = 1/mean(ed_tms_eight);
lambda_round = 1/mean(ed_tms_round);

% Goodness-Fit test with data of EDduration with Coil EIGHT and ROUND
[chi2_eight, chi2_rsmpl_eight] = Group44Exe2Fun1(ed_tms_eight, lambda_eight);
[chi2_round, chi2_rsmpl_round] = Group44Exe2Fun1(ed_tms_round, lambda_round);

% Descisions of Goodness-Fit test
p_value_eight = mean(chi2_rsmpl_eight >= chi2_eight);
p_value_round = mean(chi2_rsmpl_round >= chi2_round);

% Show results
disp('Coil Eight');
disp(['X^2 of the initial sample: ', num2str(chi2_eight)]);
disp(['Resampling p-value: ', num2str(p_value_eight)]);
[~, p_param_eight] = chi2gof(ed_tms_eight, 'CDF', @(x) expcdf(x, 1/lambda_eight));
disp(['Parametric p-value: ', num2str(p_param_eight)]);

fprintf('\n')

disp('Coil Round');
disp(['X^2 of the initial sample: ', num2str(chi2_round)]);
disp(['Resampling p-value: ', num2str(p_value_round)]);
[~, p_param_round] = chi2gof(ed_tms_round, 'CDF', @(x) expcdf(x, 1/lambda_round));
disp(['Parametric p-value: ', num2str(p_param_round)]);



                    %%%%%%%%%% COMMENTS %%%%%%%%%%

% -The RESAMPLING test shows that the data DON'T fit the Exponential 
%  distribution well, because x^2 of the initial sample is in the right 
%  tail and the null hypothesis is rejected (p-value < 0.05).
%
% -The PARAMETRIC test, indicates that the x^2 of the initial sample is 
%  not in the right tail, so we fail to reject the null hypothesis 
%  (p-value > 0.05) and we accept that the data fit the Exponential dist.
%
% *both tested multiple times