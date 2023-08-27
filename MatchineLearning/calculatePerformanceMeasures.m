function [PM] =calculatePerformanceMeasures( conf )

TP = conf(1);
FP = conf(2);
FN = conf(3);
TN = conf(4);

disp('Calculating classification Performance measures...');
Acc = (TP + TN) / (TP + TN + FP + FN);
Accuracy=Acc*100;
Pre = TP/(TP+FP);
Precision = Pre*100;
Rec = TP/(TP+FN);
Recall = Rec*100;
Fscore = 2*((Recall*Precision)/(Recall+Precision));

Matthews_correlation_coefficient = (TP*TN-FP*FN)/(sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN)));
MCC = Matthews_correlation_coefficient*100;
Specificity = (TN/(TN+FP))*100;

PM = table(Accuracy,Precision,Recall,Specificity,Fscore,MCC);
end

