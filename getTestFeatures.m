function [ AvTestData] = getTestFeatures(image,gt )

%----Variables

stats              = gt.stats;
S                  = gt.S;
vessLabGT          = gt.vessLabGT;
mask = calc_mask(image);
Pixel = [];
segNr = [];
CenterLine = [];
Features=[];
Label = [];
%------End variables
  
%--------------Red, Green, Blue Channels-----------
    Red = preproc(image(:,:,1),mask);
    Green = preproc(image(:,:,2),mask);
    Blue = preproc(image(:,:,3),mask);
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
    
%     hsi=cat(3,H,Situ,I);
%     HV=hsi(:,:,1)*2*pi;
%     SV=hsi(:,:,2);
%     IV=hsi(:,:,3);
    %---------------End HSI Creation-------------------
    
    %------Creating Gaussian Blurred(sig=2,4,8,16) of Red, Green-----------
    
        Redblur2 = imgaussfilt(Red,2);
        Redblur4 = imgaussfilt(Red,4);
        Redblur8 = imgaussfilt(Red,8);
        Redblur16 = imgaussfilt(Red,16);
        
        Greenblur2 = imgaussfilt(Green,2);
        Greenblur4 = imgaussfilt(Green,4);
        Greenblur8 = imgaussfilt(Green,8);
        Greenblur16 = imgaussfilt(Green,16);
        
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
    
    
    %-------------------------Building FeaturesSet-------------------------
    
    for i=1:length(vessLabGT)
        objVNo =    vessLabGT(i,1); % Getting vessel segment numbers
        objLNo =    vessLabGT(i,2); % Getting center line segment number
        objLab =    vessLabGT(i,3); % Getting segment labels. 

        
        objV = S.PixelList{objVNo};
        objL = stats.PixelList{objLNo};
        
        [rowsV,colsV] = size(objV);
        [rowsL,colsL] = size(objL);
        %%%========================Center Line Features====================
        
        Lf1 = [];
        for row=1:rowsL      
            Pixel = [Pixel;objL(row,1),objL(row,2)];
            segNr = [segNr;objVNo]; 
            CenterLine = [CenterLine;objLNo];
            
            Lf1 = [Lf1;...
                Red(objL(row, 1), objL(row, 2)), Green(objL(row, 1), objL(row, 2)), Blue(objL(row, 1), objL(row, 2)),...
                H(objL(row, 1), objL(row, 2)), Situ(objL(row, 1), objL(row, 2)), I(objL(row, 1), objL(row, 2)), ...
                Redblur2(objL(row, 1), objL(row, 2)), Redblur4(objL(row, 1), objL(row, 2)), Redblur8(objL(row, 1), objL(row, 2)),Redblur16(objL(row, 1), objL(row, 2)),...
                Greenblur2(objL(row, 1), objL(row, 2)), Greenblur4(objL(row, 1), objL(row, 2)),Greenblur8(objL(row, 1), objL(row, 2)),Greenblur16(objL(row, 1), objL(row, 2)),...
                SteerJ2(objL(row, 1), objL(row, 2)), SteerJ4(objL(row, 1), objL(row, 2)), SteerJ8(objL(row, 1), objL(row, 2)),SteerJ16(objL(row, 1), objL(row, 2))];
            
            Label=[Label;objLab];
        end
       
        %%%+++++++++++++++++++++++++++++++++++++++++++++++++++Center line pixel base features ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
        
        
        %%%======================Vessel Segment============================
        
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
        for row=1:rowsV
            R_values =  [R_values; Red(objV(row, 1), objV(row, 2))];
            G_values =  [G_values; Green(objV(row, 1), objV(row, 2))];
            B_values =  [B_values; Blue(objV(row, 1), objV(row, 2))];

            H_values =  [H_values; H(objV(row, 1), objV(row, 2))];
            S_values =  [S_values; Situ(objV(row, 1), objV(row, 2))];
            I_values =  [I_values; I(objV(row, 1), objV(row, 2))];
            
            Rb2_values = [Rb2_values; Redblur2(objV(row, 1), objV(row, 2))];
            Rb4_values = [Rb4_values; Redblur4(objV(row, 1), objV(row, 2))];
            Rb8_values = [Rb8_values; Redblur8(objV(row, 1), objV(row, 2))];
            Rb16_values = [Rb16_values; Redblur16(objV(row, 1), objV(row, 2))];
            
            Gb2_values = [Gb2_values; Greenblur2(objV(row, 1), objV(row, 2))];
            Gb4_values = [Gb4_values; Greenblur4(objV(row, 1), objV(row, 2))];
            Gb8_values = [Gb8_values; Greenblur8(objV(row, 1), objV(row, 2))];
            Gb16_values = [Gb16_values; Greenblur16(objV(row, 1), objV(row, 2))];
            
            St2_values = [St2_values; SteerJ2(objV(row, 1), objV(row, 2))];
            St4_values = [St4_values; SteerJ4(objV(row, 1), objV(row, 2))];
            St8_values = [St8_values; SteerJ8(objV(row, 1), objV(row, 2))];
            St16_values = [St16_values; SteerJ16(objV(row, 1), objV(row, 2))];
        end
        
        vect = [mean(double(R_values)),mean(double(G_values)), mean(double(B_values)),...
            mean(H_values),mean(S_values),mean(I_values),std(double(R_values)),std(double(G_values)),std(double(B_values)),...
            std(H_values),std(S_values),std(I_values),max(R_values),min(R_values),max(G_values),min(G_values)];
       
        
        f = cat(2,Lf1,repmat(vect,size(Lf1,1),1));
        
        Features = [Features;f];
        %%%======================End Vessel Segment feature extraction ========================
        
    end
    %--------------------------End of feature building-----------------------
    Features = zscore(Features);
    AvTestData = table(Pixel,segNr,CenterLine,Features,Label);
     
end



