clear all;
clc;
%%
f = dir('FeaturesExtractions/Features/OnlyFea/*.csv');
fea=[];
for ra=1:size(f,1)
    d = readtable(f(ra).name);
    disp(f(ra).name);
    d = table2array(d);
    X = d(:,1:80);
    Y = d(:,81);
    hp = hpfilter(X,100);
    sk = getScale(hp);
    z = zscore(sk);
    mv = movmean(z,[5,4]);
    mv=[mv,Y];
    fea = [fea;mv];
    F = array2table(fea);
    fe = strcat('Preprocessing/processed/',f(ra).name);
    writetable(F,fe,'Delimiter',',','QuoteStrings',false);
end