function entrop = z_get_tot_entropy(M, step)

% Compute total entropy of an image M by first computing entropy in bpp
% then multiplying through by the number of pixels. The quantisation step
% for the image must be set too

entrop_bpp = bpp(quantise(M,step));
entrop = entrop_bpp * numel(M);

return