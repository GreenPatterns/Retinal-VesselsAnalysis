function [sls,skel] =  doProcess(bw)
    toDraw = imdilate(bw,strel('disk',3));
    skel = bwmorph(toDraw,'thin', Inf);
    subwindow = 16;
    skel = spur_clearing(skel,subwindow);
    subwindow = 14;
    skel = spur_clearing(skel, subwindow);
    skel = spur_clearing(skel, subwindow);

%     CC = bwconncomp(skel);
%     numPixels = cellfun(@numel,CC.PixelIdxList);
%     [ra,ca] = find(numPixels < 40);
% 
%     for idx=1:length(ca)
%         skel(CC.PixelIdxList{ca(idx)}) = 0;
%     end

    [rb,cb , rj, cj, re, ce, junc , ends] = findendsjunctions(double(skel), 0);
    
     junc2 = imdilate(junc,strel('disk',3));
     junc3 = imdilate(junc,strel('disk',11));
    
     skel_segments = skel & ~junc2;
     sls = bw & ~junc3;
    
     CC = bwconncomp(sls);
     numPixels = cellfun(@numel,CC.PixelIdxList);
     [ra,ca] = find(numPixels < 50);
     for idx=1:length(ca)
        sls(CC.PixelIdxList{ca(idx)}) = 0;
     end
  
end

function skel = spur_clearing(skel, subwindow)
 
    [rb,cb , rj, cj, re, ce, junc , ends] = findendsjunctions(double(skel), 0);

    for idx=1:length(rb)
        cY=rb(idx);
        cX=cb(idx);


        rad = subwindow;
        ptx1 = cX-rad:cX+rad;
        ptx2(1:rad*2) = cX+rad;
        ptx3 = cX+rad:-1:cX-rad;
        ptx4(1:rad*2)= cX-rad;

        ptX = [ptx1, ptx2,ptx3,ptx4];


        pty1(1:rad*2) = cY-rad;
        pty2 = cY-rad:cY+rad;
        pty3(1:rad*2) = cY+rad;
        pty4= cY+rad:-1:cY-rad;

        ptY = [pty1, pty2,pty3,pty4];

        %plot(ptX,ptY,'Color','blue','LineWidth',1);

        nCount = 0;
        lastIdxOne = 0;
        for idx=1:numel(ptX)
           if skel(ptY(idx) , ptX(idx)) == 1
               if(lastIdxOne == idx-1)
               aaa=0;
               else
                    nCount = nCount+1;
               end
               lastIdxOne = idx;
           end
        end


        if(nCount <= 2 && nCount>0)
           %it is spur
           imgpart = skel(cY-rad:cY+rad,cX-rad:cX+rad);
     
        %                branchPt = bwmorph(imgpart,'branchpoints');
           centImgPart = rad+1;
           imgpart(centImgPart-1:centImgPart+1, centImgPart-1:centImgPart+1) = 0;
           CC = bwconncomp(imgpart);
           numPixels = cellfun(@numel,CC.PixelIdxList);
           [smallest,idx] = min(numPixels);
           imgpart(CC.PixelIdxList{idx}) = 0;
      
           imgpart(centImgPart, centImgPart) =  1; clear CC:
           tmplte = [1,1,1,1,1;1,0,0,0,1;1,0,0,0,1;1,0,0,0,1;1,1,1,1,1];
           tmplte_img = imgpart(centImgPart-2:centImgPart+2, centImgPart-2:centImgPart+2);
           sidIdx = find((tmplte & tmplte_img)==1);
           todoIdx = 0;
           for idx = 1:length(sidIdx)
               if(sidIdx(idx) <= 2) todoIdx(idx) = 7; elseif(sidIdx(idx) == 3) todoIdx(idx) = 8; elseif(sidIdx(idx) == 4 || sidIdx(idx) == 5)  todoIdx(idx) = 9 ; end 
               if(sidIdx(idx) ==  6 || sidIdx(idx) == 11 || sidIdx(idx) == 16) todoIdx(idx) = 12; elseif(sidIdx(idx) == 21)  todoIdx(idx) = 17; end
               if(sidIdx(idx) == 22 || sidIdx(idx) == 23 || sidIdx(idx) == 24) todoIdx(idx) = 18; elseif(sidIdx(idx) == 25)  todoIdx(idx) = 19; end
               if(sidIdx(idx) == 10 || sidIdx(idx) == 15 || sidIdx(idx) == 20) todoIdx(idx) = 14; end
           end
           if(todoIdx~=0)
               tmplte_img(todoIdx) = 1;
           end
           imgpart(centImgPart-2:centImgPart+2, centImgPart-2:centImgPart+2) = imgpart(centImgPart-2:centImgPart+2, centImgPart-2:centImgPart+2) | tmplte_img;
           skel(cY-rad:cY+rad,cX-rad:cX+rad) = skel(cY-rad:cY+rad,cX-rad:cX+rad) & imgpart;

        end
        if(nCount == 3)
           %it is branching
          % plot(ptX,ptY,'Color','black','LineWidth',1);
        end

        if(nCount > 3)
           %it is crossover
           %plot(ptX,ptY,'Color','green','LineWidth',1);
        end
    end
    
    %hold off;
end
