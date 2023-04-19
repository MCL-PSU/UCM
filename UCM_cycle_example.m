% analysis across multiple cycles
% first, simulate a time series of 6 elements, add noise,
% and use a fake Jacobian matrix to compute the UCM analysis.

close all

% setting parameters
n_elements = 5; % number of simulated elements
Fs = 100; % sampling frequency
t = 10; % time in s
Fd = 20; %downsample frequency

assert(n_elements<Fd, "Number of elements must be less than new sample frequency")
assert(n_elements<(t-1), "Number of elements must be less than t - 1")

% generating fake data
x = 1:(t*Fs); % generate time series of cycles at 1 Hz given time and sample freq
element = -cos((x*2*pi)/Fs); % generating basic element
elements = repmat([element]', 1, n_elements);

% add noise to the elements
for i=1:200
    rands = zeros(size(elements));
    for j=1:n_elements
        rands(:,j) = (.01*(cos((x/1000)*128*pi*rand(1))));
    end
    elements = elements + rands;
end
elements = elements + (5*repmat(rand(1,n_elements),Fs*t,1));

% chopping cycles
el_sum = sum(elements,2); % summing elements to find peaks
max_inds = [zeros(t,1)]; % initializing container
for i=1:t
    st = ((i-1)*Fs)+1; % getting starting index
    en = (i*Fs); % getting final index
    [~, ind] = max(el_sum(st:en,:)); % getting index of maximum
    max_inds(i) = st + ind; % storing index of maximum
end

% plotting simulated data, segmenting and  
figure
hold on
subplot(2,1,1)
to_plot = {elements, el_sum};
for i=1:2
    subplot(2,1,i)
    plot(x/Fs, to_plot{i})
    hold on
    xlabel("Time (s)")
    ylabel("Force (N)")
    for val=max_inds
        xline(val/Fs)
    end
end
hold off

% getting regression cotefficients  (i.e. Jacobian)
% note that I am using the whole time series for regression
jacobian = pinv(diff(elements - mean(elements))) * (diff(el_sum - mean(el_sum)));

% now chopping up cycles and stacking them
cycs = zeros(Fd,t-1,n_elements);
for i=2:length(max_inds)
    st = max_inds(i-1);
    en = max_inds(i);
    segs = array_split(elements(st:en,:), Fd);
    for j=1:Fd
        cycs(j,i-1,:) = mean(segs{j});
    end
end

% taking stacked cycles and running synergy index
ucm_results = cell(Fd,1);
for i=1:Fd
    phase = reshape(cycs(i,:,:), t-1, n_elements);
    ucm = UCM(phase, jacobian');
    vucm(i) = ucm.vucm;
    vort(i) = ucm.vort;
    dv(i) = ucm.dv;
end

% plotting results
figure
title("Vucm, Vort, dVz")
subplot(2,1,1)
plot(vucm)
hold on
plot(vort)
legend("Vucm", "Vort")
hold off
xlabel("Phase")
ylabel("Variance")
subplot(2,1,2)
hold on
ylim([-1 1])
plot(dv)
xlabel("Phase")
ylabel("dV")
hold off






