% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 3, Prog.1
clc; clearvars;


%%%%%%%%%  Check if we can accept that the mean value of ED duration
%%%%%%%%%  for all of the 6 states with and without TMS is mu0.


% Load the data from 'TMS.xlsx'
data = readtable('TMS.xlsx');

% Access the second column (EDduration) due to TMS
ed_duration = data.EDduration;

% Choose data of EDduration without TMS(0) and calculate the mean value
ed_without_tms = ed_duration(data.TMS == 0);
mu0_no_tms = mean(ed_without_tms);

% Choose data of EDduration with TMS(1) and calculate the mean value
ed_with_tms = ed_duration(data.TMS == 1);
mu0_tms = mean(ed_with_tms);

% Initialize table to store the results
total_results = table((1:6)', zeros(6, 1), zeros(6, 1), zeros(6, 1), strings(6, 1), ...
    zeros(6, 1), zeros(6, 1), zeros(6, 1), strings(6, 1), ...
    'VariableNames', {'State', 'Mean.', 'LowerCI_NoTMS', 'UpperCI_NoTMS', 'mu0_within_CI.',...
    'Mean', 'LowerCI_WithTMS', 'UpperCI_WithTMS', 'mu0_within_CI'});

% Results for the goodness-fit test X^2 and the acceptance of mu0
fprintf('Goodness-fit test X^2 for EDduration without TMS:\n');
results_no_tms = Group44Exe3Fun1(ed_duration, data, 0, mu0_no_tms);
fprintf('\nmu0 of EDduration without TMS : %f\n', mu0_no_tms);

fprintf('\nGoodness-fit test X^2 for EDduration with TMS:\n');
results_with_tms = Group44Exe3Fun1(ed_duration, data, 1, mu0_tms);
fprintf('\nmu0 of EDduration with TMS : %f', mu0_tms);

% Gather up the results at the table
total_results(:, {'Mean.', 'LowerCI_NoTMS', 'UpperCI_NoTMS','mu0_within_CI.'}) = results_no_tms(:, {'Mean', 'Lower_ci', 'Upper_ci', 'Accept'});
total_results(:, {'Mean', 'LowerCI_WithTMS', 'UpperCI_WithTMS', 'mu0_within_CI'}) = results_with_tms(:, {'Mean', 'Lower_ci', 'Upper_ci', 'Accept'});

% Show results
fprintf('\n\nResults of the 6 states(with and without TMS):\n');
disp(total_results);



                    %%%%%%%%%% COMMENTS %%%%%%%%%%

% === WITHOUT TMS ===
% According to the results which determine whether Parametric (accept 
% Normal distribution) or Bootstrap (can't accept Normal) CI will be used:
% - STATES 1, 2 and 4 reject the null hypothesis (that the distribution is 
%   NORMAL, h = 1), because p < 0.05.
% - STATES 3, 5 and 6 FAIL to reject the null hypothesis (that the distribution is 
%   Normal, h = 0), because p > 0.05.
% - mu0 belongs at the CI for STATES 1, 2 and 6 (Don't reject H0:mean=mu)
% - mu0 doesn't belong at the CI for STATES 3, 4 and 5

% === WITH TMS ===
% According to the results:
% - STATES 2 and 4 reject the null hypothesis (NORMAL, h = 1).
% - STATES 1, 3, 5 and 6 FAIL to reject the null hypothesis (h = 0).
% - mu0 belongs at the CI for STATES 1, 3 and 5 
% - mu0 doesn't belong at the CI for STATES 2, 4 and 6


% ----- COMPARE the RESULTS WITH and WITHOUT TMS -----
% - STATES 1 and 4 AGREE (both accept that mu0 is within the CI)
% - STATES 2, 3, 5 and 6 DISAGREE (both reject that mu0 is within the CI)
% 
% The use of TMS looks to affects the mean value of ED duration:
%  - At STATES 1 and 4 it is slightly decreased, which explains the 
%    agreement of the results.
%  - At STATES 2, 3 and 6 is considerably decreased and in 5 is 
%    increased, which explains the difference in the results.
