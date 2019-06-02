function [vlc, bits, huffval, param] = finalenc(X)
    DWT_ID = 1;
    LBT_ID=2;
    DCT_ID=3;
    param = superscheme(X);
    scheme = param(1);
    step = param(4);
    if scheme == DWT_ID
        n = param(2);
        [vlc, bits, huffval] = jpeg2000enc(X, step, n, true);
    elseif scheme == LBT_ID
        N = param(2);
        M=param(3);
        [vlc, bits, huffval] = jpegxrenc(X-128, step, N, M, true);
    elseif scheme == DCT_ID
        N = param(2);
        M=param(3);
        [vlc, bits, huffval] = jpegenc(X-128, step, N, M, true);
    else
        disp("Something went wrong");
    end
    
return