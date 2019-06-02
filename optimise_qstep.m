function qstep = optimise_qstep(X,N,M,opthuff, precision, min_step, LBT)

% Optimise q step such that total number of bits is less than MAX
if nargin < 7, LBT = false; end

MAX = 40960;
totBits = 2*MAX;
qstep = min_step;

while totBits > MAX
    qstep = qstep + precision;
    if LBT
        [vlc, bits, huffval] = jpegxrenc(X, qstep, N, M, opthuff);
    else
        [vlc, bits, huffval] = jpegenc(X, qstep, N, M, opthuff);
    end
    totBits = sum(vlc(:,2));
    if opthuff
        totBits = totBits + 1429;
    end
end