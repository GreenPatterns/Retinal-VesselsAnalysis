function [ flag ] = isRelated( x,y )
flag = false;

for i = 1: length(y)
    for j = 1: length(x)
        if(eq(x(j,1),y(i,1))&& eq(x(j,2),y(i,2)))
            flag = true;
            break;
        end
    end
end
end

