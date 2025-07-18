% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 2, Fun.1

% Function for the Goodness-Fit test
function [chi2_initial, chi2_resampling] = Group44Exe2Fun1(sample, lambda)
    n = 1000; % number of random samples
    bins = 15;
    [counts, edges] = histcounts(sample, bins);
    
    % Initial sample
    observed = counts;
    expected = diff(expcdf(edges, 1/lambda)) * numel(sample); 
    chi2_initial = sum((observed - expected).^2 ./ expected);

    % Resampling
    chi2_resampling = zeros(n, 1);
    for i = 1:n
        resampling = exprnd(1/lambda, size(sample));
        [rsmpl_counts, ~] = histcounts(resampling, edges);
        chi2_resampling(i) = sum((rsmpl_counts - expected).^2 ./ expected);
    end
end