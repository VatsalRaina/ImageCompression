function [X_low, X_high] = z_high_vs_lowpass(N,X);

% Generate high and low pass versions of the image X for different
% lengths N of the odd-length half-cosine filters

h_n = halfcos(N);
X_low = conv2se(h_n,h_n,X);
X_high = X-X_low;

return
