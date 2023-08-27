function DeepLearning()

clear all; clc;
close all;

% ImageName =[];
% Accuracy=[];
% Precision=[];
% Recall=[];
% Specificity=[];
% Fscore=[];
% MCC = [];

fea_Files = dir('data/dataset/*.mat');
impoFeatures = [25    32    29    30    23    27    26    34    19    24    22    20];

for ra=1:size(fea_Files,1)
    disp(sprintf('%d) %s',ra,fea_Files(ra).name));
    test= load(fea_Files(ra).name);
    
    trainX=[];
    trainY=[];
    testX=[];
    testY=[];
    
    testX = test.AvDataset.Features;
    testY = test.AvDataset.Label;
    
    for i=1:size(fea_Files,1)
        if(ra~=i)
            train = load(fea_Files(i).name);
            trainX = [trainX;train.AvDataset.Features];
            trainY = [trainY;train.AvDataset.Label];
        end
    end

    train_x = toZeroOne(trainX);
    test_x  = toZeroOne(testX);
    
    test_x = test_x(:,impoFeatures);
    test_y  = double(testY);
   
    differ = rem(size(train_x,1),100);
    trainLen = size(train_x,1)-differ;
    
    train_x = train_x(1:trainLen,impoFeatures);
    train_y = trainY(1:trainLen,:);
    
    trY=[];
    tsY=[];
    for n=1:trainLen
        if(train_y(n)==0)
            trY=[trY;1,0];
        else
            trY=[trY;0,1];
        end
    end
    
    for n=1:size(test_y,1)
        if(test_y(n)==0)
            tsY=[tsY;1,0];
        else
            tsY=[tsY;0,1];
        end
    end
    
    train_y=trY; clear trY;
    test_y=tsY;  clear tsY;

end
end

