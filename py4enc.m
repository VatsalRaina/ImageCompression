% Generate a 4-layer pyramid, so that X is split into four highpass images
% Y0, Y1, Y2, Y3, each a quarter size of its predecessor, plus a tiny
% lowpass image X4, which is a quarter size of Y3.

X1 = rowdec(rowdec(X,h)',h)';
Y0 = X - rowint(rowint(X1,2*h)',2*h)';

X2 = rowdec(rowdec(X1,h)',h)';
Y1 = X1 - rowint(rowint(X2,2*h)',2*h)';

X3 = rowdec(rowdec(X2,h)',h)';
Y2 = X2 - rowint(rowint(X3,2*h)',2*h)';

X4 = rowdec(rowdec(X3,h)',h)';
Y3 = X3 - rowint(rowint(X4,2*h)',2*h)';

% Note, we only need to transmit X4, Y0, Y1, Y2, Y3 over a channel which
% are sufficient to reconstruct X and require fewer bits to transmit then X
% itself

draw(beside(Y0,beside(Y1,beside(Y2,beside(Y3,X4)))));