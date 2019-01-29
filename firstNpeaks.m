function [Fk,amp,pha]=firstNpeaks(x,NFFT,NPEAKS)

% X      - FRAME OF SPEECH (------IT MUST BE A ROW VECTOR------)
% NFFT   - NO POINTS FOR DFT COMPUTATION
% NPEAKS - NO OF PEAKS TO BE COSIDERED

if (size(x,2)==1)                % IF THE INPUT SIGNAL IS COLUMN VECTOR THEN CHANGE IT TO A ROW VECTOR  
    x=x';
end

xk1=fft(x,NFFT);
xk=xk1(1:(NFFT/2)+1);
xkm=abs(xk);
xkp=angle(xk);

[FL,Amp]=findpeaks_V3(xkm);
L=length(FL);
[sortmag index]=sort(Amp) ;       % SORT THE MAGNITUDE IN ASCENING ORDER
Newindex=FL(fliplr(index));       % ******** TO USE FLIPLR VARIABLE MUST BA A ROW VECTOR ********

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if(L>NPEAKS)
    Fk= Newindex(1:NPEAKS);      %  FREQUENCY INDEXES CORRESPONDS TO FIRST NPEAKS
else
    Fk=Newindex;
end

amp=xkm(Fk);                        % FIRST N LARGEST PEAK VALUES  
pha=xkp(Fk);                        % PHASE VALUES CORRESPODS TO FIRST N LARGEST PEAKS  


%**************************************************************************
