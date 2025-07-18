%Georgios Chrisologou 10782
%Georgios Tsantikis 10722

%This function creates the regression model based on the data, calculates 
%the R2 and R2adj values and creates a scatter plot of EDduration in
%respect to Setup, a scatter plot of the predicted values of EDduration in
%respect to Setup (from the regression model) and the diagnostic scatter
%plot of standarized residuals.

function Group44Exe5Fun1(X, Y, figOffset, titleSuffix)
    covMatrix = cov(X, Y);
    varX = covMatrix(1, 1);
    covXY = covMatrix(1, 2);

    b1 = covXY / varX;
    b0 = mean(Y) - b1 * mean(X);
    Y_estimated = b0 + b1 * X;
    fprintf("Model of linear regression: y = %f + %f * x\n", b0, b1)

    figure(figOffset);
    scatter(X, Y, 'blue');
    title(['Scatter plot of EDduration, Setup ', titleSuffix]);

    figure(figOffset + 1);
    scatter(X, Y_estimated, 'red');
    title(['Scatter plot of predicted EDduration, Setup ', titleSuffix]);

    SS_res = sum((Y - Y_estimated).^2);
    SS_tot = sum((Y - mean(Y)).^2);
    R2 = 1 - SS_res / SS_tot;

    n = length(Y);
    m = 1;
    R2_adj = 1 - (1 - R2) * ((n - 1) / (n - m - 1));

    e = Y - Y_estimated;
    se2 = sum(e.^2) / (n - 2);
    standarized_e = e / sqrt(se2);

    figure(figOffset + 2);
    scatter(Y_estimated, standarized_e);
    xlabel('Predictions');
    ylabel('Standardized errors');
    title(['Diagnostic scatter plot ', titleSuffix]);
    yline(0, '--', 'Color', 'r');

    disp(['R2: ', num2str(R2)]);
    disp(['R2_adj: ', num2str(R2_adj)]);
end
