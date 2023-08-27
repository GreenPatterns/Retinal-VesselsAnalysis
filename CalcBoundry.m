%gt = imread('data/30_chase vessels.png');
gt = img;
imtool(gt);

b = boundaries(gt);
boundry = zeros(size(gt));
for i=1:length(b);
    B = b{i};
    [m,n] = size(B);
    for row=1:m
        boundry(B(row,1),B(row,2))=true;
    end
end

imtool(boundry);