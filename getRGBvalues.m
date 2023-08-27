function getRGBvalues()

R = Image_11L(:,:,1);
G = Image_11L(:,:,2);
B = Image_11L(:,:,3);
RGB_Intensities = [];
CC = bwconncomp(centerLine_segments);
L = labelmatrix(CC);

stats = regionprops('Table',L,'PixelIdxList');
for i=1:numel(stats.PixelIdxList)
    [y,x] = ind2sub(size(L), stats.PixelIdxList{1});
        R_values = R(x,y);
        G_values = G(x,y);
        B_values = B(x,y);
        aSegment = {{R_values,G_values,B_values}};
        RGB_Intensities = cat(2,RGB_Intensities,aSegment);

end
end

