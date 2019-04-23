% hw5 pt4 code ee599 spring 2019

% generate clean speech
[f,fs]=sapisynth('<rate speed="3">Oh my god can i pet your <emph>dog?</emph></rate>','fcp3');

% plot specgram of clean speech
figure(1)
spectrogram(f,256,128,512,fs,'yaxis')

snr=1;

% generate white noise 
sigpow=sum(f.^2)/length(f);

noise=sqrt(sigpow/(10^(snr/10)))*randn(size(f));

% add white noise to signal
nf=f+noise;

% plot specgram of noisy signal
figure(2)
spectrogram(nf,256,128,512,fs,'yaxis')


% set ssubmmse parameters

pp.of=2;         % overlap factor = (fft length)/(frame increment) [2]
pp.ti=0.02;          % desired frame increment [0.016 seconds]
pp.ri=1;          % set to 1 to round ti to the nearest power of 2 samples [0]
pp.ta=0.4;          % time const for smoothing SNR estimate [0.396 seconds]
pp.gx=1000;          % maximum posterior SNR as a power ratio [1000 = +30dB]
pp.gn=-5;          % min posterior SNR as a power ratio when estimating prior SNR [1 = 0dB]
pp.gz=0.01;          % min posterior SNR as a power ratio [0.001 = -30dB]
pp.xn=0;          % minimum prior SNR [0]
pp.xb=1;         % bias compensation factor for prior SNR [1]
pp.lg=2;          % MMSE target: 0=amplitude, 1=log amplitude, 2=perceptual Bayes [1]
pp.bt=-1;          % threshold for binary gain or -1 for continuous gain [-1]
pp.mx=0;          % input mixture gain [0]
pp.gc=5;          % maximum amplitude gain [10 = 20 dB]
pp.rf=0;          % round output signal to an exact number of frames [0]
pp.ne=1;
pp.tax=0.1;      % smoothing time constant for noise power estimate [0.0717 seconds](8)
pp.tap=0.2;      % smoothing time constant for smoothed speech prob [0.152 seconds](23)
pp.psthr=0.9;    % threshold for smoothed speech probability [0.99] (24)
pp.pnsaf=0.01;    % noise probability safety value [0.01] (24)
pp.pspri=0.5;    % prior speech probability [0.5] (18)
pp.asnr=15;     % active SNR in dB [15] (18)
pp.psini=0.5;    % initial speech probability [0.5] (23)
pp.tavini=0.064;   % assumed speech absent time at start [0.064 seconds]
 

% do speech enhancement
ef=ssubmmse(nf,fs,pp);

% plot specgram of enhanced speech signal
figure(3)
spectrogram(ef,256,128,512,fs,'yaxis')


