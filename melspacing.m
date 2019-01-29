%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [MF,PF]=melspacing(Fmin,Fmax,N)

% FMIN      - MINIMUM FREQUENCY (Hz)
% FMAX      - MAXIMUM FREQUENCY (Hz)
% N         - NO OF BANDS
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Melmin=hztomel(Fmin);
Melmax=hztomel(Fmax);

S=(Melmax-Melmin)/N;         % SPACING

MF(1)=0;

for i=2:N+1
    MF(i)=MF(i-1)+S;
end

for i=1:N+1
    PF(i)=meltohz(MF(i));
end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
function [fmel]=hztomel(fhz)
% THIS CONVERTS PHYSICAL FREQUENCY FREQUENCY INTO MEL FREQUENCY  FMEL=2595*(LOG10(1+FHZ/700)
fmel=2595*log10(1+fhz/700);
%``````````````````````````````````````````````````````````````````````````

function [fhz]=meltohz(fmel)
% THIS CONVERTS MEL FREQUENCY INTO PHYSICAL FREQUENCY  FMEL=2595*(LOG10(1+FHZ/700)
temp=fmel/2595;
fhz=(10^(temp)-1)*700;
%``````````````````````````````````````````````````````````````````````````

%**************************************************************************
