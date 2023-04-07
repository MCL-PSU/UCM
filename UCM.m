classdef UCM
    %UCM: a class used to perform the UCM analysis in Matlab.
    % reference Scholz and Schoner 1999 for the original formulation of the
    % analysis.
    % The below is equivalent to the original formulation but is expressed
    % in the simple (yet powerful) language of covariance matrices and
    % orthonormal bases.

    % For the record: I do not like Matlab. Using this code will simplify
    % analyses but will not teach you why the analysis works, nor how to
    % troubleshoot it. I highly recommend coding something similar in a
    % language of your choice to not only famaliarize yourself with OOP but
    % to test your understanding of the mechanics of the methods below.
    %
    % - Joe Ricotta
    
    properties
        % listing object properties that can be extracted as needed during
        % analysis
        elements
        jacobian
        cov_el
        cov_s
        dim_ucm
        dim_ort
        ucm_basis
        ort_basis
        S
        vucm
        vort
        dv
        dvz
    end
    
    methods
        function obj = UCM(elements, jacobian)
            %Construct an instance of UCM object.

            % checking shape of element matrix
            [nrows_el, ncols_el] = size(elements);
            assert(nrows_el>=ncols_el, "Matrix of elements must not be wide (rows must be >= cols)")

            % checking shape of jacobian matrix and throwing
            % errors/warnings if strange.            
            [nrows_jac, ncols_jac] = size(jacobian);
            assert(ncols_jac>= nrows_jac, "Jacobian matrix must not be long (cols must be >= rows)")
            if nrows_jac == ncols_jac
                warning("You are using a square Jacobian matrix, which only has a nullspace if it has det 0. Are you sure this is correct?");
            end

            % checking compatability of elements and jacobian
            if ncols_jac ~= ncols_el
                error("The number of columns in the element matrix must equal the number of columns in the jacobian matrix.");
            end

            % taking inputs and determining covariance matrix of elements
            cov_el = cov(elements);
            ucm_basis = null(jacobian);
            ort_basis = normalize(jacobian', 'norm', 2);

            % assigning dimensionality of the spaces
            ucm_size = size(ucm_basis);
            ort_size = size(ort_basis);
            dim_ucm = ucm_size(2);
            dim_ort = ort_size(2);

            % creating orthonormal basis spanning the space of elements
            S = [ort_basis ucm_basis];

            % projecting data covariance onto orthonormal basis S
            cov_s = S' * cov_el * S; % = cov(elements * S)

            % extracting variances
            variances = diag(cov_s);
            vort_tot = sum(variances(1:dim_ort));
            vucm_tot = sum(variances((dim_ort+1):(dim_ucm+dim_ort)));

            % assigning variances to object and normalizing by dimension
            vucm_norm = vucm_tot / dim_ucm;
            vort_norm = vort_tot / dim_ort;

            % solving for and storing synergy index values
            synergy_index = vucm_norm - vort_norm / (vucm_norm + vort_norm);

            % assigning attributes to object
            obj.elements = elements;
            obj.jacobian = jacobian;
            obj.cov_el = cov_el;
            obj.ucm_basis = ucm_basis;
            obj.ort_basis = ort_basis;
            obj.cov_s = cov_s;
            obj.S = S;
            obj.vucm = vucm_norm;
            obj.vort = vort_norm;
            obj.dim_ucm = dim_ucm;
            obj.dim_ort = dim_ort;
            obj.dv = synergy_index;
            obj.dvz = atanh(synergy_index);
        end
    end
end

