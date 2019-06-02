function [vlc bits huffval] = jpeg2000enc(X, qstep, n, opthuff)

dcbits = 8;

N=2^n;
M=N;

% Implement DWT with regrouping so a similar approach to Huffman coding in
% jpeg.m can be used

global huffhist  % Histogram of usage of Huffman codewords.

% Perform n levels of DWT
nlevdwt;

% Perform regrouping
Yg = dwtgroup(Y,n);

% The rest is the same as the usual jpeg
Yq=quant1(Yg,qstep,qstep);

% Generate zig-zag scan of AC coefs.
scan = diagscan(M);

% On the first pass use default huffman tables.
disp('Generating huffcode and ehuf using default tables')
[dbits, dhuffval] = huffdflt(1);  % Default tables.
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows')
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
  fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)));
  return;
end

% Design custom huffman tables.
disp('Generating huffcode and ehuf using custom tables')
[dbits, dhuffval] = huffdes(huffhist);
[huffcode, ehuf] = huffgen(dbits, dhuffval);

% Generate run/ampl values and code them into vlc(:,1:2).
% Also generate a histogram of code symbols.
disp('Coding rows (second pass)')
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
fprintf(1,'Bits for coded image = %d\n', sum(vlc(:,2)))
fprintf(1,'Bits for huffman table = %d\n', (16+max(size(dhuffval)))*8)

if (nargout>1)
  bits = dbits;
  huffval = dhuffval';
end


return
