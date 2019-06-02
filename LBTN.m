function Y = LBTN(X,N,inverse,s,step)
% Function for performing the LBT (with DCT) or its inverse
%
%   @param:
%

% Specify default arguments
if nargin < 5, step = 17; end
if nargin < 4, s = 1.414; end
if nargin < 3, inverse = false; end

C = dct_ii(N);

if inverse
    % Apply inverse transform
    Y = invDCT(X,C,true,s);
else
    % Apply forward transform and quantise
    Y = DCT(X,C,true,s);
    Y = quantise(Y,step);
end

return