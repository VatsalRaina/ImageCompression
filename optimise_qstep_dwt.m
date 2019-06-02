function qstep = optimise_qstep_dwt(X,n,opthuff, precision, min_step)

% Optimise q step such that total number of bits is less than MAX
% Set the encoding function to be jpegenc, jpegxrenc or jpeg2000enc

MAX = 40960;
totBits = 2*MAX;
qstep = min_step;

while totBits > MAX
    qstep = qstep + precision;
    [vlc, ~, ~] = jpeg2000enc(X, qstep, n, opthuff);
    totBits = sum(vlc(:,2));
    if opthuff
        totBits = totBits + 1429;
    end
end

%disp("Total bits")
%disp(totBits)