% Decode encoded images into the original images. Z0 should be equal to X.

Z4 = rowint(rowint(X5,2*h)',2*h)' + Y4;
Z3 = rowint(rowint(Z4,2*h)',2*h)' + Y3;
Z2 = rowint(rowint(Z3,2*h)',2*h)' + Y2;
Z1 = rowint(rowint(Z2,2*h)',2*h)' + Y1;
Z0 = rowint(rowint(Z1,2*h)',2*h)' + Y0;

err = max(abs(X(:)-Z0(:)));
