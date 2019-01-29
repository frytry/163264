function [Indexes,slope]=findpostonegzc_V3(x,N,SLN)

Indexes=zeros(1,length(x));
slope=Indexes;

for i=N+1:length(x)-N

    x1=x(i-N:i);
    x2=x(i+1:i+N);
    
    if(x1>=0), t1=1;   else t1=0;  end
    if(x2<0),  t2=1;   else t2=0;  end
    
    if(x1>0),  t11=1;  else t11=0; end
    if(x2<=0), t22=1;  else t22=0; end
    
    T=max(t1*t2,t11*t22);
    Indexes(i)=T;
    
    if(T==1)
        if(i-SLN<=0)
            slope(i)=x(1)-(x(i+SLN));
        elseif(i+SLN>length(x))
            slope(i)=x(i-SLN)-(x(end));
        else
            slope(i)=x(i-SLN)-(x(i+SLN));
        end
    end
    
end
   
  
%slope=slope./max(slope);
    