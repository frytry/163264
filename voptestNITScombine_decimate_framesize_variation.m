
function [VOP] =voptestNITScombine_decimate_framesize_variation(speech, LPFL, LPOLN)
%%%%%This program is written to evaluate VOP performance for to common
%%%%%sentence of TIMIT database
% clear all;
% close all;
% clc;       
  
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
%           [data,phoneme,endpoints]=wavReadTimit('D:\project\TIMIT\TEST\DR6\FDRW0\SA1.WAV');
          % [data,phoneme,endpoints]=wavReadTimit('D:\project\TIMIT\TRAIN\DR6\FAPB0\SA2.wav');
          %[speech,~,~] = wavReadTimit('D:\project\TIMIT\TEST\DR7\MDVC0\SA2.wav');
          data=speech;
           out1 = decimate(data',2); %            change@30/12/2015 Azhar
           %out1=data;
% %            out1=data';
           out2=out1-mean(out1);
      
           out=out2/max(abs(out2));
             
%--------------------------------------------------------------------------
Fs=8000;  P=8; Npoints=(50*Fs)/1000;    %     LPFL=(20*Fs)/1000; LPOLN=(10*Fs)/1000;   WL=(20*Fs)/1000;  OL=(10*Fs)/1000;                                                                                           % FOR HE MEANSMOOTH  
   NFFT=512;     NPEAKS=10;                              
Fmin=0;  Fmax=Fs/2;  NBANDS=18;  NORDER=1000; LPFFc=28; MWL=20; MOLN=1;                    
%%%%%%--------------------------------------------------------------------------
WL=LPFL;OL=LPOLN; %modified by niru



%LPR
[res1,LPCoeffs1] = LPresidual_v4(out,LPFL,LPOLN,P,1,1,0);
%--------------------------------------------------------------------------
%DFT,MS,SHE
[sumAmp1]=computesumdft(out,Fs,WL,OL,NFFT,NPEAKS);
[ms1,MS1]= modulationspectrum(out,Fmin,Fmax,Fs,NBANDS,NORDER,LPFFc,MWL,MOLN);
he1=abs(hilbert(res1))';
she1=meansmooth(he1,Npoints,0);
she1=she1-min(she1); 
SHE1=she1./max(abs(she1));
%--------------------------------------------------------------------------
AA11=repeatvalues(sumAmp1,OL);
AA1=[AA11 AA11(end).*ones(1,length(out)-length(AA11))];
AA1=AA1-min(AA1);AA1=AA1./max(abs(AA1));
MS1=MS1-min(MS1);MS1=MS1./max(abs(MS1));
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
D1=medfilt1(MD1,5);
D2=medfilt1(MD2,5);
D3=medfilt1(MD3,5);
%--------------------------------------------------------------------------
%FIND THE POS ZC  (PEAKS)
plotflag=0;
[PN1,SLP1]=findpostonegzc_V3(D1,2,40);
In1=find(PN1==1);
[Ind11,Ind13,Ind12,Me1]=Tempfun_V6(MSAA1,SLP1,In1,1,0.5*mean(MSAA1),400,plotflag);

[PN2,SLP2]=findpostonegzc_V3(D2,2,40);
In2=find(PN2==1);
[Ind21,Ind23,Ind22,Me2]=Tempfun_V6(MSMS1,SLP2,In2,1,0.7*mean(MS1),400,plotflag);

[PN3,SLP3]=findpostonegzc_V3(D3,2,40);
In3=find(PN3==1);
[Ind31,Ind33,Ind32,Me3]=Tempfun_V6(SHE1,SLP3,In3,1,0.9*mean(SHE1),400,plotflag);
%--------------------------------------------------------------------------
%FIND THE NEG ZC (VALLEY)
NP1=findnegtoposzc(D1,5);Ind1=find(NP1==1);
NP2=findnegtoposzc(D2,5);Ind2=find(NP2==1);
NP3=findnegtoposzc(D3,5);Ind3=find(NP3==1);
%--------------------------------------------------------------------------
%ENHANCE THE VALUES
%[EnhancedValues,Index]=regions_V2(SIGNAL, PEAKS, VALLEYS, DIST B/W PEAKS&VALLEYS)
[MSAAR,Index1r]=regions_V2(MSAA1,Ind12,Ind1,200);       
[MSMSR,Index2r]=regions_V2(MSMS1,Ind22,Ind2,0);
[SHER,Index3r]=regions_V2(SHE1,Ind32,Ind3,100);
%--------------------------------------------------------------------------
%--------VOPEVIDENCES-----------------------------------------------------------------
%-----------windowing-------------
[G,Gd]= gausswin(801,200);
nc=conv(MSMSR,Gd);
n1=nc(401:length(nc)-400);
n1=n1/max(abs(n1));
nc1=conv(MSAAR,Gd);
n2=nc1(401:length(nc1)-400);
n2=n2/max(abs(n2));
nc3=conv(SHER,Gd);
n3=nc3(401:length(nc3)-400);
n3=n3/max(abs(n3));
n=n1+n2+n3;
n=n/max(abs(n));

 
%%%%%%%%%%%%%%%%%  peak picking 
   y=n;
   len=length(y);
   h=max(abs(y));
   a=1;
   pp=zeros(1,len);
    for i=101:len-100
       temp1=y(i-100:i+100);
         if(max(temp1)==y(i)&&max(temp1)>h./15)
          pp(i)=y(i);
          k(a)=i;
          a=a+1;
         else
           pp(i)=0;
         end
    end

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
%      VOP=find(pp~=0);   % change by Niru
VOP1=find(pp~=0);
     VOP = (VOP1*2);
    clear k;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%reading ref locations
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END CODING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 