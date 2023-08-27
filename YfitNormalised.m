function [t] = YfitNormalised(segNr,Yfit,tSeg)

bins = zeros(tSeg,1);
v = zeros(tSeg,1);
vP = zeros(tSeg,1);
a = zeros(tSeg,1);
aP = zeros(tSeg,1);
f = zeros(tSeg,1);

for i=1:length(Yfit)
    bins(segNr(i)) = segNr(i);
    if(Yfit(i)==1)
        a(segNr(i)) = a(segNr(i))+1;
        f(segNr(i)) = f(segNr(i))+1;
    else if(Yfit(i)==0)
            v(segNr(i)) = v(segNr(i))+1;
            f(segNr(i)) = f(segNr(i))+1;
        end
    end
end

for i=1:length(bins)
    aP(i) = (a(i)/f(i))*100;
    vP(i) = (v(i)/f(i))*100;
end

t = table(bins,a,v,f,aP,vP);
end