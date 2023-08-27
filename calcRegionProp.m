function [ img ] = calcRegionProp( BW )
img = BW;
conncomp = bwconncomp(img);
numPixels = cellfun(@numel, conncomp.PixelIdxList);
smallComp = find(numPixels < 40);
for i = 1 : length(smallComp)
    img(conncomp.PixelIdxList{smallComp(i)}) = 0;
end
end

