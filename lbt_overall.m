% Perhaps convert into function in future

% Subtract 128 from image to make it zero mean: Ensure cmd
% cleared before calling this file to avoid 128 being subtracted
% multiple times
%X = X - 128;
% Parameters to vary:
% POT scaling factor
s = sqrt(2);
% DCT transform size
N = 8;
% Quantisation step size
step = 16.582;
% Rise for quantisation step about 0
rise = step;

% Boolean to select whether high frequency coefficents
% are set to 0 prior to compression and how many sub-images
% suppress
suppressed = true;
num_sup = 8;

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
            for i =1:num_sup
                for j = 1:num_sup
                    Y(row-i+1,col-j+1) = 0;
                end
            end
        end
    end
end

% Perform quantisation
Yq = quantise(Y,step,rise);

% Reconstruct images
Z = colxfm(colxfm(Yq',C')',C');
Zp = Z;
Zp(:,t) = colxfm(Zp(:,t)',Pr')';
Zp(t,:) = colxfm(Zp(t,:),Pr');
draw(Zp);

rms_lbt = std(X(:)-Zp(:));

N_fixed = 16;
Yr = regroup(Yq,N)/N;
totBits = dctbpp(Yr,N_fixed);
disp("rms ")
disp(rms_lbt)
disp("Entropy")
disp(totBits)

