% dwtstep = [17,17,17;17,17,0;17,17,0]; % Step sizes
dwtent = dwtstep; % Entropies of each sub-image
Yq = Y;
m=256;
for i = 1:n
    m=m/2;
    t=1:m;
    s=m+1:2*m;
    % Quantise the high-pass images at level i
    
    Yq(t,s)= quantise(Yq(t,s),dwtstep(3,i));
    dwtent(3,i)= bpp(Yq(t,s))*numel(Yq(t,s));
    
    Yq(s,t)= quantise(Yq(s,t),dwtstep(2,i));
    dwtent(2,i)= bpp(Yq(s,t))*numel(Yq(s,t));
    
    Yq(s,s)= quantise(Yq(s,s),dwtstep(1,i));
    dwtent(1,i)= bpp(Yq(s,s))*numel(Yq(s,s));
    
end

% Quantise the low-pass image
siz = 2^n;
Yq(1:256/siz,1:256/siz) = quantise(Yq(1:256/siz,1:256/siz),dwtstep(1,n+1));
dwtent(1,n+1) = bpp(Yq(1:256/siz,1:256/siz))*numel(Yq(1:256/siz,1:256/siz));
