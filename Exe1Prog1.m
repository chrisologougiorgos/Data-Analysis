% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 1, Prog.1
clc; clearvars;


%%%%%%%%%  1) Find the best fitted Probability distribution  %%%%%%%%%

% Load the data from 'TMS.xlsx'
data = readtable('TMS.xlsx');

% Access the second column (EDduration) due to TMS
ed_duration = data.EDduration;

% Choose data of EDduration with TMS(1)
ed_with_tms = ed_duration(data.TMS == 1);

% Choose data of EDduration without TMS(0)
ed_without_tms = ed_duration(data.TMS == 0);


% Adjust distributions to the data WITH TMS
dist_normal1 = fitdist(ed_with_tms, 'Normal');
dist_exponential1 = fitdist(ed_with_tms, 'Exponential');

% Goodness-fit test with X^2 for each distribution
fprintf('EDduration with TMS\n')
[h_normal1, p_normal1] = chi2gof(ed_with_tms, 'CDF', dist_normal1);
fprintf('Normal: h = %.1f and p = %.6f\n', h_normal1, p_normal1);
[h_exponential1, p_exponential1] = chi2gof(ed_with_tms, 'CDF', dist_exponential1);
fprintf('Exponential: h = %.1f and p = %.4f\n', h_exponential1, p_exponential1);


% Adjust distributions to the data WITHOUT TMS
dist_normal2 = fitdist(ed_without_tms, 'Normal');
dist_exponential2 = fitdist(ed_without_tms, 'Exponential');

% Statistical check X^2 for each distribution
fprintf('\nEDduration without TMS\n')
[h_normal2, p_normal2] = chi2gof(ed_without_tms, 'CDF', dist_normal2);
fprintf('Normal: h = %.1f and p = %.7f\n', h_normal2, p_normal2);
[h_exponential2, p_exponential2] = chi2gof(ed_without_tms, 'CDF', dist_exponential2);
fprintf('Exponential: h = %.1f and p = %.5f\n', h_exponential2, p_exponential2);



%%%%%%%%%  2) Empirical and Fitted PDFs  %%%%%%%%%

% Variables to help us create the plots
bins = 15;
min_val_ed = min(ed_duration);
max_val_ed = max(ed_duration);
edges = linspace(min_val_ed, max_val_ed, bins + 1); % 
x_vals = linspace(min_val_ed, max_val_ed, 110); % data range

% Curves of the Exponential Distribution for both data sets
exp_curve_with_tms = pdf(dist_exponential1, x_vals); 
exp_curve_without_tms = pdf(dist_exponential2, x_vals);


% Plot empirical and fitted pdf for EDduration with TMS and without TMS
figure(1)
clf
histogram(ed_with_tms, 'Normalization', 'pdf', 'BinEdges', edges);
hold on;
histogram(ed_without_tms, 'Normalization', 'pdf', 'BinEdges', edges);
plot(x_vals, exp_curve_with_tms, 'r-', 'LineWidth', 2);
plot(x_vals, exp_curve_without_tms, 'b--', 'LineWidth', 2);

legend({'Empirical PDF (with TMS)', 'Empirical PDF (without TMS)', ...
        'Fitted PDF (with TMS)', 'Fitted PDF (without TMS)'});

title('Comparison of EDduration PDFs');
xlabel('EDduration (sec)');
ylabel('Probability Density');



                    %%%%%%%%%% COMENTS %%%%%%%%%%

% 1)
% - If h = 0, then we do NOT reject the null hypothesis, that the data 
%   follow the distribution we have chosen.
% - If h = 1, then we reject the null hypothesis
%
% The p-value is the degree of probability that the result of the 
% statistical test will be observed if the null hypothesis is acceptable 
% (that is, if the distribution we chose fits the data).
% - If for a distribution, the p-value is greater than 0.05, then that 
%   distribution appears to fit the data well.
% - If the p-value is less than 0.05 then the distribution does not fit 
%   the data well.
%
% After the results, the appropriate known (parametric) probability 
% distribution that best fits the data for ED duration (EDduration) with 
% TMS and without TMS, it semms to be the EXPONENTIAL.
               
% 2)
% After oserving the plot, the Exponential distribution seems to be 
% appropriate for the data of ED duration with and without TMS and also
% PDF seems to be the same.