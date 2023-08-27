function [ CLR ] = getCLRfeatures( hsi,xyy,clrobj )
CLR=[];
hp = impixel(hsi,clrobj(:,2),clrobj(:,1));
xp = impixel(xyy,clrobj(:,2),clrobj(:,1));
CLR=[CLR;std2(hp), skewness(hp(:)), kurtosis(hp(:)), std2(xp), skewness(xp(:)), kurtosis(xp(:))];
end

