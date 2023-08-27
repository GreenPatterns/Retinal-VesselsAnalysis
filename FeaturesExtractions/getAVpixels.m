function [art,ven] = getAVpixels( BW,GT,stats )
indexes = GT(:,1);
labels = GT(:,2);
art=[];ven=[];

[~,skel] = doProcess(BW);

lbl = bwlabel(skel);
s = regionprops('Table',lbl,'PixelList');

for j=1: height(s)
    objL = s.PixelList{j};
    for row=1:size(objL,1)
        p=[objL(row,1),objL(row,2)];
        for i=1:numel(indexes)
            objV = stats.PixelList{indexes(i)};
            if(is_member(objV,p))
                if(labels(i)==0)
                        art=[art;p];
                else if(labels(i)==1)
                        ven=[ven;p];
                    end
                end
                break;
            end
        end
    end
end
end

