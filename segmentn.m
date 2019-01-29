function [samples,NF,NW,OLN]=segmentn(X,FS,NW,OLN)

NX=length(X);
NF=fix((NX-NW+OLN)/OLN);
samples=zeros(NF,NW);
startingindex=(0:NF-1)*OLN+1;
for i=1:NF
samples(i,1:NW)=X(startingindex(i):startingindex(i)+NW-1)';
end

%**************************************************************************
