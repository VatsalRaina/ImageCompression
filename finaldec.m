function Z = finaldec(vlc, bits, huffval, param)

    DWT_ID = 1;
    LBT_ID=2;
    DCT_ID=3;

    scheme = param(1);
    qstep = param(4);
    
    if scheme == DWT_ID
        n = param(2);
        Z = jpeg2000dec(vlc, qstep, n, bits, huffval);
    elseif scheme == LBT_ID
        N = param(2);
        M=param(3);
        Z= jpegxrdec(vlc, qstep, N, M, bits, huffval);
    elseif scheme == DCT_ID
        N = param(2);
        M=param(3);
        Z= jpegdec(vlc, qstep, N, M, bits, huffval);
    else
        disp("Something went wrong");
    end

    disp(strcat("Bits required for vlc: ",num2str(vlctest(vlc))));
    disp(vlctest(vlc));
    disp("Bits required for overheads: 1429");
    totBits = vlctest(vlc) + 1429;
    disp(strcat("Total number of bits: ", num2str(totBits)));
    
    if scheme == LBT_ID || scheme == DCT_ID
        Z = Z+128;
    end
    
    
    
    draw(Z);
    
    max1 = max(Z(:));
    min1 = min(Z(:));
    disp(max1);
    disp(min1);
    Z = arrayfun(@clip,Z);
    Z = uint8(Z);
    
    
    max1 = max(Z(:));
    min1 = min(Z(:));
    disp(max1);
    disp(min1);
return