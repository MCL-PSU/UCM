% example of regression
y = rand(30,1);
X = rand(30,2);

% complete regression
reg = ols(y,X);

% observe properties
display(reg)

% r-squared
display(reg.r2)

% beta coefficients, i.e. the Jacobian
display(reg.betas)