%Blur Demo

%Import image
% im = im2double(imread('Image_01L.jpg'));
im = im2double(imread('proposed.png'));
g = im(:,:,2);
r = im(:,:,1);
b = im(:,:,3);

se = strel('disk',0,0);

g_open = imopen(g,se);
r_open = imopen(r,se);
b_open = imopen(b,se);

%Blur Kernel
ksize = 149;
kernel = zeros(ksize);

%Gaussian Blur
s = 35;
m = ksize/2;
[X, Y] = meshgrid(1:ksize);
kernel = (1/(2*pi*s^2))*exp(-((X-m).^2 + (Y-m).^2)/(2*s^2));

r_blur = conv2(r,kernel,'same');
g_blur = conv2(g,kernel,'same');
b_blur = conv2(b,kernel,'same');

r_norm = r_open-r_blur;
g_norm = g_open-g_blur;
b_norm = b_open-b_blur;

%Plot image
figure, imshow([g,g_norm;b,b_norm],[])
title('Results Image')
figure, imshow([im,cat(3,r,g_norm,b_norm)],[])
title('Results Image')
