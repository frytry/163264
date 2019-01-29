function y=firfilter_lpf(x,F,Fs)

% F => CUTOFF FREQ
% N => ORDER OF THE FILTER

N=200;
Fs1=Fs/2;
F=F/Fs1;
b=fir1(N,F);
y1=conv(b,x);
y=y1((N/2)+1:end-(N/2));




% f = [0 F F 1];
% m = [1 1 0 0];
% [h,w] = freqz(b,1,512);

% figure;   plot(f.*Fs1,m,(w/pi).*Fs1,abs(h)); grid on
% legend('Ideal','fir1 Designed')
% title('LPF Frequency Response Magnitudes')

% figure;
% plot(x);hold on
% plot(y,'r'); grid on
%**************************************************************************
