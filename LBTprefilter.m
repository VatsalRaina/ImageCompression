function Xp = LBTprefilter(X,N,s)
% Apply LBT forward transform to image
% Generate forward matrix
if nargin < 3, [Pf, ~] = pot_ii(N);
else [Pf, ~] = pot_ii(N,s); end

I = size(X,2);

t = [(1+N/2):(I-N/2)]; % N is the DCT size, I is the image size 
Xp = X; % copy the non-transformed edges directly from X 
Xp(t,:) = colxfm(Xp(t,:), Pf);
Xp(:,t) = colxfm(Xp(:,t)', Pf)';
return