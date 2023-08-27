

%  load('data/chaseDB/mat_files/Dataset and ensembles/NotNormalizedTrainingSet.mat');
% 
%  
% X=AvDataset.Features;
% Y=AvDataset.Label;
% 
% 
% % %partition. 
% % rng(10);
cvpart = cvpartition(Y,'holdout',0.3);

%Training samples
Xtrain = X(training(cvpart),:);
Ytrain = Y(training(cvpart),:);
%Testing samples 

Xtest = X(test(cvpart),:);
Ytest = Y(test(cvpart),:);
% 
% %% Fitting
% % parpool
% bagEnsemble = fitensemble(X,Y,'Bag',300,'Tree','Type','Classification');
% ABEnsemble = fitensemble(X,Y,'AdaBoostM1',300,'Tree','Type','Classification');
% LBEnsemble = fitensemble(X,Y,'LogitBoost',300,'Tree','Type','Classification');
% save('data/chaseDB/mat_files/Dataset and ensembles/NotNormalizedEnsembles','bagEnsemble','ABEnsemble','LBEnsemble');
% 
% %% Plot errors
figure;
plot(oobLoss(bagEnsemble,'mode','cumulative'),'r-');
hold on;
plot(resubLoss(ABEnsemble,'mode','Cumulative'),'g-');
plot(resubLoss(LBEnsemble,'mode','Cumulative'),'b-');
hold off;
xlabel('Number of trees');
ylabel('Out of bag classification loss');
legend('Bagging streatgy','Adaboost','Logitboost','Location','NE');

%% Testing phase 
%Bag Confusion matrix / Testing Phase 
Xtest = AvDataset.Features;
Ytest = AvDataset.Label;

[bagYfit, bagScore] = predict(bagEnsemble,Xtest);
tab = tabulate(Ytest);
mat=bsxfun(@rdivide,confusionmat(Ytest,bagYfit),tab(:,2))*100;
bagMeasures = calculatePerformanceMeasures(mat)

%%Ada Confusion matrix/ Testing Phase 
[ABYfit, ABScore] = predict(ABEnsemble,Xtest);
tab = tabulate(Ytest);
mat=bsxfun(@rdivide,confusionmat(Ytest,ABYfit),tab(:,2))*100;
ABMeasures = calculatePerformanceMeasures(mat)

%%Logit Confusion matrix/ Testing Phase 
[LBYfit, LBScore] = predict(LBEnsemble,Xtest);
tab = tabulate(Ytest);
mat=bsxfun(@rdivide,confusionmat(Ytest,LBYfit),tab(:,2))*100;
LBMeasures = calculatePerformanceMeasures(mat)


% % Receiver Operating Characteristic (ROC) curve for Classification.
[x1,y1,~,auc1] = perfcurve(Ytest, bagScore(:,2),1); 
[x2,y2,~,auc2] = perfcurve(Ytest, ABScore(:,2),1);
[x3,y3,~,auc3] = perfcurve(Ytest, LBScore(:,2),1);

str1 = sprintf('LogitBoost 50per split, Area Under Curve =  %s',num2str(auc1));  
str2 = sprintf('LogitBoost 60per Split, Area Under Curve =  %s',num2str(auc2)); 
str3 = sprintf('LogitBoost 70per Split, Area Under Curve =  %s',num2str(auc3)); 

figure;
plot(x1,y1)
hold on
plot(x2,y2)
plot(x3,y3)
hold off
legend(str1,str2,str3,'Location','SE')
xlabel('False positive rate');ylabel('True positive rate');
title('ROC curve for ''1'', predicted vs. actual response (Test Set)')

