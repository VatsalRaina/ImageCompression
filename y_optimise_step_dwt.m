function stepSize = y_optimise_step_dwt(X,step_X,n)

X_qu = quantise(X,step_X);
rms = std(X(:)-X_qu(:));
rms_dwt = 100;

nlevdwt;

stepSize = 6.336;
precision = 0.0001;
diff=3;
Yq=Y;
totBits=0;

while abs(diff) > precision/2
    if diff > 0
        stepSize = stepSize - precision;
    else
        stepSize = stepSize + precision;
    end
    dwtstep = zeros(3,n+1);
    % For equal step scheme
    %dwtstep(:)=stepSize;
    % For equal MSE scheme
    dwtstep(1,1)=stepSize;
    dwtstep(2,1)=sqrt(82656/43125)*stepSize;
    dwtstep(3,1)=sqrt(82656/43125)*stepSize;
    
    dwtstep(1,2)=sqrt(82656/135980)*stepSize;
    dwtstep(2,2)=sqrt(82656/101410)*stepSize;
    dwtstep(3,2)=sqrt(82656/101410)*stepSize;
    
    dwtstep(1,3)=sqrt(82656/402430)*stepSize;
    dwtstep(2,3)=sqrt(82656/304980)*stepSize;
    dwtstep(3,3)=sqrt(82656/304980)*stepSize;
    
    dwtstep(1,4)=sqrt(82656/1481500)*stepSize;
    dwtstep(2,4)=sqrt(82656/1300900)*stepSize;
    dwtstep(3,4)=sqrt(82656/1300900)*stepSize;
    
    dwtstep(1,5)=sqrt(82656/5801300)*stepSize;
    dwtstep(2,5)=sqrt(82656/5140800)*stepSize;
    dwtstep(3,5)=sqrt(82656/5140800)*stepSize;
    
    dwtstep(1,n+1)=sqrt(82656/4555600)*stepSize;
    quantdwt;
    nlevidwt;
    rms_dwt = std(X(:)-Z(:));
    diff = rms_dwt - rms;
    
    dwtent(2,n+1)=0;
    dwtent(3,n+1)=0;
    totBits=sum(dwtent(:));
end

disp("rms ")
disp(rms_dwt)
disp("Entropy")
disp(totBits)

return