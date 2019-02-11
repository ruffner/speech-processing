%% PROJECT 1 MATLAB CODE
% Matt Ruffner
% EE699 Speech Processing
% Feb. 9 2019
% University of Kentucky
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% INPUT FILE: sun.wav
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PREPROCESSING
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
spectrogram(X,Fr,Fr/2,Nfft,Fs,'yaxis');
title('Spectrogram of "sun.wav", nfft=1024, winSize=256, nOverlap=128');

%% ENERGY AND ZERO CROSSING RATE
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

%% PHONEME SELECTION
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%
% PHONEME FRAME CHOICES
Sidx=5;
Uidx=14;
Nidx=20;

% PLOT PHONEMES AGAINST TIME (SAMPLE #) AXIS
figure(3)
subplot(3,1,1)
plot(Xk(:,Sidx))
title('S Phoneme (frame 5)')
xlabel('Sample number (relative to frame)')

subplot(3,1,2)
plot(Xk(:,Uidx))
title('U Phoneme (frame 14)');
xlabel('Sample number (relative to frame)')

subplot(3,1,3)
plot(Xk(:,Nidx))
title('N Phoneme (frame 20)');
xlabel('Sample number (relative to frame)')


%% LOG MAGNITUDE FFT
%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%


%% CEPSTRUM
%%%%%%%%%%%
%%%%%%%%%%%

%% LPC SPECTRA
%%%%%%%%%%%%%%
%%%%%%%%%%%%%%


%% LPC RESIDUAL
%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%

%% PITCH TRACKING
%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%


%% FORMANT ANALYSIS
%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%

