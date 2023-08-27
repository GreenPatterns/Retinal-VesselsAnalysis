clear all;
close;
clc;

%%  Import the data and prepare it for classification.
load skin.dat
Y = skin(:,end); 
skin(:,end) = [];

%% Examine the response data.
tabulate(Y)

%% Partition the data for quality assessment.

part = cvpartition(Y,'holdout',0.5);
istrain = training(part); % data for fitting
istest = test(part); % data for quality assessment
tabulate(Y(istrain))

%% Create the ensemble.
t = templateTree('minleaf',5);
tic
rusTree = fitensemble(skin(istrain,:),Y(istrain),'RUSBoost',1000,t,'LearnRate',0.1,'nprint',100);
toc

%% Inspect the classification error.
figure;
tic
plot(loss(rusTree,skin(istest,:),Y(istest),'mode','cumulative'));
toc
grid on;
xlabel('Number of trees');
ylabel('Test classification error');

%% Examine the confusion matrix for each class as a percentage of the true class.
tic
Yfit = predict(rusTree,skin(istest,:));
toc
tab = tabulate(Y(istest));
bsxfun(@rdivide,confusionmat(Y(istest),Yfit),tab(:,2))*100

%% Compact the ensemble.
cmpctRus = compact(rusTree);

sz(1) = whos('rusTree');
sz(2) = whos('cmpctRus');
[sz(1).bytes sz(2).bytes]

