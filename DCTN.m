function Y = DCTN(X,N,inverse,step)
% Function for performing the DCT or its inverse
if nargin < 4, step = 17; end
if nargin < 3, inverse = false; end

C = dct_ii(N);

if inverse
    % Apply inverse transform
    Y = invDCT(X,C);
else
    % Apply forward transform and quantise
    Y = DCT(X,C);
    Y = quantise(Y,step);
end

return