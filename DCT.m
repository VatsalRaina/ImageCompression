function Y = DCT(X,C,LBT,s)
% Apply forward DCT - LBT is boolean
if nargin < 3, LBT = false; end
if LBT
    if nargin < 4, X = LBTprefilter(X,size(C,1));
    else X = LBTprefilter(X,size(C,1),s); end
end
Y = colxfm(colxfm(X,C)',C)';
return
