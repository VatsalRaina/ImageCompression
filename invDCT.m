function Z = invDCT(Y,C,LBT,s)
% Apply inverse DCT - LBT is boolean
Z = colxfm(colxfm(Y',C')',C');
if nargin < 3, LBT = false; end
if LBT
    if nargin < 4, Z = LBTpostfilter(Z,size(C,1));
    else Z = LBTpostfilter(Z,size(C,1),s); end
end
return