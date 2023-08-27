function vesselSegmentsProcessing()


im_Files = dir('./data/DRIVE/training/*.bmp');
Range=(1:size(im_Files,1));
parpool;
for ra=Range
    image_name = im_Files(ra).name;
    strL = sprintf('%d. %s',ra,image_name);
    disp(strL);
    img =  imread(image_name);
    img = calcRegionProp(img);
    img = doProcess(img);

%     cc = bwconncomp(img);
%     L = labelmatrix(cc);
%     S = regionprops('Table',L,'PixelList');
% 
%     vessLabGT = [];
%     for i=1:height(S)
%         objV = S.PixelList{i};
%         for j=1:length(GT)
%             objP = stats.PixelList{GT(j,1)};
%             if(isRelated2(objV,objP))
%                 vessLabGT=[vessLabGT;i,j,GT(j,2)];
%             end
%         end
%     end
% 
%     vesselSegments = zeros(size(img));
%     for i=1:length(vessLabGT)
%         obj = S.PixelList{vessLabGT(i,1)};
%         [rows,cols] = size(obj);
% 
%         for row=1:rows
%             vesselSegments(obj(row,2),obj(row,1)) = true;
%         end
%     end

    [pathstr,name,ext] = fileparts(image_name);
    strStore = sprintf('./data/DRIVE/test/vesselSegments/%s.bmp',name);
    imwrite(img,strStore);
% save(gfile,'-append','vesselSegments','S','v'); 
end
poolobj = gcp('nocreate');
delete(poolobj);
end



