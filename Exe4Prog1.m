% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 4, Prog.1
clc; clearvars;


%%%%%%%%%%  Ιnvestigate if there is correlation between preTMS  %%%%%%%%%%
%%%%%%%%%%  and post TMS


% Load the data from 'TMS.xlsx'
data = readtable('TMS.xlsx');

% Initialize table to store the results
results = table((1:6)', zeros(6,1), zeros(6,1), strings(6,1), ...
    'VariableNames', {'State', 'p_val_param', 'p_val_perm', 'Correlation_detected'});

L = 1000;  % Number of random samples for permutation test
alpha = 0.05;  % Significance level

for state = 1:6
    % Access the third (preTMS) and fourth (postTMS) column due to Setup
    preTMS = data.preTMS(data.TMS == 1 & data.Setup == state);
    postTMS = data.postTMS(data.TMS == 1 & data.Setup == state);
    n = length(preTMS); % Same number of samples with postTMS

    % 1. Parametric test using t-statistic (Student's t-distribution)
    numerator = sum((preTMS - mean(preTMS)) .* (postTMS - mean(postTMS)));
    denominator = sqrt(sum((preTMS - mean(preTMS)).^2) * sum((postTMS - mean(postTMS)).^2));
    r = numerator / denominator; % Correlation coefficient Pearson
    % Compute t-statistic for the observed data and two tailed (x2) p-value for t-test
    t0 = r * sqrt((n - 2) / (1 - r^2)); 
    p_param = 2 * (1 - tcdf(abs(t0), n - 2));
    % [r, p_param] = corr(preTMS, postTMS, 'Type', 'Pearson'); % Easier way with Student dist. built-in


    % 2. Permutation test
    t_perm = zeros(L, 1);  % Storage for permutation t-statistics
    for i = 1:L
        % Permute postTMS randomly
        postTMS_perm = postTMS(randperm(n));

        % Compute correlation and t-statistic for the permuted data
        r_perm = corr(preTMS, postTMS_perm, 'Type', 'Pearson');
        t_perm(i) = r_perm * sqrt((n - 2) / (1 - r_perm^2));
    end

    % Compute empirical p-value (|t_perm| >= |t0| / L)
    lower_limit = round((alpha/2)*L); % (a/2)
    upper_limit = round(L * ((1-alpha/2)*L)); % (1- a/2)
    p_perm = sum(abs(t_perm) >= abs(t0)) / L;

    % Correlation detected if p-value < alpha
    if p_param < alpha || p_perm < alpha
        detected = true;
    else
        detected = false;
    end

    % Store results
    results{state, {'p_val_param', 'p_val_perm', 'Correlation_detected'}} = ...
        [p_param, p_perm, string(detected)];
end

% Display results
fprintf('Results of the 6 states with correlation tests (parametric and permutation) for preTMS and postTMS:\n\n');
disp(results);



                    %%%%%%%%%% COMMENTS %%%%%%%%%%


% 1. No, there is NO state for which the correlation between preTMS and 
%    postTMS is statistically significant, as all p-values ​​are greater 
%    than a = 0.05
%
% 2. -Parametric test is based on the assumption that the data follows 
%     a Normal distribution. If this is true, it is more efficient.
%    -Permutation test doesn't require assumptions about the distribution 
%     of the data. It is more general and applies regardless of the 
%     distribution
%    -Since we are not sure if the data follow Normal distribution and 
%     because the population is quite small for most of the states,
%     Permutation test is more reliable.
