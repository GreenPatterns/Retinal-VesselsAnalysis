function atest2()
dir_path = 'D:\projects\A-V classification\Datasets\CHASEDB1_Groundtruth\Second Observer\';
Files = dir(strcat(dir_path,'*.png'));
Range=(1:size(Files,1));
for r=Range
    file = Files(r).name;
    disp(file)
    if strcmp(file,'Image_06R_2ndHO.png')==0
        im = im2bw(imread(strcat(dir_path,file)));
        im_pro = doProcess(im);
        imwrite(im_pro,strcat(dir_path,file));
    end
end
