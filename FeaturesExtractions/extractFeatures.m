function extractFeatures()
 clc;
 close all;
 
 pixel=[];
 segNr = [];
 Features=[];
 Label=[];
 
 gt_Files = dir('FeaturesExtractions/Labels assigned/*.mat');
 rgb_Files = dir('FeaturesExtractions/images/*.jpg');
   
for ra=1:24
    
     rgb = imread(rgb_Files(ra).name);
     gt = load(gt_Files(ra).name);
     
     disp('Working, Please Wait.......');
     fprintf('%d : %s, %s\n',ra,rgb_Files(ra).name,gt_Files(ra).name);
     
     BW = gt.bw_image;
     GT = gt.ground_truth;
     stats = gt.region_props;
     
     [art,ven] = getAVpixels(BW,GT,stats);
     indexes = GT(:,1);
     
%*******************Preparing Images for features*************
    
    In = Proposed_Retinex(rgb);
    mask = im2double(calc_mask(In));
    hsi = rgb2hsi(In).*mask;
    xyy = rgb2xyy(In).*mask;
    
%     Redblur2 = imgaussfilt(In(:,:,1),2);
%     Redblur4 = imgaussfilt(In(:,:,1),4);       
%     Greenblur2 = imgaussfilt(In(:,:,2),2);
%     Greenblur4 = imgaussfilt(In(:,:,2),4);
%     SteerJ2 = steerGaussFilterOrder2(In,360,2,false);
%     SteerJ8 = steerGaussFilterOrder2(In,360,8,false);
    
%*************************************************************
    [lbl,~] = bwlabel(BW);

%*************************************************************

    for aPix=1:length(art)
        x = art(aPix,1);
        y = art(aPix,2);
        for i=1:length(indexes)
            idx = indexes(i);
            obj = stats.PixelList{idx};
            c = obj(:,2);
            r = obj(:,1);
            
            if(is_member(obj,[x,y]) && (x<=size(BW,1)) && (y<=size(BW,2)))
                
                pixel=[pixel;x,y];
                segNr=[segNr;idx];
                
                objPatch = lbl==idx;
                [~,clrskel] = doProcess(objPatch);
                clrlbl = bwlabel(clrskel);
                clrprop = regionprops('Table',clrlbl,'PixelList');
                clrobj = clrprop.PixelList{1}; 
                
                rgbVa = impixel(In,y,x);
                caliber = vessel_width(objPatch);
                CLR = getCLRfeatures(hsi,xyy,clrobj);
                colr = mean(impixel(xyy,c,r));
                FOS = getFOSfeatures(hsi,xyy,obj);
                
                hsipix = impixel(hsi,c,r);
                xyypix = impixel(xyy,c,r);
   
                hsiglcm0 = getGLCMFeatures(graycomatrix(hsipix,'Offset',[0 1],'Symmetric', true));%0 degree
                hsiglcm90 = getGLCMFeatures(graycomatrix(hsipix,'Offset',[-1 0],'Symmetric', true));%90 deg
                    
                xyyglcm0 = getGLCMFeatures(graycomatrix(xyypix,'Offset',[0 1],'Symmetric', true));%0 degree
                xyyglcm90 = getGLCMFeatures(graycomatrix(xyypix,'Offset',[-1 0],'Symmetric', true));%90 deg
                
                Fv=[];
                Fv =[Fv; rgbVa, caliber, CLR, colr, FOS, hsiglcm0, hsiglcm90, xyyglcm0, xyyglcm90];
                     
                
                Features = [Features;Fv];             
                Label=[Label;0];
                
                clear Fv; clear rgbVa; clear rgbVa; clear caliber; clear CLR; clear colrFOS;
                clear hsiglcm0; clear hsiglcm90; clear xyyglcm0; clear xyyglcm0; clear xyyglcm90;
            end
        end
    end
  
    for aPix=1:length(ven)
        x = ven(aPix,1);
        y = ven(aPix,2);
        for i=1:length(indexes)
            idx = indexes(i);
            obj = stats.PixelList{idx};
            c = obj(:,2);
            r = obj(:,1);
            
            if(is_member(obj,[x,y]) && (x<=size(BW,1)) && (y<=size(BW,2)))
                
                pixel=[pixel;x,y];
                segNr=[segNr;idx];
                
                objPatch = lbl==idx;
                [~,clrskel] = doProcess(objPatch);
                clrlbl = bwlabel(clrskel);
                clrprop = regionprops('Table',clrlbl,'PixelList');
                clrobj = clrprop.PixelList{1}; 
                
                rgbVa = impixel(In,y,x);
                caliber = vessel_width(objPatch);
                CLR = getCLRfeatures(hsi,xyy,clrobj);
                colr = mean(impixel(xyy,c,r));
                FOS = getFOSfeatures(hsi,xyy,obj);
                
                hsipix = impixel(hsi,c,r);
                xyypix = impixel(xyy,c,r);
   
                hsiglcm0 = getGLCMFeatures(graycomatrix(hsipix,'Offset',[0 1],'Symmetric', true));%0 degree
                hsiglcm90 = getGLCMFeatures(graycomatrix(hsipix,'Offset',[-1 0],'Symmetric', true));%90 deg
                    
                xyyglcm0 = getGLCMFeatures(graycomatrix(xyypix,'Offset',[0 1],'Symmetric', true));%0 degree
                xyyglcm90 = getGLCMFeatures(graycomatrix(xyypix,'Offset',[-1 0],'Symmetric', true));%90 deg
                
                Fv=[];
                Fv =[Fv; rgbVa, caliber, CLR, colr, FOS, hsiglcm0, hsiglcm90, xyyglcm0, xyyglcm90];
                     
                
                Features = [Features;Fv];             
                Label=[Label;1];
                
                clear Fv; clear rgbVa; clear rgbVa; clear caliber; clear CLR; clear colrFOS;
                clear hsiglcm0; clear hsiglcm90; clear xyyglcm0; clear xyyglcm0; clear xyyglcm90;
            end
        end
    end
    
    data = table(pixel,segNr,Features,Label);
    writetable(data,strcat(strcat('FeaturesExtractions/Features/',rgb_Files(ra).name),'.csv'),'Delimiter',',','QuoteStrings',false);
    clear data;
end         
end



