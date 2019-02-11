%% PROJECT 1 MATLAB CODE
% Matt Ruffner
% EE699 Speech Processing
% Feb. 9 2019
% University of Kentucky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT FILE: sun.wav
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% 1. PREPROCESSING
%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%
% READ SIGNAL AND SAMPLE RATE
X=audioread('sun.wav');
Xinfo=audioinfo('sun.wav');
Fs=Xinfo.SampleRate;

% CHOOSE FRAME SIZE = 256 -> 25ms CHUNKS
Fr=256;
Nfft=256;

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
spectrogram(X,Fr,Fr/2,Nfft,Fs,'yaxis')
title('Spectrogram of "sun.wav", nfft=1024, winSize=256, nOverlap=128');

%% 2. ENERGY AND ZERO CROSSING RATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ZERO PAD TO MAKE EVEN MULTIPLE OF Fr
X=[X; zeros(length(X)-floor(length(X)/Fr)*Fr,1)];

% RESHAPE TO COLUMNS REPRESENTING 256 SAMPLE CHUNKS
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
    Xzcr=[Xzcr; sum(abs(sign(a(2:256))-sign(a(1:255))))];
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
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
% PHONEME FRAME CHOICES
Sidx=5;
Uidx=14;
Nidx=20;

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
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
% APPLY A HAMMING WINDOW TO EACH PHONEME AND COMPUTE THE LOG MAGNITUDE
W=hamming(Fr);
Nfft=256;
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
%%%%%%%%%%%
%%%%%%%%%%%

Ph1cep=ifft(log(abs(fft(W.*Ph1,256))));
Ph2cep=ifft(log(abs(fft(W.*Ph2,256))));
Ph3cep=ifft(log(abs(fft(W.*Ph3,256))));

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
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%

% SELECT A SINGLE CEPSTRUM CUTOFF TO SEPARATE VOCAL TRACT AND EXCITATION
Cepc=30;

[b,a]=butter(7,Cepc/Fr,'low');
Ph1Lft=20*log10(abs(filtfilt(b,a,Ph1)));
Ph2Lft=20*log10(abs(filtfilt(b,a,Ph2)));
Ph3Lft=20*log10(abs(filtfilt(b,a,Ph3)));

figure(6)
subplot(3,1,1)
plot(Ph1Lft)
subplot(3,1,2)
plot(Ph2Lft)
subplot(3,1,3)
plot(Ph3Lft)



%% LPC SPECTRA
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%

Ph1LPC4=lpc(Ph1,4);
Ph1LPC14=lpc(Ph1,14);
Ph1LPC404=lpc(Ph1,40);

Ph2LPC4=lpc(Ph2,4);
Ph2LPC14=lpc(Ph2,14);
Ph2LPC40=lpc(Ph2,40);

Ph3LPC4=lpc(Ph3,4);
Ph3LPC14=lpc(Ph3,14);
Ph3LPC40=lpc(Ph3,40);



%% LPC RESIDUAL
%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%

%% PITCH TRACKING
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%


%% FORMANT ANALYSIS
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

