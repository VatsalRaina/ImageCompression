function totBits = dctbpp(Yr,N)

% Calculate total number of bits from a regrouped image by
% summing total entropy of each sub-image.
% Assume image size is a multiple of N
% N here represents the required number of sub-images in each row

[rows columns] = size(Yr);
sub_img_size = rows / N;

totBits = 0;
for row=1:sub_img_size:rows,
    for column=1:sub_img_size:columns,
        Ys = Yr(row:row+sub_img_size-1,column:column+sub_img_size-1);
        totBits = totBits + bpp(Ys)*numel(Ys);
    end
end

return