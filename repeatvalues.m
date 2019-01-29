function [y]=repeatvalues(x,OLN)

for i=1:length(x)
    
    start=((i-1)*OLN)+1;
    endi=start+OLN-1;
    y(start:endi)=x(i);
    
end

%**************************************************************************
