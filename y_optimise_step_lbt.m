function stepSize = y_optimise_step_lbt(X,step_X,N,s)
    
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

stepSize = 22.94;
precision = 0.001;
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