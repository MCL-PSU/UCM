classdef ols
    %OLS: Ordinary least squares regression
    %   completes simple ordinary least squares regression for a response
    %   variable y and an input variable X
    % note: no intercept term is used in this function.
    % y_hat: predicted y
    % betas: regression coefficients
    % r2: the variance accounted for by the predictions
    
    properties
        y
        X
        r2
        y_hat
        betas
        sse
        sst
    end
    
    methods
        function obj = ols(y,X)
            y_ = y - mean(y);
            X_ = X - mean(X);
            betas = pinv(X_)* y_;
            y_hat = X_ * betas;

            % calculating regression fit
            sse = sum((y_ - y_hat).^2);
            sst = sum(y_.^2);
            r2 = 1 - (sse/sst);

            % assigning attributes
            obj.y = y_;
            obj.X = X_;
            obj.y_hat = y_hat;
            obj.betas = betas;
            obj.sse = sse;
            obj.sst = sst;
            obj.r2 = r2;
        end
    end
end

