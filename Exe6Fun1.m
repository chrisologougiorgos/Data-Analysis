%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%This function searches for the lambda value which leads to the model with
%the highest R2adj value and the lowest MSE value.

function bestLambda = Group44Exe6Fun1(X, Y)
    % Lambda values that are to be checked
    log_lambda_values = linspace(-2, 2, 50); % 50 values from -2 to 2 in logarithmic form
    lambda_values = 10.^log_lambda_values; % conversion to powers of 10
    
    % Table of results for each lambda value
    results = table('Size', [length(lambda_values), 4], ...
                    'VariableTypes', {'double', 'double', 'double', 'double'}, ...
                    'VariableNames', {'Lambda', 'AdjustedR2', 'MSE', 'Score'});
    
    % Testing for all lambda values
    for i = 1:length(lambda_values)
        lambda = lambda_values(i);
        
        [B, FitInfo] = lasso(X, Y, 'Lambda', lambda);
        
        bestBeta = B; 
        intercept = FitInfo.Intercept;
        Y_estimated = intercept + X * bestBeta;
        
        SS_res = sum((Y - Y_estimated).^2);
        SS_tot = sum((Y - mean(Y)).^2);
        R2 = 1 - (SS_res / SS_tot);
        
        n = length(Y);
        m = sum(bestBeta ~= 0);
        if m == 0
            R2_adj = NaN;
        else
            R2_adj = 1 - (1 - R2) * ((n - 1) / (n - m - 1));
        end
        
        MSE = mean((Y - Y_estimated).^2);
        
       % Calculation of score in order to find the lambda value which leads
       % to the higher R2_adj value and the lower MSE 
        if isnan(R2_adj)
            score = NaN; 
        else
            score = -R2_adj + log(MSE); 
        end
        
        results.Lambda(i) = lambda;
        results.AdjustedR2(i) = R2_adj;
        results.MSE(i) = MSE;
        results.Score(i) = score;
    end
    
    %disp(results);
    
    % Choice of the lambda value with the lowest score
    [~, bestIdx] = min(results.Score); 
    bestLambda = results.Lambda(bestIdx);
end

    