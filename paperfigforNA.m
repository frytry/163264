clc;
close all;
clear all;
tic
%**************************************************************************
% Signal='na-8.wav';
% [out1 Fs nb]=wavread(Signal);
% out=resample(out1,80,441);

out=readshort1('NA_SP000.RAW');
out=out/max(out);
Fs=8000;
LPFL=(20*Fs)/1000;     LPOLN=(10*Fs)/1000;     P=8;                                        % FOR LPR
Npoints=(50*Fs)/1000;                                                                       % FOR HE MEANSMOOTH  
WL=(20*Fs)/1000;  OL=(10*Fs)/1000;   NFFT=512;     NPEAKS=10;                               % ST PARAMETERS
Fmin=0;  Fmax=Fs/2;  NBANDS=18;  NORDER=1000; LPFFc=28; MWL=20; MOLN=1;                     % FOR MODULATION SPECTRUM
%LPR
[res1,LPCoeffs1] = LPresidual_v4(out,LPFL,LPOLN,P,1,1,0);
%--------------------------------------------------------------------------
%DFT,MS,SHE
[sumAmp1]=computesumdft(out,Fs,WL,OL,NFFT,NPEAKS);
[ms1,MS1]= modulationspectrum(out,Fmin,Fmax,Fs,NBANDS,NORDER,LPFFc,MWL,MOLN);
he1=abs(hilbert(res1))';
she1=meansmooth(he1,Npoints,0);
% she1=she1-min(she1); 
SHE1=she1./max(she1);
%--------------------------------------------------------------------------
AA11=repeatvalues(sumAmp1,OL);
AA1=[AA11 AA11(end).*ones(1,length(out)-length(AA11))];
AA1=AA1-min(AA1);AA1=AA1./max(AA1);
MS1=MS1-min(MS1);MS1=MS1./max(MS1);
%--------------------------------------------------------------------------
%MEAN SMOOTH
NMP=(50*Fs)/1000;
MSAA1=meansmooth(AA1,NMP,0);       %DFT
MSMS1=meansmooth(MS1,NMP,0);       %Modulation Spectrum
SHE1=meansmooth(SHE1,NMP,0);       %Smoothed Hilbert Envelope
%--------------------------------------------------------------------------
%FIND THE SLOPE
MD1=diff(MSAA1);MD1=MD1./max(abs(MD1));
MD2=diff(MSMS1);MD2=MD2./max(abs(MD2));
MD3=diff(SHE1); MD3=MD3./max(abs(MD3));
%--------------------------------------------------------------------------
%MEDIAN FILTERING TO REMOVE THE SPIKES
D1=medfilt1(MD1,3);
D2=medfilt1(MD2,3);
D3=medfilt1(MD3,5);
%--------------------------------------------------------------------------
%FIND THE POS ZC  (PEAKS)
plotflag=0;
[PN1,SLP1]=findpostonegzc_V3(D1,2,40);
In1=find(PN1==1);
[Ind11,Ind13,Ind12,Me1]=Tempfun_V6(MSAA1,SLP1,In1,1,1*mean(MSAA1),400,plotflag);

[PN2,SLP2]=findpostonegzc_V3(D2,2,40);
In2=find(PN2==1);
[Ind21,Ind23,Ind22,Me2]=Tempfun_V6(MSMS1,SLP2,In2,0.5,0.5*mean(MS1),400,plotflag);

[PN3,SLP3]=findpostonegzc_V3(D3,2,40);
In3=find(PN3==1);
[Ind31,Ind33,Ind32,Me3]=Tempfun_V6(SHE1,SLP3,In3,1,1*mean(SHE1),400,plotflag);
%--------------------------------------------------------------------------
%FIND THE NEG ZC (VALLEY)
NP1=findnegtoposzc(D1,5);Ind1=find(NP1==1);
NP2=findnegtoposzc(D2,5);Ind2=find(NP2==1);
NP3=findnegtoposzc(D3,5);Ind3=find(NP3==1);
%--------------------------------------------------------------------------
%ENHANCE THE VALUES
%[EnhancedValues,Index]=regions_V2(SIGNAL, PEAKS, VALLEYS, DIST B/W PEAKS&VALLEYS)
[MSAAR,Index1r]=regions_V2(MSAA1,Ind12,Ind1,400);       
[MSMSR,Index2r]=regions_V2(MSMS1,Ind22,Ind2,0);
[SHER,Index3r]=regions_V2(SHE1,Ind32,Ind3,0);
%--------------------------------------------------------------------------
Time1=[0:1:length(out)-1].*(1/Fs);             %25000 for PKM1  & 41000 for real2
L1=length(Time1);
% 
% figure;
% subplot(411);plot(out);axis tight;
% subplot(412);plot(MSAA1);axis tight;
% subplot(413);plot(MSMS1);axis tight;
% subplot(414);plot(SHE1);axis tight;







%--------VOPEVIDENCES-----------------------------------------------------------------
%-----------windowing-------------
[G,Gd]= gausswin(801,200);
nc=conv(MSMSR,Gd);
n1=nc(401:length(out)+400);
n1=n1/max(n1);

nc=conv(MSAAR,Gd);
n2=nc(401:length(out)+400);
n2=n2/max(n2);

nc=conv(SHER,Gd);
n3=nc(401:length(out)+400);
n3=n3/max(n3);

n=n1+n2+n3;
 n=n/max(n);

 
 % peak picking for SHE
   y=n3;
len=length(y);
a=1;
pp=zeros(1,len);
for i=101:len-100
    temp1=y(i-100:i+100);
    if(max(temp1)>y./20&max(temp1)==y(i))
          pp(i)=y(i);
        k(a)=i;
        a=a+1;
           else
            pp(i)=0;
    end
end
% plot(pp,'r');
b=length(k);
for i=1:b-1
    temp2=y(k(i):k(i+1));
    if(min(temp2)<0)
       
     pp(k(i))=1;
    else
            
             pp(k(i))=0;
                k(i)=0;
    end
end
temp3=y(k(b):end);
 if(min(temp3)<0)
       
     pp(k(b))=1;
    else
            
             pp(k(b))=0;
                k(b)=0;
 end
%  
%  
%  P=zeros(1,length(n));



res1=res1/max(res1);
Time1=[0:1:length(out)-1].*(1/Fs);         
L1=length(Time1);
he1=he1/max(he1);
SHE1=SHE1/max(SHE1);
SHER=SHER/max(SHER);
n3=n3/max(n3);


% %----1---------------



figure;
subplot(411);plot(Time1,out(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0,'(a)');
subplot(412);plot(Time1,res1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0,'(b)');
subplot(413);plot(Time1,he1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0,'(c)');
subplot(414);plot(Time1,SHE1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0.1,'(d)');
xlabel('Time(sec)')


%--------------------------------------



    
%       % peak picking for MOD
   y=n1;
len=length(y);
a=1;
pp1=zeros(1,len);
for i=101:len-100
    temp1=y(i-100:i+100);
    if(max(temp1)>y./20&max(temp1)==y(i))
          pp1(i)=y(i);
        k(a)=i;
        a=a+1;
           else
            pp1(i)=0;
    end
end
% plot(pp,'r');
b=length(k);
for i=1:b-1
    temp2=y(k(i):k(i+1));
    if(min(temp2)<0)
       
     pp1(k(i))=1;
    else
            
             pp1(k(i))=0;
                k(i)=0;
    end
end
temp3=y(k(b):end);
 if(min(temp3)<0)
       
     pp1(k(b))=1;
    else
            
             pp1(k(b))=0;
                k(b)=0;
 end
 
% -------Mod spectrum method fig 4-------------    --------------------- 


MSMS1=MSMS1/max(MSMS1);
    MSMSR=MSMSR/max(MSMSR);
    n1=n1/max(n1);
    
    
    figure;
subplot(411);plot(Time1,out(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0,'(a)');
subplot(412);plot(Time1,MSMS1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0.1,'(b)');
subplot(413);plot(Time1,MSMSR(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0.5,'(c)');
subplot(414);plot(Time1,n1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(d)');
xlabel('Time(sec)')
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%--
     % peak picking for DFT
   y=n2;
len=length(y);
a=1;
pp2=zeros(1,len);
for i=101:len-100
    temp1=y(i-100:i+100);
    if(max(temp1)>y./20&max(temp1)==y(i))
          pp2(i)=y(i);
        k(a)=i;
        a=a+1;
           else
            pp2(i)=0;
    end
end
% plot(pp,'r');
b=length(k);
for i=1:b-1
    temp2=y(k(i):k(i+1));
    if(min(temp2)<0)
       
     pp2(k(i))=1;
    else
            
             pp2(k(i))=0;
                k(i)=0;
    end
end
temp3=y(k(b):end);
 if(min(temp3)<0)
       
     pp2(k(b))=1;
    else
            
             pp2(k(b))=0;
                k(b)=0;
 end
 
%  
  
  MSAA1=MSAA1/max(MSAA1);
    MSAAR=MSAAR/max(MSAAR);
    n2=n2/max(n2);
 
 %---------------------DFT spectrum method fig
 %6-------------------------------------------------------------

 
 
     figure;
subplot(411);plot(Time1,out(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0,'(a)');
subplot(412);plot(Time1,MSAA1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0.1,'(b)');
subplot(413);plot(Time1,MSAAR(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 0 1]);text(max(Time1+0.03),0.5,'(c)');
subplot(414);plot(Time1,n2(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(d)');
xlabel('Time(sec)')
 
%  ------------------------------------------------------------------------
%  ---------------------------------------------------------------------
     % peak picking for combined
   y=n;
len=length(y);
a=1;
pp3=zeros(1,len);
for i=101:len-100
    temp1=y(i-100:i+100);
    if(max(temp1)>y./20&max(temp1)==y(i))
          pp3(i)=y(i);
        k(a)=i;
        a=a+1;
           else
            pp3(i)=0;
    end
end
% plot(pp,'r');
b=length(k);
for i=1:b-1
    temp2=y(k(i):k(i+1));
    if(min(temp2)<0)
       
     pp3(k(i))=1;
    else
            
             pp3(k(i))=0;
                k(i)=0;
    end
end
temp3=y(k(b):end);
 if(min(temp3)<0)
       
     pp3(k(b))=1;
    else
            
             pp3(k(b))=0;
                k(b)=0;
  end

clear k;
%  
 
 %---------Combined fig 9-----------------------
%   figure();
%  subplot(5,1,1)
% 
%    plot(out/max(out));
%    axis tight;
% %    hold on;
% %    plot(P,'r');
% %    axis tight;
% %    subplot(5,1,2)
% %    plot(n3);
%     axis tight;
%    subplot(5,1,3)
%    plot(n1);
%     axis tight;
%    subplot(5,1,4)
%    plot(n2);
%    subplot(5,1,5)
%    plot(n);
%     axis tight;
%     hold on;
%     plot(pp3,'r');
%      axis tight;

    figure;
subplot(511);plot(Time1,out(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0,'(a)');
subplot(512);plot(Time1,n3(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(b)');
subplot(513);plot(Time1,n1(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(c)');
subplot(514);plot(Time1,n2(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(d)');
subplot(515);plot(Time1,n(1:L1),'k');grid on;axis ([0 max(Time1)+0.005 -1 1]);text(max(Time1+0.03),0.5,'(e)');
xlabel('Time(sec)')
%--------------------------------------------------------------------------
%--------------------------------------------------------------------------
%-