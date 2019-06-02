%function SSIM = DWTssim(X, N, step)
% Get the SSIM of an image compressed using DWT and the given step size
%Y = DWTN(X,N,false,step,false);
%Z = DWTN(Y,N,true);
%SSIM = ssim(Z,X);
%return


function SSIM = DCTssim(X, n, step)
% Get the SSIM of an image compressed using DCT and the given step size
[vlc, bits, huffval] = jpeg2000enc(X, step, n, true);
Z = jpeg2000dec(vlc, step, n, bits, huffval);
SSIM = ssim(Z,X);
return