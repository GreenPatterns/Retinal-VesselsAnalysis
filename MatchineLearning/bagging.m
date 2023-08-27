
load('data/chaseDB/mat_files/Dataset and ensembles/TrainingSet.mat');
X=AvDataset.Features;
Y=AvDataset.Label;


% %% PARTITION OF DATA INTO TRAINING AND TESTING.
% % Training samples 1.22529e5 or 1.22529 x 10 power 5
% cvpart5 = cvpartition(Y,'holdout',0.5);
% Xtrain5 = X(training(cvpart5),:);
% Ytrain5 = Y(training(cvpart5),:);
% %testing samples
% Xtest5 = X(test(cvpart5),:);
% Ytest5 = Y(test(cvpart5),:);
% 
% %Training samples 1.47035e5 Or 1.47035 x 10 power 5
% cvpart4 = cvpartition(Y,'holdout',0.4);
% Xtrain4 = X(training(cvpart4),:);
% Ytrain4 = Y(training(cvpart4),:);
% %testing samples
% Xtest4 = X(test(cvpart4),:);
% Ytest4 = Y(test(cvpart4),:);
% 
% %Training samples 1.7154e5 Or 1.7154 x 10 power 5
% cvpart3 = cvpartition(Y,'holdout',0.3);
% Xtrain3 = X(training(cvpart3),:);
% Ytrain3 = Y(training(cvpart3),:);
% %testing samples
% Xtest3 = X(test(cvpart3),:);
% Ytest3 = Y(test(cvpart3),:);
%ensembles

B1 = TreeBagger(100,X,Y,'OOBPred','On','Method','classification');
B2 = TreeBagger(200,X,Y,'OOBPred','On','Method','classification');
B3 = TreeBagger(300,X,Y,'OOBPred','On','Method','classification');

err1 = oobError(B1);
err2 = oobError(B2);
err3 = oobError(B3);

e1 = sum(err1(:))
e2 = sum(err2(:))
e3 = sum(err3(:))


% bag100 = fitensemble(X,Y,'Bag',100,'Tree','Type','Classification');
% bag200 = fitensemble(X,Y,'Bag',200,'Tree','Type','Classification');
% bag300 = fitensemble(X,Y,'Bag',300,'Tree','Type','Classification');

% bL100=oobLoss(bag100,'Mode','Cumulative')'
% bE5=sum(bL100(:))
% bL200=oobLoss(bag200,'Mode','Cumulative')'
% bE4=sum(bL200(:))
% bL300=oobLoss(bag300,'Mode','Cumulative')'
% bE3=sum(bL300(:))
%Display Out of Bag classification error.

figure;
plot(err1,'red');
hold on
plot(err2,'blue');
plot(err3,'k');
hold off
xlabel('Number of trees');
ylabel('Out of bag classifiaction error');
legend('100 bagged trees ','200 bagged trees','300 bagged trees','Location','NE');

% % confusion mat
% [Yfit, classifScore5] = predict(bag5,Xtest5);
% tab = tabulate(Ytest5);
% mat=bsxfun(@rdivide,confusionmat(Ytest5,Yfit),tab(:,2))*100;
% Bagging_50Percent_split = calculatePerformanceMeasures(mat)
% 
% [Yfit, classifScore4] = predict(bag4,Xtest4);
% tab = tabulate(Ytest4);
% mat=bsxfun(@rdivide,confusionmat(Ytest4,Yfit),tab(:,2))*100;
% Bagging_60Percent_split = calculatePerformanceMeasures(mat)
% 
% [Yfit, classifScore3] = predict(bag3,Xtest3);
% tab = tabulate(Ytest3);
% mat=bsxfun(@rdivide,confusionmat(Ytest3,Yfit),tab(:,2))*100;
% Bagging_70Percent_split = calculatePerformanceMeasures(mat)
