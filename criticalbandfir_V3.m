function y= criticalbandfir_V3(x,F,Fs,N) 

Fs1=Fs/2;

F1=F(1)/Fs1;
F2=F(2)/Fs1;
F3=(F(2)+0.01*F(2))/Fs1;

if(F3>1)
    F2=0.99;
    F3=0.999;
end

f = [0 F1 F2 F3 1];
m = [0 0  1  0  0];

b = fir2(N,f,m);
y1=conv(b,x);
y=y1((N/2)+1:end-(N/2));


%**************************************************************************

