function [ flage ] = isRelated2( x,y )
flage =false;

res = intersect(x,y,'rows');
re = (length(res)*100)/length(y);
if(re>=22)
    flage = true;
end

