function [Ind1,Ind2,Ind3,M]=Tempfun_V6(MSAA1,SLP1,In1,Th,Th3,ND,plotflag)
MSAA1=MSAA1';
%------------------------------------------------------------------------
SLP1=abs(SLP1);
MM1=Th.*mean(SLP1(In1));
M=MM1.*ones(1,length(MSAA1));
TT3=Th3.*ones(1,length(MSAA1));
%------------------------------------------------------------------------
Ind1=In1;
Indd=find((SLP1(In1)<MM1)&(MSAA1(In1)<Th3));
Ind1(Indd)=[];
%------------------------------------------------------------------------
Th2=0;
Indd2=find(MSAA1(Ind1)<Th2);
Ind2=Ind1;
Ind2(Indd2)=[];
%------------------------------------------------------------------------
DD=diff(Ind2);
Ti1=find(DD<ND);
%------------------------------------------------------------------------
if(length(Ti1)>1)
    Ti11=Tempfun_V10(MSAA1,Ind2,Ti1);
else
    Ti11=Ti1;
end
%------------------------------------------------------------------------
Ind3=Ind2;
Ind3(Ti11)=[];
%------------------------------------------------------------------------
if(plotflag==1)
    figure;
    subplot(411);plot(MSAA1);grid on;axis tight;hold on;plot(In1,MSAA1(In1),'r.');hold on;plot(TT3,'g');title('Variable')
    subplot(412);stem(In1,SLP1(In1));axis tight;grid on;hold on;plot(M,'g');title('SLOPE')
    subplot(413);plot(MSAA1);grid on;axis tight;hold on;plot(Ind1,MSAA1(Ind1),'r.');title(sprintf(strcat('SLOPE<X & Variabele <Y')))
    %title(sprintf(strcat('SLOPE<',num2str(Th),'X Mean of SLOPE','&
    %%Variabele <',num2str(Th3))))
    subplot(414);plot(MSAA1);grid on;axis tight;hold on;plot(Ind3,MSAA1(Ind3),'r.');title(sprintf(strcat('Peak Diatance<',num2str(ND))))
end
%------------------------------------------------------------------------


%**************************************************************************
function Ti11=Tempfun_V10(MSAA1,Ind2,Ti1)

if(length(Ti1)>0)
    
    for i=1:length(Ti1)-1
    
        x=[Ti1(i) Ti1(i+1)];
    
        %------------------------------------------------------------------------
        if(diff(x)==1)
            Ti11(i)=Ti1(i);
            yy=Ind2(x);
            zz=MSAA1(yy);
            [minzz minii]=min(zz);
            Ti11(i)=x(minii);
        else
            xx=Ti1(i);
            yy=[Ind2(xx) Ind2(xx+1)];
            zz=MSAA1(yy);
            [minzz minii]=min(zz);
            Ti11(i)=xx+minii-1;
        end
        %------------------------------------------------------------------------
        
    end
            xx=Ti1(end);
            yy=[Ind2(xx) Ind2(xx+1)];
            zz=MSAA1(yy);
            [minzz minii]=min(zz);
            Ti11(i)=xx+minii-1;

else
    Ti11=Ti1;
end

%------------------------------------------------------------------------
