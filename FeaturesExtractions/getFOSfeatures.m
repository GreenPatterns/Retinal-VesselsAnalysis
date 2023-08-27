function [out] = getFOSfeatures(hsi,xyy,obj)

c = obj(:,2);
r = obj(:,1);

out =[];
hsiPv = impixel(hsi,c,r);
xyyPv = impixel(xyy,c,r);
out = [out;FOS(hsiPv),FOS(xyyPv)];
end

function [out] = FOS(x)
out=[];
out=[out;mean2(x),std2(x),rms(x(:)),skewness(x(:)),kurtosis(x(:))];
end

