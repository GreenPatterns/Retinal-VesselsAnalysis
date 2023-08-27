clear all;
clc;
%%
f = dir('Preprocessing/processed/*.csv');
fe=[];
for ra=3:9
    d = readtable(f(ra).name);
    disp(f(ra).name);
    d = table2array(d);
    
    fe = [fe;d];
    F = array2table(fe);   
end
writetable(F,'preprocessing/processed/train.csv','Delimiter',',','QuoteStrings',false);