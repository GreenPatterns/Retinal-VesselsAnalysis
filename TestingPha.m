function TestingPha()

ImageName =[];
Accuracy=[];
Precision=[];
Recall=[];
Specificity=[];
Fscore=[];
MCC = [];


fea_Files = dir('data/dataset/*.mat');
gt_Files = dir('data/chaseDB/mat_files/GT/VGT/*.mat');
rgb_Files = dir('data/chaseDB/images/RGB/*.jpg');
idx = [25,32,29,30,23,27,26,34,19,24,22,20];
%parpool
for ra=1:size(fea_Files,1)
    
    imgFea = fea_Files(ra).name;
    test= load(imgFea);
    gfile = gt_Files(ra).name;
    load(gfile); 
    ifile = rgb_Files(ra).name;
    image = imread(ifile);
    ImageName = strvcat(ImageName,ifile);
    str = sprintf('%d) %s, GT = %s, testImage=%s',ra,ifile,gfile,imgFea);  
    disp(str);
    
    Xtest = test.AvDataset.Features;
    Ytest = test.AvDataset.Label;
    
    Xtrain=[];
    Ytrain=[];
    
    for i=1:size(fea_Files,1)
        if(ra~=i)
            imgFea = fea_Files(i).name;
            train = load(imgFea);
            Xtrain = [Xtrain;train.AvDataset.Features];
            Ytrain = [Ytrain;train.AvDataset.Label];
        end
    end



    EnsMdl = fitensemble(Xtrain(:,idx),Ytrain,'Bag',150,'Tree','Type','Classification');
%     B = TreeBagger(15,Xtrain,Ytrain,'OOBPred','On','Method','classification');
%     KNNMdl = fitcknn(Xtrain,Ytrain,'NumNeighbors',1);
%     CMdl = fitcknn(Xtrain,Ytrain,'NumNeighbors',1,'NSMethod','exhaustive','Distance','cosine');
    
    [Yfit, score] = predict(EnsMdl,Xtest(:,idx));
    tab = tabulate(Ytest);
    mat=bsxfun(@rdivide,confusionmat(Ytest,Yfit),tab(:,2))*100;
    measures = calculatePerformanceMeasures(mat);
%     yfit = [];
%     for i=1:length(Yfit)
%     if( strcmpi(Yfit(i),'1'))
%         yfit(i)=1;
%         else
%         yfit(i)=0;
%         end
%     end
        
%     [~,~,measures]=DrawYfit(yfit,score,image,BW,stats,test.AvDataset,GT(:,1));
    
    Accuracy = [Accuracy; measures.Accuracy];
    Precision= [Precision;measures.Precision];
    Recall   = [Recall;measures.Recall];
    Specificity = [Specificity;measures.Specificity];
    Fscore   = [Fscore;measures.Fscore];
    MCC      = [MCC;measures.MCC];
%   AUC      = [AUC;trapz(newYfit(:,1),newYfit(:,2))];

end
 
    ImageName= strvcat(ImageName,'Average');
    Accuracy = [Accuracy;mean(Accuracy)];
    Precision= [Precision;mean(Precision)];
    Recall   = [Recall;mean(Recall)];
    Specificity = [Specificity;mean(Specificity)];
    Fscore   = [Fscore;mean(Fscore)];
    MCC      = [MCC;mean(MCC)];
%   AUC      = [AUC;mean(AUC)];

    ImageName= strvcat(ImageName,'Standard Deviation');
    Accuracy = [Accuracy;std(Accuracy)];
    Precision= [Precision;std(Precision)];
    Recall   = [Recall;std(Recall)];
    Specificity = [Specificity;std(Specificity)];
    Fscore   = [Fscore;std(Fscore)];
    MCC      = [MCC;std(MCC)];
%   AUC      = [AUC;std(AUC)];
    
   
 
    BagPre = table(Accuracy,Precision,Recall,Fscore,Specificity, MCC,'RowNames',cellstr(ImageName));
    
    save('BagPred_14_3_17.mat','BagPre');
end

