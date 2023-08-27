 load('data/chaseDB/mat_files/Dataset and ensembles/Ensembles.mat');
load('data/chaseDB/mat_files/Dataset and ensembles/testSet/Image_14L.mat');
 load('data/chaseDB/mat_files/GT/VGT/VGT_Image_14L.mat');
 image = imread('data/chaseDB/images/RGB/Image_14L.jpg');
 Xtest = AvDataset.Features;
 Ytest = AvDataset.Label;
[Yfit, score] = predict(bagEnsemble,Xtest);
DrawYfit(Yfit,score,image,BW,stats,AvDataset,GT(:,1));
