function [newYtest,newYfit,measures] = DrawYfit( Yfit,score,image,BW,stats,AvDataset,indexes)


newYfit = [];
newYtest = [];

Tn = YfitNormalised(AvDataset.segNr,Yfit,height(stats));
To = YfitNormalised(AvDataset.segNr,AvDataset.Label,height(stats));

% Create newYtest
for i=1:height(stats)
    if(~(isequal(To.aP(i),'NaN'))||~isequal(To.vP(i),'NaN'))
        if((To.aP(i)>=70))
            newYtest = [newYtest;i,0];
        else
            newYtest = [newYtest;i,1];
        end
    end
end

% Create NewYfit
for i=1:height(stats)
    if(~(isequal(Tn.aP(i),'NaN'))||~isequal(Tn.vP(i),'NaN'))
        if((Tn.aP(i)>=50))       %if((To.aP(row)>=75)&&(Tn.aP(row)>=40))
            newYfit = [newYfit;i,0];
        else
            newYfit = [newYfit;i,1];
        end
    end
end


tab = tabulate(newYtest(:,2));
mat=bsxfun(@rdivide,confusionmat(newYtest(:,2),newYfit(:,2)),tab(:,2))*100;
measures = calculatePerformanceMeasures(mat)

% % % R = zeros(size(BW));
% % % G = zeros(size(BW));
% % % B = zeros(size(BW));
% % % 
% % % for i=1:length(indexes)
% % %     sN = indexes(i);
% % %     
% % %     obj = stats.PixelList{newYtest(sN,1)};
% % %     for k=1:size(obj,1)
% % %         if(newYtest(sN,2)==1)
% % %             R(obj(k,2),obj(k,1)) = 255;
% % %         else if(newYtest(sN,2)==0)
% % %                 B(obj(k,2),obj(k,1)) = 255;
% % %         end
% % %     end
% % % end
% % % end
% % % 
% % % My = cat(3,R,G,B);
% % % 
% % % R = zeros(size(BW));
% % % G = zeros(size(BW));
% % % B = zeros(size(BW));
% % % 
% % % for i=1:length(indexes)
% % %     sN = indexes(i);
% % %     obj = stats.PixelList{newYfit(sN,1)};
% % %     for k=1:size(obj,1)
% % %         if(newYfit(sN,2)==1)
% % %             R(obj(k,2),obj(k,1)) = 255;
% % %         else if(newYfit(sN,2)==0)
% % %                 B(obj(k,2),obj(k,1)) = 255;
% % %         end
% % %     end
% % % end
% % % end
% % % 
% % % pro = cat(3,R,G,B);
% % % 
% % % figure,
% % % imshow(My),title('Processed');

% segNr = newYfit(:,1);
% newscore =[];
% for i=1:size(newYfit,1)
% index = find(segNr(3)==AvDataset.segNr);
% s = score(index,:);
% sM = median(s);
% newscore = [newscore;sM];
% end

end



