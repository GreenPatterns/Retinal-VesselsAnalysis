function [] = plotLabels(BW,segNr,Labels)

CC = bwconncomp(BW);
L = labelmatrix(CC);
stats = regionprops('Table',L,'PixelList');

figure,imshow(BW);
hold on
for row=1:length(Labels)
    obj = stats.PixelList{segNr(row)};
    
    if(Labels(row)==0)
        plot(obj(:,1),obj(:,2),'r.');
    else if(Labels(row)==1)
        plot(obj(:,1),obj(:,2),'b.');
        end
    end
end
hold off;
end

