%function SSIM = LBTssim(X, N, step)
% Get the SSIM of an image compressed using DWT and the given step size
%s = sqrt(2);
%Y = LBTN(X,N,false,s,step);
%Z = LBTN(Y,N,true,s);
%SSIM = ssim(Z,X);
%return

function SSIM = LBTssim(X, N, M, step)
[vlc, bits, huffval] = jpegxrenc(X, step, N, M, true);
Z = jpegxrdec(vlc, step, N, M, bits, huffval);
SSIM = ssim(Z,X);
return