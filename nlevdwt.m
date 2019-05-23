% Perform n levels of DWT
% n>=2

m=256;
Y=dwt(X);
if n>1
    for lev = 2:n
        m=m/2;
        t=1:m;
        Y(t,t)=dwt(Y(t,t));
    end
end
%draw(Y)
