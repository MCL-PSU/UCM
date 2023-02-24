% example demonstrating the use of the Uncontrolled manifold analysis with the UCM class.

% simulate elemental data of three elements with 30 observations
elements = rand(30,3);

% imagine the jacobian matrix here is [1 1 1].
% often, it is not-- such as when it is estimated using regression
% coefficients-- but a simple additive linear system will result in this
% canonical jacobian matrix linking elements to performance.
jacobian = [1 1 1];

% the entire UCM analysis can be run with this single line of code
ucm = UCM(elements, jacobian);

% look at the properties of the ucm object to access for computation
display(ucm);

% Should result in something like this:
% ucm = 
% 
%   UCM with properties:
%
%      elements: [30×3 double]
%      jacobian: [1 1 1]
%        cov_el: [3×3 double]
%         cov_s: [3×3 double]
%       dim_ucm: 2
%       dim_ort: 1
%     ucm_basis: [3×2 double]
%     ort_basis: [3×1 double]
%             S: [3×3 double]
%          vucm: 0.0343
%          vort: 0.0980
%            dv: -0.7064
%           dvz: -0.8800


% access the properties of the object as follows:
vucm = ucm.vucm;
vort = ucm.vort;
dv = ucm.dv;
dvz = ucm.dvz;


% print to display values
display("Vucm = " + ucm.vucm)
display("Vort = " + ucm.vort)
display("Vort = " + ucm.dv)
display("Vort = " + ucm.dvz)