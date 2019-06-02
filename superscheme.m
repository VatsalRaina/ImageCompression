function model = superscheme(X)
% Super-scheme of image compression methods which optimises the error
% measure between the original and reconstructed image
% Store the best model
model = [];
SSIM = 0;

% Integer codes
DWT_ID = 1;
LBT_ID=2;
DCT_ID=3;

% Set parameters for levels to consider
n = [3, 4, 5];

% Test the DWT
for i = 1:size(n,2)
    qstep = optimise_qstep_dwt(X,n(i),true,1,10);
    qstep = optimise_qstep_dwt(X,n(i),true,0.1,qstep-1);
    qstep = optimise_qstep_dwt(X,n(i),true,0.01,qstep-0.1);
    currssim = DWTssim(X, n(i), qstep);
    if abs(currssim) > SSIM
       disp("QSTEP:"); disp(qstep); 
       % Store the model if it is better than the current stored one
       model = [DWT_ID, n(i), n(i), qstep];
       SSIM = abs(currssim);
    end
end
%disp("Best SSIM: "); disp(SSIM);
%return

% Set different parameters for the next methods
N = [8, 16];
M = [8, 16, 32];

% 128 must be subtracted from X for the next methods to work
X = X - 128;

% Test the DCT
for i = 1:size(N,2)
   for j = 1:size(M,2)
        qstep = optimise_qstep(X,N(i),M(j),true,1,20,false);
        % Repeat with higher precision
        qstep = optimise_qstep(X,N(i),M(j),true,0.1,qstep-1,false);
        qstep = optimise_qstep(X,N(i),M(j),true,0.01,qstep-0.1,false);
        currssim = DCTssim(X, N(i), M(j), qstep);
        if abs(currssim) > SSIM
            % Store the model if it is better than the current stored one
            model = [DCT_ID, N(i), M(j), qstep];
            SSIM = abs(currssim);
        end    
   end
end

% Test the LBT
for i = 1:size(N,2)
   for j = 1:size(M,2)
        qstep = optimise_qstep(X,N(i),M(j),true,1,20,true);
        % Repeat with higher precision
        qstep = optimise_qstep(X,N(i),M(j),true,0.1,qstep-1,true);
        qstep = optimise_qstep(X,N(i),M(j),true,0.01,qstep-0.1,true);
        currssim = LBTssim(X, N(i),M(j), qstep);
        if abs(currssim) > SSIM
            % Store the model if it is better than the current stored one
            model = [LBT_ID, N(i), M(j), qstep];
            SSIM = abs(currssim);
            disp("QSTEP:"); disp(qstep);
        end    
   end
end

disp("Best SSIM: "); disp(SSIM);

return

