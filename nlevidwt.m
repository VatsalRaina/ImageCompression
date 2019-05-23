% Transform a set of quantised sub-images 
% Yq into the reconstructed image Z
% n>=2

Z=Yq;
m = 256/(2^(n-1));
t=1:m;
Z(t,t)=idwt(Z(t,t));
if n>1
    for lev = 2:n
        m=2*m;
        t=1:m;
        Z(t,t)=idwt(Z(t,t));
    end
end

draw(Z)