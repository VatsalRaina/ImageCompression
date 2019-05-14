% Decode encoded images into the original images. Z0 should be equal to X.

Z0 = rowint(rowint(X1,2*h)',2*h)' + Y0;

err = max(abs(X(:)-Z0(:)));
