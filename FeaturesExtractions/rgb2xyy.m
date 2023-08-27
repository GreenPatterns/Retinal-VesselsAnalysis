function [ xyy ] = rgb2xyy(rgb)
xyz = rgb2xyz(rgb);
cform = makecform('xyz2xyl');
xyy = applycform(xyz,cform); 
end

