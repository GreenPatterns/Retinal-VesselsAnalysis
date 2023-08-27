function  show(img, g,flage)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

V = g.G.V;

a = V(g.G.art,:);
v = V(g.G.ven,:);

figure,imshow(img);
hold on 
if(flage==1)
    plot(a(:,1),a(:,2),'r.','markersize',12);
elseif(flage==0)
    plot(v(:,1),v(:,2),'b.','markersize',12);
end
hold off
end

