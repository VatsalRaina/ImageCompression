function Y = DWTN(X,N,inverse,step,MSE,filters)
% Function for performing the DWT or its inverse
%
%   @param: X = 
% 

% Specify default parameters
if nargin < 6
    % Use LeGall filters
    h1 = [-1 2 6 2 -1]/8; 
    h2 = [-1 2 -1]/4;
    g1 = [1 2 1]/2; 
    g2 = [-1 -2 6 -2 -1]/4;
else
    % Use custom filters
    h1 = filters(1);
    h2 = filters(2);
    g1 = filters(3);
    g2 = filters(4);
end
if nargin < 5, MSE = true; end
if nargin < 4, step = 17; end
if nargin < 3, inverse = false; end

if inverse
    % Apply inverse transform
    Y = nlevidwt(X,N,g1,g2);
else
    % Apply forward transform and quantise with chosen scheme
    Y = nlevdwt(X,N,h1,h2);
    [Y, ~] = quantdwt(Y,N,step,MSE);
end

return