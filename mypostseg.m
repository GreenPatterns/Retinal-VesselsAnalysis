function [ img, conncomp, vesselSkeleton ] = mypostseg( segImg )

img = im2double(segImg);

% eliminate false classification
conncomp = bwconncomp(img);
numPixels = cellfun(@numel, conncomp.PixelIdxList);
smallComp = find(numPixels < 60);
for i = 1 : length(smallComp)
    img(conncomp.PixelIdxList{smallComp(i)}) = false;
end

vesselSkeleton = skeleton(img);
end

