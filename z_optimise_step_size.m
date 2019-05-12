function stepSize = z_optimise_step_size(X,step_X,layers)

%Calculates the step size required for a pyramid with number of layers
%equal to 'layers' such that the quantisation leads to an rms error
%approximately equal to the rms error between X and its quantised version
%with a step size of step_X

h = [0.25,0.5,0.25];
X_qu = quantise(X,step_X);
rms = std(X(:)-X_qu(:));

stepSize = 3;   %Initialise to an arbitrary value
precision = 0.1;
diff = 3;       %Initialise difference between rms errors

while abs(diff) > precision/2
    % Update the step_size
    if diff > 0
        stepSize = stepSize - precision;
    else
        stepSize = stepSize + precision;
    end
    % Form pyramid (of 4 layers)
    py4enc;
    py4dec;     %Decoding necessary as an initialisation process
    % Quantise correct number of layers
    switch layers
        case 1
            z_quantise_pyr_1lays;
        case 2
            z_quantise_pyr_2lays;
        case 3
            z_quantise_pyr_3lays;
        case 4
            z_quantise_pyr_4lays;
        otherwise
            disp('Only use layers between 1 and 4')
    end
    py4dec;
    rms_pyr = std(X(:)-Z0(:));
    diff = rms_pyr - rms;
end