function centerLineManualLabels()

mat_Files = dir('./data/DRIVE/AV_GT_DRIVE/AV-DRIVE/training/*.mat');
im_Files = dir('./data/DRIVE/training/centerline/*.bmp');
range=(1:size(im_Files,1));

for ra = range
    
    image_name = im_Files(ra).name;
    manual = mat_Files(ra).name;
    BW = imread(image_name);
    load(manual);
    
    V = G.V
    art = 
    
end


end