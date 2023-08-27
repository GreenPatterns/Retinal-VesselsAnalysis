function [ rgb ] = xyy2rgb(xyy)
cform = makecform('xyl2xyz');
xyz = applycform(xyy,cform);
rgb = xyz2rgb(xyz);
end

