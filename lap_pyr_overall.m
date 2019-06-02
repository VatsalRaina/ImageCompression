% Perhaps convert into function later

% Subtract 128 from image to make it zero mean: Ensure cmd
% cleared before calling this file to avoid 128 being subtracted
% multiple times
X = X - 128;
% Filter to apply on image
h = [0.25,0.5,0.25];
% Form pyramid of 4 layers (smaller pyramids form automatically)
py4enc;
% Number of layers for pyramid (maximum 4)
n = 3;
% Step size for Y0 - this is the parameter to vary to achieve
% total size (variable called comp_size) less than 5kb
step = 18;
% List of relative step ratios for the other images in pyramid
% This changes based on the chosen filter h
fac = [sqrt(10000/22500), sqrt(10000/75250), sqrt(10000/288910), sqrt(10000/1142000)];
% Perform decoding and determine size of compressed image

switch layers
    case 1
        comp_size=z_get_tot_entropy(Y0,step)+z_get_tot_entropy(X1,step*fac(1));            
        Y0 = quantise(Y0,step);
        X1 = quantise(X1,step*fac(1));
        py1dec;
    case 2
        comp_size=z_get_tot_entropy(Y0,step)+z_get_tot_entropy(Y1,step*fac(1))+z_get_tot_entropy(X2,step*fac(2));            
        Y0 = quantise(Y0,step);
        Y1 = quantise(Y1,step*fac(1));
        X2 = quantise(X2,step*fac(2));
        py2dec;
    case 3
        comp_size=z_get_tot_entropy(Y0,step)+z_get_tot_entropy(Y1,step*fac(1))+z_get_tot_entropy(Y2,step*fac(2))+z_get_tot_entropy(X3,step*fac(3));            
        Y0 = quantise(Y0,step);
        Y1 = quantise(Y1,step*fac(1));
        Y2 = quantise(Y2,step*fac(2));
        X3 = quantise(X3,step*fac(3));
        py3dec;
    case 4
        comp_size=z_get_tot_entropy(Y0,step)+z_get_tot_entropy(Y1,step*fac(1))+z_get_tot_entropy(Y2,step*fac(2))+z_get_tot_entropy(Y3,step*fac(3))+z_get_tot_entropy(X4,step*fac(4));            
        Y0 = quantise(Y0,step);
        Y1 = quantise(Y1,step*fac(1));
        Y2 = quantise(Y2,step*fac(2));
        Y3 = quantise(Y3,step*fac(3));
        X4 = quantise(X4,stepSize*fac4);
        py4dec;
end





