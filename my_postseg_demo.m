
im_Files = dir('data/DRIVE/test/testSegmented/*.bmp');
im_TFiles = dir('data/DRIVE/training/trainSegmented/*.bmp');
Range=(1:size(im_Files,1));
parpool;
for ra=Range
    image_name = im_Files(ra).name;
    strL = sprintf('%d. %s',ra,image_name);
    disp(strL);
    
    segImg =  imread(image_name);
    segVess = segImg(:, :, 1); 
    
    
    [img, conncomp, vesselSkeleton] = mypostseg( segVess ); 
    [VesselGraph, V, vesselSkeleton2] = extractGraph(vesselSkeleton);
    
    vesselSkeletonPixel2 = roundSkel(vesselSkeleton2);
    vesselJunctionPixel = roundJunctions(V);
    [Rows,Cols] = size(img);
    centerLine = zeros(Rows,Cols);
    for i = 1: length(vesselSkeletonPixel2)
        L = vesselSkeletonPixel2{i};
        [rows, cols] = size(L);
        for row=1:rows
        centerLine(L(row, 1), L(row, 2))=true;
        end
    end
    centerLine(vesselJunctionPixel(:, 1), vesselJunctionPixel(:, 2)) = false;
    
    [pathstr,name,ext] = fileparts(image_name);
    strStore = sprintf('data/DRIVE/test/centerline/%s.bmp',name);
    imwrite(centerLine,strStore);
    
    %Training
    image_name = im_TFiles(ra).name;
    strL = sprintf('%d. %s',ra,image_name);
    disp(strL);
    
    segImg =  imread(image_name);
    segVess = segImg(:, :, 1); 
    
    
    [img, conncomp, vesselSkeleton] = mypostseg( segVess ); 
    [VesselGraph, V, vesselSkeleton2] = extractGraph(vesselSkeleton);
    
    vesselSkeletonPixel2 = roundSkel(vesselSkeleton2);
    vesselJunctionPixel = roundJunctions(V);
    [Rows,Cols] = size(img);
    centerLine = zeros(Rows,Cols);
    for i = 1: length(vesselSkeletonPixel2)
        L = vesselSkeletonPixel2{i};
        [rows, cols] = size(L);
        for row=1:rows
        centerLine(L(row, 1), L(row, 2))=true;
        end
    end
    centerLine(vesselJunctionPixel(:, 1), vesselJunctionPixel(:, 2)) = false;
    
    [pathstr,name,ext] = fileparts(image_name);
    strStore = sprintf('data/DRIVE/training/centerline/%s.bmp',name);
    imwrite(centerLine,strStore);
end
poolobj = gcp('nocreate');
delete(poolobj);
