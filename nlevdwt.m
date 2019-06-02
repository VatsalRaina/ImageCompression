function Y = nlevdwt(X,N,h1,h2)
% Build an N-level binary wavelet tree from X
m = size(X,1);
if N < 1, N = 1; end % N must be a positive integer
if nargin < 3, h1 = [-1 2 6 2 -1]/8; h2 = [-1 2 -1]/4; end % use default filters

Y = dwt(X,h1,h2);
if N > 1
    for i = 1:N-1
        m = m/2;
        t = 1:m;
        Y(t,t) = dwt(Y(t,t),h1,h2);
    end
end

return