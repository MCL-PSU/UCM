function bins = array_split(array, n_bins)
    % splits array by row into n_bins bins. based on numpy.array_split() in Python.
    %
    % example:
    %
    % x = [1 4 3 5 4; 3 5 6 4 3]';
    % bins = array_split(x, 3);
    % display(bins)
    %

    % running checks on matrix shape and argument compatability
    [n_rows, n_cols] = size(array);
    shape_check = n_rows > n_cols;
    assert(shape_check, "Your matrix is wide, not long. Transpose prior to using array_split().")

    % checking the n_bins request doesn't exceed n_rows.
    split_check = n_rows > n_bins;
    assert(split_check, "Number of rows in array must be greater than n_bins. Is your matrix long?")

    % determining number of elements per bin
    n_each_bin = floor(n_rows/n_bins);
    n_extras = rem(n_rows, n_bins);

    % getting lengths of each slice
    bin_lengths = cat(1, 0, repmat(n_each_bin+1,n_extras,1), repmat(n_each_bin,n_bins-n_extras,1));

    % getting indices from each length
    bin_inds = cumsum(bin_lengths) + 1;

    % initializing cell of proper size for output
    bins = cell(n_bins,1);

    % chopping up array into bins
    for i=1:(length(bin_inds)-1)
        st = bin_inds(i);
        en = bin_inds(i+1)-1;
        bins{i} = array(st:en,:);
    end

end