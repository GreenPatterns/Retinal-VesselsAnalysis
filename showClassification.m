function showClassification(BW,newlabels,segNr)

CC = bwconncomp(BW);
L = labelmatrix(CC);
stats = regionprops('Table',L,'PixelList');

figure,imshow(BW);
hold on
for i=1:length(newlabels)
if(newlabels(i)==1)
    obj = stats.PixelList{segNr(i)};
    plot(obj(:,1),obj(:,2),'r.');
else if(newlabels(i)==0)
        obj = stats.PixelList{segNr(i)};
        plot(obj(:,1),obj(:,2),'r.');
    end
end
end
hold off
end