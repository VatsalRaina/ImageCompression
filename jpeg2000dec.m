function Z = jpeg2000dec(vlc, qstep, n, bits, huffval)

N=2^n;
M=N;
opthuff=true;
H=256;
W=256;
dcbits=8;

% Set up standard scan sequence
scan = diagscan(M);

if (opthuff)
  %disp('Generating huffcode and ehuf using custom tables')
else
  %disp('Generating huffcode and ehuf using default tables')
  [bits huffval] = huffdflt(1);
end
% Define starting addresses of each new code length in huffcode.
huffstart=cumsum([1; bits(1:15)]);
% Set up huffman coding arrays.
[huffcode, ehuf] = huffgen(bits, huffval);

% Define array of powers of 2 from 1 to 2^16.
k=[1; cumprod(2*ones(16,1))];

% For each block in the image:

% Decode the dc coef (a fixed-length word)
% Look for any 15/0 code words.
% Choose alternate code words to be decoded (excluding 15/0 ones).
% and mark these with vector t until the next 0/0 EOB code is found.
% Decode all the t huffman codes, and the t+1 amplitude codes.

eob = ehuf(1,:);
run16 = ehuf(15*16+1,:);
i = 1;
Zq = zeros(H, W);
t=1:M;

%disp('Decoding rows')
for r=0:M:(H-M),
  for c=0:M:(W-M),
    yq = zeros(M,M);

% Decode DC coef - assume no of bits is correctly given in vlc table.
    cf = 1;
    if (vlc(i,2)~=dcbits) error('The bits for the DC coefficient does not agree with vlc table'); end
    yq(cf) = vlc(i,1) - 2^(dcbits-1);
    i = i + 1;

% Loop for each non-zero AC coef.
    while any(vlc(i,:) ~= eob),
      run = 0;

% Decode any runs of 16 zeros first.
      while all(vlc(i,:) == run16), run = run + 16; i = i + 1; end

% Decode run and size (in bits) of AC coef.
      start = huffstart(vlc(i,2));
      res = huffval(start + vlc(i,1) - huffcode(start));
      run = run + fix(res/16);
      cf = cf + run + 1;  % Pointer to new coef.
      si = rem(res,16);
      i = i + 1;

% Decode amplitude of AC coef.
      if vlc(i,2) ~= si,
        error('Problem with decoding .. you might be using the wrong bits and huffval tables');
        return
      end
      ampl = vlc(i,1);

% Adjust ampl for negative coef (i.e. MSB = 0).
      thr = k(si);
      yq(scan(cf-1)) = ampl - (ampl < thr) * (2 * thr - 1);

      i = i + 1;      
    end

% End-of-block detected, save block.
    i = i + 1;

    % Possibly regroup yq
    if (M > N) yq = regroup(yq, M/N); end
    Zq(r+t,c+t) = yq;
  end
end

%Ungroup
Z = dwtgroup(Zq,-n);

%fprintf(1, 'Inverse quantising to step size of %i\n', qstep);
%Zi=quant2(Z,qstep,qstep);

dwtstep = zeros(3,n+1);

dwtstep(1,1)=qstep;
dwtstep(2,1)=sqrt(82656/43125)*qstep;
dwtstep(3,1)=sqrt(82656/43125)*qstep;

dwtstep(1,2)=sqrt(82656/135980)*qstep;
dwtstep(2,2)=sqrt(82656/101410)*qstep;
dwtstep(3,2)=sqrt(82656/101410)*qstep;

dwtstep(1,3)=sqrt(82656/402430)*qstep;
dwtstep(2,3)=sqrt(82656/304980)*qstep;
dwtstep(3,3)=sqrt(82656/304980)*qstep;

if n==3
    dwtstep(1,n+1)=sqrt(82656/288910)*qstep;
elseif n==4
    dwtstep(1,4)=sqrt(82656/1481500)*qstep;
    dwtstep(2,4)=sqrt(82656/1300900)*qstep;
    dwtstep(3,4)=sqrt(82656/1300900)*qstep;
    dwtstep(1,n+1)=sqrt(82656/1142200)*qstep;
elseif n==5
    dwtstep(1,4)=sqrt(82656/1481500)*qstep;
    dwtstep(2,4)=sqrt(82656/1300900)*qstep;
    dwtstep(3,4)=sqrt(82656/1300900)*qstep;
    dwtstep(1,5)=sqrt(82656/5801300)*qstep;
    dwtstep(2,5)=sqrt(82656/5140800)*qstep;
    dwtstep(3,5)=sqrt(82656/5140800)*qstep;
    dwtstep(1,n+1)=sqrt(82656/4555600)*qstep;    
else
    disp("Use n in range 3-5 for DWT levels");
end

Zq = Z;
m=256;
for i = 1:n
    m=m/2;
    t=1:m;
    s=m+1:2*m;
    % Quantise the high-pass images at level i  
    Zq(t,s)= quant2(Zq(t,s),dwtstep(3,i)); 
    Zq(s,t)= quant2(Zq(s,t),dwtstep(2,i)); 
    Zq(s,s)= quant2(Zq(s,s),dwtstep(1,i));
end
siz = 2^n;
Zq(1:256/siz,1:256/siz) = quant2(Zq(1:256/siz,1:256/siz),dwtstep(1,n+1));

Z=Zq;
% Invert n levels of DWT

m = 256/ (2^(n-1));
t=1:m;
Z(t,t)=idwt(Z(t,t));
if n>1
    for lev = 2:n
        m=2*m;
        t=1:m;
        Z(t,t)=idwt(Z(t,t));
    end
end

% The reconstructed image returned is Z

return