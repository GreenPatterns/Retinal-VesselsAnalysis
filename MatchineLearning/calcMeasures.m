function [T] = calcMeasures()

%%Confusion matrix/ Testing Phase / Adda BoostM1
[Yfit, classifScore] = predict(ens5,Xtest5);
tab = tabulate(Ytest5);
mat=bsxfun(@rdivide,confusionmat(Ytest5,Yfit),tab(:,2))*100;
AddaBoost_50Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ens4,Xtest4);
tab = tabulate(Ytest4);
mat=bsxfun(@rdivide,confusionmat(Ytest4,Yfit),tab(:,2))*100;
AddaBoost_60Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ens3,Xtest3);
tab = tabulate(Ytest3);
mat=bsxfun(@rdivide,confusionmat(Ytest3,Yfit),tab(:,2))*100;
AddaBoost_70Percent_split = calculatePerformanceMeasures(mat);

%%Gentel Boost
[Yfit, classifScore] = predict(ensG5,Xtest5);
tab = tabulate(Ytest5);
mat=bsxfun(@rdivide,confusionmat(Ytest5,Yfit),tab(:,2))*100;
GentleBoost_50Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ensG4,Xtest4);
tab = tabulate(Ytest4);
mat=bsxfun(@rdivide,confusionmat(Ytest4,Yfit),tab(:,2))*100;
GentleBoost_60Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ensG3,Xtest3);
tab = tabulate(Ytest3);
mat=bsxfun(@rdivide,confusionmat(Ytest3,Yfit),tab(:,2))*100;
GentleBoost_70Percent_split = calculatePerformanceMeasures(mat);

%%Logitboost
[Yfit, classifScore] = predict(ensL5,Xtest5);
tab = tabulate(Ytest5);
mat=bsxfun(@rdivide,confusionmat(Ytest5,Yfit),tab(:,2))*100;
LogitBoost_50Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ensL4,Xtest4);
tab = tabulate(Ytest4);
mat=bsxfun(@rdivide,confusionmat(Ytest4,Yfit),tab(:,2))*100;
LogitBoost_60Percent_split = calculatePerformanceMeasures(mat);

[Yfit, classifScore] = predict(ensL3,Xtest3);
tab = tabulate(Ytest3);
mat=bsxfun(@rdivide,confusionmat(Ytest3,Yfit),tab(:,2))*100;
LogitBoost_70Percent_split = calculatePerformanceMeasures(mat);

rnames = {'Accuracy';'Precision';'Recall';'Fscore';'Matthews Correlation Coefficient(MCC)'};
T = table(AddaBoost_50Percent_split,AddaBoost_60Percent_split,AddaBoost_70Percent_split,...
    GentleBoost_50Percent_split,GentleBoost_60Percent_split,GentleBoost_70Percent_split,...
    LogitBoost_50Percent_split,LogitBoost_60Percent_splitLogitBoost_70Percent_split,...
    'RowNames',rnames);
end

