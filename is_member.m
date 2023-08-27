function [ flage ] = is_member(o,p)
flage = false;
a=0;
[~,index] = ismember(o,p,'rows');
a = find(index==1);
if(a~=0)
    flage = true;
end
end

