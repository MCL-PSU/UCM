% fake data
X = rand(200,10);

% remove mean
X = X - mean(X);

% PCA to obtain modes
[V, D] = eig(cov(X));

% V: eigenvectors (PCs)
% D: eigenvalues (variance per PC)
factors = V * sqrt(D);

% varimax rotating factors
rot_facts = rotatefactors(factors(:,1:2), "Method", "varimax");

% obtaining MU-mode magnitudes
mode_mags = X * rot_facts;

