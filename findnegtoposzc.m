function Indexes=findnegtoposzc(x,N)

Indexes=zeros(1,length(x));

for i=N+1:length(x)-N

    x1=x(i-N:i);
    x2=x(i+1:i+N);
    
    if(x1<=0), t1=1;  else   t1=0;    end
    if(x2>0),  t2=1;  else   t2=0;    end
      
    if(x1<0),  t11=1;  else   t11=0;  end
    if(x2>=0), t22=1;  else   t22=0;  end
       
    Indexes(i)=max(t1*t2,t11*t22);
    
end
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
%     clc;   
%     x=[1 2 4];
%     y=[-1 -2 4] 
%     
%     if(x>0 & y<0)
%         
%         disp('NT')
%     end
        