function [vlc bits huffval] = jpeg2000enc(X, qstep, n, opthuff)

dcbits = 8;

N=2^n;
M=N;

% Implement DWT with regrouping so a similar approach to Huffman coding in
% jpeg.m can be used

global huffhist  % Histogram of usage of Huffman codewords.

% Perform n levels of DWT
m=256;
Y=dwt(X);
if n>1
    for lev = 2:n
        m=m/2;
        t=1:m;
        Y(t,t)=dwt(Y(t,t));
    end
end



%Quantise using an equal MSE scheme

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

Yq = Y;
m=256;
for i = 1:n
    m=m/2;
    t=1:m;
    s=m+1:2*m;
    % Quantise the high-pass images at level i  
    Yq(t,s)= quant1(Yq(t,s),dwtstep(3,i)); 
    Yq(s,t)= quant1(Yq(s,t),dwtstep(2,i)); 
    Yq(s,s)= quant1(Yq(s,s),dwtstep(1,i));
end
siz = 2^n;
Yq(1:256/siz,1:256/siz) = quant1(Yq(1:256/siz,1:256/siz),dwtstep(1,n+1));

% Perform regrouping
Yg = dwtgroup(Yq,n);
Yq=Yg;


%Yq=quant1(Yg,qstep,qstep);

% The rest is the same as the usual jpeg

% Generate zig-zag scan of AC coefs.
scan = diagscan(M);

% On the first pass use default huffman tables.
%disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
%disp('Coding rows')
sy=size(Yq);
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    if ((yq(1)<0) | (yq(1)>(2^dcbits-1)))
      error('DC coefficients too large for desired number of bits');
    end
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end

% Return here if the default tables are sufficient, otherwise repeat the
% encoding process using the custom designed huffman tables.
if (opthuff==false) 
  if (nargout>1)
    bits = dbits;
    huffval = dhuffval;
  end
  %fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)));
  return;
end

% Design custom huffman tables.
%disp('Generating huffcode and ehuf using custom tables')
[dbits, dhuffval] = huffdes(huffhist);
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
%disp('Coding rows (second pass)')
t = 1:M;
huffhist = zeros(16*16,1);
vlc = [];
for r=0:M:(sy(1)-M),
  vlc1 = [];
  for c=0:M:(sy(2)-M),
    yq = Yq(r+t,c+t);
    % Possibly regroup 
    if (M > N) yq = regroup(yq, N); end
    % Encode DC coefficient first
    yq(1) = yq(1) + 2^(dcbits-1);
    dccoef = [yq(1)  dcbits]; 
    % Encode the other AC coefficients in scan order
    ra1 = runampl(yq(scan));
    vlc1 = [vlc1; dccoef; huffenc(ra1, ehuf)]; % huffenc() also updates huffhist.
  end
  vlc = [vlc; vlc1];
end
%fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)))
%fprintf(1,'Bits for huffman table = %d\n', (16+max(size(dhuffval)))*8)

if (nargout>1)
  bits = dbits;
  huffval = dhuffval';
end


return
