
%load('myProcData_1.mat');
%load('Image_11L.mat');

% [VesselGraph, V, vesselSkeleton2] = extractGraph(vesselSkeleton);
% vesselSkeletonPixel = roundSkel(vesselSkeleton2);
% vesselJunctionPixel = roundJunctions(V);
%% Ploted Skeleton

%         immg = zeros(size(img));
%         figure;
%         imshow(immg),title('Ploted Skeleton'); 
%         hold on;
%         for i = 1: length(vesselSkeleton)
%             L = vesselSkeleton{i};
%             %plot(L(:, 2), L(:, 1), '-', 'Color', rand(1,3));
%             plot(L(:, 2), L(:, 1), 'white-');
%         end
%         plot(V(:, 2), V(:, 1),'g.','markersize',10); % x-y wrong order?
%         hold off


%% Constructing binary image.
% immg2 = zeros(size(img));
% 
% for i = 1: length(vesselSkeletonPixel)
%     L = vesselSkeletonPixel{i};
%     [rows, cols] = size(L);
%     for row=1:rows
%     immg2(L(row, 1), L(row, 2))=true;
%     end
% end
% immg2(vesselJunctionPixel(:, 1), vesselJunctionPixel(:, 2)) = false;
% segments = calcRegionProp(immg2);
% imtool(segments);
%--------------------------------------------------------------------------
% Labeling objects and making it visible,
%--------------------------------------------------------------------------

% [M,N] = size(immg2);
% removedSmallSegments = calcRegionProp(immg2);
% CC = bwconncomp(removedSmallSegments); 
% L = labelmatrix(CC);
% vislabels(L);
% axis([1 N 1 M])

%--------------------------------------------------------------------------
% Drawing segments on segmented vessels image.
%--------------------------------------------------------------------------
% immg3 = zeros(size(img));
% immg3 = img;
% immg3 = ~immg3;
% 
% figure,
% imshow(img);
% hold on;
% plot(vesselJunctionPixel(:, 2), vesselJunctionPixel(:, 1),'black.','markersize',30); % x-y wrong order?
% hold off

%--------------------------------------------------------------------------
% Geting RGBValues
%--------------------------------------------------------------------------
% R = Image_11L(:,:,1);
% G = Image_11L(:,:,2);
% B = Image_11L(:,:,3);
% RGB_Intensities = [];
% CC = bwconncomp(centerLine_segments);
% L = labelmatrix(CC);
% 
% stats = regionprops('Table',L,'PixelList');
% for i=1:length(stats.PixelList)
%     %[y,x] = ind2sub(size(L), stats.PixelIdxList{i});
%     obj = stats.PixelList{i};
%     [rows,cols] = size(obj);
%     R_values = [];
%     G_values = [];
%     B_values = [];
%     for row=1:rows
%         R_values =  [R_values; R(obj(row, 1), obj(row, 2))];
%         G_values =  [G_values; G(obj(row, 1), obj(row, 2))];
%         B_values =  [B_values; B(obj(row, 1), obj(row, 2))];
%     end
%         aSegment = {{R_values,G_values,B_values}};
%         RGB_Intensities = cat(2,RGB_Intensities,aSegment);
% end
%--------------------------------------------------------------------------
% Ploting RGB intensities 
%--------------------------------------------------------------------------
% [m,n] = size(centerLine_segments);
% Rzeros = zeros(m,n);
% Gzeros = zeros(m,n);
% Bzeros = zeros(m,n);
% 
% for i=1:length(RGB_Intensities)
%     V = RGB_Intensities{i};
%     obj = stats.PixelList{i};
%     rv = V{1};
%     gv = V{2};
%     bv = V{3};
%     [rows,cols] = size(obj);
%     for row=1:rows
%         Rzeros(obj(row,1),obj(row,2))=rv(row);
%         Gzeros(obj(row,1),obj(row,2))=gv(row);
%         Bzeros(obj(row,1),obj(row,2))=bv(row);
%     end
% end
% 
% output = cat(3,Rzeros,Gzeros,Bzeros);
% figure, imshow(output);
%--------------------------------------------------------------------------
% Getting HSI values.
%--------------------------------------------------------------------------
% F=im2double(Image_11L);
% r=F(:,:,1);
% g=F(:,:,2);
% b=F(:,:,3);
% th=acos((0.5*((r-g)+(r-b)))./((sqrt((r-g).^2+(r-b).*(g-b)))+eps));
% H=th;
% H(b>g)=2*pi-H(b>g);
% H=H/(2*pi);
% S=1-3.*(min(min(r,g),b))./(r+g+b+eps);
% I=(r+g+b)/3;
% HSI = cat(3,H,S,I);
% HSI_Intensities = [];
% CC = bwconncomp(centerLine_segments);
% L = labelmatrix(CC);
% 
% stats = regionprops('Table',L,'PixelList');
% 
% for i=1:length(stats.PixelList)
%     obj = stats.PixelList{i};
%     [rows,cols] = size(obj);
%     H_values = [];
%     S_values = [];
%     I_values = [];
%     for row=1:rows
%         H_values =  [H_values; H(obj(row, 1), obj(row, 2))];
%         S_values =  [S_values; S(obj(row, 1), obj(row, 2))];
%         I_values =  [I_values; I(obj(row, 1), obj(row, 2))];
%     end
%         aSegment = {{H_values,S_values,I_values}};
%         HSI_Intensities = cat(2,HSI_Intensities,aSegment);
% end
%--------------------------------------------------------------------------
% Ploting HSI intensities.
%--------------------------------------------------------------------------
% [m,n] = size(centerLine_segments);
% Hzeros = zeros(m,n);
% Szeros = zeros(m,n);
% Izeros = zeros(m,n);
% 
% for i=1:length(HSI_Intensities)
%     V = HSI_Intensities{i};
%     obj = stats.PixelList{i};
%     hv = V{1};
%     sv = V{2};
%     iv = V{3};
%     [rows,cols] = size(obj);
%     for row=1:rows
%         Hzeros(obj(row,1),obj(row,2))=hv(row);
%         Szeros(obj(row,1),obj(row,2))=sv(row);
%         Izeros(obj(row,1),obj(row,2))=iv(row);
%     end
% end
% 
% output = cat(3,Hzeros,Szeros,Izeros);
% figure, imshow(output);

%--------------------------------------------------------------------------
% Calculating Features from RGB intensities
%--------------------------------------------------------------------------
% Seg_no=[];
% Features=[];
% Label = [];
% for i=1:length(RGB_Intensities)
%     rgbV = RGB_Intensities{i};
%     hsiV = HSI_Intensities{i};
%     
%     Seg_no=[Seg_no;i];
%     
%     rInts = double(rgbV{1});
%     gInts = double(rgbV{2});
%     bInts = double(rgbV{3});
%     hInts = hsiV{1};
%     sInts = hsiV{2};
%     iInts = hsiV{3};
%     
%     f = [];
%     [len,mx,mn,sd,med] = calcFeatures(rInts);
%     f = [f;len,mx,mn,sd,med];
%     
%     [len,mx,mn,sd,med] = calcFeatures(gInts);
%     f = [f,len,mx,mn,sd,med];
%     
%     [len,mx,mn,sd,med] = calcFeatures(bInts);
%     f = [f,len,mx,mn,sd,med];
%     
%     [len,mx,mn,sd,med] = calcFeatures(hInts);
%     f = [f,len,mx,mn,sd,med];
%     
%     [len,mx,mn,sd,med] = calcFeatures(sInts);
%     f = [f,len,mx,mn,sd,med];
%     
%     [len,mx,mn,sd,med] = calcFeatures(iInts);
%     f = [f,len,mx,mn,sd,med];
%     
%     Features = [Features;f];
%     Label=[Label;1];
%     
% end
% 
% FeatureTable = table(Seg_no,Features,Label);
% 
% 
% 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% vessLab = [];
% for i=1:height(S)
%     objV = S.PixelList{i};
%     for j=1:length(GT)
%         objP = stats.PixelList{GT(j,1)};
%         if(isRelated(objV,objP))
%             vessLab=[vessLab;i, j];
%         end
%     end
% end
% 
% 
% im = zeros(size(img));
% for i=1:length(vessTrue)
% obj = S.PixelList{vessTrue(i,1)};
% [rows,cols] = size(obj);
% for row=1:rows
% im(obj(row,1),obj(row,2)) = true;
% end
% end
% imshow(im)


