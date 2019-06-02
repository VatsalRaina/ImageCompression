function Zp = LBTpostfilter(Z,N,s)
% Apply LBT backward transform to image
% Generate backward matrix
if nargin < 3, [~, Pr] = pot_ii(N);
else [~, Pr] = pot_ii(N,s); end

I = size(Z,2);

t = [(1+N/2):(I-N/2)]; % N is the DCT size, I is the image size 
Zp = Z; % copy the non-transformed edges directly from Z 
Zp(:,t) = colxfm(Zp(:,t)', Pr')';
Zp(t,:) = colxfm(Zp(t,:), Pr');
return