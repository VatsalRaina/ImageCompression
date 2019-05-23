function stepSize = y_optimise_step_dct(X,step_X,transformSize)
    
% Get step size of a DCT of a given size to have same rms error
% as X with a step size of step_X

X_qu = quantise(X,step_X);
rms = std(X(:)-X_qu(:));
rms_dct = 100;

C = dct_ii(transformSize);
Y = colxfm(colxfm(X,C)',C)';

stepSize = 23.90;
precision = 0.01;
diff = 3;
Yq = Y;

while abs(diff) > precision/2
    if diff > 0
        stepSize = stepSize - precision;
    else
        stepSize = stepSize + precision;
    end
    
    Yq = quantise(Y,stepSize);
    Z = colxfm(colxfm(Yq',C')',C'); 
    rms_dct = std(X(:)-Z(:));
    diff = rms_dct - rms;
end

N=transformSize;
Yr = regroup(Yq,N)/N;
totBits = dctbpp(Yr,N);
disp("rms ")
disp(rms_dct)
disp("Entropy")
disp(totBits)

Z = colxfm(colxfm(Yq',C')',C');
draw(Yr);

return