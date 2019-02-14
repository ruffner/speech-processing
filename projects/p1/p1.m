%% PROJECT 1 MATLAB CODE
% Matt Ruffner
% EE699 Speech Processing
% Feb. 9 2019
% University of Kentucky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT FILE: sun.wav
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Supported frame sized are 256 and 512

%% 1. PREPROCESSING
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%
% READ SIGNAL AND SAMPLE RATE
X=audioread('sun.wav');
Xinfo=audioinfo('sun.wav');
Fs=Xinfo.SampleRate;

% CHOOSE FRAME SIZE, THESE TWO SUPPORTED BY THE SCRIPT
% 256 -> 25ms CHUNKS
% 512 -> 50ms CHUNKS
Fr=512;
Nfft=Fr;

% ZERO MEAN THE SIGNAL
X=X-mean(X);

% PLOT TIME SERIES AND SPECTROGRAM
figure(1)
subplot(2,1,1)
plot(X)
title('"sun.wav" with respect to time');
xlabel('Samples');
ylabel('Signal value');
subplot(2,1,2)
spectrogram(X,Fr,Fr*.75,Nfft,Fs,'yaxis')
title('Spectrogram of "sun.wav", nfft=1024, winSize=256, nOverlap=128');

%% 2. ENERGY AND ZERO CROSSING RATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZERO PAD TO MAKE EVEN MULTIPLE OF Fr
X=[X; zeros(length(X)-floor(length(X)/Fr)*Fr,1)];

% RESHAPE TO COLUMNS REPRESENTING Fr SAMPLE CHUNKS
Xk=reshape(X,Fr,length(X)/Fr);

% COMPUTE MEAN SQUARED SIGNAL AMPLITUDE
Xpow=mean(Xk.^2);
% FORMAT FOR PLOTTING
Xpowp=[];
for i=1:length(Xpow)
   Xpowp=[Xpowp; repmat(Xpow(i),Fr,1)];
end

% COMPUTE ZERO CROSSING RATE
Xzcr=[];
for i=1:size(Xk,2)
    a=Xk(:,i);
    Xzcr=[Xzcr; sum(abs(sign(a(2:Fr))-sign(a(1:Fr-1))))];
end
% FORMAT FOR PLOTTING
Xzcrp=[];
for i=1:length(Xzcr)
   Xzcrp=[Xzcrp; repmat(Xzcr(i),Fr,1)];
end


figure(2)
subplot(3,1,1)
plot(X)
title('"sun.wav" with respect to time');

subplot(3,1,2)
plot(Xpowp)
title('Energy per frame (mean squared)');

subplot(3,1,3)
plot(Xzcrp)
title('Zero crossing rate per frame')

%% 3. PHONEME SELECTION
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% PHONEME FRAME CHOICES
if Fr==256
    Sidx=6;
    Uidx=13;
    Nidx=20;
elseif Fr==512
    Sidx=4;
    Uidx=8;
    Nidx=12;
else
    disp('error no Fr (frame size) defined');
end
       
% PLOT PHONEMES AGAINST TIME (SAMPLE #) AXIS
figure(3)
subplot(3,1,1)
Ph1=Xk(:,Sidx);
plot(Ph1)
title('S Phoneme (frame 5)')
xlabel('Sample number (relative to frame)')

subplot(3,1,2)
Ph2=Xk(:,Uidx);
plot(Ph2)
title('U Phoneme (frame 14)');
xlabel('Sample number (relative to frame)')

subplot(3,1,3)
Ph3=Xk(:,Nidx);
plot(Ph3)
title('N Phoneme (frame 20)');
xlabel('Sample number (relative to frame)')


%% 4. LOG MAGNITUDE FFT
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%
% APPLY A HAMMING WINDOW TO EACH PHONEME AND COMPUTE THE LOG MAGNITUDE
W=hamming(Fr);
Nfft=Fr;
Fax=Fs*[0:Nfft-1]/Nfft;

% COMPUTE PHONEME LOG MAGNITUDE
Ph1mag=20*log10(abs(fft(Ph1.*W,Nfft)));
Ph2mag=20*log10(abs(fft(Ph2.*W,Nfft)));
Ph3mag=20*log10(abs(fft(Ph3.*W,Nfft)));

% PLOT LOG MAGNITUDES OF PHONEMES
figure(4)
subplot(3,1,1)
plot(Fax,Ph1mag)
subplot(3,1,2)
plot(Fax,Ph2mag)
subplot(3,1,3)
plot(Fax,Ph3mag)


%% 5. CEPSTRUM
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%

Ph1cep=ifft(log(abs(fft(W.*Ph1,Fr))));
Ph2cep=ifft(log(abs(fft(W.*Ph2,Fr))));
Ph3cep=ifft(log(abs(fft(W.*Ph3,Fr))));

figure(5)
subplot(3,1,1)
plot(Ph1cep)
subplot(3,1,2)
plot(Ph2cep)
subplot(3,1,3)
plot(Ph3cep)

% peak of u phoneme at idx=4 ->  156.25Hz, idx=83 -> 3242.1875Hz
% peak of n phoneme at idx=69 -> 2695.3125Hz


%% 6. LIFTERED SPECTRUM
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

% SELECT A SINGLE CEPSTRUM CUTOFF TO SEPARATE VOCAL TRACT AND EXCITATION
if Fr==256
    Cepc=30;
else
    Cepc=50;
end

% SAVE ONLY LOW FREQ VOCAL TRACT INFO, ZERO OUT THE REST SYMMETRICALLY
Ph1cep=[Ph1cep(1:50);zeros(Fr-Cepc*2-1,1);Ph1cep(length(Ph1cep)-Cepc:end)];
Ph2cep=[Ph2cep(1:50);zeros(Fr-Cepc*2-1,1);Ph2cep(length(Ph2cep)-Cepc:end)];
Ph3cep=[Ph3cep(1:50);zeros(Fr-Cepc*2-1,1);Ph3cep(length(Ph3cep)-Cepc:end)];

% LIFTER THE SPECTRA
Ph1Lft=fft(Ph1cep);
Ph2Lft=fft(Ph2cep);
Ph3Lft=fft(Ph3cep);

% PLOT THE LIFTERED SPECTRA
figure(6)
subplot(3,1,1)
plot(Fax,real(Ph1Lft))
subplot(3,1,2)
plot(Fax,real(Ph2Lft))
subplot(3,1,3)
plot(Fax,real(Ph3Lft))



%% 8. LPC SPECTRA
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%

Ph1LPC4= lpc(W.*Ph1,4);
Ph1LPC14=lpc(W.*Ph1,14);
Ph1LPC40=lpc(W.*Ph1,40);

Ph2LPC4= lpc(W.*Ph2,4);
Ph2LPC14=lpc(W.*Ph2,14);
Ph2LPC40=lpc(W.*Ph2,40);

Ph3LPC4=lpc(W.*Ph3,4);
Ph3LPC14=lpc(W.*Ph3,14);
Ph3LPC40=lpc(W.*Ph3,40);

figure(7)
subplot(3,3,1)
plot(Fax,20*log10(abs(freqz(1,Ph1LPC4))))
title('LPC of degree 4 for "s" phoneme')
subplot(3,3,2)
plot(Fax,20*log10(abs(freqz(1,Ph1LPC14))))
title('LPC of degree 14 for "s" phoneme')
subplot(3,3,3)
plot(Fax,20*log10(abs(freqz(1,Ph1LPC40))))
title('LPC of degree 40 for "s" phoneme')

subplot(3,3,4)
plot(Fax,20*log10(abs(freqz(1,Ph2LPC4))))
title('LPC of degree 4 for "u" phoneme')
subplot(3,3,5)
plot(Fax,20*log10(abs(freqz(1,Ph2LPC14))))
title('LPC of degree 14 for "u" phoneme')
subplot(3,3,6)
plot(Fax,20*log10(abs(freqz(1,Ph2LPC40))))
title('LPC of degree 40 for "u" phoneme')

subplot(3,3,7)
plot(Fax,20*log10(abs(freqz(1,Ph3LPC4))))
title('LPC of degree 4 for "n" phoneme')
subplot(3,3,8)
plot(Fax,20*log10(abs(freqz(1,Ph3LPC14))))
title('LPC of degree 14 for "n" phoneme')
subplot(3,3,9)
plot(Fax,20*log10(abs(freqz(1,Ph3LPC40))))
title('LPC of degree 40 for "n" phoneme')



%% 8. LPC RESIDUAL
%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%


Nfrms=length(X)/Fr;
Xres=[];
for i=1:Nfrms
    res=lpc(Xk(:,i),14);
    temp=filter(res,1,Xk(:,i));
    Xres(i,:)=temp;
end

figure(8);
plot(reshape(Xres',Fr*Nfrms,1))
title('LPC Residual Signal')
xlabel('Time (in samples)')




Ph1r=lpc(Ph1,14);
Ph2r=lpc(Ph2,14);
Ph3r=lpc(Ph3,14);

Ph1rf=filter(Ph1r,1,Ph1);
Ph2rf=filter(Ph2r,1,Ph2);
Ph3rf=filter(Ph3r,1,Ph3);

figure(9)
subplot(3,1,1)
plot(Ph1rf)
title('LPC Residual for "s" Phoneme')

subplot(3,1,2)
plot(Ph2rf)
title('LPC Residual for "u" Phoneme')

subplot(3,1,3)
plot(Ph3rf)
title('LPC Residual for "n" Phoneme')


%% 10. FORMANT ANALYSIS
%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%

