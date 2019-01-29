%%%%%This program is written to evaluate VOP performance for to common
%%%%%sentence of TIMIT database



clear all;
close all;
clc;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
   speakerno=1;
   total1=0;
   count110=0;
   count120=0;
   count130=0;
   count140=0;
   count150=0;
   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
      for timitdir=2:2                               %%%%% TRAIN & TEST
    
      if (timitdir==1)
        
            SourceDir='D:\project\TIMIT\TRAIN\'; %%%%% TIMIT TRAIN DIRECTORY
            DRN=1:8;                            %%%%%%% NUMBER OF DRNS IN THE TRAIN DIRECTORY
            NOSPK=[38,76,76,68,70,35,77,22];   %%%%%%% NUMBER OF SPEAKERS IN RESPECTIVE DRN  FOLDER
%%%%%%      NOSPK=[15,35,35,25,25,15,35,15];    %%%%%%%% NUMBER OF SPEAKERS IN RESPECTIVE DRN  FOLDER

     else
            SourceDir='D:\project\TIMIT\TEST\';  %%%%%%%% TIMIT TEST DIRECTORY
            DRN=6:7;                            %%%%%%%%NUMBER OF DRNS IN THE TEST DIRECTORY
    %%%%%%%%NOSPK=[11,26,26,32,28,11,23,11];    %%%%%%%%%%NUMBER OF SPEAKERS IN RESPECTIVE DRN  FOLDER
            NOSPK=[0,0,0,0,0,11,19,0]; %%%%%%%%%IF YOU WANT TO SELECT ONLY PARTICULAR SPEAER CHANGE THIS VALUES
            end
   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
    for drn=1:length(DRN)
    MainDir=strcat(SourceDir,'DR',num2str(DRN(drn)));
    SubFolder=dir(MainDir);
    SPKNAMES=char(SubFolder.name);
    NNSPK=length(SPKNAMES)-2;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:NOSPK(DRN(drn))%%%%%%%%%%IF YOU WANT TO USE ALL SPEAKERS REPLACE "NOSPK(drn)" BY  "NNSPK"
    %%%%%%for i=1:NNSPK  
        SPKNAME=SPKNAMES(i+2,:);
        Files=dir(strcat(MainDir,'\',SPKNAME));
        Filenames=char(Files.name);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%             
        %%%%%%%%%%%%%%%%%%%%%%% TO SELECT ONLY WAVFILES IN THAT PARTICULR SPEAKER FOLDER
                                    ttk=1; zzz=[];
                                    for j=1:length(Filenames)-2
                                    x=strtrim(Filenames(j+2,:));  
                                    if(x(end-2:end)==char('WAV')), zzz(ttk)=j+2;  ttk=ttk+1;  end
                                    end
                                    WavFilenames=Filenames(zzz,:);
                                    NAWF=size(WavFilenames,1); %%%%%%%%TOTAL NO OF WAV FILES IN THAT FOLDER
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%           
     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% FEATURE EXTRACTION
        NAWF=2;
        for k=1:NAWF     %%%%%%%%%%%%%%%%% TO SELECT LAST 'N' WAV FILES
                   
        SpeechFileName=strcat(MainDir,'\',SPKNAME,'\', WavFilenames(k,:));
        d=strcat(MainDir,'\',SPKNAME,'\voprefmark\sa',num2str(k),'\');        %%%%%%%ref marking location
        
        
      
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%          
          [data,phoneme,endpoints]=wavReadTimit(SpeechFileName);
           out1 = decimate(data',2);
           out2=out1-mean(out1);
      
           out=out2/max(abs(out2));
             
%--------------------------------------------------------------------------
Fs=8000; LPFL=(20*Fs)/1000; LPOLN=(10*Fs)/1000; P=8; Npoints=(50*Fs)/1000;                                                                                                        % FOR HE MEANSMOOTH  
WL=(20*Fs)/1000;  OL=(10*Fs)/1000;   NFFT=512;     NPEAKS=10;                              
Fmin=0;  Fmax=Fs/2;  NBANDS=18;  NORDER=1000; LPFFc=28; MWL=20; MOLN=1;                    
%%%%%%--------------------------------------------------------------------------
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
     VOP=find(pp~=0);
    clear k;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%reading ref locations
        len=length(VOP);
        d1=[d,num2str(speakerno)];
        d2=[d1,'.wrd'];
        [a]=textread(d2,'%d');
        total1=len+total1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%comparision with ref location
        for i=1:len
          for j=1:length(a)
            differ=VOP(i)-a(j);
              if differ>-80&& differ<80
                count110=count110+1;
              end
          end
        end
       for i=1:len
            for j=1:length(a)
              differ=VOP(i)-a(j);
                 if differ>-160&& differ<160
                   count120=count120+1;
                 end
               end
       end
          for i=1:len
             for j=1:length(a)
                differ=VOP(i)-a(j);
                 if differ>-240&& differ<240
                  count130=count130+1;
                 end
             end
          end
         for i=1:len
            for j=1:length(a)
              differ=VOP(i)-a(j);
                if differ>-320&& differ<320
                  count140=count140+1;
                end
            end
         end
          for i=1:len
             for j=1:length(a)
                 differ=VOP(i)-a(j);
                  if differ>-400&& differ<400
                   count150=count150+1;
                  end
             end
          end
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%results          
         count10=count110
         count20=count120
         count30=count130
         count40=count140
         count50=count150
                         total=total1
                         miss=750-count40
                         spu=total-count40
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mar=zeros(1,length(out)); %%%%%%reading ref location
          for i=1:length(a)
          mar(a(i))=1;
          end
          clear k;

         

%   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
      
   end
 speakerno=speakerno+1 
   end
   end
   end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%END CODING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 