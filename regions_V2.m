function [sigr,Index]=regions_V2_fig(sig,PNT,NPT,Th)

y=[1 NPT length(sig)];              % VALLEYS

for i=1:length(PNT)
    
    x=PNT(i);                       % PEAKS

    T1=x-y;

    In1=find(T1>Th);
    
    if(length(In1)==0),
        In1=find(T1>0);
    end

    In2=find(T1<-Th);
    
    if(length(In2)==0)
        In2=find(T1<0);
    end


    In3=find(T1(In1)==min(T1(In1)));

    In4=find(abs(T1(In2))==min(abs(T1(In2))));

    In5=In1(In3);

    In6=In2(In4);
    
    Index(i,:)=[y(In5) x y(In6)];
    
end

sigr=zeros(1,length(sig));

for i=1:size(Index)

    Index1=Index(i,1):Index(i,3);
    Tempsig=sig(Index1)-min(sig(Index1));
    Tempsig=Tempsig./max(Tempsig);
    sigr(Index1)=Tempsig;
    
end