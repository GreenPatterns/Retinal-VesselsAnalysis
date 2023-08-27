% load('Data.mat');
load('ensembles.mat')

rng(0,'twister')
b = TreeBagger(100,X,Y,'OOBVarImp','On');
oobCError = oobError(b);
ClassiErr = sum(oobCError);
figure
plot(oobCError);
xlabel('Number of Grown Trees');
ylabel('Out-of-Bag Classification Error');

impo = b.OOBPermutedVarDeltaError;
figure
bar(impo);
xlabel('Feature Index');
ylabel('Out-of-Bag Feature Importance');
idxvar = find(b.OOBPermutedVarDeltaError>3.5);

ada = fitensemble(Xtrain(:,idxvar),Ytrain,'AdaBoostM1',300,'Tree','Type','Classification');

figure
plot(resubLoss(ada,'mode','cumulative'));
xlabel('Number of Grown Trees');
ylabel('Resub Classification Error');

%%Confusion matrix/ Testing Phase 
[Yfit, classifScore] = predict(ada,Xtest(:,idxvar));
tab = tabulate(Ytest);
mat=bsxfun(@rdivide,confusionmat(Ytest,Yfit),tab(:,2))*100;
calculatePerformanceMeasures(mat)