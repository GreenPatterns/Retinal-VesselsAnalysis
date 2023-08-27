function Copy_of_calcDriveFeatures(image)


     mask = im2double(calc_mask(image));
     load('data/chaseDB/mat_files/GT/VGT/VGT_image_13L.mat');
     indexes = GT(:,1);

    %--------------Red, Green, Blue Channels-----------
    Red  =preproc(image(:,:,1),mask);
    Green=preproc(image(:,:,2),mask);
    Blue =preproc(image(:,:,3),mask);
    
    %--------------------End---------------------------

    %--------------CREATING HSI------------------------
    th=acos((0.5*((Red-Green)+(Red-Blue)))./((sqrt((Red-Green).^2+(Red-Blue).*(Green-Blue)))+eps));
    H=th;
    H(Blue>Green)=2*pi-H(Blue>Green);
    H=H/(2*pi);
    Situ=1-3.*(min(min(Red,Green),Blue))./(Red+Green+Blue+eps);
    I=(Red+Green+Blue)/3;
    
    H = preproc(H,mask);
    Situ = preproc(Situ,mask);
    I = preproc(I,mask);
    %---------------End HSI Creation-------------------
    
    %------Creating Gaussian Blurred(sig=2,4,8,16) of Red, Green-----------
    
        Redblur2 = imgaussfilt(Red,2);
        Redblur4 = imgaussfilt(Red,4);
        Redblur16 = imgaussfilt(Red,16);        
        Greenblur2 = imgaussfilt(Green,2);
        Greenblur4 = imgaussfilt(Green,4);
        Greenblur16 = imgaussfilt(Green,16);
        SteerJ2 = steerGaussFilterOrder2(image,360,2,false);
        SteerJ8 = steerGaussFilterOrder2(image,360,8,false);
        
    %------End of Gaussian Blurred(sig=2,4,8,16) of Red, Green-------------
    
    %------------------Steered second Gaussian derivative------------------
    
    SteerJ2 = steerGaussFilterOrder2(image,360,2,false);
    SteerJ4 = steerGaussFilterOrder2(image,360,4,false);
    SteerJ8 = steerGaussFilterOrder2(image,360,8,false);
    SteerJ16 = steerGaussFilterOrder2(image,360,16,false);
    
    SteerJ2 = preproc(SteerJ2,mask);
    SteerJ4 = preproc(SteerJ4,mask);
    SteerJ8 = preproc(SteerJ8,mask);
    SteerJ16 = preproc(SteerJ16,mask);
    
%------------End of Steered second Gaussian derivative-----------------

%     a = roundJunctions(G.V(G.art,:));
%     v = roundJunctions(G.V(G.ven,:));
    
    pixel=[];
    segNr = [];
    
    Features=[];
    Label=[];
    CC = bwconncomp(BW);
    L = labelmatrix(CC);
    stats = regionprops('Table',L,'PixelList');
    
    
    for aPix=1:length(a)
        for i=1:length(indexes)
             obj = stats.PixelList{indexes(i)};
            for row=1:size(obj,1)
                if((a(aPix,1)==obj(row,1))&&(a(aPix,2)==obj(row,2)) && (a(aPix,1)<=size(BW,1))&& (a(aPix,2)<=size(BW,2)))
                    pixel=[pixel;a(aPix,1),a(aPix,2)];
                    segNr=[segNr;indexes(i)];
                    F=[];
                    F = [F;...
                    Red(a(aPix, 1), a(aPix, 2)), Green(a(aPix, 1), a(aPix, 2)), Blue(a(aPix, 1), a(aPix, 2)),...
                    H(a(aPix, 1), a(aPix, 2)), Situ(a(aPix, 1), a(aPix, 2)), I(a(aPix, 1), a(aPix, 2)), ...
                    Redblur2(a(aPix, 1), a(aPix, 2)),Redblur4(a(aPix, 1), a(aPix, 2)),...
                    Redblur8(a(aPix, 1), a(aPix, 2)),Redblur16(a(aPix, 1), a(aPix, 2)),...
                    Greenblur2(a(aPix, 1), a(aPix, 2)),Greenblur4(a(aPix, 1), a(aPix, 2)),...
                    Greenblur8(a(aPix, 1), a(aPix, 2)),Greenblur16(a(aPix, 1), a(aPix, 2)),...
                    SteerJ2(a(aPix, 1), a(aPix, 2)), SteerJ4(a(aPix, 1), a(aPix, 2)),...
                    SteerJ8(a(aPix, 1), a(aPix, 2)), SteerJ16(a(aPix, 1), a(aPix, 2))];
                
                    vect = getSegmentStatistics(Red,Green,Blue,H,Situ,I,...
                                     Redblur2,Redblur4,Redblur8,Redblur16,...
                                     Greenblur2,Greenblur4,Greenblur8,Greenblur16,...
                                     SteerJ2,SteerJ4,SteerJ8,SteerJ16,obj);
                     
                    F = [F,vect];
                    Features = [Features;F];             
                    Label=[Label;0];
                end
            end
        end
    end
    
  
    for aPix=1:length(v)
        for i=1:length(indexes)
            obj = stats.PixelList{indexes(i)};
            for row=1:size(obj,1)
                if((v(aPix,1)==obj(row,1))&&(v(aPix,2)==obj(row,2)) && (v(aPix,1)<=size(BW,1))&& (v(aPix,2)<=size(BW,2)))
                    pixel=[pixel;v(aPix,1),v(aPix,2)];
                    segNr=[segNr;indexes(i)];
                    F=[];
                    F = [F;...
                    Red(v(aPix, 1), v(aPix, 2)), Green(v(aPix, 1), v(aPix, 2)), Blue(v(aPix, 1), v(aPix, 2)),...
                    H(v(aPix, 1), v(aPix, 2)), Situ(v(aPix, 1), v(aPix, 2)), I(v(aPix, 1), v(aPix, 2)), ...
                    Redblur2(v(aPix, 1), v(aPix, 2)),Redblur4(v(aPix, 1), v(aPix, 2)),...
                    Redblur8(v(aPix, 1), v(aPix, 2)),Redblur16(v(aPix, 1), v(aPix, 2)),...
                    Greenblur2(v(aPix, 1), v(aPix, 2)),Greenblur4(v(aPix, 1), v(aPix, 2)),...
                    Greenblur8(v(aPix, 1), v(aPix, 2)),Greenblur16(v(aPix, 1), v(aPix, 2)),...
                    SteerJ2(v(aPix, 1), v(aPix, 2)), SteerJ4(v(aPix, 1), v(aPix, 2)),...
                    SteerJ8(v(aPix, 1), v(aPix, 2)), SteerJ16(v(aPix, 1), v(aPix, 2))];
                
                    vect = getSegmentStatistics(Red,Green,Blue,H,Situ,I,...
                                     Redblur2,Redblur4,Redblur8,Redblur16,...
                                     Greenblur2,Greenblur4,Greenblur8,Greenblur16,...
                                     SteerJ2,SteerJ4,SteerJ8,SteerJ16,obj);
                     
                    F = [F,vect];
                    Features = [Features;F];             
                    Label=[Label;1];
                end
            end
        end
    end
                    
    Features =  zscore(Features);   
    AvDataset = table(pixel,segNr,Features,Label);

    save('data/dataset/Image_13L.mat','AvDataset');
    

end

function [vect]=getSegmentStatistics(Red,Green,Blue,H,Situ,I,...
                                     Redblur2,Redblur4,Redblur8,Redblur16,...
                                     Greenblur2,Greenblur4,Greenblur8,Greenblur16,...
                                     SteerJ2,SteerJ4,SteerJ8,SteerJ16,obj)
        
        
        % Arrays to store RGB Values of a segment.
        R_values = []; G_values = []; B_values = [];

        % Arrays to store HSI Values of the same segment.
        H_values = []; S_values = []; I_values = [];
        
        % Arrays to store Red Gauss blur values of the same segment.
        Rb2_values = []; Rb4_values = []; Rb8_values = []; Rb16_values = [];
        
        % Arrays to store Green Gauss blur Values of the same segment.
        Gb2_values = []; Gb4_values = []; Gb8_values = []; Gb16_values = [];
        
        % Arrays to store Steered second Gaussian derivative Values of the same segment.
        St2_values = []; St4_values = []; St8_values = []; St16_values = [];
        
        % Filling arraies from values.
        for row=1:size(obj,1)
            if((obj(row, 1)<=size(Red,1))&& (obj(row, 2)<=size(Red,2)))
            R_values =  [R_values; Red(obj(row, 1), obj(row, 2))];
            G_values =  [G_values; Green(obj(row, 1), obj(row, 2))];
            B_values =  [B_values; Blue(obj(row, 1), obj(row, 2))];

            H_values =  [H_values; H(obj(row, 1), obj(row, 2))];
            S_values =  [S_values; Situ(obj(row, 1), obj(row, 2))];
            I_values =  [I_values; I(obj(row, 1), obj(row, 2))];
            
            Rb2_values = [Rb2_values; Redblur2(obj(row, 1), obj(row, 2))];
            Rb4_values = [Rb4_values; Redblur4(obj(row, 1), obj(row, 2))];
            Rb8_values = [Rb8_values; Redblur8(obj(row, 1), obj(row, 2))];
            Rb16_values = [Rb16_values; Redblur16(obj(row, 1), obj(row, 2))];
            
            Gb2_values = [Gb2_values; Greenblur2(obj(row, 1), obj(row, 2))];
            Gb4_values = [Gb4_values; Greenblur4(obj(row, 1), obj(row, 2))];
            Gb8_values = [Gb8_values; Greenblur8(obj(row, 1), obj(row, 2))];
            Gb16_values = [Gb16_values; Greenblur16(obj(row, 1), obj(row, 2))];
            
            St2_values = [St2_values; SteerJ2(obj(row, 1), obj(row, 2))];
            St4_values = [St4_values; SteerJ4(obj(row, 1), obj(row, 2))];
            St8_values = [St8_values; SteerJ8(obj(row, 1), obj(row, 2))];
            St16_values = [St16_values; SteerJ16(obj(row, 1), obj(row, 2))];
            end
        end
        
        vect = [mean(double(R_values)),mean(double(G_values)), mean(double(B_values)),...
            mean(H_values),mean(S_values),mean(I_values),std(double(R_values)),std(double(G_values)),std(double(B_values)),...
            std(H_values),std(S_values),std(I_values),max(R_values),min(R_values),max(G_values),min(G_values)];
end

