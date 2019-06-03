function x = clip(x)
% Clip and element to fit in the range 0-255
if x > 255, x = 255;
elseif x < 0, x = 0; end
return