function stepSize = z_optimise_MSE(X,step_X,layers)

%Calculates the step size required for a pyramid with number of layers
%equal to 'layers' such that the quantisation leads to an rms error
%approximately equal to the rms error between X and its quantised version
%with a step size of step_X

%h = [0.25,0.5,0.25];
h = [0.0625,0.25,0.375,0.25,0.0625];
X_qu = quantise(X,step_X);
rms = std(X(:)-X_qu(:));
rms_pyr = 100;

stepSize = 17;   %Initialise to an arbitrary value

%fac1= sqrt(10000/22500);
%fac2=sqrt(10000/75250);
%fac3=sqrt(10000/288910);
%fac4=sqrt(10000/1142000);
%fac5 = sqrt(10000/4555600) ;

fac1= sqrt(10000/11963);
fac2=sqrt(10000/39029);
fac3=sqrt(10000/149230);
fac4=sqrt(10000/590400);

precision = 0.002;
diff = 3;       %Initialise difference between rms errors

while abs(diff) > precision/2
    % Update the step_size
    if diff > 0
        stepSize = stepSize - precision;
    else
        stepSize = stepSize + precision;
    end
    % Form pyramid (of 5 layers)
    py5enc;
    % Quantise and decode correct number of layers
    switch layers
        case 1
            entropy=z_get_tot_entropy(Y0,stepSize)+z_get_tot_entropy(X1,stepSize*fac1);            
            Y0 = quantise(Y0,stepSize);
            X1 = quantise(X1,stepSize*fac1);
            py1dec;
        case 2
            entropy=z_get_tot_entropy(Y0,stepSize)+z_get_tot_entropy(Y1,stepSize*fac1)+z_get_tot_entropy(X2,stepSize*fac2);            
            Y0 = quantise(Y0,stepSize);
            Y1 = quantise(Y1,stepSize*fac1);
            X2 = quantise(X2,stepSize*fac2);
            py2dec;
        case 3
            entropy=z_get_tot_entropy(Y0,stepSize)+z_get_tot_entropy(Y1,stepSize*fac1)+z_get_tot_entropy(Y2,stepSize*fac2)+z_get_tot_entropy(X3,stepSize*fac3);            
            Y0 = quantise(Y0,stepSize);
            Y1 = quantise(Y1,stepSize*fac1);
            Y2 = quantise(Y2,stepSize*fac2);
            X3 = quantise(X3,stepSize*fac3);
            py3dec;
        case 4
            entropy=z_get_tot_entropy(Y0,stepSize)+z_get_tot_entropy(Y1,stepSize*fac1)+z_get_tot_entropy(Y2,stepSize*fac2)+z_get_tot_entropy(Y3,stepSize*fac3)+z_get_tot_entropy(X4,stepSize*fac4);            
            Y0 = quantise(Y0,stepSize);
            Y1 = quantise(Y1,stepSize*fac1);
            Y2 = quantise(Y2,stepSize*fac2);
            Y3 = quantise(Y3,stepSize*fac3);
            X4 = quantise(X4,stepSize*fac4);
            py4dec;
        case 5
            entropy=z_get_tot_entropy(Y0,stepSize)+z_get_tot_entropy(Y1,stepSize*fac1)+z_get_tot_entropy(Y2,stepSize*fac2)+z_get_tot_entropy(Y3,stepSize*fac3)+z_get_tot_entropy(Y4,stepSize*fac4)+z_get_tot_entropy(X5,stepSize*fac5);            
            Y0 = quantise(Y0,stepSize);
            Y1 = quantise(Y1,stepSize*fac1);
            Y2 = quantise(Y2,stepSize*fac2);
            Y3 = quantise(Y3,stepSize*fac3);
            Y4 = quantise(Y4,stepSize*fac4);
            X5 = quantise(X5,stepSize*fac5);
            py5dec;
        otherwise
            disp('Only use layers between 1 and 5')
    end
    rms_pyr = std(X(:)-Z0(:));
    diff = rms_pyr - rms;
end

disp("rms ")
disp(rms_pyr)
disp("Entropy")
disp(entropy)