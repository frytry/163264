function [Ampl,AMPL]= modulationspectrum(x,Fmin,Fmax,Fs,NBANDS,NORDER,LPFFc,WL,OLN)

%  TO FIND THE MODULATION FREQUENCY CONTENT (4HZ) FOR SPPECH & NON SPEECH
%  DETECTION

%Normal Values:  Fmin=0;  Fmax=4000;  NBANDS=18;  NORDER=1000; LPFFc=28; WL=20; OLN=1;  % MODULATION SPECTRUM

% X               - SPEECH SIGNAL
% FS              - SAMPLING FREQUENCY
% FMIN            - MINIMUM FREQ FOR MEL FILTER
% FMAX            - MAXIMUM FREQUENCY FOR MEL FILTER
% NBANDS          - NO OF BANDS
% NORDER          - BAND PASS FILTER ORDER
% LPFFC           - LOW PASS FILTER CUTOFF FREQ
% WL              - MODULATION SPECTRUM WINDOW LENGTH
% OLN             - MODULATION SPECTRUM OVERLAP LENGTH

%disp('-------------- MODULATION SPECTRUM---------------------')

x=x./max(x);
if(size(x,2)==1)
x=x';
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%MELSPACING
[MF,PF]=melspacing(Fmin,Fmax,NBANDS);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%CRITICAL BAND FILTER
for i=1:NBANDS
    
%   fprintf('Band Pass Filter:  Band %g of %g \n',i,NBANDS); 
    
    if(i==1)
            F=[0.1 PF(i+1)];             %in Hz
            ybpf(i,:)=criticalbandfir_V3(x,F,Fs,NORDER);
    else
           F=[PF(i)-0.2*PF(i) PF(i+1)];
           ybpf(i,:)=criticalbandfir_V3(x,F,Fs,NORDER);
   end
   
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%HALF WAVE RECTIFICATION 
y=ybpf;
index=find(y<0);
y(index)=0;
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%ENVELOPE
for i=1:NBANDS
    
 %   fprintf('Low Pass Filter:  Band %g of %g \n',i,NBANDS); 
    
    y1=firfilter_lpf(y(i,:),LPFFc,Fs);             % LPF
    y2=decimate(y1,100);                           % DOWN SAMPLE
    M=mean(y2);                                    % LONG TERM AVERAGE   
    y3(i,:)=y2./M;                                 % NORMALIZE

end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
%SPECTRUM
for i=1:NBANDS
    
  % fprintf('SPECTRUM:  Band %g of %g \n',i,NBANDS); 

   Signal=y3(i,:);
   [samples,NF,NW,OLN]=segmenthamm_V2(Signal',Fs/100,WL,OLN);
  
 
      
   for j=1:NF
       
       XK=abs(fft(samples(j,:),80));                   % FR=80/80=1;
       Mag(i,j)=XK(5)*XK(5);                        % 4 Hz Component
       
   end
   
end
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Ampl=sum(Mag);
Ampl=Ampl./max(Ampl);
AMPL1=repeatvalues(Ampl,100*OLN);
AMPL=[min(AMPL1).*ones(1,1000) AMPL1  min(AMPL1).*ones(1,length(x)-length(AMPL1)-1000)];
%**************************************************************************
