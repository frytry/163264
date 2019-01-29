function [FL,Amp]=findpeaks_V3(xk1)

a=(xk1);
j=1;

for i=3:length(a)-2
    
            p=max([a(i-2),a(i-1),a(i+1),a(i+2)]);     

            if(a(i)>p)
          
                FL(j)= i;
                Amp(j)=a(i);
                j=j+1; 
            
            end
end

%**************************************************************************
