% Georgios Chrisologou - 10782
% Georgios Tsantikis - 10722
%
% DATA ANALYSIS WORK
% Exercise 3, Fun.1

% Check if mu0 is within the Confidence Interval
function results = Group44Exe3Fun1(ed_duration, data, tms, mu)
    results = table((1:6)', zeros(6, 1), zeros(6, 1), zeros(6, 1), strings(6, 1), ...
        'VariableNames', {'State', 'Mean', 'Lower_ci', 'Upper_ci', 'Accept'});

    for state = 1:6
        sample = ed_duration(data.TMS == tms & data.Setup == state);

        [h_normal, p_normal] = chi2gof(sample, 'EMin', 0);
        fprintf('State %d, Normal: h = %.1f and p = %.6f\n', state, h_normal, p_normal);
    
        % Parametric or bootstrap confidence interval
        if h_normal == 0 % Normal distribution
            [~, ~, ci] = ttest(sample, mu);
            ci_lower = ci(1);
            ci_upper = ci(2);
        else % Bootstrap CI
            ci_boot = bootci(1000, @mean, sample);
            ci_lower = ci_boot(1);
            ci_upper = ci_boot(2);
        end
            
        % Check if the mu0 belongs at the CI, in order to accept mu=mu0
        if mu > ci_lower && mu < ci_upper
            accept = true;
        else
            accept = false;
        end

        % Store results
        results{state, 'Mean'} = mean(sample);
        results{state, 'Lower_ci'} = ci_lower;
        results{state, 'Upper_ci'} = ci_upper;
        results{state, 'Accept'} = string(accept);
    end
end