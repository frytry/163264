function [samples,NF,NW,OLN]=segmenthamm_V2(X,FS,NW,OLN)

NX=length(X);                       % LENGTH OF THE GIVEN WAVE FILE
NF=abs(fix((NX-NW+OLN)/OLN));       % NO OF FRAMES
samples=zeros(NF,NW);               % MATRIX OF DIAMENSION NO OF FRAMES x NO OF SAMPLES PER FRAME
startingindex=(0:NF-1)*OLN+1;       % STARTING INDEX VALUE OF EACH FRAME
w=hamming(NW);                      % HAMMING WINDOW

for i=1:NF                          % SEGMENTATION
samples(i,1:NW)=X(startingindex(i):startingindex(i)+NW-1)';
samples(i,1:NW)=samples(i,1:NW).*w';
end

%**************************************************************************

