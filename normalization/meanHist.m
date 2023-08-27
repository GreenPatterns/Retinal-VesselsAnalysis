function [ meanGL ] = meanHist( im )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
[pixelCount grayLevels] = imhist(im);
meanGL = sum(pixelCount .* grayLevels) / sum(pixelCount);

end

