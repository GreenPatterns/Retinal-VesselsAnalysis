function [ labels ] = medianLabels(BW, labels,score,segNr)

CC = bwconncomp(BW);
L = labelmatrix(CC);
stats = regionprops('Table',L,'PixelList');
newlabel=[];
indx = [];
newscore=[];
for i= 1:height(stats)
    indx =find(segNr ==i);
    s = score(indx,:);
    if(size(s,1)>1)
        med = median(s);
         if(med(1)>med(2))
            newlabel=0;
         else
            newlabel=1;
         end
         
         for j=  1:length(indx)
            labels(indx(j))=newlabel;
         end
    else if(size(s,1)==1)
         med = s;
          if(med(1)>med(2))
            newlabel=0;
          else
            newlabel=1;
          end
          
          for j=  1:length(indx)
            labels(indx(j))=newlabel;
          end
        end
    end
end
end


