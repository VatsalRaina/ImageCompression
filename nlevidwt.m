function Z = nlevidwt(Y,N,g1,g2)
% Reconstruct image from an N-level binary wavelet tree
if N < 1,return; end
if nargin < 3, g1 = [1 2 1]/2; g2 = [-1 -2 6 -2 -1]/4; end % use default filters

m = size(Y,1)/2^N;
for i = 1:N
    m = m*2;
    t = 1:m;
    Y(t,t) = idwt(Y(t,t),g1,g2);
end
Z = Y;
return