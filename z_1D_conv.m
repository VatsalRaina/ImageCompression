Y= conv(h, X(1,:));
for row = 2:256
    temp = conv(h, X(row,:));
    Y = [Y;temp];
end
% Trim filtered image to correct size
draw(Y(:,[1:256]+7))