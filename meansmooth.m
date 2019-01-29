function [SmoothedFunc]=meansmooth(signal,framesize,plotflag)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% USAGE: [SmoothedFunc]=MeanSmooth(signal,framesize,plotflag);
%  This function will perform mean smoothing on the input function by 
%  considering framesize/2 samples to the left and framesize/2 samples 
%  to the right of each sample. It will work only for the case where
%  window size is of odd length. If it is even, then it is converted into 
%  next higher odd value before performing mean smoothing.   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%disp('--------------- MEAN SMOOTH --------------- ')
SmoothedFunc=zeros(length(signal),1);

j=1;

for(i=1:length(signal))
i;
	if(i<floor(framesize/2)+1)

		frm=signal(i:i+framesize-1);
	
	elseif((length(signal)-i)<floor(framesize/2))

		frm=signal(i:length(signal));
	else
		frm=signal((i-floor(framesize/2)):(i+floor(framesize/2)));

	end

	mfrm=mean(frm);

	SmoothedFunc(j)=mfrm;

	j=j+1;

end



if(plotflag==1)

	figure;

	subplot(2,1,1);plot(signal);grid;

	subplot(2,1,2);plot(SmoothedFunc);grid;

end
	

temp=SmoothedFunc(floor(framesize/2));
SmoothedFunc(end-floor(framesize/2):end)=min(temp);


SmoothedFunc=SmoothedFunc./max(SmoothedFunc);