function [sumAmp1]=computesumdft(out,Fs,WL,OL,NFFT,NPEAKS)

%SEGMENTATION
[d,NF,NW,OLN]=segmentn(out,Fs,WL,OL);
%--------------------------------------------------------------------------
for i=1:NF
   
    x=d(i,:);    
    x1=x.*hamming(length(x))';
    [Loc1,Amp1,Pha1]=firstNpeaks(x1,NFFT,NPEAKS);
    sumAmp1(i)=sum(Amp1);
    
end
%--------------------------------------------------------------------------
