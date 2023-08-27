clc;



% theta = [0:15:360];
image = imread('Image_01L.jpg');
% dim = ndims(inImg);
% if(dim == 3)
%     %Input is a color image
%     inImg = rgb2gray(inImg);
% end
% I = inImg;
% tic
% for i = [1:length(theta)]
%    J1 = steerGaussFilterOrder1(I,theta(i),2,true);
% end
% toc

% tic
% for i = [1:length(theta)]
%    J2 = steerGaussFilterOrder2(I,theta(i),2,true);
% end
% toc

J2 = steerGaussFilterOrder2(image,360,2,false);
% J4 = steerGaussFilterOrder2(image,360,4,false);
% J8 = steerGaussFilterOrder2(image,360,8,false);
% J16 = steerGaussFilterOrder2(image,360,16,false);




