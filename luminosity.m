function [xiso] = luminosity(xorig)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Snippet for ISO image
%% Luminosity and contrast normalization in retinal images
%% Medical Image Analysis 9(3):179-90 · July 2005
%%
%% Requires:
%% xmask: binary mask equal to 1 in the region of the image containing the retina
%% xorig: double RGB retinal image with values in the range [0,1]
%%
%% Parameters:
%% Nblock: size of the square region onto which evaluate local luminosity
%% th_green: threshold to set the exclusion of bright pixels from the normal mask
%% th_s: number of std defining background retina 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
xorig = im2double(xorig);
xmask = calc_mask(xorig);

Nblock=127;
th_green=0.75;
th_s=0.5;

% Finding background on green channel
xgreen=xorig(:,:,2);
xden=conv2(xmask,ones(Nblock),'same');
xden(xden==0)=1;
xden=conv2(xmask,ones(Nblock),'same');
xden(xden==0)=1;
xmean=conv2(xgreen,ones(Nblock),'same')./xden;
xstd=sqrt(conv2((xgreen-xmean).^2.*xmask,ones(Nblock),'same')./xden);
xnor=xgreen>(xmean-th_s*xstd) & xgreen<(xmean+th_s*xstd);
xnor=xnor & (xgreen<th_green);
xden=conv2(xnor.*xmask,ones(Nblock),'same');
xden(xden==0)=1;

% Find local luminosity and contrast for each colour channel
% and correct it to zero mean and 0.07 standard deviation
for ctcolor=1:3,
% Evaluate local mean on backround
xm=conv2(xorig(:,:,ctcolor).*xnor,ones(Nblock),'same')./xden;
% remove local mean
xc=xorig(:,:,ctcolor)-xm;
% Evaluate local standard deviation on backround
xs=sqrt(conv2((xc).^2.*xnor,ones(Nblock),'same')./xden);
% local whitening (zero mean and 1 std)
xtmp=(xc./xs.*xmask);
n=find(xmask);
% normalize to zero mean and 0.07 std
xiso(:,:,ctcolor)=xtmp/std(xtmp(n))*0.07.*xmask;
end;
% check for nans
xiso(isnan(xiso))=0;
end

function mask = calc_mask(img)

% Uses the red channel for finding the mask.
red = img(:,:,1);
red = double(red) / 255;

%Calculates edges with laplacian of gaussian
edges = edge(red, 'log', 0.0005, 3);

% Fills in little missing parts in edges.
edges = myimclose(edges, strel('diamond', 2));
  
% Adds a countour around the edges image.
[nlins,ncols] = size(edges);
edges(1,:) =     ones(1, ncols);
edges(nlins,:) = ones(1, ncols);
edges(:,1) =     ones(nlins, 1);
edges(:,ncols) = ones(nlins, 1);

% figure; imshow(edges);
% Creates the seed for the outer region by thresholding.
maxred = max(red(:));
seed = uint8(red < 0.15 * maxred);
seed = bwareaopen(seed, 10);

% Takes seed away from the border.
seed(1,:) =     zeros(1, ncols);
seed(nlins,:) = zeros(1, ncols);
seed(:,1) =     zeros(nlins, 1);
seed(:,ncols) = zeros(nlins, 1);
seed = imerode(seed, strel('diamond', 10));
%figure; imshow(seed);

% Fills the seed until it reaches the edges of tha aperture.
notmask = imfill(edges, find(seed > 0));
mask = ~notmask;
mask = imdilate(mask, strel('diamond', 1));

%figure; imshow(mask);

% Filling in missing parts.
mask = bwareaclose(mask, 5000);

% Removing false positive contour.
mask = imopen(mask, strel('diamond', 6));

%Removing other false positives.
mask = bwareaopen(mask, 50000);

%figure; imshow(mask);
end
function bw2 = bwareaclose(bw1, n)

bw2 = ~bwareaopen(~bw1, n);
end
% For some reason, imclose from MATLAB 6.0 doesn't work properly, so
% we use this one instead.
function closed = myimclose(img, element)

img = imdilate(img, element);
closed = imerode(img, element);
end

