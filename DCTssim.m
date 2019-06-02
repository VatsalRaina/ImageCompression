%function SSIM = DCTssim(X, N, step)
% Get the SSIM of an image compressed using DWT and the given step size
%Y = DCTN(X,N,false,step);
%Z = DCTN(Y,N,true);
%SSIM = ssim(Z,X);
%return

function SSIM = DCTssim(X, N, M, step)
% Get the SSIM of an image compressed using DCT and the given step size
[vlc, bits, huffval] = jpegenc(X, step, N, M, true);
Z = jpegdec(vlc, step, N, M, bits, huffval);
SSIM = ssim(Z,X);
return