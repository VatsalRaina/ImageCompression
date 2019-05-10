% Convolve rows first then columns
row_column = convse(convse(X,h)',h)';
draw(row_column);

% Convolve columns first then rows
column_row = convse(convse(X',h)',h);
draw(column_row);

% Calculate absolute difference between the two images
epsilon_img = imabsdiff(row_column,column_row);
epsilon = max(max(epsilon_img));