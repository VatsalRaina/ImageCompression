function stepSize = y_optimise_step_lbt(X,step_X,N,s)

% Boolean to select whether high frequency coefficents
% are set to 0 prior to compression
suppressed = true;

X_qu = quantise(X,step_X);
rms = std(X(:)-X_qu(:));
rms_lbt = 100;

[Pf Pr] = pot_ii(N,s);

[I , ~] = size(X);

t = [(1+N/2):(I-N/2)];
Xp = X;
Xp(t,:) = colxfm(Xp(t,:),Pf);
Xp(:,t) = colxfm(Xp(:,t)',Pf)';

C = dct_ii(N);
Y = colxfm(colxfm(Xp,C)',C)';

if suppressed
    for row = N:N:256
        for col = N:N:256
            Y(row,col) = 0;
        end
    end
end

stepSize = 16.58;
riseRatio = 1;
rise = stepSize*riseRatio;
precision = 0.01;
diff = 3;
Yq = Y;

while abs(diff) > precision/2
    if diff > 0
        stepSize = stepSize - precision;
        rise = stepSize*riseRatio;
    else
        stepSize = stepSize + precision;
        rise = stepSize*riseRatio;
    end
    
    Yq = quantise(Y,stepSize,rise);
    Z = colxfm(colxfm(Yq',C')',C');
    Zp = Z;
    Zp(:,t) = colxfm(Zp(:,t)',Pr')';
    Zp(t,:) = colxfm(Zp(t,:),Pr');
    rms_lbt = std(X(:)-Zp(:));
    diff = rms_lbt - rms;
end

N_fixed = 16;
Yr = regroup(Yq,N)/N;
totBits = dctbpp(Yr,N_fixed);
disp("rms ")
disp(rms_lbt)
disp("Entropy")
disp(totBits)

Z = colxfm(colxfm(Yq',C')',C');
Zp = Z;
Zp(:,t) = colxfm(Zp(:,t)',Pr')';
Zp(t,:) = colxfm(Zp(t,:),Pr');

draw(Zp);


return