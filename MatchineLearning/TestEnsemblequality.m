
clear all;clc;
load('data/mat_files/features/standNormFeatures_all.mat');
X=AvDataset.Features;
Y=AvDataset.Label;


NumTrees=300;
%% PARTITION OF DATA INTO TRAINING AND TESTING.
% Training samples 1.22529e5 or 1.22529 x 10 power 5
cvpart5 = cvpartition(Y,'holdout',0.5);
Xtrain5 = X(training(cvpart5),:);
Ytrain5 = Y(training(cvpart5),:);
%Test samples
Xtest5 = X(test(cvpart5),:);
Ytest5 = Y(test(cvpart5),:);

%Training samples 1.47035e5 Or 1.47035 x 10 power 5
cvpart4 = cvpartition(Y,'holdout',0.4);
Xtrain4 = X(training(cvpart4),:);
Ytrain4 = Y(training(cvpart4),:);
%Test samples
Xtest4 = X(test(cvpart4),:);
Ytest4 = Y(test(cvpart4),:);

%Training samples 1.7154e5 Or 1.7154 x 10 power 5
cvpart3 = cvpartition(Y,'holdout',0.3);
Xtrain3 = X(training(cvpart3),:);
Ytrain3 = Y(training(cvpart3),:);
%Test samples
Xtest3 = X(test(cvpart3),:);
Ytest3 = Y(test(cvpart3),:);

% Xtest = X(test(cvpart),:);
% Ytest = Y(test(cvpart),:);

%% Training AddaBoostM1 performance 
ens5 = fitensemble(Xtrain5,Ytrain5,'AdaBoostM1',NumTrees,'Tree','Type','Classification');
ens4 = fitensemble(Xtrain4,Ytrain4,'AdaBoostM1',NumTrees,'Tree','Type','Classification');
ens3 = fitensemble(Xtrain3,Ytrain3,'AdaBoostM1',NumTrees,'Tree','Type','Classification');
% 
% %%Confusion matrix/ Testing Phase 
% 
% [Yfit, classifScore] = predict(bag4,Xtest4);
% tab = tabulate(Ytest4);
% mat=bsxfun(@rdivide,confusionmat(Ytest4,Yfit),tab(:,2))*100;
% calculatePerformanceMeasures(mat);

%Display Resubstitution Error 
figure;
plot(resubLoss(ens5,'Mode','Cumulative'),'black-'),title('AddaBoostM1 performance');
hold on
plot(resubLoss(ens4,'Mode','Cumulative'),'blue');
plot(resubLoss(ens3,'Mode','Cumulative'),'green--');
hold off
xlabel('Number of trees');
ylabel('Resubstitution error');
legend('50% split','60% split','70% split','Location','NE');


%% Training 'LogitBoost' performance
ensL5 = fitensemble(Xtrain5,Ytrain5,'LogitBoost',NumTrees,'Tree','Type','Classification');
ensL4 = fitensemble(Xtrain4,Ytrain4,'LogitBoost',NumTrees,'Tree','Type','Classification');
ensL3 = fitensemble(Xtrain3,Ytrain3,'LogitBoost',NumTrees,'Tree','Type','Classification');

%Display Resubstitution Error 
figure;
plot(resubLoss(ensL5,'Mode','Cumulative'),'black-'),title('LogitBoost performance');
hold on
plot(resubLoss(ensL4,'Mode','Cumulative'),'blue');
plot(resubLoss(ensL3,'Mode','Cumulative'),'green--');
hold off
xlabel('Number of trees');
ylabel('Resubstitution error');
legend('50% split','60% split','70% split','Location','NE');

% %% Testing 'GentleBoost' performance
% ensG5 = fitensemble(Xtrain5,Ytrain5,'GentleBoost',NumTrees,'Tree','Type','Classification');
% ensG4 = fitensemble(Xtrain4,Ytrain4,'GentleBoost',NumTrees,'Tree','Type','Classification');
% ensG3 = fitensemble(Xtrain3,Ytrain3,'GentleBoost',NumTrees,'Tree','Type','Classification');
% 
% %Display Resubstitution Error 
% figure;
% plot(resubLoss(ensG5,'Mode','Cumulative'),'black-'),title('GentleBoost performance');
% hold on
% plot(resubLoss(ensG4,'Mode','Cumulative'),'blue');
% plot(resubLoss(ensG3,'Mode','Cumulative'),'green--');
% hold off
% xlabel('Number of trees');
% ylabel('Resubstitution error');
% legend('50% split','60% split','70% split','Location','NE');

