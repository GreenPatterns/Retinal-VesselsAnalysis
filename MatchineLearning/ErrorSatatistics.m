clc;

disp('AdaBoostM1')
AdaError5=resubLoss(ens5,'Mode','Cumulative');
AdaError5=sum(AdaError5(:));

AdaError4=resubLoss(ens4,'Mode','Cumulative');
AdaError4=sum(AdaError4(:));

AdaError3=resubLoss(ens3,'Mode','Cumulative');
AdaError3=sum(AdaError3(:));

disp('GentleBoost')
AdaErrorG5=resubLoss(ensG5,'Mode','Cumulative');
AdaErrorG5=sum(AdaErrorG5(:));

AdaErrorG4=resubLoss(ensG4,'Mode','Cumulative');
AdaErrorG4=sum(AdaErrorG4(:));

AdaErrorG3=resubLoss(ensG3,'Mode','Cumulative');
AdaErrorG3=sum(AdaErrorG3(:));

disp('LogitBoost')
AdaErrorL5=resubLoss(ensL5,'Mode','Cumulative');
AdaErrorL5=sum(AdaErrorL5(:));

AdaErrorL4=resubLoss(ensL4,'Mode','Cumulative');
AdaErrorL4=sum(AdaErrorL4(:));

AdaErrorL3=resubLoss(ensL3,'Mode','Cumulative');
AdaErrorL3=sum(AdaErrorL3(:));

BoostingError = table(AdaError3,AdaError4,AdaError5, AdaErrorG3,AdaErrorG4,...
    AdaErrorG5,AdaErrorL3,AdaErrorL4,AdaErrorL5)