function myRoc(FPR,TPR,yfit)

auc = trapz(yfit(:,1),yfit(:,2));

str1 = sprintf('Bagging prediction , Area Under Curve =  %s',num2str(auc)); 
str2 = sprintf('Performance threshold'); 
t = [0;TPR;1];
f = [0;FPR;1];
x = [0,1];
y = [0,1];

figure,
plot(x,y,'r');
hold on
grid on
grid minor
plot(f,t,'b');
hold off
legend(str2,str1,'Location','SE')
xlabel('False positive rate');ylabel('True positive rate');
title('ROC curve illustrating baggining predicitons on unseen data')
end

