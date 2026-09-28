function stats = imageStats(img)
% IMAGESTATS  Max, Min, Mean, Std and Entropy of every channel, from its histogram.
%   stats has one row per channel (1 for grayscale, 3 for RGB) and the
%   columns Max, Min, Mean, Std, Entropy, matching the GUI's stats table.

levels = 0:255;
stats = zeros(size(img, 3), 5);

for k = 1:size(img, 3)
    p = Histogram.pdf(img(:, :, k));
    present = levels(p > 0);

    mu = sum(levels .* p);
    sigma = sqrt(sum((levels - mu) .^ 2 .* p));
    entropy = -sum(p(p > 0) .* log2(p(p > 0)));   % in bits, 0..8

    stats(k, :) = [max(present), min(present), mu, sigma, entropy];
end
end
